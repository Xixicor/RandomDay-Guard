-- RandomDayGuard generic public reporting pipeline.
-- This module reads only state and local evidence supplied by the watchdog.
-- It never sends notifications or treats report output as enforcement authority.
-- Documentation: docs/SOURCE_MODULE_REFERENCE.md#public-reporting-module
-- Public contract: current character identity, retained history, route ownership,
-- translation, and local-outbox state remain portable and provider-neutral.
-- Evidence boundary: PlayerData and retained identity history never prove current
-- activity, player conduct, ownership, damage, or enforcement eligibility.
-- Failure behavior: incomplete discovery, stale lineage, ledger overflow, or paired
-- output failure stays explicit and fails affected route proof and queueing closed.

return function(ctx)
    local state = assert(ctx.state, "state is required")
    local version = assert(ctx.version, "version is required")
    local now = assert(ctx.now, "now is required")
    local today = assert(ctx.today, "today is required")
    local str = assert(ctx.str, "str is required")
    local join_path = assert(ctx.join_path, "join_path is required")
    local relpath = assert(ctx.relpath, "relpath is required")
    local runtime_path = assert(ctx.runtime_path, "runtime_path is required")
    local file_readable = assert(ctx.file_readable, "file_readable is required")
    local read_file = assert(ctx.read_file, "read_file is required")
    local validate_admin_ini_text = assert(ctx.validate_admin_ini_text, "validate_admin_ini_text is required")
    local find_admin_ini = assert(ctx.find_admin_ini, "find_admin_ini is required")
    local atomic_write_json = assert(ctx.atomic_write_json, "atomic_write_json is required")
    local atomic_write_file = assert(ctx.atomic_write_file, "atomic_write_file is required")
    local cached_saved_file_list = assert(ctx.cached_saved_file_list, "cached_saved_file_list is required")
    local cached_log_file_paths = assert(ctx.cached_log_file_paths, "cached_log_file_paths is required")
    local is_active_log = assert(ctx.is_active_log, "is_active_log is required")

    local SOURCE_STATUSES = {
        available=true,
        expected_empty=true,
        partial=true,
        deferred=true,
        unavailable=true,
        malformed=true,
        permission_denied=true,
        error=true,
    }
    local REPORT_COVERAGE_STATUSES = {
        complete=true,
        complete_with_gaps=true,
        partial=true,
        unavailable=true,
    }
    local ROUTE_PROOF_STATUSES = {
        full=true,
        limited_expected_empty=true,
        missing=true,
    }
    local TRANSLATED_MAX_ITEMS = 8
    local TRANSLATED_MAX_REFS = 12
    local TRANSLATED_MAX_VALUE_BYTES = 512
    local DURABLE_LEDGER_MAX_ROWS = 5000
    local PLAYERDATA_DISCOVERY_MAX_FILES = 500
    local TRANSLATION_DICTIONARY_VERSION = "public_value_dictionary/v1"
    local OPERATOR_BRIEF_CONTRACT = "randomdayguard.operator-brief/v1"
    local IS_WINDOWS = package and package.config and package.config:sub(1, 1) == "\\"

    local VALUE_DICTIONARY = {
        route_proof = {
            full={meaning="Current route evidence is complete for the route-owned scope.", confidence="strong"},
            limited_expected_empty={meaning="The route is explicitly empty for its owned scope; this is not a report failure.", confidence="strong"},
            missing={meaning="The route is missing required current proof and must not be treated as complete.", confidence="limited"},
        },
        coverage = {
            complete={meaning="Configured source accounting is terminal with no named source gap.", confidence="strong"},
            complete_with_gaps={meaning="Configured source accounting is terminal with explicit optional gaps.", confidence="moderate"},
            partial={meaning="Bounded source accounting is still incomplete.", confidence="limited"},
            unavailable={meaning="Required source accounting is unavailable.", confidence="limited"},
        },
        source_freshness = {
            fresh_current_poll={meaning="Source evidence matches the current version, boot, epoch, and completed poll.", confidence="strong"},
            current_poll_error={meaning="The current poll recorded an explicit source failure.", confidence="strong"},
            stale_or_unproven={meaning="Source lineage is stale, incomplete, or unproven for this poll.", confidence="limited"},
        },
        identity_confidence = {
            direct_login_request={meaning="Identity is mapped from a server login request.", confidence="strong"},
            mapped_presence_after_login={meaning="Presence was reconciled after a mapped login identity.", confidence="moderate"},
            playerdata_only={meaning="Identity comes from a current PlayerData filename only.", confidence="limited"},
            historical_ledger_identity={meaning="Identity is retained historical context and is not current activity.", confidence="limited"},
            unknown={meaning="Identity confidence is unknown; review source evidence before drawing conclusions.", confidence="unknown"},
        },
    }

    local function sorted_unique(values)
        local out, seen = {}, {}
        for _,value in ipairs(values or {}) do
            value = str(value)
            if value ~= "" and not seen[value] then
                seen[value] = true
                table.insert(out, value)
            end
        end
        table.sort(out)
        return out
    end

    local function bounded_text_value(value)
        value = str(value):gsub("[\r\n\t]+", " ")
        if #value > TRANSLATED_MAX_VALUE_BYTES then
            return value:sub(1, TRANSLATED_MAX_VALUE_BYTES - 3) .. "..."
        end
        return value
    end

    local function append_translated_section(lines, title, values)
        table.insert(lines, title)
        local count = 0
        for _,value in ipairs(values or {}) do
            if count >= TRANSLATED_MAX_ITEMS then break end
            table.insert(lines, "- " .. bounded_text_value(value))
            count = count + 1
        end
        if count == 0 then table.insert(lines, "- None recorded.") end
        if #(values or {}) > count then
            table.insert(lines, "- " .. str(#values - count) .. " additional bounded items omitted; review structured output.")
        end
    end

    local function probe_file(path)
        if not path or path == "" then return "missing", "path_not_configured" end
        local file, open_error = nil, nil
        if io and io.open then
            file, open_error = io.open(path, "rb")
        end
        if file then
            file:close()
            return "available", nil
        end
        local detail = str(open_error):lower()
        if detail:find("permission denied", 1, true) or detail:find("access is denied", 1, true) or detail:find("operation not permitted", 1, true) then
            return "permission_denied", str(open_error)
        end
        if detail:find("no such file", 1, true) or detail:find("cannot find", 1, true) or detail:find("not found", 1, true) then
            return "missing", str(open_error)
        end
        return "unavailable", str(open_error)
    end

    local function map_count(values)
        local count = 0
        for _ in pairs(values or {}) do count = count + 1 end
        return count
    end

    local function source_index_by_name(sources)
        local indexed = {}
        for _,source in ipairs(sources or {}) do indexed[source.source_class] = source end
        return indexed
    end

    local function count_phrase(count, singular, plural)
        count = tonumber(count) or 0
        return str(count) .. " " .. (count == 1 and singular or (plural or (singular .. "s")))
    end

    local runtime_ref

    local function read_all(path)
        local file = io and io.open and io.open(path, "rb") or nil
        if not file then return nil end
        local data = file:read("*a")
        file:close()
        return data
    end

    local function split_tsv(line)
        local values = {}
        line = str(line) .. "\t"
        for value in line:gmatch("(.-)\t") do table.insert(values, value) end
        return values
    end

    local IDENTITY_STRENGTH = {
        direct_login_request=100,
        mapped_presence_after_login=70,
        historical_session_evidence=58,
        historical_ledger_identity=54,
        playerdata_only=50,
        unmapped_presence_only=10,
        unknown=0,
    }

    local function identity_strength(value)
        return IDENTITY_STRENGTH[str(value)] or 0
    end

    local function bool_value(value)
        value = str(value):lower()
        return value == "true" or value == "1" or value == "yes"
    end

    local function exact_numeric_id(value)
        value = str(value)
        return value:match("^%d+$") and value or nil
    end

    local function tsv_value(values, header, key)
        local index = header and header[key] or nil
        return index and values[index] or nil
    end

    local function read_durable_accounts(path, source_ref, skipped_is_partial)
        if not file_readable(path) then return {}, "empty", 0, nil end
        local data = read_all(path)
        if data == nil then return {}, "error", 0, "identity_ledger_read_failed" end
        local header, accounts, row_count, skipped_rows = nil, {}, 0, 0
        for line in data:gmatch("[^\r\n]+") do
            local values = split_tsv(line)
            if not header then
                header = {}
                for index,name in ipairs(values) do header[name] = index end
                if not header.account_id then
                    return {}, "malformed", 0, "identity_ledger_account_id_header_missing"
                end
            else
                row_count = row_count + 1
                if row_count > DURABLE_LEDGER_MAX_ROWS then
                    return {}, "error", row_count, "identity_ledger_row_limit_exceeded"
                end
                local account_id = exact_numeric_id(tsv_value(values, header, "account_id"))
                if account_id then
                    accounts[account_id] = {
                        account_id=account_id,
                        ban_id=tsv_value(values, header, "ban_id") or account_id,
                        display_name=tsv_value(values, header, "display_name") or tsv_value(values, header, "name") or tsv_value(values, header, "log_name") or "",
                        identity_confidence=tsv_value(values, header, "identity_confidence") or "historical_ledger_identity",
                        identity_state=tsv_value(values, header, "identity_state") or "retained_historical_identity",
                        current_playerdata=bool_value(tsv_value(values, header, "current_playerdata")),
                        historical_playerdata_seen=bool_value(tsv_value(values, header, "historical_playerdata_seen")),
                        status=tsv_value(values, header, "status") or "INFO",
                        score=tonumber(tsv_value(values, header, "score")) or 0,
                        first_seen=tsv_value(values, header, "first_seen") or "",
                        last_seen=tsv_value(values, header, "last_seen") or "",
                        source_references={source_ref},
                    }
                    local encoded_refs = tsv_value(values, header, "source_references") or ""
                    for ref in encoded_refs:gmatch("[^|]+") do
                        table.insert(accounts[account_id].source_references, ref)
                    end
                    accounts[account_id].source_references = sorted_unique(accounts[account_id].source_references)
                else
                    skipped_rows = skipped_rows + 1
                end
            end
        end
        if skipped_rows > 0 then
            return accounts, skipped_is_partial == false and "ready" or "partial", row_count, "identity_ledger_non_numeric_rows_skipped:" .. str(skipped_rows)
        end
        return accounts, row_count > 0 and "ready" or "empty", row_count, nil
    end

    local function merge_account_history(target, source)
        for account_id,account in pairs(source or {}) do
            local existing = target[account_id]
            if not existing then
                target[account_id] = account
            else
                existing.source_references = existing.source_references or {}
                existing.ban_id = existing.ban_id ~= "" and existing.ban_id or account.ban_id
                if identity_strength(account.identity_confidence) >= identity_strength(existing.identity_confidence) then
                    existing.display_name = account.display_name ~= "" and account.display_name or existing.display_name
                    existing.identity_confidence = account.identity_confidence or existing.identity_confidence
                    existing.identity_state = account.identity_state or existing.identity_state
                end
                existing.current_playerdata = existing.current_playerdata == true or account.current_playerdata == true
                existing.historical_playerdata_seen = existing.historical_playerdata_seen == true or account.historical_playerdata_seen == true
                if (tonumber(account.score) or 0) >= (tonumber(existing.score) or 0) then
                    existing.score = tonumber(account.score) or 0
                    existing.status = account.status or existing.status
                end
                existing.first_seen = existing.first_seen ~= "" and existing.first_seen or account.first_seen
                if account.last_seen ~= "" and (existing.last_seen == "" or account.last_seen > existing.last_seen) then existing.last_seen = account.last_seen end
                for _,ref in ipairs(account.source_references or {}) do table.insert(existing.source_references, ref) end
                existing.source_references = sorted_unique(existing.source_references)
            end
        end
        return target
    end

    local function write_durable_accounts(accounts)
        local header = {"account_id", "ban_id", "display_name", "identity_confidence", "identity_state", "current_playerdata", "historical_playerdata_seen", "status", "score", "first_seen", "last_seen", "source_references"}
        local rows = {table.concat(header, "\t")}
        local ids = {}
        for account_id in pairs(accounts or {}) do table.insert(ids, account_id) end
        table.sort(ids)
        if #ids > DURABLE_LEDGER_MAX_ROWS then return false, "identity_ledger_row_limit_exceeded" end
        for _,account_id in ipairs(ids) do
            local account = accounts[account_id]
            local values = {
                account_id, account.ban_id or "", account.display_name or "", account.identity_confidence or "unknown", account.identity_state or "retained_historical_identity",
                tostring(account.current_playerdata == true), tostring(account.historical_playerdata_seen == true),
                account.status or "INFO", account.score or 0, account.first_seen or "", account.last_seen or "",
                table.concat(sorted_unique(account.source_references), "|"),
            }
            for index,value in ipairs(values) do values[index] = str(value):gsub("[\r\n\t]+", " ") end
            table.insert(rows, table.concat(values, "\t"))
        end
        return atomic_write_file(runtime_path("runtime/history/public_accounts.tsv"), table.concat(rows, "\n") .. "\n")
    end

    local function read_durable_session_count()
        local data = read_all(runtime_path("runtime/session_events.tsv")) or ""
        local sessions = {}
        for line in data:gmatch("[^\r\n]+") do
            local columns = split_tsv(line)
            local session_id = columns[3]
            if session_id and session_id ~= "" and session_id ~= "session_id" then sessions[session_id] = true end
        end
        return map_count(sessions)
    end

    -- Capture durable history before startup refreshes current snapshot files.
    -- The independent history file prevents a second quiet restart from erasing it.
    local prior_accounts = {}
    local durable_accounts, durable_ledger_status, durable_ledger_row_count, durable_ledger_error = read_durable_accounts(runtime_path("runtime/history/public_accounts.tsv"), "runtime/history/public_accounts.tsv", true)
    local snapshot_accounts, snapshot_ledger_status, snapshot_ledger_row_count, snapshot_ledger_error = read_durable_accounts(runtime_path("runtime/account_evidence.tsv"), "runtime/account_evidence.tsv", false)
    local durable_ledger_load_ok = durable_ledger_status ~= "error" and durable_ledger_status ~= "malformed"
        and snapshot_ledger_status ~= "error" and snapshot_ledger_status ~= "malformed"
    if durable_ledger_load_ok then
        merge_account_history(prior_accounts, durable_accounts)
        merge_account_history(prior_accounts, snapshot_accounts)
    end
    local prior_session_count = read_durable_session_count()

    local function json_unescape(value)
        local unescaped = str(value):gsub("\\n", "\n"):gsub("\\r", "\r"):gsub("\\t", "\t"):gsub('\\"', '"'):gsub("\\\\", "\\")
        return unescaped
    end

    local function json_string_field(text, key)
        local value = str(text):match('"' .. key .. '"%s*:%s*"(.-)"')
        return value and json_unescape(value) or nil
    end

    local function json_number_field(text, key)
        return tonumber(str(text):match('"' .. key .. '"%s*:%s*(-?%d+%.?%d*)'))
    end

    local function json_string_array_field(text, key)
        local values = {}
        local body = str(text):match('"' .. key .. '"%s*:%s*%[(.-)%]')
        for value in str(body):gmatch('"(.-)"') do table.insert(values, json_unescape(value)) end
        return sorted_unique(values)
    end

    local function retained_case_from_json(text, source_ref)
        local case_id = json_string_field(text, "case_id")
        if not case_id or case_id == "" then return nil end
        local accounts = json_string_array_field(text, "accounts")
        local refs = {source_ref}
        for _,key in ipairs({"source_references", "evidence_references", "report_paths"}) do
            for _,ref in ipairs(json_string_array_field(text, key)) do table.insert(refs, ref) end
        end
        local evidence_items = {}
        for _,key in ipairs({"evidence", "evidence_event_ids", "confirmed_fact_event_ids"}) do
            for _,item in ipairs(json_string_array_field(text, key)) do table.insert(evidence_items, item) end
        end
        local score = json_number_field(text, "score") or json_number_field(text, "central_account_score") or json_number_field(text, "observed_value") or 0
        for _,account_id in ipairs(accounts) do score = math.max(score, tonumber((prior_accounts[account_id] or {}).score) or 0) end
        return {
            case_id=case_id,
            ts=json_string_field(text, "ts") or "",
            reason=json_string_field(text, "reason") or "retained_case",
            status=json_string_field(text, "review_status") or json_string_field(text, "status") or "REVIEW",
            score=score,
            accounts=accounts,
            evidence=json_string_field(text, "evidence") or json_string_field(text, "note") or "",
            evidence_items=sorted_unique(evidence_items),
            source_references=sorted_unique(refs),
            scope="historical",
            current_live_evidence=false,
        }
    end

    local function read_retained_cases(refs)
        local cases, parse_failures = {}, 0
        local function add_case(text, source_ref)
            local case = retained_case_from_json(text, source_ref)
            if case then cases[case.case_id] = case else parse_failures = parse_failures + 1 end
        end
        for _,ref in ipairs(refs or {}) do
            local data = read_file(runtime_path(ref), 262144) or ""
            if ref:lower():match("index%.jsonl$") then
                for line in data:gmatch("[^\r\n]+") do add_case(line, ref) end
            elseif ref:lower():match("%.json$") then
                add_case(data, ref)
            end
        end
        return cases, parse_failures
    end

    local function normalize_local_path(path)
        path = str(path):gsub("\\", "/"):gsub("/+", "/")
        return path:gsub("/$", "")
    end

    local UNSAFE_SHELL_PATH_CHARS = {
        ['"']=true, ["'"]=true, ['$']=true, ['`']=true, ['%']=true,
        ['!']=true, ['^']=true, ['&']=true, [';']=true, ['|']=true,
        ['<']=true, ['>']=true,
    }

    -- Inventory commands accept absolute POSIX paths or absolute Windows drive
    -- paths. A colon is valid only as the drive separator at byte two.
    local function inventory_root_is_safe(root)
        root = str(root)
        if root == "" then return false end
        local third = root:sub(3, 3)
        local windows_drive = #root >= 3
            and root:sub(1, 1):match("%a") ~= nil
            and root:byte(2) == 58
            and (third == "/" or third == "\\")
        local posix_absolute = root:sub(1, 1) == "/"
        if not windows_drive and not posix_absolute then return false end
        for index=1,#root do
            local byte = root:byte(index)
            if byte < 32 or byte == 127 or UNSAFE_SHELL_PATH_CHARS[root:sub(index, index)] then return false end
            if byte == 58 and not (windows_drive and index == 2) then return false end
        end
        return true
    end

    local function shell_quote(path)
        path = str(path)
        if not inventory_root_is_safe(path) then return nil end
        return '"' .. path .. '"'
    end

    local function current_playerdata_id(root, path)
        root = normalize_local_path(root):lower()
        path = normalize_local_path(path)
        local lower_path = path:lower()
        if lower_path:sub(1, #root + 1) ~= root .. "/" then return nil end
        local relative = lower_path:sub(#root + 2)
        return relative:match("^savegames/server/worlds/[^/]+/playerdata/player_(%d+)%.sav$")
    end

    local function process_close_succeeded(handle)
        local ok, result, _, code = pcall(function() return handle:close() end)
        return ok and (result == true or result == 0 or code == 0)
    end

    -- Public contract: discovery is rooted at the selected live Saved folder and
    -- accepts only one active world/PlayerData level; backup trees never count.
    -- Failure behavior: unavailable command execution stays deferred, never empty.
    local function discover_current_playerdata_files_bounded(root, limit)
        root = normalize_local_path(root)
        limit = math.max(1, math.min(PLAYERDATA_DISCOVERY_MAX_FILES, tonumber(limit) or PLAYERDATA_DISCOVERY_MAX_FILES))
        local result = {
            root=root,
            limit=limit,
            entries={},
            command_available=false,
            completed=false,
            truncated=false,
            error=nil,
        }
        if root == "" then result.error = "saved_root_unavailable"; return result end
        if not inventory_root_is_safe(root) then result.error = "unsafe_playerdata_root"; return result end
        local seen = {}
        local function add(path, source)
            path = normalize_local_path(path)
            local account_id = current_playerdata_id(root, path)
            local key = path:lower()
            if account_id and not seen[key] and (file_readable(path) or read_file(path, 1) ~= nil) then
                seen[key] = true
                table.insert(result.entries, {
                    account_id=account_id,
                    path=path,
                    source=source,
                    source_reference="Saved/" .. relpath(root, path),
                })
            end
        end
        for _,meta in ipairs(cached_saved_file_list() or {}) do
            if #result.entries >= limit then result.truncated = true; break end
            add(meta.path or "", "cached_saved_file_list")
        end
        if io and io.popen then
            local worlds = join_path(root, "SaveGames/Server/Worlds")
            local commands = {}
            if IS_WINDOWS then
                local quoted_windows_worlds = shell_quote((worlds:gsub("/", "\\")) .. "\\Player_*.sav")
                if quoted_windows_worlds then
                    table.insert(commands, "cmd /c dir /s /b " .. quoted_windows_worlds .. " 2>nul")
                end
            else
                local quoted_worlds = shell_quote(worlds)
                if quoted_worlds then
                    table.insert(commands, "find " .. quoted_worlds .. " -mindepth 3 -maxdepth 3 -path '*/PlayerData/Player_*.sav' -type f -print 2>/dev/null")
                end
            end
            for _,command in ipairs(commands) do
                local ok_open, handle = pcall(io.popen, command)
                if ok_open and handle then
                    result.command_available = true
                    local ok_lines, line_error = pcall(function()
                        local line_count = 0
                        for line in handle:lines() do
                            line_count = line_count + 1
                            if line_count > limit then result.truncated = true; break end
                            add(line, command:sub(1, 4) == "find" and "bounded_find" or "bounded_dir")
                            if #result.entries >= limit then result.truncated = true; break end
                        end
                    end)
                    local closed = process_close_succeeded(handle)
                    if ok_lines and closed then result.completed = true end
                    if not ok_lines then result.error = "playerdata_discovery_read_failed:" .. str(line_error) end
                end
                if result.truncated then break end
            end
        end
        table.sort(result.entries, function(a,b) return str(a.path) < str(b.path) end)
        return result
    end

    local function bounded_runtime_inventory(root_rel, max_files)
        local root = normalize_local_path(runtime_path(root_rel))
        max_files = math.max(1, tonumber(max_files) or 100)
        if not inventory_root_is_safe(root) then
            return {}, false, false, "unsafe_inventory_root"
        end
        if not io or not io.popen then return {}, false, false, "inventory_command_unavailable" end
        local commands = {}
        if IS_WINDOWS then
            local quoted_windows_root = shell_quote(root:gsub("/", "\\") .. "\\*")
            if quoted_windows_root then
                table.insert(commands, "cmd /c dir /s /b " .. quoted_windows_root .. " 2>nul")
            end
        else
            local quoted_root = shell_quote(root)
            if quoted_root then
                table.insert(commands, "find " .. quoted_root .. " -maxdepth 3 -type f -print 2>/dev/null")
            end
        end
        local refs, seen, inventory_available, truncated, inventory_error = {}, {}, false, false, nil
        for _,command in ipairs(commands) do
            local ok_open, pipe = pcall(io.popen, command)
            if not ok_open then
                inventory_error = "inventory_command_open_failed"
            elseif pipe then
                local command_rows, command_seen = {}, {}
                local ok_read = pcall(function()
                    for line in pipe:lines() do
                        local path = normalize_local_path(line)
                        local lower_root, lower_path = root:lower(), path:lower()
                        local name = lower_path:match("([^/]+)$") or ""
                        local bookkeeping = name == ".gitkeep" or name:sub(1, 1) == "." or name:match("%.tmp$") or name:match("%.lock$") or name:match("~$")
                        if (lower_path == lower_root or lower_path:sub(1, #lower_root + 1) == lower_root .. "/") and not bookkeeping and file_readable(path) and not seen[lower_path] and not command_seen[lower_path] then
                            if #refs + #command_rows >= max_files then
                                truncated = true
                                break
                            end
                            command_seen[lower_path] = true
                            table.insert(command_rows, {key=lower_path, ref=runtime_ref(path)})
                        end
                    end
                end)
                local ok_close = pcall(function() return pipe:close() end)
                if ok_read and ok_close then
                    inventory_available = true
                    for _,row in ipairs(command_rows) do
                        seen[row.key] = true
                        table.insert(refs, row.ref)
                    end
                elseif not ok_read then
                    inventory_error = "inventory_command_read_failed"
                else
                    inventory_error = "inventory_command_close_failed"
                end
                if #refs > 0 then break end
            else
                inventory_error = "inventory_command_open_failed"
            end
        end
        table.sort(refs)
        if inventory_available then return refs, true, truncated, nil end
        return {}, false, truncated, inventory_error or "inventory_command_unavailable"
    end

    runtime_ref = function(path)
        return relpath(state.mod_root or ".", path)
    end

    -- Snapshot retained runtime history before start() writes current-boot outputs.
    local prior_case_refs, prior_case_inventory_available, prior_case_truncated, prior_case_inventory_error = bounded_runtime_inventory("runtime/raid_cases", 100)
    local prior_report_refs_a, prior_report_inventory_available_a, prior_report_truncated_a, prior_report_inventory_error_a = bounded_runtime_inventory("runtime/final_logs", 100)
    local prior_report_refs_b, prior_report_inventory_available_b, prior_report_truncated_b, prior_report_inventory_error_b = bounded_runtime_inventory("runtime/forensic_days", 100)
    local prior_report_refs_c, prior_report_inventory_available_c, prior_report_truncated_c, prior_report_inventory_error_c = bounded_runtime_inventory("runtime/warnings", 100)
    local prior_evidence_refs, prior_evidence_inventory_available, prior_evidence_truncated, prior_evidence_inventory_error = bounded_runtime_inventory("runtime/evidence", 100)
    local prior_cases, prior_case_parse_failures = read_retained_cases(prior_case_refs)

    local function saved_ref(path)
        if not state.saved_root then return "Saved source unavailable" end
        return "Saved/" .. relpath(state.saved_root, path)
    end

    local function source_record(name, scope, required, status, refs, detail, count)
        if not SOURCE_STATUSES[status] then status = "error" end
        local terminal = status ~= "partial" and status ~= "deferred"
        return {
            source_class=name,
            scope=scope,
            required=required == true,
            status=status,
            terminal=terminal,
            available=status == "available" or status == "expected_empty",
            readable=status == "available" or status == "expected_empty",
            file_count=tonumber(count) or 0,
            source_references=sorted_unique(refs),
            detail=detail,
            does_not_prove="Source availability does not prove player intent, ownership, damage, duplication, or enforcement eligibility.",
        }
    end

    local function collect_sources(playerdata_discovery)
        local log_paths = cached_log_file_paths() or {}
        local active_refs, backup_refs, playerdata_refs = {}, {}, {}
        local active_probe_status, active_probe_detail = "unavailable", "no active log path was discovered"
        local backup_path_seen, backup_probe_status, backup_probe_detail = false, "expected_empty", "no backup log path was discovered"

        for _,path in ipairs(log_paths) do
            local probe_status, probe_detail = probe_file(path)
            if is_active_log(path) then
                if probe_status == "available" then
                    table.insert(active_refs, saved_ref(path))
                    active_probe_status, active_probe_detail = "available", nil
                elseif active_probe_status ~= "available" then
                    active_probe_status, active_probe_detail = probe_status == "missing" and "unavailable" or probe_status, probe_detail
                end
            elseif probe_status == "available" then
                backup_path_seen = true
                table.insert(backup_refs, saved_ref(path))
                backup_probe_status, backup_probe_detail = "available", nil
            else
                backup_path_seen = true
                if backup_probe_status ~= "available" then
                    backup_probe_status, backup_probe_detail = probe_status == "missing" and "unavailable" or probe_status, probe_detail
                end
            end
        end
        playerdata_discovery = playerdata_discovery or {entries={}, completed=false, truncated=false, error="playerdata_discovery_not_run"}
        for _,entry in ipairs(playerdata_discovery.entries or {}) do table.insert(playerdata_refs, entry.source_reference) end
        local playerdata_status, playerdata_detail
        if not state.saved_root then
            playerdata_status, playerdata_detail = "unavailable", "Saved root is unavailable, so current PlayerData discovery could not run."
        elseif playerdata_discovery.error == "unsafe_playerdata_root" then
            playerdata_status, playerdata_detail = "malformed", "Selected Saved root was rejected by the bounded discovery path guard."
        elseif playerdata_discovery.truncated == true then
            playerdata_status, playerdata_detail = "partial", "Bounded current PlayerData discovery reached its file limit; current-character counts may be incomplete."
        elseif playerdata_discovery.completed ~= true then
            playerdata_status, playerdata_detail = "deferred", "Bounded current PlayerData discovery is pending or command execution was unavailable; expected-empty is not proven."
        elseif #playerdata_refs > 0 then
            playerdata_status, playerdata_detail = "available", "Current PlayerData filenames were discovered under the selected live Saved root."
        else
            playerdata_status, playerdata_detail = "expected_empty", "Bounded discovery completed under the selected live Saved root and found no current PlayerData files."
        end

        local admin_path, admin_path_error = find_admin_ini()
        local admin_status, admin_detail = "unavailable", "Saved root is unavailable"
        local admin_refs = {}
        if state.saved_root then
            local admin_probe, admin_probe_detail = "missing", admin_path_error
            if admin_path then admin_probe, admin_probe_detail = probe_file(admin_path) end
            if admin_path_error then
                admin_status = "malformed"
                admin_detail = admin_path_error
            elseif admin_probe == "available" then
                admin_status = "available"
                admin_refs = {saved_ref(admin_path)}
                local admin_text = read_file(admin_path)
                local valid, validation_error = validate_admin_ini_text(admin_text or "")
                if not valid then
                    admin_status = "malformed"
                    admin_detail = validation_error or "admin_ini_validation_failed"
                else
                    admin_detail = "Current administrator state is readable and structurally valid."
                end
            elseif admin_probe == "missing" then
                admin_status = "expected_empty"
                admin_detail = "Admin.ini is absent; no administrator state was expected from this optional source."
            else
                admin_status = admin_probe
                admin_detail = admin_probe_detail or "Admin.ini could not be read."
            end
        end

        local scan_status, scan_refs, scan_count = "deferred", {}, 0
        if file_readable(runtime_path("runtime/scan_complete.json")) then
            scan_status, scan_refs, scan_count = "available", {"runtime/scan_complete.json", "runtime/baselines/file_manifest.tsv"}, 1
        elseif file_readable(runtime_path("runtime/scan_checkpoint.json")) or file_readable(runtime_path("runtime/scan_progress.json")) then
            scan_status, scan_refs, scan_count = "partial", {"runtime/scan_checkpoint.json", "runtime/scan_progress.json"}, 1
        elseif state.startup_scan_pending ~= true then
            scan_status = "unavailable"
        end

        local case_refs = prior_case_refs
        local case_inventory_available = prior_case_inventory_available
        local case_truncated = prior_case_truncated
        local case_count = #case_refs
        local report_refs = {}
        for _,ref in ipairs(prior_report_refs_a) do table.insert(report_refs, ref) end
        for _,ref in ipairs(prior_report_refs_b) do table.insert(report_refs, ref) end
        for _,ref in ipairs(prior_report_refs_c) do table.insert(report_refs, ref) end
        local report_inventory_available = prior_report_inventory_available_a or prior_report_inventory_available_b or prior_report_inventory_available_c
        local report_truncated = prior_report_truncated_a or prior_report_truncated_b or prior_report_truncated_c
        local evidence_refs = prior_evidence_refs
        local evidence_inventory_available = prior_evidence_inventory_available
        local evidence_truncated = prior_evidence_truncated
        local case_inventory_detail = prior_case_inventory_error
            or (prior_case_parse_failures > 0 and (str(prior_case_parse_failures) .. " retained case summaries could not be parsed.")
            or (case_truncated and "Bounded case inventory reached its limit." or "Existing local case records retained before this boot."))
        local report_inventory_detail = prior_report_inventory_error_a or prior_report_inventory_error_b or prior_report_inventory_error_c or (report_truncated and "Bounded report inventory reached its limit." or "Existing local report records retained before this boot.")
        local evidence_inventory_detail = prior_evidence_inventory_error or (evidence_truncated and "Bounded evidence inventory reached its limit." or "Existing local evidence records retained before this boot.")

        local playerdata_source = source_record("playerdata_filenames", "current", false,
            playerdata_status, playerdata_refs, playerdata_detail, #playerdata_refs)
        playerdata_source.discovery_completed = playerdata_discovery.completed == true
        playerdata_source.discovery_pending = playerdata_discovery.completed ~= true
        playerdata_source.discovery_truncated = playerdata_discovery.truncated == true
        playerdata_source.discovery_limit = playerdata_discovery.limit or PLAYERDATA_DISCOVERY_MAX_FILES
        playerdata_source.current_character_identity_count = #playerdata_refs
        playerdata_source.playerdata_presence_is_activity = false

        return {
            source_record("active_log", "current", true,
                #active_refs > 0 and "available" or active_probe_status,
                active_refs, active_probe_detail or "Current server log evidence.", #active_refs),
            source_record("admin_ini", "current", false, admin_status, admin_refs,
                admin_detail, #admin_refs),
            source_record("recent_backup_logs", "historical", false,
                #backup_refs > 0 and "available" or (backup_path_seen and backup_probe_status or (state.saved_root and "expected_empty" or "unavailable")),
                backup_refs, backup_probe_detail or "Recent rotated or backup log context.", #backup_refs),
            playerdata_source,
            source_record("existing_cases", "historical", false,
                case_count > 0 and ((case_truncated or prior_case_parse_failures > 0) and "partial" or "available")
                    or (prior_case_parse_failures > 0 and "malformed" or (case_inventory_available and "expected_empty" or "unavailable")),
                case_refs, case_inventory_detail, case_count),
            source_record("existing_reports", "historical", false,
                #report_refs > 0 and (report_truncated and "partial" or "available") or (report_inventory_available and "expected_empty" or "unavailable"),
                report_refs, report_inventory_detail, #report_refs),
            source_record("existing_evidence", "historical", false,
                #evidence_refs > 0 and (evidence_truncated and "partial" or "available") or (evidence_inventory_available and "expected_empty" or "unavailable"),
                evidence_refs, evidence_inventory_detail, #evidence_refs),
            source_record("world_save_scan", "historical", false, scan_status, scan_refs,
                "Bounded slow scan with resumable changed-file manifest.", scan_count),
        }
    end

    local function summarize_sources(sources)
        local required_failure, pending, gap = false, false, false
        local usable, unavailable = {}, {}
        for _,source in ipairs(sources) do
            if source.status == "available" or source.status == "expected_empty" then
                table.insert(usable, source.source_class)
            else
                table.insert(unavailable, source.source_class)
            end
            if source.status == "partial" or source.status == "deferred" then pending = true end
            if source.status == "unavailable" or source.status == "malformed" or source.status == "permission_denied" or source.status == "error" then
                gap = true
                if source.required then required_failure = true end
            end
        end
        local status = "complete"
        if required_failure then status = "unavailable"
        elseif pending then status = "partial"
        elseif gap then status = "complete_with_gaps" end
        return status, sorted_unique(usable), sorted_unique(unavailable)
    end

    local function current_cycle_proof(active_log_available)
        local epoch_id = state.current_epoch and state.current_epoch.epoch_id or nil
        local poll_id = tonumber(state.poll_id) or 0
        local lineage_complete = str(version) ~= "" and str(state.boot_id) ~= "" and str(epoch_id) ~= "" and poll_id > 0
        local source = type(state.current_poll_source) == "table" and state.current_poll_source or {}
        local source_matches = lineage_complete
            and str(source.version) == str(version)
            and str(source.boot_id) == str(state.boot_id)
            and str(source.epoch_id) == str(epoch_id)
            and tonumber(source.poll_id) == poll_id
        local source_status = source_matches and str(source.status) or "stale_or_unproven"
        local source_fresh = source_matches and source_status == "fresh_current_poll"
            and active_log_available == true and str(source.poll_completed_ts) ~= ""
        local cycle_id = table.concat({str(version), str(state.boot_id), str(epoch_id), str(poll_id)}, "/")
        return {
            version=version,
            boot_id=state.boot_id,
            epoch_id=epoch_id,
            poll_id=poll_id,
            cycle_id=cycle_id,
            lineage_complete=lineage_complete,
            complete=source_fresh,
            source_freshness={
                status=source_fresh and "fresh_current_poll" or source_status,
                current_cycle=source_matches,
                checked_ts=now(),
                active_log_status=active_log_available and "available" or "unavailable",
                source_version=source.version,
                source_boot_id=source.boot_id,
                source_epoch_id=source.epoch_id,
                source_poll_id=source.poll_id,
                collected_ts=source.collected_ts,
                last_poll_ts=source.last_poll_ts,
                poll_completed_ts=source.poll_completed_ts,
                poll_completed_count=source.poll_completed_count,
                active_log_read_failed=source.active_log_read_failed == true,
                log_tail_status=source.log_tail_status,
            },
        }
    end

    local function set_report_result(report, proof_status)
        if not ROUTE_PROOF_STATUSES[proof_status] then proof_status = "missing" end
        report.route_proof_status = proof_status
        report.completed = proof_status ~= "missing"
        report.expected_empty = proof_status == "limited_expected_empty"
        report.route_result = {
            status=proof_status,
            completed=report.completed,
            expected_empty=report.expected_empty,
        }
        return report
    end

    local function report_base(route, proof_status, coverage_status, observed, interpretation, unknown, does_not_prove, next_action, refs, cycle)
        if not ROUTE_PROOF_STATUSES[proof_status] then proof_status = "missing" end
        if not REPORT_COVERAGE_STATUSES[coverage_status] then coverage_status = "unavailable" end
        local report = {
            schema="randomdayguard.report/v1",
            generated_ts=now(),
            report_date=today(),
            version=cycle.version,
            boot_id=cycle.boot_id,
            epoch_id=cycle.epoch_id,
            poll_id=cycle.poll_id,
            cycle_id=cycle.cycle_id,
            source_freshness=cycle.source_freshness,
            current_cycle_lineage_complete=cycle.lineage_complete == true,
            current_cycle_proof_complete=cycle.complete == true,
            route=route,
            coverage_status=coverage_status,
            observed=observed or {},
            interpretation=interpretation or {},
            unknown=unknown or {},
            does_not_prove=does_not_prove or {},
            next_action=next_action,
            source_references=sorted_unique(refs),
            enforcement_authority=false,
        }
        return set_report_result(report, proof_status)
    end

    local function translated_value(category, value)
        local raw = str(value)
        if raw == "" or raw == "nil" then raw = "unknown" end
        local row = (VALUE_DICTIONARY[category] or {})[raw]
        if row then
            return {
                category=category,
                raw_value=raw,
                meaning=row.meaning,
                confidence=row.confidence,
                mapped=true,
            }
        end
        return {
            category=category,
            raw_value=raw,
            meaning="Unknown or unmapped " .. str(category) .. " value (" .. raw .. "); review source evidence before drawing conclusions.",
            confidence="unknown",
            mapped=false,
        }
    end

    local function make_rating(metric, score, issue_status, explanation, why_not_higher, why_not_lower, operator_action, raw_values)
        score = math.max(0, math.min(5, tonumber(score) or 0))
        local labels = {[0]="No support", [1]="Weak support", [2]="Limited support", [3]="Running with limitations", [4]="Strong support", [5]="Complete support"}
        return {
            metric=metric,
            score=score,
            max_score=5,
            label=labels[score],
            issue_status=issue_status,
            explanation=explanation,
            why_not_higher=why_not_higher,
            why_not_lower=why_not_lower,
            operator_action=operator_action,
            raw_values=raw_values or {},
        }
    end

    local function route_rating_explanations(report)
        if report.route_proof_status == "missing" then
            return {make_rating("route_completeness", 0, "blocked",
                "Required current proof or an owned output write is missing for this route.",
                "Current lineage, source accounting, and paired output writes must agree.",
                "The missing state is explicit and queueing remains blocked.",
                report.next_action, {route=report.route, coverage_status=report.coverage_status, source_freshness=(report.source_freshness or {}).status})}
        end
        if report.route == "server_status" then
            local running = report.scheduler_status == "running" and report.current_cycle_proof_complete == true
            return {make_rating("operational_health", running and 5 or 1, running and "not_failure" or "blocked",
                running and "Scheduler and current-poll source freshness agree." or "Current server continuity is not fully proven.",
                running and "No higher rating exists." or "Current scheduler and source freshness must both be proven.",
                running and "The rating remains limited to Guard operation." or "A current status artifact still exists for review.",
                report.next_action, {scheduler_status=report.scheduler_status, source_freshness=(report.source_freshness or {}).status})}
        end
        if report.route == "player_activity" then
            local movement = report.movement or {}
            local present = report.player_activity_present == true
            local identity_score = (tonumber(report.current_character_identity_count) or 0) > 0 and 1 or 0
            return {
                make_rating("live_presence_strength", present and 4 or 0, present and "caution" or "expected_empty",
                    present and "Current movement or same-day session evidence owns this route." or "No current movement or same-day session evidence owns this route.",
                    present and "Observed activity remains bounded to recorded session transitions." or "A current movement or same-day session row is required.",
                    present and "The route does not infer intent or conduct." or "The expected-empty state is explicit rather than guessed from history.",
                    report.next_action, movement),
                make_rating("identity_strength", identity_score, identity_score > 0 and "caution" or "expected_empty",
                    identity_score > 0 and "Current PlayerData supplies numeric roster identity only." or "No current character identity was discovered.",
                    "PlayerData does not supply direct login identity or conduct evidence.",
                    "Current and retained identity counts remain reconciled and reviewable.",
                    "Review login/session evidence before identity-sensitive conclusions.",
                    {current_character_identity_count=report.current_character_identity_count, retained_identity_count=report.retained_identity_count}),
            }
        end
        if report.route == "case_review" then
            local present = (tonumber(report.current_case_count) or 0) > 0
            return {make_rating("review_readiness", present and 3 or 0, present and "caution" or "expected_empty",
                present and "Current named review material exists." or "No current named review subject exists.",
                present and "Each subject still requires source-level human review." or "A named current review item is required.",
                present and "Eligibility remains separate from action." or "Historical cases remain context without triggering this route.",
                report.next_action, {current_case_count=report.current_case_count, retained_case_count=report.retained_case_count})}
        end
        if report.route == "daily_rollup" then
            local mature = ((report.daily_maturity or {}).mature) == true
            return {make_rating("report_completeness", mature and 4 or 2, mature and "not_failure" or "expected_empty",
                mature and "The once-per-day continuity report passed its current report-maturity checks." or "Daily continuity is not mature yet; this is an explicit expected-empty state.",
                mature and "Route-specific reports remain the detailed evidence surfaces." or "Terminal source accounting, a completed poll, and durable identity reconciliation are required.",
                "The daily archive keeps source gaps and route ownership explicit.",
                report.next_action, report.daily_maturity or {})}
        end
        local failure = report.critical_failure_present == true
        return {make_rating("guard_failure_state", failure and 0 or 5, failure and "failure" or "not_failure",
            failure and "A current-boot or current-poll Guard failure is recorded." or "No current Guard failure owns this route.",
            failure and "Repair and verify the recorded current failure." or "No higher rating exists.",
            "This route is limited to Guard failures and serious current blockers.",
            report.next_action, {critical_failure_present=failure, source_freshness=(report.source_freshness or {}).status})}
    end

    local function attach_operator_brief(report)
        local notes = {
            translated_value("route_proof", report.route_proof_status),
            translated_value("coverage", report.coverage_status),
            translated_value("source_freshness", (report.source_freshness or {}).status),
        }
        if report.route == "player_activity" then
            local first = (report.current_players or {})[1] or (report.historical_players or {})[1] or {}
            table.insert(notes, translated_value("identity_confidence", first.identity_confidence or "unknown"))
        end
        local unmapped = 0
        for _,note in ipairs(notes) do if note.mapped ~= true then unmapped = unmapped + 1 end end
        local headline, meaning, boundary
        if report.route == "server_status" then
            headline = "Server continuity brief"
            meaning = "This route covers scheduler, startup, poll, scan, and current source continuity only."
            boundary = "Server continuity does not prove player conduct or causation."
        elseif report.route == "player_activity" then
            headline = "Player activity brief"
            meaning = report.player_activity_present and "Current movement or same-day session evidence is present." or "No current movement or same-day session evidence is present."
            boundary = "Historical identity, PlayerData, and retained reports do not prove current player activity, intent, ownership, damage, or enforcement eligibility."
        elseif report.route == "case_review" then
            headline = "Case review brief"
            meaning = (tonumber(report.current_case_count) or 0) > 0 and "Current named review material is available." or "Case review is explicitly expected-empty because no current named review material exists."
            boundary = "Historical cases and review thresholds remain review context; they do not authorize automatic action."
        elseif report.route == "daily_rollup" then
            headline = "Daily continuity brief for " .. str(report.report_date)
            meaning = "This is the once-per-day continuity archive across server, player, case, scan, source, and identity accounting."
            boundary = "Daily continuity is an index of bounded evidence and does not replace route-specific source review."
        else
            headline = "Critical Guard brief"
            meaning = report.critical_failure_present and "A current Guard failure requires operator review." or "No current Guard failure is recorded."
            boundary = "Expected-empty critical status does not prove future availability."
        end
        if report.route_proof_status == "missing" then
            meaning = "Required current proof is missing for this route; use the named source and output failure state before drawing conclusions."
        end
        report.translation = {
            dictionary_version=TRANSLATION_DICTIONARY_VERSION,
            notes=notes,
            unmapped_value_count=unmapped,
            unknown_unmapped_fallback="Unknown or unmapped values remain explicit and require source review.",
        }
        report.operator_brief = {
            contract=OPERATOR_BRIEF_CONTRACT,
            route=report.route,
            headline=headline,
            meaning=meaning,
            confirmed_evidence=report.observed,
            inferred_context=report.interpretation,
            unknowns=report.unknown,
            evidence_boundary=boundary,
            rating_explanations=route_rating_explanations(report),
            translation_notes=notes,
            operator_action=report.next_action,
            review_first=true,
            enforcement_authority=false,
        }
        return report
    end

    local function translated_text(report)
        local brief = report.operator_brief or attach_operator_brief(report).operator_brief
        local lines = {
            bounded_text_value(brief.headline),
            "Generated: " .. report.generated_ts,
            "",
            "Summary",
            bounded_text_value(brief.meaning),
            "",
        }
        append_translated_section(lines, "What Guard observed", report.observed)
        table.insert(lines, "")
        append_translated_section(lines, "What it means", report.interpretation)
        table.insert(lines, "")
        append_translated_section(lines, "What remains unknown", report.unknown)
        table.insert(lines, "")
        table.insert(lines, "Recommended next step")
        table.insert(lines, bounded_text_value(report.next_action))
        table.insert(lines, "")
        table.insert(lines, "Evidence boundary")
        table.insert(lines, bounded_text_value(brief.evidence_boundary))
        for _,value in ipairs(report.does_not_prove or {}) do table.insert(lines, "- " .. bounded_text_value(value)) end
        table.insert(lines, "")
        table.insert(lines, "Rating explanation")
        for _,rating in ipairs(brief.rating_explanations or {}) do
            table.insert(lines, "- " .. bounded_text_value(str(rating.metric) .. ": " .. str(rating.score) .. "/" .. str(rating.max_score) .. " - " .. str(rating.label) .. ". " .. str(rating.explanation)))
        end
        table.insert(lines, "")
        table.insert(lines, "Technical record")
        table.insert(lines, "- Route: " .. str(report.route))
        table.insert(lines, "- Version: " .. str(report.version))
        table.insert(lines, "- Cycle: boot=" .. str(report.boot_id) .. " epoch=" .. str(report.epoch_id) .. " poll=" .. str(report.poll_id))
        table.insert(lines, "- Source freshness: " .. str((report.source_freshness or {}).status))
        table.insert(lines, "- Route result: " .. str(report.route_proof_status))
        table.insert(lines, "- Coverage: " .. str(report.coverage_status))
        table.insert(lines, "")
        table.insert(lines, "Translation notes")
        for _,note in ipairs(brief.translation_notes or {}) do
            table.insert(lines, "- " .. bounded_text_value(str(note.category) .. "=" .. str(note.raw_value) .. " -> " .. str(note.meaning)))
        end
        local refs = {}
        for index,ref in ipairs(report.source_references or {}) do
            if index > TRANSLATED_MAX_REFS then break end
            table.insert(refs, bounded_text_value(ref))
        end
        table.insert(lines, "")
        table.insert(lines, "Source references")
        for _,ref in ipairs(refs) do table.insert(lines, "- " .. ref) end
        if #refs == 0 then table.insert(lines, "- None recorded.") end
        if #(report.source_references or {}) > #refs then
            table.insert(lines, "- " .. str(#report.source_references - #refs) .. " additional references are available in the structured report.")
        end
        return table.concat(lines, "\n") .. "\n"
    end

    local function write_report(report)
        local root = (((state.config or {}).reports or {}).output_root) or "runtime/final_logs"
        local json_rel = root .. "/" .. report.route .. "_latest.json"
        local text_rel = root .. "/" .. report.route .. "_latest.txt"
        report.output_paths = {json_rel, text_rel}
        local ok_json = atomic_write_json(runtime_path(json_rel), report)
        local ok_text = atomic_write_file(runtime_path(text_rel), translated_text(report))
        if not (ok_json and ok_text) then
            set_report_result(report, "missing")
            report.next_action = "Repair both route output writes before using this report."
            attach_operator_brief(report)
            -- Best-effort convergence prevents a successfully written sibling from
            -- retaining a success claim after its paired output failed.
            atomic_write_json(runtime_path(json_rel), report)
            atomic_write_file(runtime_path(text_rel), translated_text(report))
            return false, report
        end
        return true, report
    end

    local function dedupe_piece(value)
        value = str(value):gsub("[^%w_.%-]+", "_")
        if #value > 128 then value = value:sub(1, 128) end
        return value ~= "" and value or "none"
    end

    local function report_dedupe_key(report)
        if report.route == "daily_rollup" then
            if ((report.daily_maturity or {}).mature) == true then
                return "daily_rollup:" .. dedupe_piece(report.report_date) .. ":public_operator_brief_v1", "date"
            end
            return "daily_rollup:" .. dedupe_piece(report.report_date) .. ":not_mature:public_operator_brief_v1", "date_and_maturity"
        end
        if report.route == "player_activity" then
            local movement = report.movement or {}
            local signature = table.concat({
                movement.joined or 0, movement.left or 0, movement.still_present or 0,
                movement.clean_exits or 0, movement.unclean_exits or 0,
                movement.rapid_reconnects or 0, movement.post_crash_returns or 0,
                movement.today_session_event_count or 0,
            }, "-")
            return "player_activity:" .. dedupe_piece(report.report_date) .. ":" .. dedupe_piece(signature) .. ":public_operator_brief_v1", "date_and_activity_signature"
        end
        if report.route == "case_review" then
            local subjects = {}
            for index,row in ipairs(report.review_subjects or {}) do
                if index > 16 then break end
                table.insert(subjects, str(row.case_id or row.account_id))
            end
            return "case_review:" .. dedupe_piece(report.report_date) .. ":" .. dedupe_piece(table.concat(sorted_unique(subjects), "-")) .. ":public_operator_brief_v1", "date_and_named_subjects"
        end
        if report.route == "critical_guard" then
            return "critical_guard:" .. dedupe_piece(report.boot_id) .. ":" .. dedupe_piece(report.critical_failure_present and "failure" or "expected_empty") .. ":public_operator_brief_v1", "boot_and_failure_state"
        end
        return "server_status:" .. dedupe_piece(report.boot_id) .. ":" .. dedupe_piece(report.scheduler_status) .. ":" .. dedupe_piece((report.source_freshness or {}).status) .. ":public_operator_brief_v1", "boot_and_operational_state"
    end

    local function notification_candidate(report)
        local cfg = (state.config or {}).notification or {}
        local route_enabled = (cfg.routes or {})[report.route] == true
        local configured = cfg.enabled == true and cfg.mode == "local_file_outbox" and route_enabled
        local daily_mature = report.route ~= "daily_rollup" or ((report.daily_maturity or {}).mature) == true
        local eligible = configured and report.completed == true and report.current_cycle_lineage_complete == true and daily_mature
            and (report.route_proof_status == "full" or (report.route ~= "daily_rollup" and cfg.include_expected_empty == true))
        local root = cfg.output_root or "runtime/notifications/pending"
        local output_path = runtime_path(root .. "/" .. report.route .. "_latest.json")
        local suppression_reason = nil
        if not eligible then
            suppression_reason = not configured and "notification_disabled"
                or (report.route == "daily_rollup" and not daily_mature and "daily_rollup_not_mature")
                or "route_or_completion_policy_blocked"
        end
        local dedupe_key, dedupe_scope = report_dedupe_key(report)
        dedupe_key = dedupe_key .. ":" .. (eligible and "eligible" or (configured and "suppressed" or "disabled"))
        local payload = {
            schema="randomdayguard.notification/v1",
            generated_ts=now(),
            source_generated_ts=report.generated_ts,
            version=report.version,
            boot_id=report.boot_id,
            epoch_id=report.epoch_id,
            poll_id=report.poll_id,
            cycle_id=report.cycle_id,
            source_freshness=report.source_freshness,
            route=report.route,
            completed_output=report.completed == true,
            route_proof_status=report.route_proof_status,
            route_result=report.route_result,
            current_cycle_lineage_complete=report.current_cycle_lineage_complete,
            current_cycle_proof_complete=report.current_cycle_proof_complete,
            report_path=report.output_paths and report.output_paths[1] or nil,
            translated_path=report.output_paths and report.output_paths[2] or nil,
            source_references=report.source_references,
            operator_brief=report.operator_brief,
            operator_brief_contract=OPERATOR_BRIEF_CONTRACT,
            translation_dictionary_version=TRANSLATION_DICTIONARY_VERSION,
            evidence_boundary=(report.operator_brief or {}).evidence_boundary,
            dedupe_key=dedupe_key,
            dedupe_scope=dedupe_scope,
            delivery_backend="none",
            delivery_attempted=false,
            delivery_eligible=eligible,
            delivery_allowed=eligible,
            status=eligible and "ready_for_local_consumer" or "suppressed_current_cycle",
            suppression_reason=suppression_reason,
        }
        local should_write = configured or file_readable(output_path)
        if should_write and file_readable(output_path) then
            local existing = read_file(output_path, 131072) or ""
            if json_string_field(existing, "dedupe_key") == dedupe_key then
                return eligible, eligible and "local_outbox_deduplicated" or "current_cycle_suppressed_deduplicated"
            end
        end
        local written = not should_write or atomic_write_json(output_path, payload)
        if not written then return false, "local_outbox_write_failed" end
        if not eligible then return false, should_write and "current_cycle_suppressed" or "disabled" end
        return true, "local_outbox_written"
    end

    local function refresh(reason, force)
        local cfg = (state.config or {}).reports or {}
        if cfg.enabled == false then return false, "reports_disabled" end
        local interval = tonumber(cfg.refresh_interval_seconds) or 30
        local clock = os.time()
        local same_cycle = state.last_public_pipeline_boot_id == state.boot_id
            and state.last_public_pipeline_poll_id == (tonumber(state.poll_id) or 0)
        if force ~= true and same_cycle and state.last_public_pipeline_time and clock - state.last_public_pipeline_time < interval then
            return false, "cadence_deferred"
        end
        state.last_public_pipeline_time = clock
        state.last_public_pipeline_boot_id = state.boot_id
        state.last_public_pipeline_poll_id = tonumber(state.poll_id) or 0

        local source_cfg = (state.config or {}).source_accounting or {}
        local source_accounting_enabled = source_cfg.enabled ~= false
        local playerdata_discovery = discover_current_playerdata_files_bounded(state.saved_root, PLAYERDATA_DISCOVERY_MAX_FILES)
        local sources = collect_sources(playerdata_discovery)
        local accounting_status, usable_sources, unavailable_sources = summarize_sources(sources)
        if not source_accounting_enabled then
            accounting_status = "unavailable"
            usable_sources = {}
            unavailable_sources = {}
            for _,source in ipairs(sources) do table.insert(unavailable_sources, source.source_class) end
            unavailable_sources = sorted_unique(unavailable_sources)
        end
        local active_log_available = false
        local slow_scan_incomplete = false
        local case_source_status = "unavailable"
        for _,source in ipairs(sources) do
            if source.source_class == "active_log" and source.status == "available" then active_log_available = true end
            if source.source_class == "world_save_scan" and (source.status == "partial" or source.status == "deferred") then slow_scan_incomplete = true end
            if source.source_class == "existing_cases" then case_source_status = source.status end
        end
        local cycle = current_cycle_proof(active_log_available)

        local active_count = map_count(state.active)
        local current_count = map_count(state.accounts)
        local current_players, historical_players, players = {}, {}, {}
        local next_history = {}
        if durable_ledger_load_ok then
            for account_id,account in pairs(prior_accounts or {}) do
                next_history[account_id] = {
                    account_id=account_id,
                    ban_id=account.ban_id or account_id,
                    display_name=account.display_name or "",
                    identity_confidence=account.identity_confidence or "historical_ledger_identity",
                    identity_state=account.identity_state or "retained_historical_identity",
                    current_playerdata=false,
                    historical_playerdata_seen=account.historical_playerdata_seen == true or account.current_playerdata == true,
                    status=account.status or "INFO",
                    score=tonumber(account.score) or 0,
                    first_seen=account.first_seen or "",
                    last_seen=account.last_seen or "",
                    source_references=sorted_unique(account.source_references),
                }
            end
        end
        for account_id,account in pairs(state.accounts or {}) do
            local refs = {"runtime/account_evidence.json", "runtime/evidence/session_events.jsonl"}
            local current = {
                account_id=account_id,
                ban_id=account.ban_id or exact_numeric_id(account_id) or "",
                display_name=account.name or account.log_name or "",
                identity_confidence=account.identity_confidence or "unknown",
                identity_state=account.identity_state or "current_runtime_identity",
                current_playerdata=false,
                historical_playerdata_seen=account.playerdata_verified == true,
                status=account.status or "INFO",
                score=tonumber(account.score) or 0,
                first_seen=account.first_seen or "",
                last_seen=account.last_seen or "",
                source_references=refs,
            }
            if exact_numeric_id(account_id) then merge_account_history(next_history, {[account_id]=current}) end
            table.insert(current_players, {
                account_id=account_id,
                display_name=current.display_name,
                identity_confidence=current.identity_confidence,
                current_live_evidence=state.active[account_id] ~= nil,
                historical_context=false,
                scope="current",
                status=current.status,
                score=current.score,
                first_seen=current.first_seen,
                last_seen=current.last_seen,
                source_references=refs,
            })
        end
        local current_playerdata_ids = {}
        for _,entry in ipairs(playerdata_discovery.entries or {}) do
            local account_id = exact_numeric_id(entry.account_id)
            if account_id and not current_playerdata_ids[account_id] then
                current_playerdata_ids[account_id] = true
                merge_account_history(next_history, {[account_id]={
                    account_id=account_id,
                    ban_id=account_id,
                    display_name="",
                    identity_confidence="playerdata_only",
                    identity_state="id_only_playerdata",
                    current_playerdata=true,
                    historical_playerdata_seen=true,
                    status="INFO",
                    score=0,
                    first_seen="",
                    last_seen=now(),
                    source_references={entry.source_reference},
                }})
            end
        end
        for account_id,account in pairs(next_history) do
            table.insert(historical_players, {
                account_id=account_id,
                display_name=account.display_name or "",
                identity_confidence=account.identity_confidence or "unknown",
                identity_state=account.identity_state or "retained_historical_identity",
                current_character=account.current_playerdata == true,
                current_live_evidence=false,
                historical_context=true,
                scope="historical",
                also_observed_currently=state.accounts[account_id] ~= nil,
                status=account.status or "INFO",
                score=tonumber(account.score) or 0,
                source_references=sorted_unique(account.source_references),
            })
        end
        local function player_sort(a,b)
            if str(a.account_id) == str(b.account_id) then return str(a.scope) < str(b.scope) end
            return str(a.account_id) < str(b.account_id)
        end
        table.sort(current_players, player_sort)
        table.sort(historical_players, player_sort)
        for _,row in ipairs(current_players) do table.insert(players, row) end
        for _,row in ipairs(historical_players) do table.insert(players, row) end
        local historical_count = map_count(next_history)
        local current_character_count = map_count(current_playerdata_ids)
        local historical_without_current_character_count = math.max(0, historical_count - current_character_count)
        local history_accounts_write_ok, history_accounts_write_error = false, durable_ledger_error or snapshot_ledger_error
        if durable_ledger_load_ok then
            history_accounts_write_ok, history_accounts_write_error = write_durable_accounts(next_history)
        end
        local identity_reconciliation = {
            status=not durable_ledger_load_ok and "error"
                or ((durable_ledger_status == "partial" or snapshot_ledger_status == "partial" or playerdata_discovery.completed ~= true or playerdata_discovery.truncated == true) and "partial" or "ready"),
            durable_ledger_path="runtime/history/public_accounts.tsv",
            durable_ledger_load_bound=DURABLE_LEDGER_MAX_ROWS,
            durable_ledger_load_status=durable_ledger_status,
            durable_ledger_row_count=durable_ledger_row_count,
            snapshot_load_status=snapshot_ledger_status,
            snapshot_row_count=snapshot_ledger_row_count,
            load_warning=durable_ledger_error or snapshot_ledger_error,
            load_error=history_accounts_write_error,
            current_playerdata_discovery_completed=playerdata_discovery.completed == true,
            current_playerdata_discovery_truncated=playerdata_discovery.truncated == true,
            current_playerdata_discovery_limit=playerdata_discovery.limit,
            current_character_identity_count=current_character_count,
            retained_identity_count=historical_count,
            historical_without_current_character_count=historical_without_current_character_count,
            current_and_retained_counts_computed_before_candidate_promotion=true,
            playerdata_presence_is_activity=false,
            character_restore_performed=false,
            report_candidate_promotion_performed=false,
        }
        local accounting = {
            schema="randomdayguard.source-accounting/v1",
            generated_ts=now(),
            reason=reason,
            status=accounting_status,
            enabled=source_accounting_enabled,
            disabled_reason=source_accounting_enabled and nil or "source_accounting_disabled",
            current_and_historical_are_distinct=true,
            identity_reconciliation=identity_reconciliation,
            changed_file_manifest="runtime/baselines/file_manifest.tsv",
            sources=sources,
            usable_source_classes=usable_sources,
            unavailable_source_classes=unavailable_sources,
            does_not_prove="Complete source accounting does not prove that every historical event was observable or that any player caused a server condition.",
        }
        local accounting_write_ok = atomic_write_json(runtime_path("runtime/final_logs/source_accounting_latest.json"), accounting)
        local history_write_ok = atomic_write_json(runtime_path("runtime/final_logs/historical_backfill_latest.json"), {
            schema="randomdayguard.history/v1",
            generated_ts=now(),
            status=accounting_status,
            resumable=true,
            changed_file_refresh=true,
            current_evidence_is_not_history=true,
            identity_reconciliation=identity_reconciliation,
            source_accounting=sources,
            unavailable_source_classes=unavailable_sources,
            next_action=accounting_status == "partial" and "Allow bounded discovery and scan work to resume." or "Review explicit source gaps before relying on historical absence.",
        })

        local movement = {joined=0, left=0, still_present=active_count, clean_exits=0, unclean_exits=0, rapid_reconnects=0, post_crash_returns=0, today_session_event_count=0}
        local activity_accounts = {}
        local same_day_sessions = {}
        local report_date = today()
        for session_id,session in pairs(state.sessions or {}) do
            local account_id = str(session.account_id)
            local joined_today = str(session.join_ts):sub(1, 10) == report_date
            local left_today = str(session.leave_ts):sub(1, 10) == report_date
            if joined_today then
                movement.joined = movement.joined + 1
                movement.today_session_event_count = movement.today_session_event_count + 1
                if session.reconnect_after_lifecycle == true then movement.post_crash_returns = movement.post_crash_returns + 1 end
                if account_id ~= "" then activity_accounts[account_id] = true end
            end
            if left_today then
                movement.left = movement.left + 1
                movement.today_session_event_count = movement.today_session_event_count + 1
                if session.clean_leave == true then movement.clean_exits = movement.clean_exits + 1 else movement.unclean_exits = movement.unclean_exits + 1 end
                if account_id ~= "" then activity_accounts[account_id] = true end
            end
            if joined_today or left_today then
                local account = (state.accounts or {})[account_id] or {}
                table.insert(same_day_sessions, {
                    session_id=session.session_id or session_id,
                    account_id=account_id,
                    display_name=session.name or account.name or account.log_name or "",
                    join_ts=session.join_ts,
                    leave_ts=session.leave_ts,
                    clean_exit=session.leave_ts and session.clean_leave == true or nil,
                    lifecycle_close=session.lifecycle_close == true,
                    reconnect_after_lifecycle=session.reconnect_after_lifecycle == true,
                    source_references={"runtime/evidence/session_events.jsonl"},
                })
            end
        end
        table.sort(same_day_sessions, function(a,b)
            if str(a.join_ts) == str(b.join_ts) then return str(a.session_id) < str(b.session_id) end
            return str(a.join_ts) < str(b.join_ts)
        end)
        for account_id in pairs(state.active or {}) do activity_accounts[str(account_id)] = true end
        movement.current_activity_account_count = map_count(activity_accounts)
        movement.completed_sessions = movement.left
        local player_activity_present = false
        for _,key in ipairs({"joined", "left", "still_present", "clean_exits", "unclean_exits", "rapid_reconnects", "post_crash_returns", "today_session_event_count"}) do
            if (tonumber(movement[key]) or 0) > 0 then player_activity_present = true; break end
        end
        for _,row in ipairs(current_players) do row.same_day_activity = activity_accounts[str(row.account_id)] == true end

        -- Only the explicitly configured slow scan may block otherwise fresh current reports.
        local slow_scan_blocks = source_cfg.slow_world_scan_blocks_current_reports == true
        local current_reports_ready = cycle.complete and source_accounting_enabled and accounting_write_ok and history_write_ok
            and history_accounts_write_ok and not (slow_scan_blocks and slow_scan_incomplete)
        local history_ready = cycle.complete and accounting_status ~= "partial" and accounting_status ~= "unavailable"
            and source_accounting_enabled and accounting_write_ok and history_write_ok and history_accounts_write_ok

        local source_index = source_index_by_name(sources)
        local active_log_count = tonumber((source_index.active_log or {}).file_count) or 0
        local backup_log_count = tonumber((source_index.recent_backup_logs or {}).file_count) or 0
        local scan_job = state.scan_job or {}
        local scan_files_done = tonumber(scan_job.files_done) or 0
        local scan_total_files = tonumber(scan_job.total_files) or 0
        local scan_pending = state.startup_scan_pending == true or scan_job.active == true
        local epoch_started_ts = state.current_epoch and state.current_epoch.start_ts or nil
        local latest_poll_ts = state.last_poll_completed_ts or (cycle.source_freshness or {}).poll_completed_ts
        local gap_text = #unavailable_sources > 0 and table.concat(unavailable_sources, ", ") or "none"
        local server_proof = current_reports_ready and "full" or "missing"
        local server_observed = {
            "Guard scheduler: " .. str(state.scheduler_status) .. "; latest completed monitoring cycle: " .. str(cycle.poll_id) .. " at " .. str(latest_poll_ts ~= "" and latest_poll_ts or "time unavailable") .. ".",
            epoch_started_ts and ("Current server run began at " .. str(epoch_started_ts) .. ".") or "Current server-run start time is not available in this cycle.",
            "Log coverage: " .. count_phrase(active_log_count, "active log") .. " and " .. count_phrase(backup_log_count, "rotated or backup log") .. ".",
            scan_pending and ("World scan is still running: " .. str(scan_files_done) .. " of " .. str(scan_total_files) .. " discovered files checked.") or "World scan is not marked pending.",
            "Players connected now: " .. str(active_count) .. ". Source groups ready: " .. str(#usable_sources) .. " of " .. str(#sources) .. "; named gaps: " .. gap_text .. ".",
        }
        local server = report_base("server_status", server_proof, accounting_status,
            server_observed,
            {current_reports_ready and "Guard completed a current monitoring cycle and the server log is readable." or "Guard cannot yet prove a complete current monitoring cycle."},
            {scan_pending and "Complete-world scan conclusions must wait for the bounded scan." or "No current scan limitation is recorded."},
            {"This status describes server and Guard operation; player activity is reported separately."},
            current_reports_ready and "No immediate action. Investigate only if the cycle timestamp stops advancing or a named source gap matters to the question being reviewed." or "Restore the missing current source or report write, then run another monitoring cycle.",
            {"runtime/current/poll_status.json", "runtime/current_server_epoch.json", "runtime/log_registry.json", "runtime/final_logs/source_accounting_latest.json"}, cycle)
        server.scheduler_status = state.scheduler_status
        server.active_log_status = state.log_tail_status
        server.server_metrics = {
            current_epoch_started_ts=epoch_started_ts,
            latest_completed_poll_ts=latest_poll_ts,
            completed_poll_id=cycle.poll_id,
            active_player_count=active_count,
            active_log_count=active_log_count,
            backup_log_count=backup_log_count,
            scan_pending=scan_pending,
            scan_files_done=scan_files_done,
            scan_total_files=scan_total_files,
            usable_source_group_count=#usable_sources,
            configured_source_group_count=#sources,
            unavailable_source_groups=unavailable_sources,
        }

        local player_proof = not current_reports_ready and "missing" or (player_activity_present and "full" or "limited_expected_empty")
        local player_observed = {
            "Today: " .. count_phrase(movement.joined, "join") .. ", " .. count_phrase(movement.left, "leave") .. ", and " .. count_phrase(movement.still_present, "player", "players") .. " connected now.",
            "Session outcomes: " .. count_phrase(movement.clean_exits, "clean exit") .. ", " .. count_phrase(movement.unclean_exits, "unclean exit") .. ", and " .. count_phrase(movement.post_crash_returns, "return after a server lifecycle change") .. ".",
            "Accounts with same-day activity: " .. str(movement.current_activity_account_count) .. ". Current character files: " .. str(current_character_count) .. "; retained historical identities: " .. str(historical_count) .. ".",
        }
        for index,session in ipairs(same_day_sessions) do
            if index > 5 then break end
            local subject = str(session.display_name) ~= "" and (str(session.display_name) .. " (account " .. str(session.account_id) .. ")") or ("account " .. str(session.account_id))
            local outcome = session.leave_ts and ((session.clean_exit == true and "left cleanly" or "left without a clean-exit record") .. " at " .. str(session.leave_ts)) or "is still active"
            table.insert(player_observed, subject .. " joined at " .. str(session.join_ts) .. " and " .. outcome .. ".")
        end
        local player = report_base("player_activity", player_proof, accounting_status,
            player_observed,
            {player_activity_present and "The route contains current same-day session activity." or "No same-day movement was recorded, so the route completed without a player notice."},
            {player_activity_present and "Session records describe joins, leaves, and lifecycle context; the underlying event references remain available for detailed review." or "Retained identity rows describe known accounts, not activity today."},
            {"Historical identity and character-file presence are kept separate from current session activity."},
            player_proof == "missing" and "Restore current-cycle source freshness." or (player_activity_present and "Review only the named same-day sessions that need follow-up." or "No player follow-up is required for this cycle."),
            {"runtime/account_evidence.json", "runtime/history/public_accounts.tsv", "runtime/evidence/session_events.jsonl"}, cycle)
        player.expected_empty_reason = player_proof == "limited_expected_empty" and "no_player_activity" or nil
        player.player_activity_present = player_activity_present
        player.route_eligibility = {requires_movement_or_same_day_session=true, historical_identity_eligible=false, playerdata_identity_eligible=false}
        player.movement = movement
        player.same_day_sessions = same_day_sessions
        player.current_player_count = active_count
        player.current_evidence_player_count = current_count
        player.current_character_identity_count = current_character_count
        player.retained_identity_count = historical_count
        player.historical_without_current_character_count = historical_without_current_character_count
        player.historical_player_count = historical_count
        player.current_session_count = map_count(state.sessions)
        player.same_day_session_event_count = movement.today_session_event_count
        player.historical_session_count = prior_session_count
        player.total_session_count = player.current_session_count + player.historical_session_count
        player.historical_identity_is_current_activity = false
        player.playerdata_identity_is_current_activity = false
        player.identity_reconciliation = identity_reconciliation
        player.current_players = current_players
        player.historical_players = historical_players
        player.players = players

        local case_map = {}
        local current_case_count = 0
        for case_id,case in pairs(prior_cases or {}) do case_map[case_id] = case end
        for account_id,account in pairs(state.accounts or {}) do
            if account.status == "REVIEW" or account.status == "BAN-ELIGIBLE" then
                current_case_count = current_case_count + 1
                case_map["CURRENT-" .. account_id] = {
                    case_id="CURRENT-" .. account_id,
                    account_id=account_id,
                    accounts={account_id},
                    status=account.status,
                    score=tonumber(account.score) or 0,
                    display_name=account.name or account.log_name or "",
                    identity_confidence=account.identity_confidence or "unknown",
                    first_seen=account.first_seen,
                    last_seen=account.last_seen,
                    warning_counts=account.warnings or {},
                    reasons=account.reasons or {},
                    evidence="Current account-specific review threshold evidence.",
                    scope="current",
                    current_live_evidence=state.active[account_id] ~= nil,
                    source_references={"runtime/ban_queue.json", "runtime/account_evidence.json"},
                }
            end
        end
        local cases = {}
        local review_subjects = {}
        for _,case in pairs(case_map) do table.insert(cases, case) end
        table.sort(cases, function(a,b) return str(a.case_id) < str(b.case_id) end)
        for _,case in ipairs(cases) do if case.scope == "current" then table.insert(review_subjects, case) end end
        local case_proof = not current_reports_ready and "missing" or (current_case_count > 0 and "full" or "limited_expected_empty")
        local case_observed = {
            "Named review subjects in the current cycle: " .. str(current_case_count) .. ". Retained earlier cases: " .. str(map_count(prior_cases)) .. ".",
        }
        for index,subject in ipairs(review_subjects) do
            if index > 5 then break end
            local name = str(subject.display_name) ~= "" and (str(subject.display_name) .. " (account " .. str(subject.account_id) .. ")") or ("account " .. str(subject.account_id))
            table.insert(case_observed, name .. " is marked " .. str(subject.status) .. " with score " .. str(subject.score) .. "; identity source: " .. str(subject.identity_confidence) .. ".")
        end
        local case_report = report_base("case_review", case_proof, accounting_status,
            case_observed,
            {current_case_count == 0 and "No named current subject met the configured review criteria." or "Each named subject includes its current status, score, identity strength, and source references."},
            {"A missing source group can limit the context available for a named subject."},
            {"Retained earlier cases remain historical context and do not create a new current case by themselves."},
            case_proof == "missing" and "Restore current-cycle source freshness before case review." or (current_case_count > 0 and "Open the named subject and its source references before deciding what to do." or "No case review is required for this cycle."),
            {"runtime/raid_cases", "runtime/ban_queue.json", "runtime/account_evidence.json"}, cycle)
        case_report.expected_empty_reason = case_proof == "limited_expected_empty" and "no_case_review_activity" or nil
        case_report.cases = cases
        case_report.review_subjects = review_subjects
        case_report.retained_case_count = map_count(prior_cases)
        case_report.retained_case_parse_failure_count = prior_case_parse_failures
        case_report.current_case_count = current_case_count
        case_report.retained_case_source_status = case_source_status

        local daily_maturity_reasons = {}
        local function require_daily(ok, reason_text)
            if not ok then table.insert(daily_maturity_reasons, reason_text) end
        end
        require_daily(cycle.complete == true, "current_cycle_not_complete")
        require_daily(history_ready == true, "source_accounting_not_terminal")
        require_daily((tonumber((cycle.source_freshness or {}).poll_completed_count) or 0) > 0, "completed_poll_not_recorded")
        require_daily(identity_reconciliation.status == "ready", "identity_reconciliation_not_ready")
        require_daily(report_date:match("^%d%d%d%d%-%d%d%-%d%d$") ~= nil, "report_date_invalid")
        local daily_mature = #daily_maturity_reasons == 0
        local daily_proof = not current_reports_ready and "missing" or (daily_mature and "full" or "limited_expected_empty")
        local daily_observed = {
            "Activity today: " .. str(movement.current_activity_account_count) .. " accounts, " .. count_phrase(movement.joined, "join") .. ", " .. count_phrase(movement.left, "leave") .. ", and " .. count_phrase(active_count, "player", "players") .. " connected now.",
            "Completed session outcomes: " .. count_phrase(movement.clean_exits, "clean exit") .. " and " .. count_phrase(movement.unclean_exits, "unclean exit") .. ".",
            "Review work: " .. count_phrase(current_case_count, "named current subject") .. "; retained earlier cases: " .. str(map_count(prior_cases)) .. ".",
            "Identity inventory: " .. str(current_character_count) .. " current character files and " .. str(historical_count) .. " retained identities. These counts are context and are not counted as activity unless a same-day session exists.",
            "Source coverage: " .. str(#usable_sources) .. " of " .. str(#sources) .. " groups ready; named gaps: " .. gap_text .. ".",
        }
        local daily = report_base("daily_rollup", daily_proof, accounting_status,
            daily_observed,
            {"This once-per-day review combines server continuity, same-day sessions, named cases, scan progress, and source coverage without duplicating the route-specific reports."},
            {daily_mature and "No report-maturity limitation is recorded." or ("Daily report is not mature yet: " .. table.concat(daily_maturity_reasons, ", "))},
            {"The daily rollup summarizes the day; route reports and their cited sources hold the detailed records."},
            daily_proof == "missing" and "Repair the missing current source or output write." or (daily_mature and (current_case_count > 0 and "Review the named case subjects; use the other route reports only when their counts show activity." or "No case follow-up is required; use this page as the day record.") or "Allow the listed report-maturity checks to finish."),
            {"runtime/final_logs/source_accounting_latest.json", "runtime/final_logs/player_activity_latest.json", "runtime/final_logs/case_review_latest.json", "runtime/current/forensic_today.json"}, cycle)
        daily.expected_empty_reason = daily_proof == "limited_expected_empty" and "daily_rollup_not_mature" or nil
        daily.daily_maturity = {mature=daily_mature, required_check_count=5, missing=daily_maturity_reasons}
        daily.once_per_day_continuity = true
        daily.dedupe_window = report_date
        daily.identity_reconciliation = identity_reconciliation
        daily.daily_metrics = {
            report_date=report_date,
            current_active_players=active_count,
            accounts_with_same_day_activity=movement.current_activity_account_count,
            joins=movement.joined,
            leaves=movement.left,
            clean_exits=movement.clean_exits,
            unclean_exits=movement.unclean_exits,
            returns_after_lifecycle=movement.post_crash_returns,
            current_named_review_subjects=current_case_count,
            retained_case_count=map_count(prior_cases),
            current_character_identity_count=current_character_count,
            retained_identity_count=historical_count,
            usable_source_group_count=#usable_sources,
            configured_source_group_count=#sources,
            unavailable_source_groups=unavailable_sources,
        }

        local startup_error = state.current_startup_error
        local poll_error = state.current_poll_error
        local current_startup_error = type(startup_error) == "table" and startup_error.boot_id == state.boot_id
            and (str(startup_error.epoch_id) == "" or str(startup_error.epoch_id) == str(cycle.epoch_id))
        local current_poll_error = type(poll_error) == "table"
            and str(poll_error.boot_id) == str(cycle.boot_id)
            and str(poll_error.epoch_id) == str(cycle.epoch_id)
            and tonumber(poll_error.poll_id) == tonumber(cycle.poll_id)
        -- Prior-boot text artifacts remain audit history and never own the current critical route.
        local critical_present = state.scheduler_status == "error" or current_startup_error or current_poll_error
        local critical_contract_ready = cycle.lineage_complete and source_accounting_enabled
            and accounting_write_ok and history_write_ok and history_accounts_write_ok
        local critical_ready = current_reports_ready or (critical_contract_ready and current_poll_error)
        local critical_proof = not critical_ready and "missing" or (critical_present and "full" or "limited_expected_empty")
        local critical = report_base("critical_guard", critical_proof, accounting_status,
            {critical_present and "A runtime or evidence-integrity failure is recorded." or "No critical runtime failure is recorded."},
            {critical_present and "Critical review is required." or "Critical route is expected-empty."},
            {active_log_available and "No additional critical unknown recorded." or "Current log availability is unknown or missing."},
            {"Expected-empty critical status does not prove future availability."},
            critical_present and "Review startup/poll error evidence before restart or enforcement." or "Continue monitoring.",
            current_poll_error and {"runtime/current/poll_error.json", "runtime/current/poll_status.json"}
                or {"runtime/startup_status.json", "runtime/current/poll_status.json"}, cycle)
        critical.critical_failure_present = critical_present
        critical.current_boot_error_only = true

        local reports = {server, daily, player, case_report, critical}
        local contract_writes_ok = source_accounting_enabled and accounting_write_ok and history_write_ok and history_accounts_write_ok
        if not contract_writes_ok then
            for _,report in ipairs(reports) do
                set_report_result(report, "missing")
                report.coverage_status = "unavailable"
                report.next_action = "Repair source-accounting or historical-status output writes before using route reports."
            end
        end
        for _,report in ipairs(reports) do attach_operator_brief(report) end

        local route_proof, notification_outcomes, route_output_ready = {}, {}, {}
        for _,report in ipairs(reports) do
            local route_enabled = (cfg.routes or {})[report.route] ~= false
            if route_enabled then
                local ok_write = write_report(report)
                if not ok_write then
                    set_report_result(report, "missing")
                end
                route_output_ready[report.route] = ok_write and report.completed == true and report.route_proof_status ~= "missing"
                table.insert(route_proof, {
                    route=report.route,
                    status=report.route_proof_status,
                    version=report.version,
                    boot_id=report.boot_id,
                    epoch_id=report.epoch_id,
                    poll_id=report.poll_id,
                    cycle_id=report.cycle_id,
                    source_freshness=report.source_freshness,
                    current_cycle_lineage_complete=report.current_cycle_lineage_complete,
                    current_cycle_proof_complete=report.current_cycle_proof_complete,
                    route_result=report.route_result,
                    output_ready=route_output_ready[report.route],
                    output_paths=report.output_paths,
                    source_references=report.source_references,
                    expected_empty_reason=report.expected_empty_reason,
                    operator_brief_contract=OPERATOR_BRIEF_CONTRACT,
                    translation_dictionary_version=TRANSLATION_DICTIONARY_VERSION,
                    daily_maturity=report.daily_maturity,
                })
            else
                route_output_ready[report.route] = false
                set_report_result(report, "missing")
                report.route_disabled = true
                attach_operator_brief(report)
                table.insert(route_proof, {
                    route=report.route, status="missing", reason="route_disabled",
                    version=cycle.version, boot_id=cycle.boot_id, epoch_id=cycle.epoch_id,
                    poll_id=cycle.poll_id, cycle_id=cycle.cycle_id, source_freshness=cycle.source_freshness,
                    current_cycle_lineage_complete=cycle.lineage_complete == true,
                    current_cycle_proof_complete=cycle.complete == true,
                    route_result={status="missing", completed=false, expected_empty=false},
                    output_ready=false,
                })
            end
        end
        local route_proof_write_ok = atomic_write_json(runtime_path("runtime/final_logs/route_proof.json"), {
            schema="randomdayguard.route-proof/v1",
            generated_ts=now(),
            version=cycle.version,
            boot_id=cycle.boot_id,
            epoch_id=cycle.epoch_id,
            poll_id=cycle.poll_id,
            cycle_id=cycle.cycle_id,
            source_freshness=cycle.source_freshness,
            current_cycle_lineage_complete=cycle.lineage_complete == true,
            current_cycle_proof_complete=cycle.complete == true,
            allowed_statuses={"full", "limited_expected_empty", "missing"},
            routes=route_proof,
        })
        if not route_proof_write_ok then
            for _,report in ipairs(reports) do
                set_report_result(report, "missing")
                report.next_action = "Repair route-proof output before using or notifying from this report."
                attach_operator_brief(report)
                write_report(report)
                local _, suppression_outcome = notification_candidate(report)
                table.insert(notification_outcomes, {
                    route=report.route,
                    queued=false,
                    outcome="route_proof_write_failed",
                    outbox_outcome=suppression_outcome,
                })
            end
        else
            for _,report in ipairs(reports) do
                local queued, outcome = notification_candidate(report)
                if route_output_ready[report.route] ~= true and outcome == "disabled" then outcome = "report_route_disabled_or_incomplete" end
                table.insert(notification_outcomes, {route=report.route, queued=queued == true, outcome=outcome})
            end
        end
        atomic_write_json(runtime_path("runtime/notifications/notification_status.json"), {
            schema="randomdayguard.notification-status/v1",
            generated_ts=now(),
            version=cycle.version,
            boot_id=cycle.boot_id,
            epoch_id=cycle.epoch_id,
            poll_id=cycle.poll_id,
            cycle_id=cycle.cycle_id,
            source_freshness=cycle.source_freshness,
            current_cycle_lineage_complete=cycle.lineage_complete == true,
            current_cycle_proof_complete=cycle.complete == true,
            generic_local_outbox_only=true,
            delivery_backend="none",
            delivery_attempted=false,
            outcomes=notification_outcomes,
        })
        return contract_writes_ok and route_proof_write_ok, route_proof
    end

    return {
        refresh=refresh,
        source_statuses=SOURCE_STATUSES,
        route_proof_statuses=ROUTE_PROOF_STATUSES,
    }
end
