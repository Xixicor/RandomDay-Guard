-- Executes the shipped reporting module with public, filesystem-only fixtures.
-- Documentation: docs/VALIDATION_AND_RELEASE.md#real-lua-runtime-fixture

local fixture_root = assert(arg[1], "fixture root is required"):gsub("\\", "/"):gsub("/+$", "")

local function posix_shell_quote(value)
    return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function make_directory(path)
    local command
    if package.config:sub(1, 1) == "\\" then
        assert(not path:find('"', 1, true), "fixture path contains a quote")
        local windows_path = path:gsub("/", "\\")
        command = 'if not exist "' .. windows_path .. '" mkdir "' .. windows_path .. '"'
    else
        command = "mkdir -p " .. posix_shell_quote(path)
    end
    local ok, _, code = os.execute(command)
    return ok == true or ok == 0 or code == 0
end

local function assert_true(value, message)
    if not value then error(message or "assertion failed", 2) end
end

local function contains(values, expected)
    for _,value in ipairs(values or {}) do
        if value == expected then return true end
    end
    return false
end

local REPORT_ROUTES = {"server_status", "daily_rollup", "player_activity", "case_review", "critical_guard"}
local REPORT_COVERAGE_STATUSES = {complete=true, complete_with_gaps=true, partial=true, unavailable=true}

local function write_file(path, data)
    local file = assert(io.open(path, "wb"))
    file:write(data)
    file:close()
end

local pipeline_factory = assert(loadfile("RandomDayGuard/Scripts/public_pipeline.lua"))()
local original_popen = io.popen
local popen_options = {}
io.popen = function(command)
    local lines = {}
    local normalized = tostring(command):gsub("\\", "/")
    if popen_options.runtime_inventory_throws and normalized:find("/runtime/", 1, true) then
        error("fixture inventory popen unsupported")
    elseif normalized:find("Player_*.sav", 1, true) then
        if popen_options.playerdata_discovery_pending then return nil end
        lines = popen_options.discovered_playerdata_paths or {}
    elseif normalized:find("runtime/raid_cases", 1, true) and popen_options.retained_case_path then
        lines = {popen_options.retained_case_path}
    end
    local index = 0
    return {
        lines = function()
            return function()
                index = index + 1
                return lines[index]
            end
        end,
        close = function() return popen_options.command_close_ok ~= false end,
    }
end

local function run_case(options)
    local case_root = fixture_root .. "/" .. assert(options.name, "case name is required")
    assert_true(make_directory(case_root .. "/Saved/Logs"), "fixture Saved/Logs mkdir failed")
    assert_true(make_directory(case_root .. "/runtime/history"), "fixture history mkdir failed")
    local active_log = case_root .. "/Saved/Logs/AbioticFactor.log"
    write_file(active_log, "fixture log\n")

    local playerdata_paths = {}
    if #(options.current_playerdata_ids or {}) > 0 then
        local playerdata_root = case_root .. "/Saved/SaveGames/Server/Worlds/FixtureWorld/PlayerData"
        assert_true(make_directory(playerdata_root), "fixture PlayerData mkdir failed")
        for _, account_id in ipairs(options.current_playerdata_ids) do
            local path = playerdata_root .. "/Player_" .. tostring(account_id) .. ".sav"
            write_file(path, "fixture")
            table.insert(playerdata_paths, path)
        end
    end

    if options.ledger_row_count or options.ledger_rows then
        local rows = {"account_id\tban_id\tdisplay_name\tidentity_confidence\tidentity_state\tcurrent_playerdata\thistorical_playerdata_seen\tstatus\tscore\tfirst_seen\tlast_seen\tsource_references"}
        if options.ledger_rows then
            for _, row in ipairs(options.ledger_rows) do
                table.insert(rows, table.concat({
                    row.account_id, row.account_id, row.display_name or "", row.identity_confidence or "historical_ledger_identity",
                    "retained_historical_identity", "false", tostring(row.historical_playerdata_seen == true), "INFO", "0",
                    "2026-01-01T00:00:00Z", "2026-07-15T00:00:00Z", "runtime/history/seed",
                }, "\t"))
            end
        else
            for index=1,options.ledger_row_count do
                local account_id = tostring(100000 + index)
                table.insert(rows, table.concat({account_id, account_id, "", "historical_ledger_identity", "retained_historical_identity", "false", "false", "INFO", "0", "", "", "runtime/history/seed"}, "\t"))
            end
        end
        write_file(case_root .. "/runtime/history/public_accounts.tsv", table.concat(rows, "\n") .. "\n")
    end

    local retained_case_path = nil
    if options.retained_case then
        assert_true(make_directory(case_root .. "/runtime/raid_cases"), "fixture retained-case mkdir failed")
        retained_case_path = case_root .. "/runtime/raid_cases/CASE-HISTORICAL.json"
        write_file(retained_case_path, '{"case_id":"CASE-HISTORICAL","accounts":["900"],"status":"REVIEW","score":80,"source_references":["runtime\\\\evidence\\\\old.json"]}\n')
    end

    popen_options = {
        playerdata_discovery_pending=options.playerdata_discovery_pending == true,
        discovered_playerdata_paths=options.discover_playerdata == false and {} or playerdata_paths,
        retained_case_path=retained_case_path,
        command_close_ok=options.command_close_ok,
        runtime_inventory_throws=options.runtime_inventory_throws == true,
    }

    local writes, write_counts, virtual_files, write_attempts = {}, {}, {}, {}
    local poll_completed_count = options.poll_completed_count
    if poll_completed_count == nil then poll_completed_count = 1 end
    local state = {
        mod_root = case_root,
        saved_root = options.saved_root_override or case_root .. "/Saved",
        boot_id = "fixture-boot",
        current_epoch = {epoch_id = "fixture-epoch", start_ts = "2026-07-16T08:00:00Z", lifecycle_class = "running"},
        scan_job = {active=false, files_done=12, total_files=12},
        log_registry = {
            active={active=true, backup=false},
            backup={active=false, backup=true},
        },
        poll_id = options.poll_id,
        last_poll_ts = options.poll_id > 0 and "2026-07-16T12:00:00Z" or nil,
        last_poll_completed_ts = options.poll_id > 0 and "2026-07-16T12:00:01Z" or nil,
        scheduler_status = options.scheduler_status or "running",
        log_tail_status = options.active_log and "available" or "unavailable",
        current_poll_source = options.poll_id > 0 and {
            version = "v0.0.0-runtime-fixture",
            boot_id = "fixture-boot",
            epoch_id = "fixture-epoch",
            poll_id = options.poll_id,
            status = "fresh_current_poll",
            collected_ts = "2026-07-16T12:00:00Z",
            last_poll_ts = "2026-07-16T12:00:00Z",
            poll_completed_ts = "2026-07-16T12:00:01Z",
            poll_completed_count = poll_completed_count,
            active_log_read_failed = false,
            log_tail_status = options.active_log and "available" or "unavailable",
        } or nil,
        startup_scan_pending = false,
        active = options.active or {},
        accounts = options.accounts or {},
        sessions = options.sessions or {},
        config = {
            source_accounting = {
                enabled = true,
                slow_world_scan_blocks_current_reports = false,
            },
            reports = {
                enabled = options.reports_enabled ~= false,
                output_root = "runtime/final_logs",
                refresh_interval_seconds = 0,
                routes = {
                    server_status = true,
                    daily_rollup = true,
                    player_activity = true,
                    case_review = true,
                    critical_guard = true,
                },
            },
            notification = {
                enabled = options.notifications == true,
                mode = options.notification_mode or "local_file_outbox",
                output_root = "runtime/notifications/pending",
                include_expected_empty = options.include_expected_empty ~= false,
                routes = {
                    server_status = not options.notification_routes or options.notification_routes.server_status == true,
                    daily_rollup = not options.notification_routes or options.notification_routes.daily_rollup == true,
                    player_activity = not options.notification_routes or options.notification_routes.player_activity == true,
                    case_review = not options.notification_routes or options.notification_routes.case_review == true,
                    critical_guard = not options.notification_routes or options.notification_routes.critical_guard == true,
                },
            },
        },
    }

    local function runtime_path(relative)
        return case_root .. "/" .. relative
    end

    local function read_file(path, maximum)
        local virtual = virtual_files[path]
        if virtual then
            if type(virtual) == "string" then return virtual:sub(1, maximum or #virtual) end
            if type(virtual) == "table" and virtual.dedupe_key then
                return '{"dedupe_key":"' .. tostring(virtual.dedupe_key):gsub('"', '\\"') .. '"}'
            end
            return "{}"
        end
        local file = io.open(path, "rb")
        if not file then return nil end
        local data = file:read(maximum or "*a")
        file:close()
        return data
    end

    local pipeline = pipeline_factory({
        state = state,
        version = "v0.0.0-runtime-fixture",
        now = function() return "2026-07-16T12:00:02Z" end,
        today = function() return "2026-07-16" end,
        str = function(value) return value == nil and "" or tostring(value) end,
        join_path = function(left, right) return left .. "/" .. right end,
        relpath = function(root, path)
            root = tostring(root):gsub("\\", "/"):gsub("/+$", "")
            path = tostring(path):gsub("\\", "/")
            return path:sub(1, #root + 1) == root .. "/" and path:sub(#root + 2) or path
        end,
        runtime_path = runtime_path,
        file_readable = function(path)
            if virtual_files[path] ~= nil then return true end
            local file = io.open(path, "rb")
            if not file then return false end
            file:close()
            return true
        end,
        read_file = read_file,
        validate_admin_ini_text = function() return true end,
        find_admin_ini = function() return nil, nil end,
        atomic_write_json = function(path, value)
            write_attempts[path] = value
            if (options.fail_source_accounting_write and path == case_root .. "/runtime/final_logs/source_accounting_latest.json")
                or (options.fail_history_write and path == case_root .. "/runtime/final_logs/historical_backfill_latest.json")
                or (options.fail_route_proof_write and path == case_root .. "/runtime/final_logs/route_proof.json")
                or (options.fail_report_write and path == case_root .. "/runtime/final_logs/player_activity_latest.json") then
                return false
            end
            writes[path] = value
            virtual_files[path] = value
            write_counts[path] = (write_counts[path] or 0) + 1
            return true
        end,
        atomic_write_file = function(path, value)
            write_attempts[path] = value
            writes[path] = value
            virtual_files[path] = value
            write_counts[path] = (write_counts[path] or 0) + 1
            return true
        end,
        cached_saved_file_list = function()
            local rows = {}
            if options.cache_playerdata ~= false then
                for _,path in ipairs(playerdata_paths) do table.insert(rows, {path=path}) end
            end
            return rows
        end,
        cached_log_file_paths = function() return options.active_log and {active_log} or {} end,
        is_active_log = function(path) return path == active_log end,
    })
    assert_true(pipeline.source_statuses.error == true, "source-level error status was removed from the probe contract")

    local ok, detail = pipeline.refresh("runtime_fixture", true)
    if options.repeat_refresh then
        state.poll_id = state.poll_id + 1
        state.current_poll_source.poll_id = state.poll_id
        state.current_poll_source.poll_completed_count = poll_completed_count + 1
        state.current_poll_source.poll_completed_ts = "2026-07-16T12:00:03Z"
        local repeated_ok = pipeline.refresh("runtime_fixture_repeat", true)
        assert_true(repeated_ok == ok, "repeat refresh result changed unexpectedly")
    end
    return ok, writes, write_counts, case_root, write_attempts, detail
end

local function assert_report_coverage_contract(writes, write_attempts, root, label, expected)
    for _,route in ipairs(REPORT_ROUTES) do
        local path = root .. "/runtime/final_logs/" .. route .. "_latest.json"
        local report = writes[path] or write_attempts[path]
        assert_true(report ~= nil, label .. " omitted attempted report " .. route)
        assert_true(REPORT_COVERAGE_STATUSES[report.coverage_status] == true, label .. " emitted invalid report coverage_status " .. tostring(report.coverage_status))
        if expected then assert_true(report.coverage_status == expected, label .. " did not emit " .. expected .. " for " .. route) end
    end
end

local function routes_by_name(route_proof)
    local routes = {}
    for _, route in ipairs(route_proof.routes or {}) do routes[route.route] = route end
    return routes
end

local function sources_by_name(accounting)
    local sources = {}
    for _, source in ipairs(accounting.sources or {}) do sources[source.source_class] = source end
    return sources
end

local inventory_throw_ok, inventory_throw_writes, _, inventory_throw_root, inventory_throw_attempts = run_case({
    name="runtime-inventory-popen-throw-v2",
    active_log=true,
    poll_id=15,
    notifications=false,
    runtime_inventory_throws=true,
})
assert_true(inventory_throw_ok == true, "throwing runtime inventory popen aborted module creation or refresh")
local inventory_throw_accounting = assert(inventory_throw_writes[inventory_throw_root .. "/runtime/final_logs/source_accounting_latest.json"])
local inventory_throw_sources = sources_by_name(inventory_throw_accounting)
for _,source_name in ipairs({"existing_cases", "existing_reports", "existing_evidence"}) do
    local source = assert(inventory_throw_sources[source_name], "throwing inventory omitted source " .. source_name)
    assert_true(source.status == "unavailable", "throwing inventory did not mark " .. source_name .. " unavailable")
    assert_true(source.detail == "inventory_command_open_failed", "throwing inventory omitted explicit error for " .. source_name)
end
assert_report_coverage_contract(inventory_throw_writes, inventory_throw_attempts, inventory_throw_root, "throwing runtime inventory", "complete_with_gaps")

local portable_path_ok, portable_path_writes, _, portable_path_root = run_case({
    name="portable-path-(x86)-Español",
    active_log=true,
    poll_id=16,
    notifications=false,
    current_playerdata_ids={"76561198000000016"},
})
assert_true(portable_path_ok == true, "parenthesized Unicode runtime path was rejected")
local portable_path_accounting = assert(portable_path_writes[portable_path_root .. "/runtime/final_logs/source_accounting_latest.json"])
assert_true(sources_by_name(portable_path_accounting).playerdata_filenames.status == "available", "portable PlayerData path did not complete bounded discovery")

local windows_drive_ok, windows_drive_writes, _, windows_drive_root = run_case({
    name="windows-drive-root",
    saved_root_override="C:/Program Files (x86)/Servidor Español/Saved",
    active_log=true,
    poll_id=160,
    notifications=false,
})
assert_true(windows_drive_ok == true, "absolute Windows drive root aborted report generation")
local windows_drive_sources = sources_by_name(assert(windows_drive_writes[windows_drive_root .. "/runtime/final_logs/source_accounting_latest.json"]))
assert_true(windows_drive_sources.playerdata_filenames.status ~= "malformed", "absolute Windows drive root was rejected")

local posix_root_ok, posix_root_writes, _, posix_root = run_case({
    name="posix-absolute-root",
    saved_root_override="/srv/Abiotic Factor/Servidor Español/Saved",
    active_log=true,
    poll_id=161,
    notifications=false,
})
assert_true(posix_root_ok == true, "absolute POSIX root aborted report generation")
local posix_root_sources = sources_by_name(assert(posix_root_writes[posix_root .. "/runtime/final_logs/source_accounting_latest.json"]))
assert_true(posix_root_sources.playerdata_filenames.status ~= "malformed", "absolute POSIX root was rejected")

local unsafe_colon_ok, unsafe_colon_writes, _, unsafe_colon_root = run_case({
    name="unsafe-colon-root",
    saved_root_override="/srv/Abiotic:Factor/Saved",
    active_log=true,
    poll_id=162,
    notifications=false,
})
assert_true(unsafe_colon_ok == true, "unsafe colon path handling aborted report generation")
local unsafe_colon_sources = sources_by_name(assert(unsafe_colon_writes[unsafe_colon_root .. "/runtime/final_logs/source_accounting_latest.json"]))
local unsafe_colon_playerdata = assert(unsafe_colon_sources.playerdata_filenames, "unsafe colon path omitted PlayerData source")
assert_true(unsafe_colon_playerdata.status == "malformed", "unsafe colon path reached PlayerData command discovery")

local unsafe_relative_ok, unsafe_relative_writes, _, unsafe_relative_root = run_case({
    name="unsafe-relative-root",
    saved_root_override="relative/Saved",
    active_log=true,
    poll_id=163,
    notifications=false,
})
assert_true(unsafe_relative_ok == true, "relative path handling aborted report generation")
local unsafe_relative_sources = sources_by_name(assert(unsafe_relative_writes[unsafe_relative_root .. "/runtime/final_logs/source_accounting_latest.json"]))
local unsafe_relative_playerdata = assert(unsafe_relative_sources.playerdata_filenames, "relative path omitted PlayerData source")
assert_true(unsafe_relative_playerdata.status == "malformed", "relative path reached PlayerData command discovery")

local unsafe_path_ok, unsafe_path_writes, _, unsafe_path_root = run_case({
    name="unsafe-$-command",
    active_log=true,
    poll_id=17,
    notifications=false,
})
assert_true(unsafe_path_ok == true, "unsafe path handling aborted report generation")
local unsafe_path_sources = sources_by_name(assert(unsafe_path_writes[unsafe_path_root .. "/runtime/final_logs/source_accounting_latest.json"]))
for _,source_name in ipairs({"existing_cases", "existing_reports", "existing_evidence"}) do
    local source = assert(unsafe_path_sources[source_name], "unsafe path omitted source " .. source_name)
    assert_true(source.status == "unavailable" and source.detail == "unsafe_inventory_root", "unsafe path reached command inventory for " .. source_name)
end

local ok, writes, _, root = run_case({name="fresh-empty-v2", active_log = true, poll_id = 1, notifications = true})
assert_true(ok == true, "fresh runtime fixture did not complete")
local proof = assert(writes[root .. "/runtime/final_logs/route_proof.json"], "route proof was not written")
assert_true(proof.schema == "randomdayguard.route-proof/v1", "route proof schema differs")
assert_true(proof.current_cycle_proof_complete == true, "fresh cycle proof was not complete")
local routes = routes_by_name(proof)
assert_true(routes.server_status.status == "full", "server route was not full")
assert_true(routes.daily_rollup.status == "full", "mature daily continuity route was not full")
for _, name in ipairs({"player_activity", "case_review", "critical_guard"}) do
    assert_true(routes[name].status == "limited_expected_empty", name .. " was not expected empty")
end
local source_accounting = assert(writes[root .. "/runtime/final_logs/source_accounting_latest.json"])
local sources = sources_by_name(source_accounting)
assert_true(sources.playerdata_filenames.status == "expected_empty", "completed empty PlayerData discovery was not expected-empty")
assert_true(sources.playerdata_filenames.discovery_completed == true, "empty PlayerData discovery did not complete")
local player_report = assert(writes[root .. "/runtime/final_logs/player_activity_latest.json"])
assert_true(player_report.expected_empty == true and #player_report.players == 0, "empty player report invented a subject")
assert_true(player_report.expected_empty_reason == "no_player_activity", "player expected-empty reason differs")
assert_true(player_report.operator_brief.review_first == true, "player operator brief is not review-first")
assert_true(player_report.translation.dictionary_version == "public_value_dictionary/v1", "translation dictionary version differs")
local translated = assert(writes[root .. "/runtime/final_logs/player_activity_latest.txt"])
for _, heading in ipairs({"Summary", "What Guard observed", "What it means", "What remains unknown", "Recommended next step", "Evidence boundary", "Rating explanation", "Technical record", "Translation notes", "Source references"}) do
    assert_true(translated:find(heading, 1, true) ~= nil, "translated report omitted " .. heading)
end
local fresh_server = assert(writes[root .. "/runtime/final_logs/server_status_latest.json"])
assert_true(fresh_server.server_metrics.current_epoch_started_ts == "2026-07-16T08:00:00Z", "server report omitted the real epoch start")
assert_true(fresh_server.server_metrics.latest_completed_poll_ts == "2026-07-16T12:00:01Z", "server report omitted the completed poll timestamp")
assert_true(fresh_server.server_metrics.active_log_count == 1 and fresh_server.server_metrics.backup_log_count == 0, "server report log counts differ from source accounting")
local fresh_daily = assert(writes[root .. "/runtime/final_logs/daily_rollup_latest.json"])
assert_true(fresh_daily.daily_metrics.accounts_with_same_day_activity == 0, "empty daily report invented activity")
local notification = assert(writes[root .. "/runtime/notifications/pending/player_activity_latest.json"])
assert_true(notification.delivery_backend == "none" and notification.delivery_attempted == false, "local outbox claimed delivery")
assert_true(notification.operator_brief_contract == "randomdayguard.operator-brief/v1", "local outbox omitted the operator brief contract")

local strict_empty_ok, strict_empty_writes, _, strict_empty_root = run_case({
    name="strict-expected-empty-suppression-v2",
    active_log=true,
    poll_id=18,
    notifications=true,
    include_expected_empty=false,
})
assert_true(strict_empty_ok == true, "strict expected-empty notification fixture did not complete")
for _,route in ipairs({"player_activity", "case_review", "critical_guard"}) do
    local payload = assert(strict_empty_writes[strict_empty_root .. "/runtime/notifications/pending/" .. route .. "_latest.json"])
    assert_true(payload.delivery_eligible == false, route .. " ignored include_expected_empty=false")
    assert_true(payload.status == "suppressed_current_cycle", route .. " did not export an explicit suppressed envelope")
end

local disabled_route_ok, disabled_route_writes, _, disabled_route_root = run_case({
    name="disabled-notification-route-v2",
    active_log=true,
    poll_id=19,
    notifications=true,
    notification_routes={server_status=true, daily_rollup=true, player_activity=false, case_review=true, critical_guard=true},
})
assert_true(disabled_route_ok == true, "disabled notification route fixture did not complete")
assert_true(disabled_route_writes[disabled_route_root .. "/runtime/notifications/pending/player_activity_latest.json"] == nil,
    "disabled player notification route wrote a pending envelope")
local disabled_route_status = assert(disabled_route_writes[disabled_route_root .. "/runtime/notifications/notification_status.json"])
local disabled_player_outcome = nil
for _,outcome in ipairs(disabled_route_status.outcomes or {}) do
    if outcome.route == "player_activity" then disabled_player_outcome = outcome break end
end
assert_true(disabled_player_outcome ~= nil and disabled_player_outcome.queued == false,
    "disabled player route was not represented in notification status")
assert_true(disabled_player_outcome.outcome == "disabled",
    "disabled player route did not report the disabled outcome")

local unsupported_mode_ok, unsupported_mode_writes, _, unsupported_mode_root = run_case({
    name="unsupported-webhook-mode-v2",
    active_log=true,
    poll_id=20,
    notifications=true,
    notification_mode="webhook",
})
assert_true(unsupported_mode_ok == true, "unsupported notification mode corrupted report generation")
for _,route in ipairs(REPORT_ROUTES) do
    assert_true(unsupported_mode_writes[unsupported_mode_root .. "/runtime/notifications/pending/" .. route .. "_latest.json"] == nil,
        "unsupported mode wrote a pending envelope for " .. route)
end
local unsupported_status = assert(unsupported_mode_writes[unsupported_mode_root .. "/runtime/notifications/notification_status.json"])
for _,outcome in ipairs(unsupported_status.outcomes or {}) do
    assert_true(outcome.queued == false and outcome.outcome == "disabled",
        "unsupported mode did not fail closed for " .. tostring(outcome.route))
end
assert_true(unsupported_status.delivery_backend == "none" and unsupported_status.delivery_attempted == false,
    "unsupported mode did not explicitly disable delivery")
assert_true(unsupported_status.webhook_url == nil and unsupported_status.webhook == nil,
    "unsupported mode serialized webhook material")

local reports_disabled_ok, reports_disabled_writes, _, _, _, reports_disabled_detail = run_case({
    name="reports-disabled-v2",
    active_log=true,
    poll_id=21,
    notifications=true,
    reports_enabled=false,
})
assert_true(reports_disabled_ok == false and reports_disabled_detail == "reports_disabled", "reports.enabled=false was not honored")
assert_true(next(reports_disabled_writes) == nil, "reports.enabled=false still emitted report or notification output")

local missing_ok, missing_writes, _, missing_root = run_case({name="missing-current-source-v2", active_log = false, poll_id = 0, notifications = true})
assert_true(missing_ok == true, "missing-source fixture did not write fail-closed reports")
local missing_proof = assert(missing_writes[missing_root .. "/runtime/final_logs/route_proof.json"])
for name, route in pairs(routes_by_name(missing_proof)) do
    assert_true(route.status == "missing", name .. " did not fail closed")
    local suppressed = assert(missing_writes[missing_root .. "/runtime/notifications/pending/" .. name .. "_latest.json"], name .. " suppression envelope missing")
    assert_true(suppressed.status == "suppressed_current_cycle", name .. " was not suppressed")
    assert_true(suppressed.delivery_eligible == false and suppressed.delivery_attempted == false, name .. " claimed delivery eligibility")
end

local identity_ok, identity_writes, _, identity_root = run_case({
    name="identity-reconciliation-v2",
    active_log=true,
    poll_id=2,
    notifications=false,
    current_playerdata_ids={"100", "200"},
    ledger_rows={
        {account_id="100", display_name="Retained One", identity_confidence="historical_ledger_identity", historical_playerdata_seen=true},
        {account_id="300", display_name="Retained Three", identity_confidence="historical_ledger_identity"},
    },
})
assert_true(identity_ok == true, "identity reconciliation fixture did not complete")
local identity_player = assert(identity_writes[identity_root .. "/runtime/final_logs/player_activity_latest.json"])
assert_true(identity_player.route_proof_status == "limited_expected_empty", "PlayerData or retained identity incorrectly owned player activity")
assert_true(identity_player.current_character_identity_count == 2, "current character count was not reconciled")
assert_true(identity_player.retained_identity_count == 3, "retained identity count did not deduplicate current overlap")
assert_true(identity_player.historical_without_current_character_count == 1, "current-vs-retained subtraction differs")
assert_true(#identity_player.current_players == 0, "PlayerData identity was promoted into current activity candidates")
assert_true(identity_player.identity_reconciliation.report_candidate_promotion_performed == false, "identity reconciliation claimed candidate promotion")
local identity_ledger = assert(identity_writes[identity_root .. "/runtime/history/public_accounts.tsv"])
assert_true(identity_ledger:find("current_playerdata", 1, true) ~= nil, "durable ledger omitted current PlayerData state")
local identity_accounting = assert(identity_writes[identity_root .. "/runtime/final_logs/source_accounting_latest.json"])
assert_true(sources_by_name(identity_accounting).playerdata_filenames.status == "available", "current PlayerData discovery was not available")

local pending_ok, pending_writes, _, pending_root = run_case({
    name="playerdata-discovery-pending-v2",
    active_log=true,
    poll_id=3,
    notifications=false,
    playerdata_discovery_pending=true,
    cache_playerdata=false,
})
assert_true(pending_ok == true, "pending PlayerData discovery should not block independent current reports")
local pending_accounting = assert(pending_writes[pending_root .. "/runtime/final_logs/source_accounting_latest.json"])
local pending_source = sources_by_name(pending_accounting).playerdata_filenames
assert_true(pending_source.status == "deferred" and pending_source.status ~= "expected_empty", "pending PlayerData discovery was misclassified expected-empty")
local pending_daily = assert(pending_writes[pending_root .. "/runtime/final_logs/daily_rollup_latest.json"])
assert_true(pending_daily.route_proof_status == "limited_expected_empty" and pending_daily.expected_empty_reason == "daily_rollup_not_mature", "pending discovery did not keep daily maturity explicit")

local activity_account = {account_id="400", ban_id="400", name="Current Player", identity_confidence="direct_login_request", status="INFO", score=0, sessions={"S-1"}}
local activity_ok, activity_writes, _, activity_root = run_case({
    name="same-day-activity-v2",
    active_log=true,
    poll_id=4,
    notifications=true,
    accounts={['400']=activity_account},
    sessions={['S-1']={session_id="S-1", account_id="400", join_ts="2026-07-16T10:00:00Z", leave_ts="2026-07-16T11:00:00Z", clean_leave=true}},
})
assert_true(activity_ok == true, "same-day activity fixture did not complete")
local activity_player = assert(activity_writes[activity_root .. "/runtime/final_logs/player_activity_latest.json"])
assert_true(activity_player.route_proof_status == "full" and activity_player.player_activity_present == true, "same-day session evidence did not own player activity")
assert_true(activity_player.movement.joined == 1 and activity_player.movement.left == 1 and activity_player.movement.clean_exits == 1, "same-day movement counts differ")
assert_true(#activity_player.same_day_sessions == 1, "same-day session details were not exported")
assert_true(activity_player.same_day_sessions[1].account_id == "400" and activity_player.same_day_sessions[1].clean_exit == true, "same-day session details differ")
local activity_daily = assert(activity_writes[activity_root .. "/runtime/final_logs/daily_rollup_latest.json"])
assert_true(activity_daily.daily_metrics.accounts_with_same_day_activity == 1, "daily report omitted the active account")
assert_true(activity_daily.daily_metrics.joins == 1 and activity_daily.daily_metrics.clean_exits == 1, "daily report movement totals differ")

local historical_session_ok, historical_session_writes, _, historical_session_root = run_case({
    name="historical-session-v2",
    active_log=true,
    poll_id=5,
    notifications=false,
    accounts={['401']={account_id="401", ban_id="401", name="Old Player", identity_confidence="direct_login_request", status="INFO", score=0, sessions={"S-old"}}},
    sessions={['S-old']={session_id="S-old", account_id="401", join_ts="2026-07-15T10:00:00Z", leave_ts="2026-07-15T11:00:00Z", clean_leave=true}},
})
assert_true(historical_session_ok == true, "historical session fixture did not complete")
local historical_session_player = assert(historical_session_writes[historical_session_root .. "/runtime/final_logs/player_activity_latest.json"])
assert_true(historical_session_player.route_proof_status == "limited_expected_empty", "prior-day session evidence incorrectly owned current player activity")

local retained_case_ok, retained_case_writes, _, retained_case_root = run_case({name="retained-case-v2", active_log=true, poll_id=6, notifications=false, retained_case=true})
assert_true(retained_case_ok == true, "retained-case fixture did not complete")
local retained_case_report = assert(retained_case_writes[retained_case_root .. "/runtime/final_logs/case_review_latest.json"])
assert_true(retained_case_report.retained_case_count == 1, "retained case inventory was not preserved")
assert_true(retained_case_report.route_proof_status == "limited_expected_empty" and retained_case_report.expected_empty_reason == "no_case_review_activity", "historical case incorrectly owned current case review")
local retained_case = assert(retained_case_report.cases[1], "retained case details were not exported")
assert_true(retained_case.accounts[1] == "900", "JSON string-array account value was not decoded")
assert_true(contains(retained_case.source_references, "runtime\\evidence\\old.json"), "escaped JSON string-array value was not unescaped exactly once")

local current_case_ok, current_case_writes, _, current_case_root = run_case({
    name="current-case-v2",
    active_log=true,
    poll_id=7,
    notifications=false,
    accounts={['500']={account_id="500", ban_id="500", name="Review Subject", identity_confidence="direct_login_request", status="REVIEW", score=90, sessions={}}},
})
assert_true(current_case_ok == true, "current-case fixture did not complete")
local current_case_report = assert(current_case_writes[current_case_root .. "/runtime/final_logs/case_review_latest.json"])
assert_true(current_case_report.route_proof_status == "full" and #current_case_report.review_subjects == 1, "current named review material did not own case review")
assert_true(current_case_report.review_subjects[1].display_name == "Review Subject", "case report omitted the real display name")
assert_true(current_case_report.review_subjects[1].identity_confidence == "direct_login_request", "case report omitted identity strength")

local unknown_ok, unknown_writes, _, unknown_root = run_case({
    name="unknown-translation-v2",
    active_log=true,
    poll_id=8,
    notifications=false,
    accounts={['600']={account_id="600", ban_id="600", name="Unknown Confidence", identity_confidence="future_confidence", status="INFO", score=0, sessions={}}},
})
assert_true(unknown_ok == true, "unknown translation fixture did not complete")
local unknown_player = assert(unknown_writes[unknown_root .. "/runtime/final_logs/player_activity_latest.json"])
assert_true(unknown_player.translation.unmapped_value_count >= 1, "unknown dictionary value was not counted")
local unknown_found = false
for _, note in ipairs(unknown_player.translation.notes or {}) do
    if note.mapped == false and tostring(note.meaning):find("Unknown or unmapped", 1, true) then unknown_found = true end
end
assert_true(unknown_found, "unknown dictionary value did not use the explicit review-first fallback")

local boundary_ok, boundary_writes, _, boundary_root = run_case({
    name="ledger-boundary-v2",
    active_log=true,
    poll_id=9,
    notifications=false,
    ledger_row_count=5000,
})
assert_true(boundary_ok == true, "the documented 5000-row ledger boundary was rejected")
local boundary_accounting = assert(boundary_writes[boundary_root .. "/runtime/final_logs/source_accounting_latest.json"])
assert_true(boundary_accounting.identity_reconciliation.durable_ledger_row_count == 5000, "the 5000-row boundary count was not retained")
assert_true(boundary_accounting.identity_reconciliation.durable_ledger_load_status == "ready", "the 5000-row boundary did not load ready")

local overflow_ok, overflow_writes, overflow_counts, overflow_root = run_case({
    name="ledger-overflow-v2",
    active_log=true,
    poll_id=10,
    notifications=false,
    ledger_row_count=5001,
})
assert_true(overflow_ok == false, "ledger overflow did not fail the reporting contract closed")
local overflow_proof = assert(overflow_writes[overflow_root .. "/runtime/final_logs/route_proof.json"])
for name, route in pairs(routes_by_name(overflow_proof)) do assert_true(route.status == "missing", name .. " survived ledger overflow") end
assert_true(overflow_counts[overflow_root .. "/runtime/history/public_accounts.tsv"] == nil, "overflowing ledger was overwritten or truncated")
local overflow_accounting = assert(overflow_writes[overflow_root .. "/runtime/final_logs/source_accounting_latest.json"])
assert_true(overflow_accounting.identity_reconciliation.durable_ledger_load_bound == 5000, "ledger load bound was not exported")
assert_true(overflow_accounting.identity_reconciliation.status == "error", "ledger overflow was not exported as an identity error")
assert_report_coverage_contract(overflow_writes, {}, overflow_root, "identity accounting failure", "unavailable")

for _,failure in ipairs({
    {name="source-accounting-write-failure-v2", fail_source_accounting_write=true},
    {name="history-write-failure-v2", fail_history_write=true},
}) do
    failure.active_log = true
    failure.poll_id = 12
    failure.notifications = false
    local failure_ok, failure_writes, _, failure_root, failure_attempts = run_case(failure)
    assert_true(failure_ok == false, failure.name .. " did not fail the required contract write closed")
    assert_report_coverage_contract(failure_writes, failure_attempts, failure_root, failure.name, "unavailable")
end

local report_write_ok, report_write_writes, _, report_write_root, report_write_attempts = run_case({
    name="paired-report-write-failure-v2",
    active_log=true,
    poll_id=13,
    notifications=false,
    fail_report_write=true,
})
assert_true(report_write_ok == true, "paired route-output failure changed the aggregate contract result")
assert_report_coverage_contract(report_write_writes, report_write_attempts, report_write_root, "paired route-output failure")
local failed_player_report = assert(report_write_attempts[report_write_root .. "/runtime/final_logs/player_activity_latest.json"])
assert_true(failed_player_report.route_result.status == "missing", "paired route-output failure did not mark route_result missing")
assert_true(failed_player_report.next_action:find("both route output writes", 1, true) ~= nil, "paired route-output failure omitted its next action")

local proof_write_ok, proof_write_writes, _, proof_write_root, proof_write_attempts = run_case({
    name="route-proof-write-failure-v2",
    active_log=true,
    poll_id=14,
    notifications=false,
    fail_route_proof_write=true,
})
assert_true(proof_write_ok == false, "route-proof write failure did not fail the aggregate contract closed")
assert_report_coverage_contract(proof_write_writes, proof_write_attempts, proof_write_root, "route-proof write failure")
for _,route in ipairs(REPORT_ROUTES) do
    local report = assert(proof_write_writes[proof_write_root .. "/runtime/final_logs/" .. route .. "_latest.json"])
    assert_true(report.route_result.status == "missing", "route-proof failure left " .. route .. " non-missing")
    assert_true(report.next_action:find("route-proof output", 1, true) ~= nil, "route-proof failure omitted next action for " .. route)
end

local dedupe_ok, dedupe_writes, dedupe_counts, dedupe_root = run_case({
    name="forced-refresh-dedupe-v2",
    active_log=true,
    poll_id=11,
    notifications=true,
    repeat_refresh=true,
    accounts={['700']={account_id="700", ban_id="700", name="Stable Session", identity_confidence="direct_login_request", status="INFO", score=0, sessions={"S-700"}}},
    sessions={['S-700']={session_id="S-700", account_id="700", join_ts="2026-07-16T09:00:00Z", leave_ts="2026-07-16T09:30:00Z", clean_leave=true}},
})
assert_true(dedupe_ok == true, "forced-refresh dedupe fixture did not complete")
assert_true(dedupe_counts[dedupe_root .. "/runtime/notifications/pending/player_activity_latest.json"] == 1, "unchanged player outbox payload was rewritten per poll")
assert_true(dedupe_counts[dedupe_root .. "/runtime/notifications/pending/daily_rollup_latest.json"] == 1, "same-day daily outbox payload was rewritten")
local dedupe_status = assert(dedupe_writes[dedupe_root .. "/runtime/notifications/notification_status.json"])
local deduplicated = {}
for _, outcome in ipairs(dedupe_status.outcomes or {}) do deduplicated[outcome.route] = outcome.outcome end
assert_true(deduplicated.player_activity == "local_outbox_deduplicated", "player dedupe outcome was not explicit")
assert_true(deduplicated.daily_rollup == "local_outbox_deduplicated", "daily dedupe outcome was not explicit")

io.popen = original_popen
print("REAL LUA PUBLIC PIPELINE RUNTIME FIXTURE PASSED")
