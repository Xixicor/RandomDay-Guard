-- RandomDayGuard
-- Saved-folder and log-derived UE4SS watchdog for Abiotic Factor dedicated servers.
-- Single-file runtime: no external Lua module dependencies.

local VERSION = "v0.4.11-alpha"

local state = {
    started = false,
    mod_root = nil,
    config = nil,
    saved_root = nil,
    boot_id = nil,
    accounts = {},
    sessions = {},
    active = {},
    name_to_account = {},
    recent_logins = {},
    current_scan = nil,
    raid_counter = 0,
    log_tail_status = "not_started",
    loop_available = false,
    last_poll_ts = nil,
    scheduler_status = "not_started",
    poll_id = 0,
    state_changed = false,
    last_heartbeat_time = 0,
    last_report_time = 0,
    last_full_scan_time = 0,
    last_cleanup_time = 0,
    last_weekly_summary_time = 0,
    log_registry = {},
    current_generation_id = nil,
    current_epoch = nil,
    epoch_counter = 0,
    recent_event_keys = {},
    actor_touch_rollups = {},
    daily_event_refs = {medium={}, high={}, critical={}},
    daily_counts = {low=0, medium=0, high=0, critical=0},
    startup_scan_pending = false,
    startup_scan_complete = false,
    poll_scheduled = false,
    poll_in_flight = false,
    skipped_poll_count = 0,
    initializing_logs = false,
    log_backlog_pending = false,
    poll_stage = "idle",
    scan_job = nil,
    cached_saved_files = {},
    cached_log_files = {},
    poll_completed_count = 0,
    last_poll_completed_ts = nil,
    active_log_caught_up = true,
    active_log_unread_bytes = 0,
    active_log_size = 0,
    active_log_offset = 0,
    active_log_key = "",
    log_backlog_reason = "not_checked",
}

local function str(v) return tostring(v or "") end
local function now() return os.date("!%Y-%m-%dT%H:%M:%SZ") end
local function stamp() return os.date("!%Y%m%d_%H%M%S") end
local function today() return os.date("!%Y-%m-%d") end

local function dirname(path)
    path = str(path):gsub("\\", "/")
    return path:match("^(.*)/[^/]*$") or "."
end

local function join_path(a, b)
    a, b = str(a):gsub("\\", "/"), str(b):gsub("\\", "/")
    if a == "" then return b end
    if b == "" then return a end
    return (a:gsub("/+$", "")) .. "/" .. (b:gsub("^/+", ""))
end

local function normalize_path(path)
    path = str(path):gsub("\\", "/")
    local drive = path:match("^(%a:)/")
    if drive then
        path = drive:upper() .. path:sub(3)
    end
    path = path:gsub("/+", "/")
    local prefix = ""
    if path:match("^%a:/") then prefix, path = path:sub(1, 3), path:sub(4) end
    if path:sub(1, 1) == "/" then prefix, path = prefix .. "/", path:sub(2) end
    local parts = {}
    for part in path:gmatch("[^/]+") do
        if part == ".." then
            if #parts > 0 and parts[#parts] ~= ".." then table.remove(parts) else table.insert(parts, part) end
        elseif part ~= "." and part ~= "" then
            table.insert(parts, part)
        end
    end
    local out = table.concat(parts, "/")
    if prefix ~= "" then return prefix .. out end
    return out ~= "" and out or "."
end

local function relpath(root, path)
    root, path = normalize_path(root):gsub("/+$", ""), normalize_path(path)
    if path:sub(1, #root + 1) == root .. "/" then return path:sub(#root + 2) end
    return path
end

local function q(path) return '"' .. str(path):gsub('"', '\\"') .. '"' end

local function mkdir_p(path)
    path = normalize_path(path)
    if os and os.execute then
        os.execute("mkdir -p " .. q(path) .. " 2>/dev/null")
        os.execute("cmd /c mkdir " .. q(path:gsub("/", "\\")) .. " >nul 2>nul")
    end
end

local function read_file(path, max_bytes)
    local f = io.open(path, "rb")
    if not f then return nil end
    local data = max_bytes and max_bytes > 0 and f:read(max_bytes) or f:read("*a")
    f:close()
    return data
end

local function file_readable(path)
    local f = io.open(path, "rb")
    if not f then return false end
    f:close()
    return true
end

local function file_size(path)
    local f = io.open(path, "rb")
    if not f then return 0 end
    local ok, size = pcall(function()
        local cur = f:seek()
        local s = f:seek("end") or 0
        f:seek("set", cur or 0)
        return s
    end)
    f:close()
    return ok and tonumber(size) or 0
end

local function simple_hash(text)
    text = str(text)
    local h = 5381
    for i=1,#text do
        h = (h * 33 + text:byte(i)) % 4294967296
    end
    return string.format("%08x", h)
end

local function read_head_tail(path)
    local size = file_size(path)
    local head = read_file(path, 4096) or ""
    local tail = ""
    local f = io.open(path, "rb")
    if f then
        local start = math.max(0, size - 4096)
        f:seek("set", start)
        tail = f:read("*a") or ""
        f:close()
    end
    return size, head, tail
end

local function first_timestamp(text)
    return str(text):match("(%d%d%d%d[%.%-/]%d%d[%.%-/]%d%d[%sT%-]%d%d:%d%d:%d%d)")
end

local function last_timestamp(text)
    local last = nil
    for ts in str(text):gmatch("(%d%d%d%d[%.%-/]%d%d[%.%-/]%d%d[%sT%-]%d%d:%d%d:%d%d)") do last = ts end
    return last
end

local function write_file(path, data)
    mkdir_p(dirname(path))
    local f, err = io.open(normalize_path(path), "wb")
    if not f then
        f, err = io.open(str(path):gsub("/", "\\"), "wb")
    end
    if not f then return false, err end
    f:write(str(data))
    f:close()
    return true
end

local function append_file(path, data)
    mkdir_p(dirname(path))
    local f, err = io.open(normalize_path(path), "ab")
    if not f then
        f, err = io.open(str(path):gsub("/", "\\"), "ab")
    end
    if not f then return false, err end
    f:write(str(data))
    f:close()
    return true
end

local function json_escape(s)
    return str(s):gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\t", "\\t")
end

local function is_array(t)
    if type(t) ~= "table" then return false end
    local n = 0
    for k,_ in pairs(t) do if type(k) ~= "number" then return false end; if k > n then n = k end end
    for i=1,n do if t[i] == nil then return false end end
    return true
end

local function to_json(v)
    local tv = type(v)
    if tv == "nil" then return "null" end
    if tv == "boolean" then return v and "true" or "false" end
    if tv == "number" then return tostring(v) end
    if tv == "string" then return '"' .. json_escape(v) .. '"' end
    if tv == "table" then
        local out = {}
        if is_array(v) then
            for i=1,#v do table.insert(out, to_json(v[i])) end
            return "[" .. table.concat(out, ",") .. "]"
        end
        local keys = {}
        for k,_ in pairs(v) do table.insert(keys, tostring(k)) end
        table.sort(keys)
        for _,k in ipairs(keys) do table.insert(out, to_json(k) .. ":" .. to_json(v[k])) end
        return "{" .. table.concat(out, ",") .. "}"
    end
    return to_json(str(v))
end

local function write_json(path, data) return write_file(path, to_json(data) .. "\n") end
local function append_jsonl(path, data) return append_file(path, to_json(data) .. "\n") end

local runtime_path

runtime_path = function(rel)
    return join_path(state.mod_root or ".", rel)
end

local function write_loader_probe(source_path)
    local ok_root_boot, ok_root_probe, ok_json, ok_txt = false, false, false, false
    pcall(function()
        local root = state.mod_root or "."
        ok_root_boot = write_file(join_path(root, "BOOTSTRAP_REACHED.txt"), "RandomDayGuard bootstrap reached " .. VERSION .. " " .. now() .. "\n")
        ok_root_probe = write_file(join_path(root, "loader_probe_root.txt"), "RandomDayGuard loader probe root " .. VERSION .. " " .. now() .. "\n")
    end)
    pcall(function()
        local probe = {
            ts=now(), version=VERSION, phase="main_lua_loaded", boot_id=state.boot_id,
            mod_root=state.mod_root, source_path=source_path, resolved_mod_root=state.mod_root,
            lua_version=_VERSION, has_io=io ~= nil, has_io_open=io and io.open ~= nil,
            has_io_popen=io and io.popen ~= nil, has_os=os ~= nil, has_os_execute=os and os.execute ~= nil,
            has_debug=debug ~= nil, loopasync_available=LoopAsync ~= nil, pcall_available=pcall ~= nil,
            xpcall_available=xpcall ~= nil, root_bootstrap_written=ok_root_boot,
            root_probe_written=ok_root_probe,
        }
        ok_txt = write_file(runtime_path("runtime/loader_probe.txt"), "RandomDayGuard loader probe " .. VERSION .. " " .. now() .. "\n")
        ok_json = write_json(runtime_path("runtime/loader_probe.json"), probe)
        append_jsonl(runtime_path("runtime/logs/current.jsonl"), {ts=now(), event="LOADER_PROBE", ok_json=ok_json, ok_txt=ok_txt, ok_root_boot=ok_root_boot, ok_root_probe=ok_root_probe, version=VERSION})
    end)
    return ok_root_boot or ok_root_probe or ok_json or ok_txt
end

local function sanitize_filename(s)
    s = str(s):gsub("[^A-Za-z0-9%._%-]+", "_")
    return s ~= "" and s or "unknown"
end

local function ensure_dirs()
    for _,d in ipairs({
        "runtime", "runtime/backups", "runtime/baselines", "runtime/evidence", "runtime/logs",
        "runtime/raid_cases", "runtime/warnings", "runtime/current", "runtime/sessions", "runtime/epochs", "runtime/days",
        "runtime/evidence", "runtime/world_state",
        "runtime/world_state/boot", "runtime/world_state/current", "runtime/world_state/sessions"
    }) do mkdir_p(runtime_path(d)) end
end

local function log_event(ev)
    ev.ts = ev.ts or now()
    append_jsonl(runtime_path("runtime/logs/current.jsonl"), ev)
end

local function write_tsv(path, header, rows)
    local out = {table.concat(header, "\t")}
    for _,row in ipairs(rows or {}) do
        local vals = {}
        for _,h in ipairs(header) do
            local clean = str(row[h] or ""):gsub("[\r\n\t]+", " ")
            table.insert(vals, clean)
        end
        table.insert(out, table.concat(vals, "\t"))
    end
    write_file(path, table.concat(out, "\n") .. "\n")
end

local function runtime_ready()
    return state.started == true and state.scheduler_status == "running"
end

local function read_lines_tsv(path)
    local data = read_file(path)
    local rows = {}
    if not data then return rows end
    for line in data:gmatch("[^\r\n]+") do table.insert(rows, line) end
    return rows
end

local function parse_counts_tsv(path)
    local counts = {}
    for i,line in ipairs(read_lines_tsv(path)) do
        if i > 1 then
            local name, count = line:match("^([^\t]+)\t(%d+)")
            if name then counts[name] = tonumber(count) or 0 end
        end
    end
    return counts
end

local function load_config()
    local defaults = {
        version=VERSION,
        saved={root_candidates={}, direct_known_files={}, allow_full_find_discovery=false},
        log_tail={start_at_end_on_first_run=true, tail_backup_logs=false, register_backup_logs=true, backfill_backup_logs_on_start=false, backfill_active_log_on_boot=false, max_lines_per_poll=500, max_bytes_per_poll=262144, max_log_files_per_poll=1, max_runtime_ms=250},
        runtime={poll_interval_ms=1000, heartbeat_interval_seconds=10, max_poll_runtime_ms=250, max_lines_per_poll=500, max_bytes_per_poll=262144, max_events_per_poll=200, full_scan_interval_seconds=300, object_registry_interval_seconds=300, report_refresh_interval_seconds=30, cleanup_interval_seconds=600, weekly_summary_check_interval_seconds=3600},
        logging={low_importance_mode="aggregate", low_importance_sample_interval_seconds=60, max_low_importance_actor_events_per_session=200, max_actor_touch_events_per_poll=100, max_actor_touch_events_per_session=1000, write_low_importance_raw_events=false, escalate_low_to_medium_when_correlated=true},
        scanning={full_scan_on_start=true, reuse_completed_baseline=true, resume_incomplete_scan=true, incremental_refresh_after_baseline=true, force_full_scan=false, partial_output_interval_seconds=30, checkpoint_interval_seconds=15, checkpoint_interval_files=25, baseline_manifest_enabled=true, per_file_entry_cache_enabled=true, changed_file_detection=true, full_scan_max_age_hours=168, aggressive_first_baseline=true, targeted_token_extraction=true, fallback_broad_token_scan=false, deep_backup_scan_enabled=false, incremental_scan_enabled=true, allow_full_find_discovery=true, allow_full_find_discovery_only_in_scan_job=true, recursive_discovery_enabled=true, recursive_discovery_mode="manifest", discovery_files_per_tick=200, discovery_max_runtime_ms=100, startup_scan_files_per_tick=25, startup_scan_max_bytes_per_tick=4194304, startup_scan_max_runtime_ms=100, write_scan_progress=true, max_file_bytes=1048576},
        server_lifecycle={startup_grace_seconds=180, shutdown_grace_seconds=120, post_crash_reconnect_grace_seconds=300, normal_restart_suppression_seconds=300, lifecycle_events_are_context_only=true, close_sessions_on_crash=true, close_sessions_on_graceful_shutdown=true, dedupe_rotated_backup_logs=true},
        retention={detailed_retention_days=7, daily_summary_retention_days=90, weekly_summary_retention_weeks=12, rotate_jsonl_when_bytes_exceed=5242880, max_raw_events_lines=20000, max_low_importance_events_per_day=5000, max_actor_touch_rollups_per_day=10000, max_recent_event_keys=5000, max_warning_reports=30, max_raid_cases=200, compact_json_outputs=true, archive_rotated_runtime_logs=false},
        enforcement={auto_ban=false, review_only_mode=true, write_admin_ini=false, request_restart_after_ban=false, require_playerdata_verified=false, require_clean_ban_id=true, preserve_moderators=true, preserve_existing_bans=true, ban_on_threshold=true, trusted_ids={}},
    }
    local ok, cfg = pcall(dofile, join_path(state.mod_root, "config.lua"))
    if not ok or type(cfg) ~= "table" then
        state.config_load_error = str(cfg)
        write_file(runtime_path("runtime/config_load_error.txt"), state.config_load_error)
        return defaults
    end
    for k,v in pairs(defaults) do
        if type(v) == "table" then
            cfg[k] = cfg[k] or {}
            for dk,dv in pairs(v) do if cfg[k][dk] == nil then cfg[k][dk] = dv end end
        elseif cfg[k] == nil then cfg[k] = v end
    end
    return cfg
end

local DIRECT_KNOWN_FILES = {
    "Logs/AbioticFactor.log",
    "Logs/AbioticFactor-backup.log",
    "Logs/AbioticFactor.log.1",
    "SaveGames/Server/Admin.ini",
    "SaveGames/Server/SandboxSettings.ini",
    "Config/WindowsServer/SandboxSettings.ini",
    ".autoExclude",
}

local function list_files(root)
    local files, seen = {}, {}
    local commands = {
        {source="listing:find", cmd="find " .. q(root) .. " -type f 2>/dev/null"},
        {source="listing:find-L", cmd="find -L " .. q(root) .. " -type f 2>/dev/null"},
        {source="listing:cmd-dir", cmd="cmd /c dir /s /b " .. q(root:gsub("/", "\\")) .. " 2>nul"},
    }
    if io and io.popen then
        for _,entry in ipairs(commands) do
            local p = io.popen(entry.cmd)
            if p then
                for line in p:lines() do
                    local clean = normalize_path(line)
                    if clean ~= "" and not seen[clean] then
                        seen[clean] = true
                        table.insert(files, {path=clean, source=entry.source})
                    end
                end
                p:close()
            end
        end
    end
    return files
end

local function scan_recursive_discovery_commands(root)
    root = normalize_path(root or "")
    return {
        {source="scan_job:find", cmd="find " .. q(root) .. " -type f 2>/dev/null"},
        {source="scan_job:find-L", cmd="find -L " .. q(root) .. " -type f 2>/dev/null"},
        {source="scan_job:cmd-dir", cmd="cmd /c dir /s /b " .. q(root:gsub("/", "\\")) .. " 2>nul"},
    }
end

local function direct_known_file_rels()
    local rels, seen = {}, {}
    local function add(rel)
        rel = str(rel):gsub("\\", "/"):gsub("^/+", "")
        if rel ~= "" and not seen[rel] then
            seen[rel] = true
            table.insert(rels, rel)
        end
    end
    for _,rel in ipairs(DIRECT_KNOWN_FILES) do add(rel) end
    for _,rel in ipairs((((state.config or {}).saved or {}).direct_known_files) or {}) do add(rel) end
    return rels
end

local function accept_saved_file(path)
    local p = normalize_path(path)
    local lower = p:lower()
    if lower:match("/logs/abioticfactor.*%.log%.?%d*$") then return true end
    if p:match("/SaveGames/Server/Admin%.ini$") then return true end
    if p:match("/SaveGames/Server/Worlds/.*/PlayerData/Player_[^/]+%.sav$") then return true end
    if p:match("/SaveGames/Server/Worlds/.*%.sav$") then return true end
    if p:match("/SaveGames/Server/Backups/") then return true end
    if lower:match("%.ini$") or lower:match("%.txt$") or lower:match("%.log$") or lower:match("%.sav$") then return true end
    if p:match("/%.autoExclude$") or p:match("%.autoExclude$") then return true end
    return false
end

local function all_saved_files(root)
    root = normalize_path(root or "")
    local out, seen = {}, {}
    local function add(path, source)
        path = normalize_path(path)
        if path == "" or seen[path] or not accept_saved_file(path) then return end
        if file_readable(path) or read_file(path, 1) ~= nil then
            seen[path] = true
            table.insert(out, {path=path, relpath=relpath(root, path), source=source, size=file_size(path), readable=true})
        end
    end
    for _,rel in ipairs(direct_known_file_rels()) do add(join_path(root, rel), "direct_known") end
    table.sort(out, function(a,b) return a.path < b.path end)
    return out
end

local function direct_known_saved_files(root)
    root = normalize_path(root or "")
    local out, seen = {}, {}
    local function add(rel)
        local path = normalize_path(join_path(root, rel))
        if seen[path] or not accept_saved_file(path) then return end
        if file_readable(path) or read_file(path, 1) ~= nil then
            seen[path] = true
            table.insert(out, {path=path, relpath=relpath(root, path), source="direct_known", size=file_size(path), readable=true})
        end
    end
    for _,rel in ipairs(direct_known_file_rels()) do add(rel) end
    table.sort(out, function(a,b) return a.path < b.path end)
    return out
end

local function remember_saved_file(meta)
    if not meta or not meta.path then return end
    local key = normalize_path(meta.path)
    state.cached_saved_files[key] = meta
    if meta.path:lower():find("/logs/", 1, true) and meta.path:lower():match("%.log%.?%d*$") then
        state.cached_log_files[canonical_log_key and canonical_log_key(meta.path) or key:lower()] = meta.path
    end
end

local function cached_saved_file_list()
    local out = {}
    for _,meta in pairs(state.cached_saved_files or {}) do table.insert(out, meta) end
    table.sort(out, function(a,b) return a.path < b.path end)
    return out
end

local function scan_job_add_file(job, path, source)
    if not job or not path then return false end
    path = normalize_path(path)
    job.file_seen = job.file_seen or {}
    if path == "" or job.file_seen[path] or not accept_saved_file(path) then return false end
    if file_readable(path) or read_file(path, 1) ~= nil then
        local meta = {path=path, relpath=state.saved_root and relpath(state.saved_root, path) or path, source=source or "scan_job", size=file_size(path), readable=true}
        job.file_seen[path] = true
        table.insert(job.files, meta)
        job.readable_files_seen = (job.readable_files_seen or 0) + 1
        job.total_files = #job.files
        remember_saved_file(meta)
        return true
    end
    return false
end

local function clean_ban_id(raw)
    return str(raw):match("^(%d+)") or nil
end

local function normalize_account_id(raw)
    local id = clean_ban_id(raw)
    if id then return id end
    raw = str(raw)
    return raw ~= "" and raw or "unknown"
end

local function is_numeric_id(id) return str(id):match("^%d+$") ~= nil end

local function find_playerdata_file(ban_id)
    if not state.saved_root or not ban_id or ban_id == "" then return nil end
    local suffix = "/PlayerData/Player_" .. ban_id .. ".sav"
    for _,f in ipairs(cached_saved_file_list()) do
        if f.path:find(suffix, 1, true) then return f.path end
    end
    for _,f in ipairs(direct_known_saved_files(state.saved_root)) do
        remember_saved_file(f)
        if f.path:find(suffix, 1, true) then return f.path end
    end
    return nil
end

local function derive_saved_candidates()
    local candidates, seen = {}, {}
    local function add(path, source)
        path = str(path)
        if path == "" or path:match("^#") then return end
        local clean = normalize_path(path)
        if not seen[clean] then seen[clean] = true; table.insert(candidates, {path=clean, source=source}) end
    end
    local override = read_file(join_path(state.mod_root, "SavedRoot.txt")) or ""
    for line in override:gmatch("[^\r\n]+") do add(line:match("^%s*(.-)%s*$"), "SavedRoot.txt") end
    for _,p in ipairs(((state.config or {}).saved or {}).root_candidates or {}) do
        if str(p):match("^%a:/") or str(p):match("^/") then add(p, "config.saved.root_candidates") else add(join_path(state.mod_root, p), "config.saved.root_candidates") end
    end
    for _,p in ipairs({
        join_path(state.mod_root, "../../../../../Saved"),
        join_path(state.mod_root, "../../../../../../Saved"),
        join_path(state.mod_root, "../../../../../../AbioticFactor/Saved"),
        join_path(state.mod_root, "../Saved"),
        join_path(state.mod_root, "Saved"),
    }) do add(p, "derived_from_mod_root") end
    local extra = {}
    for _,c in ipairs(candidates) do
        if c.path:match("^Z:/") then
            local mirror_path = c.path:gsub("^Z:", "")
            table.insert(extra, {path=mirror_path, source=c.source .. ":wine_z_mirror"})
        end
        if c.path:match("^/") then table.insert(extra, {path="Z:" .. c.path, source=c.source .. ":wine_z_path"}) end
    end
    for _,c in ipairs(extra) do add(c.path, c.source) end
    return candidates
end

local function probe_saved_root(candidate_entry)
    local files = direct_known_saved_files(candidate_entry.path)
    local checks, score, known = {}, 0, {}
    local function add_check(path, kind, readable, reason)
        table.insert(checks, {path=path, kind=kind, readable=readable, reason=reason})
    end
    local by_rel = {}
    for _,f in ipairs(files) do by_rel[f.relpath] = f end
    for _,rel in ipairs(DIRECT_KNOWN_FILES) do
        local f = by_rel[rel]
        add_check(join_path(candidate_entry.path, rel), "direct_known", f ~= nil, f and "readable" or "not readable")
        if f then table.insert(known, rel) end
    end
    for _,f in ipairs(files) do
        local p = f.path
        local rel = f.relpath
        if rel == "Logs/AbioticFactor.log" then score = score + 5
        elseif p:lower():match("/logs/abioticfactor.*%.log$") then score = score + 3
        elseif rel == "SaveGames/Server/Admin.ini" then score = score + 3
        elseif rel:match("SandboxSettings%.ini$") then score = score + 2
        elseif rel:match("/PlayerData/Player_[^/]+%.sav$") then score = score + 2
        elseif rel:match("WorldSave_.*%.sav$") then score = score + 2
        elseif rel == ".autoExclude" then score = score + 1
        elseif rel:lower():match("%.ini$") or rel:lower():match("%.txt$") or rel:lower():match("%.log$") or rel:lower():match("%.sav$") then score = score + 1
        end
        add_check(p, "verified_readable", true, "io.open/read_file succeeded")
    end
    return {
        candidate=candidate_entry.path, source=candidate_entry.source, score=score,
        passed=#files > 0, selected=false, known_files_readable=known,
        readable_file_count=#files,
        failure_reason=(#files > 0) and nil or "No readable Saved evidence files found under candidate.",
        checks=checks,
    }
end

local function find_saved_root()
    local probes, best = {}, nil
    for _,candidate in ipairs(derive_saved_candidates()) do
        local p = probe_saved_root(candidate)
        table.insert(probes, p)
        if p.readable_file_count > 0 and (not best or p.score > best.score) then best = p end
    end
    if best then
        best.selected = true
        for _,f in ipairs(direct_known_saved_files(best.candidate)) do remember_saved_file(f) end
    end
    write_json(runtime_path("runtime/saved_path_probe.json"), {ts=now(), selected=best and best.candidate or nil, saved_root_found=best ~= nil, candidates=probes})
    return best and best.candidate or nil
end

local function should_scan_file(meta)
    local p = meta.path:lower()
    local cfg = (state.config or {}).saved or {}
    if p:find("/logs/", 1, true) and cfg.scan_logs == false then return false end
    if p:find("playerdata", 1, true) and cfg.scan_player_data == false then return false end
    if p:find("/backups/", 1, true) and cfg.scan_backups == false then return false end
    if p:find("/worlds/", 1, true) and cfg.scan_world_saves == false then return false end
    if p:match("%.log$") or p:match("%.sav$") or p:match("%.ini$") or p:match("%.txt$") or p:match("%.autoexclude$") then return true end
    return false
end

local function token_is_relevant(token)
    if #token < 3 or #token > 180 then return false end
    if token:match("^/Game/") or token:match("^/Script/") or token:find("PersistentLevel", 1, true) or token:match("_C$") then return true end
    for _,prefix in ipairs({"Deployed_","Container_","Item_","ResourceNode_","NPCSpawn_","PowerSocket","PlugStrip","Plugboard","Battery","Teleporter","Portal","Bridge","Barricade","Furniture","Food","Weapon","Tool","Armor","Trinket","PetBed","PestWheel","LootSpillBag"}) do
        if token:sub(1, #prefix) == prefix then return true end
    end
    return false
end

local function categorize_token(token)
    local cats = {}
    for cname,cfg in pairs(((state.config or {}).class_categories) or {}) do
        for _,pat in ipairs(cfg.patterns or {}) do
            if token:find(pat, 1, true) then table.insert(cats, cname); break end
        end
    end
    if #cats == 0 then table.insert(cats, "other") end
    return cats
end

local function scan_saved(reason)
    reason = reason or "manual"
    local result = {ts=now(), reason=reason, root=state.saved_root, scan_ok=false, files={}, counts={}, entries={}, map_paths={}, scanned_files=0, readable_files_seen=0, logs_seen=0, playerdata_seen=0, admin_ini_seen=false, world_saves_seen=0, errors={}}
    if not state.saved_root then table.insert(result.errors, "saved_root_not_found"); state.current_scan = result; return result end
    local max_bytes = tonumber((((state.config or {}).scanning or {}).max_file_bytes)) or 1048576
    local files = all_saved_files(state.saved_root)
    result.readable_files_seen = #files
    for _,meta in ipairs(files) do
        local p = meta.path
        if p:lower():match("/logs/.*%.log") then result.logs_seen = result.logs_seen + 1 end
        if p:match("/PlayerData/Player_[^/]+%.sav$") then result.playerdata_seen = result.playerdata_seen + 1 end
        if meta.relpath == "SaveGames/Server/Admin.ini" then result.admin_ini_seen = true end
        if p:match("/SaveGames/Server/Worlds/.*%.sav$") and not p:match("/PlayerData/") then result.world_saves_seen = result.world_saves_seen + 1 end
        if should_scan_file(meta) then
            local data = read_file(p, max_bytes)
            if data then
                result.scanned_files = result.scanned_files + 1
                table.insert(result.files, {path=p, relpath=meta.relpath, size=meta.size, source=meta.source})
                for token in data:gmatch("[A-Za-z0-9_/%._%-]+") do
                    if token_is_relevant(token) then
                        result.counts[token] = (result.counts[token] or 0) + 1
                        if token:find("/Game/Maps/", 1, true) then result.map_paths[token] = true end
                    end
                end
            else
                table.insert(result.errors, "read_failed: " .. p)
            end
        end
    end
    for name,count in pairs(result.counts) do table.insert(result.entries, {name=name, count=count, categories=categorize_token(name)}) end
    table.sort(result.entries, function(a,b) return a.name < b.name end)
    result.scan_ok = true
    state.current_scan = result
    return result
end

local function write_scan_outputs(scan)
    write_json(runtime_path("runtime/baselines/last_scan.json"), scan)
    write_json(runtime_path("runtime/scan_complete.json"), {boot_id=state.boot_id, epoch_id=state.current_epoch and state.current_epoch.epoch_id or nil, scan_generation_id=scan.scan_generation_id or stamp(), log_generation_id_at_scan=state.current_generation_id, created_after_restart=false, created_after_crash=false, created_after_unknown_gap=false, server_lifecycle_state=state.current_epoch and state.current_epoch.lifecycle_class or "unknown", ts=scan.ts, reason=scan.reason, root=scan.root, scan_ok=scan.scan_ok, scanned_files=scan.scanned_files, readable_files_seen=scan.readable_files_seen, entries=#scan.entries, logs_seen=scan.logs_seen, playerdata_seen=scan.playerdata_seen, admin_ini_seen=scan.admin_ini_seen, world_saves_seen=scan.world_saves_seen, errors=scan.errors})
    local prev = parse_counts_tsv(runtime_path("runtime/object_registry_counts.tsv"))
    local rows, new_count, delta_count = {}, 0, 0
    for _,e in ipairs(scan.entries) do
        local previous = prev[e.name]
        local delta = previous and (e.count - previous) or 0
        if previous == nil and next(prev) ~= nil then new_count = new_count + 1; append_jsonl(runtime_path("runtime/new_classes_detected.jsonl"), {ts=now(), class=e.name, count=e.count, enforcement="log_only", malicious_by_default=false}) end
        if delta ~= 0 then delta_count = delta_count + 1; append_jsonl(runtime_path("runtime/class_deltas.jsonl"), {ts=now(), class=e.name, previous=previous or 0, current=e.count, delta=delta}) end
        table.insert(rows, {class=e.name, count=e.count, previous=previous or "", delta=delta, categories=table.concat(e.categories or {}, ",")})
    end
    write_tsv(runtime_path("runtime/object_registry_counts.tsv"), {"class","count","previous","delta","categories"}, rows)
    write_json(runtime_path("runtime/object_registry.json"), {boot_id=state.boot_id, epoch_id=state.current_epoch and state.current_epoch.epoch_id or nil, ts=now(), entries=scan.entries, summary={classes=#scan.entries, files=scan.scanned_files, new_classes=new_count, deltas=delta_count}})
    write_json(runtime_path("runtime/baselines/last_completed_baseline.json"), {version=VERSION, boot_id=state.boot_id, epoch_id=state.current_epoch and state.current_epoch.epoch_id or nil, ts=now(), root=scan.root, scan_generation_id=scan.scan_generation_id, scan_complete=true, entries=#scan.entries, scanned_files=scan.scanned_files, readable_files_seen=scan.readable_files_seen, logs_seen=scan.logs_seen, playerdata_seen=scan.playerdata_seen, world_saves_seen=scan.world_saves_seen, limitations={"Visible strings are extracted from readable Saved/log files only.", "Unreal save files are not deserialized."}})
    local manifest_rows = {}
    for _,f in ipairs(scan.files or {}) do table.insert(manifest_rows, {path=f.path, relpath=f.relpath, size=f.size or "", source=f.source or "", scan_generation_id=scan.scan_generation_id or ""}) end
    write_tsv(runtime_path("runtime/baselines/file_manifest.tsv"), {"path","relpath","size","source","scan_generation_id"}, manifest_rows)
    return new_count, delta_count
end

local function parse_login_request(line, ctx)
    if not line:lower():find("login request", 1, true) then return nil end
    local name = line:match("[?&]Name=([^?%s]+)") or line:match("Name=([^?%s]+)")
    local connect = line:match("[?&]ConnectID=([^?%s]+)") or line:match("ConnectID=([^?%s]+)")
    local unique = line:match("UniqueId=([^%s,]+)") or line:match("UniqueID=([^%s,]+)")
    local ban_id = clean_ban_id(connect)
    local playerdata = find_playerdata_file(ban_id)
    return {
        type="PLAYER_LOGIN_IDENTITY", ts=now(), raw=line,
        log_name=name, name=name, connect_id_raw=connect, raw_id=connect,
        ban_id=ban_id, account_id=ban_id, unique_id=unique,
        identity_source="Saved/Logs Login request",
        identity_confidence=ban_id and "direct_login_request" or "unique_id_context_only",
        mapping_log_file=ctx and ctx.file or nil,
        mapping_line_number=ctx and ctx.line_number or nil,
        playerdata_file=playerdata,
        playerdata_verified=playerdata ~= nil,
        playerdata_verification_source=playerdata and "PlayerData filename" or "not_found",
    }
end

local function mapped_presence(name)
    local mapped = state.name_to_account[name or ""]
    if mapped then return mapped.account_id, mapped.raw_id, mapped.ban_id, mapped end
    mapped = state.recent_logins[name or ""]
    if mapped then return mapped.account_id, mapped.raw_id, mapped.ban_id, mapped end
    return "unmapped_name:" .. sanitize_filename(name or "unknown"), nil, nil, nil
end

local function clean_presence_name(name)
    name = str(name)
    name = name:gsub("\r", ""):gsub("\n", "")
    name = name:gsub("^%s+", ""):gsub("%s+$", "")
    name = name:gsub("^LogAbiotic:%s*Display:%s*CHAT LOG:%s*", "")
    name = name:gsub("^LogAbiotic_Display_CHAT_LOG_", "")
    name = name:gsub("^CHAT LOG:%s*", "")
    name = name:gsub("%s+$", "")
    return name
end

local function resolve_presence_event_identity(ev)
    if not ev or ev.type ~= "PLAYER_JOIN_STATE" then return ev end
    local unmapped = ev.identity_confidence == "unmapped_presence_only" or str(ev.account_id):match("^unmapped_name:")
    if not unmapped then return ev end
    local name = clean_presence_name(ev.log_name or ev.name or "")
    local account_id, raw_id, ban_id, mapped = mapped_presence(name)
    if not mapped then return ev end
    ev.name = ev.name or name
    ev.log_name = ev.log_name or name
    ev.account_id = account_id
    ev.raw_id = raw_id or mapped.raw_id
    ev.connect_id_raw = mapped.connect_id_raw or mapped.raw_id or raw_id
    ev.ban_id = ban_id or mapped.ban_id
    ev.unique_id = mapped.unique_id
    ev.identity_source = mapped.identity_source or "Saved/Logs Login request"
    ev.identity_confidence = "mapped_presence_after_login"
    ev.playerdata_verified = mapped.playerdata_verified == true
    ev.playerdata_file = mapped.playerdata_file
    return ev
end

local actor_class_family
local extract_actor_name
local extract_zone_id

local function parse_log_line(line, ctx)
    local events, lower = {}, line:lower()
    local function add(t, data)
        data = data or {}
        data.type=t; data.raw=line; data.ts=data.ts or now()
        data.mapping_log_file = data.mapping_log_file or (ctx and ctx.file or nil)
        data.mapping_line_number = data.mapping_line_number or (ctx and ctx.line_number or nil)
        data.log_generation_id = data.log_generation_id or (ctx and ctx.generation_id or nil)
        data.boot_id = state.boot_id
        data.epoch_id = state.current_epoch and state.current_epoch.epoch_id or nil
        data.poll_id = state.poll_id
        data.source_log_file = data.mapping_log_file
        data.source_line_number = data.mapping_line_number
        data.source_line_hash = simple_hash(line)
        data.event_type = data.type
        data.event_key = str(data.epoch_id) .. ":" .. str(data.log_generation_id) .. ":" .. str(data.type) .. ":" .. str(data.source_line_hash)
        table.insert(events, data)
    end
    local login = parse_login_request(line, ctx)
    if login then add(login.type, login) end

    local name, raw = line:match("CHAT LOG:%s*(.-)%s+has entered the facility")
    if not name then name, raw = line:match("user%s+(.-)%s+with User ID%s+(.-)%s+joined") end
    if not name then name = line:match("([^%[%]\r\n]+)%s+has entered the facility") end
    if not name then name, raw = line:match("Dear Admins,%s*(.-)%s+with%s+(.-)%s+JOINED") end
    if not name then name = line:match("CHAT LOG:.-%]%s*(.-)%s+entered") end
    if name and (lower:find("joined",1,true) or lower:find("entered the facility",1,true)) then
        name = clean_presence_name(name)
        local account_id, raw_id, ban_id, mapped
        if raw and raw ~= "" then
            raw_id = raw
            ban_id = clean_ban_id(raw)
            account_id = ban_id or normalize_account_id(raw)
        else
            account_id, raw_id, ban_id, mapped = mapped_presence(name)
        end
        add("PLAYER_JOIN_STATE", {name=name, log_name=name, raw_id=raw or raw_id, connect_id_raw=mapped and mapped.connect_id_raw or raw, account_id=account_id, ban_id=ban_id or clean_ban_id(raw), unique_id=mapped and mapped.unique_id or nil, identity_source=mapped and mapped.identity_source or "Saved/Logs presence", identity_confidence=mapped and "mapped_presence_after_login" or "unmapped_presence_only", playerdata_verified=mapped and mapped.playerdata_verified or false, playerdata_file=mapped and mapped.playerdata_file or nil})
    end

    name, raw = line:match("CHAT LOG:%s*(.-)%s+has exited the facility")
    if not name then name, raw = line:match("user%s+(.-)%s+with User ID%s+(.-)%s+left") end
    if not name then name = line:match("([^%[%]\r\n]+)%s+has exited the facility") end
    if not name then name, raw = line:match("Dear Admins,%s*(.-)%s+with%s+(.-)%s+LEFT") end
    if not name then name = line:match("CHAT LOG:.-%]%s*(.-)%s+exited") end
    if name and (lower:find("left",1,true) or lower:find("exited",1,true)) then
        name = clean_presence_name(name)
        local account_id, raw_id, ban_id, mapped
        if raw and raw ~= "" then
            raw_id = raw
            ban_id = clean_ban_id(raw)
            account_id = ban_id or normalize_account_id(raw)
        else
            account_id, raw_id, ban_id, mapped = mapped_presence(name)
        end
        add("PLAYER_LEAVE_STATE", {name=name, log_name=name, raw_id=raw or raw_id, account_id=account_id, ban_id=ban_id or clean_ban_id(raw), unique_id=mapped and mapped.unique_id or nil, clean_leave=true, leave_reason="normal_leave", identity_confidence=mapped and "mapped_presence_after_login" or "unmapped_presence_only"})
    end

    if lower:find("connection timed out",1,true) or lower:find("networkfailure",1,true) then
        local timeout_name = line:match("for%s+([A-Za-z0-9_%-%[%]%.]+)") or line:match("Player[:=]%s*([A-Za-z0-9_%-%[%]%.]+)")
        add("NETWORK_DISRUPTION_EVENT", {name=timeout_name, clean_leave=false, leave_reason=lower:find("networkfailure",1,true) and "network_failure" or "timeout", lifecycle_class="network_disruption", identity_confidence=timeout_name and "unmapped_presence_only" or "unknown"})
    end
    if line:find("DeployableSaveWarning",1,true) then add("DEPLOYABLE_WARNING_BURST") end
    if line:find("ActorChannelFailure",1,true) or line:find("Actor channel failed",1,true) then add("ACTOR_CHANNEL_FAILURE_BURST") end
    if line:find("UpdateActorToWorldSave",1,true) then
        add("WORLD_ACTOR_SAVE_TOUCH", {importance="low", actor_name=extract_actor_name(line), actor_class_family=actor_class_family(extract_actor_name(line)), zone_id=extract_zone_id(line), coordinate_source="log_string_context", coordinate_confidence="low"})
    end
    if line:find("ServerMove: TimeStamp expired",1,true) then add("SERVERMOVE_TIMESTAMP_EXPIRED") end
    if line:find("StaticShutdownAfterError",1,true) or lower:find("fatal error",1,true) or lower:find("critical error",1,true) or lower:find("unhandled exception",1,true) then add("SERVER_LIFECYCLE_EVENT", {lifecycle_class="crash_or_fatal", event_type="crash_or_fatal", leave_reason="server_crash_or_fatal", confidence="high"}) end
    if line:find("RequestExit",1,true) or line:find("LogExit",1,true) or lower:find("engine exit",1,true) or lower:find("server shutting down",1,true) then add("SERVER_LIFECYCLE_EVENT", {lifecycle_class="graceful_shutdown", event_type="graceful_shutdown", leave_reason="server_shutdown", confidence="high"}) end
    if lower:find("log file open",1,true) or lower:find("server started",1,true) or lower:find("listening",1,true) or lower:find("server ready",1,true) then add("SERVER_LIFECYCLE_EVENT", {lifecycle_class="restart_or_boot", event_type="restart_or_boot", confidence="medium"}) end
    if line:match("/Game/") or line:match("/Script/") then add("PATH_OR_CLASS_STRING", {game_path=line:match("(/Game/[%w_/%.-]+)"), script_path=line:match("(/Script/[%w_/%.-]+)" )}) end
    return events
end

local function read_offsets()
    local offsets = {}
    for i,line in ipairs(read_lines_tsv(runtime_path("runtime/log_offsets.tsv"))) do
        if i > 1 then
            local path, offset = line:match("^([^\t]+)\t(%d+)")
            if path then offsets[path] = tonumber(offset) or 0 end
        end
    end
    return offsets
end

local function canonical_log_key(path)
    path = normalize_path(path):lower()
    if path:match("^z:/") then path = path:sub(3) end
    path = path:gsub("/+", "/")
    return path
end

local function is_active_log(path)
    return canonical_log_key(path):match("/logs/abioticfactor%.log$") ~= nil
end

local function prefer_log_path(existing, candidate)
    existing, candidate = normalize_path(existing or ""), normalize_path(candidate or "")
    if existing == "" then return candidate end
    if candidate == "" then return existing end
    local existing_readable, candidate_readable = file_readable(existing), file_readable(candidate)
    if candidate_readable and not existing_readable then return candidate end
    if existing_readable and not candidate_readable then return existing end
    if not candidate:lower():match("^z:/") and existing:lower():match("^z:/") then return candidate end
    return existing
end

local function unique_log_paths(paths)
    local by_key, order = {}, {}
    for _,path in ipairs(paths or {}) do
        local clean = normalize_path(path)
        local key = canonical_log_key(clean)
        if key ~= "" then
            if not by_key[key] then table.insert(order, key) end
            by_key[key] = prefer_log_path(by_key[key], clean)
        end
    end
    table.sort(order)
    local out = {}
    for _,key in ipairs(order) do table.insert(out, by_key[key]) end
    return out
end

local function write_offsets(offsets)
    local rows = {}
    for path,offset in pairs(offsets) do table.insert(rows, {path=path, offset=offset, size=0}) end
    table.sort(rows, function(a,b) return a.path < b.path end)
    write_tsv(runtime_path("runtime/log_offsets.tsv"), {"path","offset","size"}, rows)
end

local continuity_event
local previous_boot_id

local function log_files()
    if not state.saved_root then return {} end
    local by_key = {}
    local function add(path)
        path = normalize_path(path)
        if file_readable(path) and path:lower():match("/logs/abioticfactor.*%.log%.?%d*$") then
            local key = canonical_log_key(path)
            local current = by_key[key]
            if current and current ~= path then
                local preferred = (not path:lower():match("^z:/")) and path or current
                by_key[key] = preferred
                continuity_event({type="path_alias_suppressed", path=path, canonical_key=key, preferred_path=preferred, what_it_means="The same log was visible through multiple Wine path aliases.", contributes_to_ban_eligibility=false, confidence="high"})
            elseif not current then
                by_key[key] = path
            end
        end
    end
    for _,path in pairs(state.cached_log_files or {}) do add(path) end
    for _,meta in ipairs(cached_saved_file_list()) do
        if meta.path:lower():find("/logs/", 1, true) and meta.path:lower():match("%.log%.?%d*$") then add(meta.path) end
    end
    add(join_path(state.saved_root, "Logs/AbioticFactor.log"))
    add(join_path(state.saved_root, "Logs/AbioticFactor-backup.log"))
    add(join_path(state.saved_root, "Logs/AbioticFactor.log.1"))
    for _,rel in ipairs((((state.config or {}).saved or {}).direct_known_files) or {}) do
        if str(rel):lower():match("^logs/abioticfactor.*%.log%.?%d*$") then add(join_path(state.saved_root, rel)) end
    end
    local out = {}
    for _,path in pairs(by_key) do table.insert(out, path) end
    table.sort(out)
    return out
end

local function refresh_log_file_cache()
    local next_cache = {}
    for _,path in ipairs(log_files()) do
        local key = canonical_log_key(path)
        next_cache[key] = prefer_log_path(next_cache[key] or state.cached_log_files[key], path)
    end
    state.cached_log_files = next_cache
end

local function cached_log_file_paths()
    local out = {}
    for _,path in pairs(state.cached_log_files or {}) do table.insert(out, path) end
    return unique_log_paths(out)
end

local function log_file_fingerprint(path)
    local size, head, tail = read_head_tail(path)
    return {
        size=size,
        head_fingerprint=simple_hash(head),
        tail_fingerprint=simple_hash(tail),
        first_timestamp=first_timestamp(head),
        last_timestamp=last_timestamp(tail),
        last_line_hash=simple_hash((tail:match("([^\r\n]*)$") or "")),
    }
end

local function log_file_key(path) return canonical_log_key(path) end

local save_session_world
local write_session_summary
local write_epoch_summary
local write_daily_summary
local rotate_if_needed

local function day_folder(ts)
    local day = str(ts or now()):sub(1, 10)
    if not day:match("^%d%d%d%d%-%d%d%-%d%d$") then day = today() end
    local folder = runtime_path("runtime/days/" .. day)
    mkdir_p(folder)
    return folder, day
end

local function classify_event(ev)
    if ev.importance then return ev.importance end
    if ev.type == "WORLD_ACTOR_SAVE_TOUCH" then return "low" end
    if ev.type == "SERVER_LIFECYCLE_EVENT" or ev.type == "NETWORK_DISRUPTION_EVENT" then return "medium" end
    if ev.type == "DEPLOYABLE_WARNING_BURST" or ev.type == "ACTOR_CHANNEL_FAILURE_BURST" or ev.type == "SERVERMOVE_TIMESTAMP_EXPIRED" then return "medium" end
    if ev.type == "ENFORCEMENT_FAILURE" then return "critical" end
    return "medium"
end

local function evidence_path_for_importance(importance)
    if importance == "critical" then return runtime_path("runtime/evidence/critical_events.jsonl") end
    if importance == "high" then return runtime_path("runtime/evidence/high_events.jsonl") end
    if importance == "medium" then return runtime_path("runtime/evidence/medium_events.jsonl") end
    return nil
end

local function append_compact_event(ev)
    if not runtime_ready() then return false end
    ev.importance = classify_event(ev)
    if ev.importance == "low" then return false end
    local path = evidence_path_for_importance(ev.importance)
    if path then
        append_jsonl(path, ev)
        local refs = state.daily_event_refs[ev.importance] or {}
        table.insert(refs, {ts=ev.ts or now(), type=ev.type, path=relpath(runtime_path("runtime"), path), event_key=ev.event_key})
        state.daily_event_refs[ev.importance] = refs
    end
    state.daily_counts[ev.importance] = (state.daily_counts[ev.importance] or 0) + 1
    return true
end

local function append_bounded_raw_event(ev)
    if not runtime_ready() then return false end
    if ev.importance == "low" and (((state.config or {}).logging or {}).write_low_importance_raw_events ~= true) then return false end
    append_jsonl(runtime_path("runtime/raw_events.jsonl"), ev)
    local max_bytes = (((state.config or {}).retention or {}).rotate_jsonl_when_bytes_exceed) or 5242880
    rotate_if_needed(runtime_path("runtime/raw_events.jsonl"), max_bytes)
    return true
end

actor_class_family = function(name)
    name = str(name)
    return name:match("^(Deployed_[%w_]+)") or name:match("^(Container_[%w_]+)") or name:match("^(Item_[%w_]+)") or name:match("^(PowerSocket[%w_]*)") or name:match("^(PlugStrip[%w_]*)") or name:match("^(Battery[%w_]*)") or name:match("^(Teleporter[%w_]*)") or name:match("^(%w+_C)") or name:match("([%w_]+)$") or "unknown"
end

extract_actor_name = function(line)
    return line:match("UpdateActorToWorldSave[^A-Za-z0-9_/%.%-]*([A-Za-z0-9_/%.%-_]+)") or line:match("((Deployed_[%w_]+)[%w_]*)") or line:match("((Container_[%w_]+)[%w_]*)") or line:match("((PowerSocket[%w_]*))") or "unknown_actor"
end

extract_zone_id = function(line)
    return line:match("PersistentLevel[%w_%.:/%-]*") or line:match("(/Game/Maps/[%w_/%.-]+)") or "unknown_zone"
end

local function active_session_ids()
    local ids = {}
    for _,sid in pairs(state.active) do table.insert(ids, sid) end
    table.sort(ids)
    return ids
end

local function actor_rollup_key(session_id, actor_name, family, zone_id)
    return str(session_id or "epoch") .. "|" .. str(actor_name) .. "|" .. str(family) .. "|" .. str(zone_id)
end

local function write_minimal_current_state(scan_pending)
    write_json(runtime_path("runtime/current/session_state.json"), {ts=now(), active_sessions={}, sessions={}, scan_pending=scan_pending == true})
    write_json(runtime_path("runtime/current/spatial_context.json"), {ts=now(), actor_touch_rollups={}, scan_pending=scan_pending == true})
    write_json(runtime_path("runtime/current/actor_touch_rollup.json"), {ts=now(), actor_touch_rollups={}})
    write_json(runtime_path("runtime/current/active_accounts.json"), {ts=now(), active_accounts={}})
end

local function update_current_state_files()
    local active_accounts, session_state = {}, {}
    for account_id,sid in pairs(state.active) do
        local s = state.sessions[sid]
        table.insert(active_accounts, {account_id=account_id, session_id=sid, name=s and s.name or "", epoch_id=s and s.epoch_id or ""})
        if s then table.insert(session_state, {session_id=sid, account_id=account_id, join_ts=s.join_ts, leave_ts=s.leave_ts, warnings=#(s.warnings or {}), actor_touch_rollups=s.actor_touch_rollup or {}}) end
    end
    local rollups = {}
    for _,r in pairs(state.actor_touch_rollups or {}) do table.insert(rollups, r) end
    write_json(runtime_path("runtime/current/active_accounts.json"), {ts=now(), active_accounts=active_accounts})
    write_json(runtime_path("runtime/current/session_state.json"), {ts=now(), active_sessions=active_accounts, sessions=session_state, scan_pending=state.startup_scan_pending == true})
    write_json(runtime_path("runtime/current/spatial_context.json"), {ts=now(), model="rolling_current_state", actor_touch_rollups=rollups, importance_model="low_medium_high_critical", scan_pending=state.startup_scan_pending == true})
    write_json(runtime_path("runtime/current/actor_touch_rollup.json"), {ts=now(), actor_touch_rollups=rollups})
end

local function handle_actor_touch(ev)
    ev.importance = "low"
    ev.contributes_to_ban_eligibility = false
    ev.what_it_means = "A world actor save-touch was observed in logs as spatial/world-state context."
    ev.what_it_does_not_prove = "A world actor save-touch does not prove object ownership, damage, container use, duplication, coordinates, or malicious action by itself."
    local actor_name = ev.actor_name or extract_actor_name(ev.raw or "")
    local family = ev.actor_class_family or actor_class_family(actor_name)
    local zone = ev.zone_id or extract_zone_id(ev.raw or "")
    local sessions = active_session_ids()
    if #sessions == 0 then sessions = {"epoch_context"} end
    local cfg = ((state.config or {}).logging or {})
    local max_session = cfg.max_actor_touch_events_per_session or 1000
    local first_append = false
    for _,sid in ipairs(sessions) do
        local s = state.sessions[sid]
        local account_id = s and s.account_id or nil
        local key = actor_rollup_key(sid, actor_name, family, zone)
        local r = state.actor_touch_rollups[key]
        if not r then
            r = {session_id=sid, account_id=account_id, epoch_id=state.current_epoch and state.current_epoch.epoch_id or ev.epoch_id, first_seen_ts=ev.ts or now(), last_seen_ts=ev.ts or now(), actor_name=actor_name, actor_class_family=family, zone_id=zone, count=0, first_source_log_file=ev.source_log_file, first_source_line_number=ev.source_line_number, last_source_log_file=ev.source_log_file, last_source_line_number=ev.source_line_number, coordinate_source="log_string_context", coordinate_confidence="low", importance="low", escalated=false, escalation_reason=""}
            state.actor_touch_rollups[key] = r
            first_append = true
        end
        if r.count < max_session then r.count = r.count + 1 end
        r.last_seen_ts = ev.ts or now()
        r.last_source_log_file = ev.source_log_file
        r.last_source_line_number = ev.source_line_number
        if s then
            s.actor_touch_rollup = s.actor_touch_rollup or {}
            s.actor_touch_rollup[key] = r
            s.zones_seen = s.zones_seen or {}
            s.zones_seen[zone] = true
            if cfg.escalate_low_to_medium_when_correlated == true and (zone:lower():find("power",1,true) or family:lower():find("socket",1,true) or family:lower():find("container",1,true)) then
                r.importance = "medium"
                r.escalated = true
                r.escalation_reason = "mapped_active_session_with_power_socket_storage_context"
                append_compact_event({ts=ev.ts or now(), type="SPATIAL_CONTEXT_ESCALATED", importance="medium", session_id=sid, account_id=account_id, actor_name=actor_name, actor_class_family=family, zone_id=zone, escalation_reason=r.escalation_reason, correlated_event_refs={ev.event_key}, what_it_means="Low actor-touch context was correlated with an active mapped session and configured spatial context.", what_it_does_not_prove="This does not prove ownership, damage, duplication, or player-caused failure.", contributes_to_ban_eligibility=false})
            end
        end
    end
    state.daily_counts.low = (state.daily_counts.low or 0) + 1
    if first_append or (((state.config or {}).logging or {}).write_low_importance_raw_events == true) then append_bounded_raw_event(ev) end
    update_current_state_files()
end

continuity_event = function(ev)
    ev.ts = ev.ts or now()
    ev.boot_id = ev.boot_id or state.boot_id
    ev.epoch_id = ev.epoch_id or (state.current_epoch and state.current_epoch.epoch_id or nil)
    ev.what_it_means = ev.what_it_means or "Log continuity state changed or was observed."
    ev.what_it_does_not_prove = ev.what_it_does_not_prove or "Log rotation, backup creation, and truncation are operational context only."
    ev.importance = ev.importance or "medium"
    append_jsonl(runtime_path("runtime/log_continuity_events.jsonl"), ev)
    append_jsonl(runtime_path("runtime/evidence/log_continuity_events.jsonl"), ev)
    append_compact_event(ev)
    append_bounded_raw_event(ev)
end

local function lifecycle_event(ev)
    ev.ts = ev.ts or now()
    ev.boot_id = ev.boot_id or state.boot_id
    ev.epoch_id = ev.epoch_id or (state.current_epoch and state.current_epoch.epoch_id or nil)
    ev.contributes_to_ban_eligibility = false
    ev.what_it_does_not_prove = ev.what_it_does_not_prove or "Lifecycle, restart, crash, network, and log-rotation events do not prove malicious player action by themselves."
    ev.importance = ev.importance or "medium"
    append_jsonl(runtime_path("runtime/server_lifecycle_events.jsonl"), ev)
    append_jsonl(runtime_path("runtime/evidence/lifecycle_events.jsonl"), ev)
    append_compact_event(ev)
    append_bounded_raw_event(ev)
end

local function write_current_epoch()
    if state.current_epoch then write_json(runtime_path("runtime/current_server_epoch.json"), state.current_epoch) end
end

local function close_active_sessions_for_lifecycle(reason, lifecycle_class)
    local affected = {}
    for account_id,sid in pairs(state.active) do
        local s = state.sessions[sid]
        if s then
            s.leave_ts = now()
            s.clean_leave = false
            s.leave_reason = reason
            s.lifecycle_close = true
            s.culpability = lifecycle_class == "unknown_lifecycle_gap" and "unknown_none_assigned" or "none"
            s.log_generation_id_at_leave = state.current_generation_id
            table.insert(s.lifecycle_events_during_session, {ts=now(), lifecycle_class=lifecycle_class, reason=reason})
            save_session_world(s, "leave")
            save_session_world(s, "diff")
            append_jsonl(runtime_path("runtime/evidence/session_events.jsonl"), {ts=now(), type="SESSION_LIFECYCLE_CLOSE", importance="medium", session_id=sid, account_id=account_id, epoch_id=s.epoch_id, leave_reason=reason, lifecycle_class=lifecycle_class})
            if write_session_summary then write_session_summary(s) end
            table.insert(affected, sid)
        end
        state.active[account_id] = nil
    end
    return affected
end

local function start_epoch(reason, lifecycle_class, generation_id)
    if state.current_epoch and not state.current_epoch.end_ts then
        state.current_epoch.end_ts = now()
        state.current_epoch.end_reason = reason
        state.current_epoch.lifecycle_class = lifecycle_class or "unknown_lifecycle_gap"
        state.current_epoch.sessions_closed_by_lifecycle = close_active_sessions_for_lifecycle(reason, state.current_epoch.lifecycle_class)
        if write_epoch_summary then write_epoch_summary(state.current_epoch) end
        append_jsonl(runtime_path("runtime/server_epochs.jsonl"), state.current_epoch)
    end
    state.actor_touch_rollups = {}
    state.daily_event_refs = state.daily_event_refs or {medium={}, high={}, critical={}}
    state.epoch_counter = state.epoch_counter + 1
    state.current_epoch = {
        epoch_id="EPOCH-" .. stamp() .. "-" .. string.format("%04d", state.epoch_counter),
        boot_id=state.boot_id, start_ts=now(), end_ts=nil, start_reason=reason, end_reason=nil,
        lifecycle_class="running", active_log_generation_id=generation_id,
        logs_seen={}, sessions_started=0, sessions_closed_by_lifecycle={},
        crash_or_fatal_seen=false, graceful_shutdown_seen=false, unknown_gap_seen=false,
        notes={"Lifecycle events are operational context by default."},
    }
    write_current_epoch()
    lifecycle_event({event_type="epoch_started", lifecycle_class="restart_or_boot", log_generation_id=generation_id, confidence="medium", evidence_patterns={reason}, what_it_means="A server/logical runtime epoch started.", active_sessions_at_event=0, affected_sessions={}})
end

local function detect_log_rotation_or_truncation(path, previous, current)
    if not previous then return "new_generation", "first_seen" end
    if current.size < (previous.last_offset or 0) then return "log_truncated", "current size is smaller than stored offset" end
    if previous.head_fingerprint and previous.head_fingerprint ~= current.head_fingerprint then return "new_generation", "head fingerprint changed" end
    return nil, nil
end

local function update_log_registry()
    local files, registry, rotations, truncations = unique_log_paths(cached_log_file_paths()), {}, 0, 0
    for _,path in ipairs(files) do
        local key = log_file_key(path)
        local fp = log_file_fingerprint(path)
        local prev = state.log_registry[key]
        local event_type, reason = detect_log_rotation_or_truncation(path, prev, {size=fp.size, head_fingerprint=fp.head_fingerprint})
        local generation_id = prev and prev.generation_id or ("LOGGEN-" .. simple_hash(key .. fp.head_fingerprint .. str(fp.first_timestamp)))
        if event_type == "new_generation" or event_type == "log_truncated" then
            generation_id = "LOGGEN-" .. simple_hash(key .. fp.head_fingerprint .. str(fp.size) .. now())
            if event_type == "log_truncated" then truncations = truncations + 1 else rotations = rotations + 1 end
            continuity_event({type=event_type, path=path, old_generation_id=prev and prev.generation_id or nil, new_generation_id=generation_id, old_offset=prev and prev.last_offset or 0, new_offset=0, size=fp.size, reason=reason, confidence="medium"})
            local active = is_active_log(path)
            if event_type == "new_generation" and active and not state.initializing_logs then start_epoch(reason, "restart_or_boot", generation_id) end
        end
        local active = is_active_log(path)
        if active then state.current_generation_id = generation_id end
        registry[key] = {
            boot_id=state.boot_id, epoch_id=state.current_epoch and state.current_epoch.epoch_id or nil,
            path=path, normalized_path=normalize_path(path), relpath=state.saved_root and relpath(state.saved_root, path) or path,
            file_key=key, size=fp.size, mtime=nil, first_seen_ts=prev and prev.first_seen_ts or now(), last_seen_ts=now(),
            last_offset=prev and prev.last_offset or 0, last_line_hash=fp.last_line_hash,
            head_fingerprint=fp.head_fingerprint, tail_fingerprint=fp.tail_fingerprint,
            generation_id=generation_id, active=active, backup=not active, rotated_from=nil, rotation_reason=reason,
        }
    end
    state.log_registry = registry
    write_json(runtime_path("runtime/log_registry.json"), registry)
    if not state.current_epoch and state.current_generation_id and not state.initializing_logs then start_epoch("initial_log_registry", "restart_or_boot", state.current_generation_id) end
    return files, rotations, truncations
end

local function write_poll_status(extra)
    local active_count = 0
    for _ in pairs(state.active) do active_count = active_count + 1 end
    local active_logs, backup_logs = {}, {}
    local files = {}
    local seen = {}
    for _,entry in pairs(state.log_registry or {}) do
        local p = entry.path
        local key = p and canonical_log_key(p) or ""
        if p and key ~= "" and not seen[key] then
            seen[key] = true
            table.insert(files, p)
            if entry.active or is_active_log(p) then table.insert(active_logs, p) else table.insert(backup_logs, p) end
        end
    end
    for _,p in pairs(state.cached_log_files or {}) do
        local key = p and canonical_log_key(p) or ""
        if p and key ~= "" and not seen[key] then
            seen[key] = true
            table.insert(files, p)
            if is_active_log(p) then table.insert(active_logs, p) else table.insert(backup_logs, p) end
        end
    end
    files = unique_log_paths(files)
    active_logs = unique_log_paths(active_logs)
    backup_logs = unique_log_paths(backup_logs)
    local job = state.scan_job or {}
    local data = {boot_id=state.boot_id, epoch_id=state.current_epoch and state.current_epoch.epoch_id or nil, poll_id=state.poll_id, ts=now(), last_poll_ts=state.last_poll_ts, last_poll_completed_ts=state.last_poll_completed_ts, poll_completed_count=state.poll_completed_count or 0, scheduler_status=state.scheduler_status, loop_available=state.loop_available, poll_scheduled=state.poll_scheduled, poll_in_flight=state.poll_in_flight, skipped_poll_count=state.skipped_poll_count or 0, poll_stage=state.poll_stage, log_backlog_pending=state.log_backlog_pending or false, active_log_caught_up=state.active_log_caught_up == true, active_log_unread_bytes=state.active_log_unread_bytes or 0, active_log_size=state.active_log_size or 0, active_log_offset=state.active_log_offset or 0, active_log_key=state.active_log_key or "", active_log_unique_count=state.active_log_unique_count or #active_logs, active_log_duplicate_count=state.active_log_duplicate_count or 0, tail_files_seen=state.tail_files_seen or #files, tail_files_unique=state.tail_files_unique or #files, active_log_read_failed=state.active_log_read_failed == true, log_backlog_reason=state.log_backlog_reason or "not_checked", lines_processed_this_poll=0, bytes_processed_this_poll=0, budget_exhausted=false, current_log_file=nil, log_files_found=#files, log_files=files, active_log_files=active_logs, backup_log_files=backup_logs, current_generation_id=state.current_generation_id, rotations_detected=0, truncations_detected=0, duplicate_lines_suppressed=0, events_seen=0, events_applied=0, active_sessions=active_count, scan_due=false, report_due=false, cleanup_due=false, weekly_summary_due=false, scan_job_active=job.active == true, scan_generation_id=job.scan_generation_id, scan_phase=job.phase, scan_reason=job.reason, scan_files_done=job.files_done or 0, scan_total_files=job.total_files or 0, scan_entries_seen=job.entries_seen or 0, scan_budget_exhausted=job.budget_exhausted == true, errors={}, error=nil}
    if extra then for k,v in pairs(extra) do data[k] = v end end
    write_json(runtime_path("runtime/poll_status.json"), data)
    write_json(runtime_path("runtime/current/poll_status.json"), data)
end

local function initialize_log_tail()
    local ok, err = pcall(function()
        state.initializing_logs = true
        local offsets = read_offsets()
        refresh_log_file_cache()
        local files = cached_log_file_paths()
        update_log_registry()
        local new_boot = previous_boot_id() ~= state.boot_id
        local cfg = state.config.log_tail or {}
        for _,path in ipairs(files) do
            local key = canonical_log_key(path)
            local size = file_size(path)
            local active = is_active_log(path)
            local should_eof = (cfg.start_at_end_on_first_run ~= false) and ((active and cfg.backfill_active_log_on_boot ~= true) or ((not active) and cfg.backfill_backup_logs_on_start ~= true))
            if offsets[key] == nil or (new_boot and should_eof) then offsets[key] = should_eof and size or 0
            elseif size < offsets[key] then offsets[key] = 0 end
        end
        write_offsets(offsets)
        if #files > 0 then
            state.log_tail_status = "initialized"
            log_event({event="LOG_TAIL_INITIALIZED", files=files, start_at_end_on_first_run=((state.config.log_tail or {}).start_at_end_on_first_run) ~= false})
        else
            state.log_tail_status = "no_log_files_found"
        end
        write_poll_status({events_seen=0, events_applied=0})
        log_event({event="POLL_HEARTBEAT", phase="startup"})
        state.initializing_logs = false
    end)
    state.initializing_logs = false
    if not ok then state.log_tail_status = "error"; write_poll_status({error=str(err)}) end
    return state.log_tail_status
end

local function account_default(id)
    return {account_id=id, id=id, ban_id=clean_ban_id(id), name=id, log_name="", connect_id_raw="", raw_id="", unique_id="", identity_source="", identity_confidence="unknown", mapping_log_file="", mapping_line_number="", playerdata_file="", playerdata_verified=false, first_seen=now(), last_seen=now(), join_count=0, leave_count=0, warnings={}, score=0, status="INFO", sessions={}, banned=false, threshold_name="", threshold_value=0, observed_value=0, reasons={}}
end

local function get_account(account_id)
    account_id = account_id or "unknown"
    if not state.accounts[account_id] then state.accounts[account_id] = account_default(account_id) end
    local a = state.accounts[account_id]
    a.last_seen = now()
    return a
end

local IDENTITY_STRENGTH = {
    direct_login_request = 100,
    mapped_presence_after_login = 70,
    playerdata_only = 50,
    unmapped_presence_only = 10,
    unknown = 0,
}

local function identity_strength(confidence)
    return IDENTITY_STRENGTH[str(confidence)] or 0
end

local function merge_account_identity(account, ev)
    local old_strength = identity_strength(account.identity_confidence)
    local new_strength = identity_strength(ev.identity_confidence)
    local stronger = new_strength >= old_strength
    account.last_seen = now()
    if ev.name and ev.name ~= "" then account.name = ev.name end
    if ev.log_name and ev.log_name ~= "" then account.log_name = ev.log_name end
    if stronger then
        for _,k in ipairs({"connect_id_raw","raw_id","ban_id","unique_id","identity_source","identity_confidence","mapping_log_file","mapping_line_number"}) do
            if ev[k] ~= nil and ev[k] ~= "" then account[k] = ev[k] end
        end
    end
    if ev.playerdata_verified == true then
        account.playerdata_verified = true
        if ev.playerdata_file and ev.playerdata_file ~= "" then account.playerdata_file = ev.playerdata_file end
    elseif stronger and account.playerdata_verified ~= true and ev.playerdata_file and ev.playerdata_file ~= "" then
        account.playerdata_file = ev.playerdata_file
    end
    return account
end

local function update_identity_from_login(ev)
    if not ev.account_id then return nil end
    local a = merge_account_identity(get_account(ev.account_id), ev)
    if ev.log_name then state.name_to_account[ev.log_name] = a end
    if ev.log_name then state.recent_logins[ev.log_name] = a end
    table.insert(state.recent_logins, {ts=ev.ts, log_name=ev.log_name, account_id=ev.account_id})
    return a
end

local function make_session_id()
    local n = 1
    for _ in pairs(state.sessions) do n = n + 1 end
    return "S-" .. stamp() .. "-" .. string.format("%04d", n)
end

local function session_dir(session)
    return runtime_path("runtime/world_state/sessions/" .. today() .. "/" .. sanitize_filename(session.session_id .. "_" .. session.account_id))
end

local function world_state_payload(session, decision)
    local scan = state.current_scan or {}
    local paths = session and {join=join_path(session_dir(session), "world_state_join.json"), latest=join_path(session_dir(session), "world_state_latest.json"), leave=join_path(session_dir(session), "world_state_leave.json"), diff=join_path(session_dir(session), "world_state_diff.json")} or {}
    local others = {}
    for id,_ in pairs(state.active) do if not session or id ~= session.account_id then table.insert(others, id) end end
    return {
        session_id=session and session.session_id or "boot", account_id=session and session.account_id or nil, ban_id=session and session.ban_id or nil,
        epoch_id=session and session.epoch_id or (state.current_epoch and state.current_epoch.epoch_id or nil),
        log_generation_id_at_join=session and session.log_generation_id_at_join or nil,
        log_generation_id_at_leave=session and session.log_generation_id_at_leave or nil,
        log_name=session and session.log_name or nil, name=session and session.name or nil, connect_id_raw=session and session.connect_id_raw or nil, raw_id=session and session.raw_id or nil, unique_id=session and session.unique_id or nil,
        identity_source=session and session.identity_source or nil, identity_confidence=session and session.identity_confidence or nil, playerdata_verified=session and session.playerdata_verified or false, playerdata_file=session and session.playerdata_file or nil,
        saved_root=state.saved_root, scan_summary={scanned_files=scan.scanned_files or 0, entries=scan.entries and #scan.entries or 0, logs_seen=scan.logs_seen or 0, world_saves_seen=scan.world_saves_seen or 0},
        object_registry_summary={classes=scan.entries and #scan.entries or 0}, join_ts=session and session.join_ts or nil, leave_ts=session and session.leave_ts or nil,
        clean_leave=session and session.clean_leave or false, leave_reason=session and session.leave_reason or nil, lifecycle_close=session and session.lifecycle_close or false, culpability=session and session.culpability or "none", reconnect_after_lifecycle=session and session.reconnect_after_lifecycle or false, reconnect_grace_context=session and session.reconnect_grace_context or "", lifecycle_events_during_session=session and session.lifecycle_events_during_session or {}, warnings=session and session.warnings or {}, server_events=session and session.server_events or {},
        other_active_players=others, world_state_paths=paths, decision_state=decision or (session and session.status) or "INFO",
    }
end

save_session_world = function(session, kind)
    local dir = session_dir(session)
    mkdir_p(dir)
    local file = kind == "join" and "world_state_join.json" or kind == "leave" and "world_state_leave.json" or kind == "diff" and "world_state_diff.json" or "world_state_latest.json"
    write_json(join_path(dir, file), world_state_payload(session, session.status or "INFO"))
    if kind ~= "diff" then write_json(join_path(dir, "world_state_latest.json"), world_state_payload(session, session.status or "INFO")) end
end

local function session_rollups(session)
    local rows = {}
    for _,r in pairs(session.actor_touch_rollup or {}) do table.insert(rows, r) end
    table.sort(rows, function(a,b) return str(a.actor_name) < str(b.actor_name) end)
    return rows
end

local function zone_keys(zones)
    local out = {}
    for z,_ in pairs(zones or {}) do table.insert(out, z) end
    table.sort(out)
    return out
end

write_session_summary = function(session)
    if not runtime_ready() then return nil end
    if not session or not session.session_id then return nil end
    local date = str(session.join_ts or session.leave_ts or now()):sub(1, 10)
    if not date:match("^%d%d%d%d%-%d%d%-%d%d$") then date = today() end
    local folder = runtime_path("runtime/sessions/" .. date)
    mkdir_p(folder)
    local rollups = session_rollups(session)
    local payload = {
        session_id=session.session_id, account_id=session.account_id, ban_id=session.ban_id, name=session.name,
        boot_id=state.boot_id, epoch_id=session.epoch_id, join_ts=session.join_ts, leave_ts=session.leave_ts,
        leave_reason=session.leave_reason, clean_leave=session.clean_leave, lifecycle_close=session.lifecycle_close,
        culpability=session.culpability, reconnect_after_lifecycle=session.reconnect_after_lifecycle,
        actor_touch_rollup=rollups, zones_seen=zone_keys(session.zones_seen),
        spatial_context_flags={world_actor_save_touch_rollups=#rollups, low_importance_context_only=true},
        low_event_counts={world_actor_save_touch=#rollups}, medium_event_refs=state.daily_event_refs.medium,
        high_event_refs=state.daily_event_refs.high, critical_event_refs=state.daily_event_refs.critical,
        ban_decision=session.status or "INFO", enforcement_result="none",
        limitations="Saved-folder/log-derived evidence only. Actor save-touch rollups do not prove ownership, coordinates, damage, container use, duplication, or player-caused failure.",
    }
    local path = join_path(folder, "session_" .. sanitize_filename(session.session_id) .. "_summary.json")
    write_json(path, payload)
    local day_dir = day_folder(date)
    append_file(join_path(day_dir, "sessions.tsv"), table.concat({date, session.session_id, session.account_id or "", session.epoch_id or "", session.join_ts or "", session.leave_ts or "", session.leave_reason or "", tostring(session.lifecycle_close)}, "\t") .. "\n")
    for _,r in ipairs(rollups) do
        append_file(join_path(day_dir, "actor_touches.tsv"), table.concat({date, r.session_id or "", r.account_id or "", r.actor_name or "", r.actor_class_family or "", r.zone_id or "", r.count or 0, r.first_seen_ts or "", r.last_seen_ts or "", r.coordinate_source or "", r.coordinate_confidence or "", r.importance or "low", tostring(r.escalated), r.escalation_reason or ""}, "\t") .. "\n")
    end
    return path
end

write_epoch_summary = function(epoch)
    if not runtime_ready() then return nil end
    if not epoch then return nil end
    local date = str(epoch.start_ts or now()):sub(1, 10)
    if not date:match("^%d%d%d%d%-%d%d%-%d%d$") then date = today() end
    local folder = runtime_path("runtime/epochs/" .. date)
    mkdir_p(folder)
    local rollups, zones = {}, {}
    for _,r in pairs(state.actor_touch_rollups or {}) do table.insert(rollups, r); zones[r.zone_id or "unknown_zone"] = true end
    local payload = {
        epoch_id=epoch.epoch_id, boot_id=epoch.boot_id, start_ts=epoch.start_ts, end_ts=epoch.end_ts,
        lifecycle_class=epoch.lifecycle_class, sessions=epoch.sessions_closed_by_lifecycle or {},
        actor_touch_rollups=rollups, zones_seen=zone_keys(zones),
        medium_event_count=state.daily_counts.medium or 0, high_event_count=state.daily_counts.high or 0,
        critical_event_count=state.daily_counts.critical or 0, log_generations={epoch.active_log_generation_id},
        restart_crash_markers={crash_or_fatal_seen=epoch.crash_or_fatal_seen, graceful_shutdown_seen=epoch.graceful_shutdown_seen},
        limitations="Lifecycle and actor save-touch context are not ban evidence by themselves.",
    }
    local path = join_path(folder, "epoch_" .. sanitize_filename(epoch.epoch_id) .. "_summary.json")
    write_json(path, payload)
    return path
end

local function write_world_boot()
    write_json(runtime_path("runtime/world_state/boot/world_state_boot_" .. state.boot_id .. ".json"), world_state_payload(nil, "INFO"))
    write_json(runtime_path("runtime/world_state/current/world_state_latest.json"), world_state_payload(nil, "INFO"))
end

local function add_warning(account_id, warning, session_id, detail, score)
    local a = get_account(account_id)
    a.warnings[warning] = (a.warnings[warning] or 0) + 1
    a.score = (a.score or 0) + (score or 0)
    if a.score >= (((state.config or {}).enforcement or {}).review_score or 80) then a.status = "REVIEW" end
    append_jsonl(runtime_path("runtime/warning_events.jsonl"), {ts=now(), account_id=account_id, warning=warning, session_id=session_id, detail=detail, score=score or 0, contributes_to_ban_eligibility=score and score > 0 or false})
end

local function start_session(ev)
    local a = ev.account_id and get_account(ev.account_id) or get_account("unmapped_name:" .. sanitize_filename(ev.name or "unknown"))
    merge_account_identity(a, ev)
    a.join_count = (a.join_count or 0) + 1
    local sid = make_session_id()
    local reconnect = state.current_epoch and state.current_epoch.lifecycle_class ~= "running"
    local s = {session_id=sid, epoch_id=state.current_epoch and state.current_epoch.epoch_id or nil, log_generation_id_at_join=state.current_generation_id, log_generation_id_at_leave=nil, account_id=a.account_id, ban_id=a.ban_id, log_name=a.log_name, name=a.name, connect_id_raw=a.connect_id_raw, raw_id=a.raw_id, unique_id=a.unique_id, identity_source=a.identity_source, identity_confidence=a.identity_confidence, playerdata_verified=a.playerdata_verified, playerdata_file=a.playerdata_file, join_ts=ev.ts or now(), clean_leave=false, leave_reason="", lifecycle_close=false, culpability="none", reconnect_after_lifecycle=reconnect, reconnect_grace_context=reconnect and "post_lifecycle_reconnect_context_only" or "", warnings={}, server_events={}, lifecycle_events_during_session={}, status="INFO"}
    state.sessions[sid] = s
    state.active[a.account_id] = sid
    table.insert(a.sessions, sid)
    append_file(runtime_path("runtime/session_events.tsv"), table.concat({now(),"JOIN",sid,a.account_id,a.ban_id or "",a.log_name or "",a.name or "",a.identity_confidence or ""}, "\t") .. "\n")
    append_jsonl(runtime_path("runtime/evidence/session_events.jsonl"), {ts=now(), type="SESSION_JOIN", importance="medium", session_id=sid, account_id=a.account_id, epoch_id=s.epoch_id})
    save_session_world(s, "join")
end

local function end_session(ev)
    local account_id = ev.account_id
    if not account_id and ev.name and state.name_to_account[ev.name] then account_id = state.name_to_account[ev.name].account_id end
    local sid = account_id and state.active[account_id] or nil
    if not sid then return end
    local s = state.sessions[sid]
    local a = get_account(account_id)
    a.leave_count = (a.leave_count or 0) + 1
    if s then
        s.leave_ts, s.clean_leave, s.leave_reason = ev.ts or now(), ev.clean_leave ~= false, ev.leave_reason or "normal_leave"
        s.log_generation_id_at_leave = state.current_generation_id
        s.lifecycle_close = ev.lifecycle_close == true
        s.culpability = ev.culpability or s.culpability or "none"
        state.active[account_id] = nil
        append_file(runtime_path("runtime/session_events.tsv"), table.concat({now(),"LEAVE",sid,account_id,a.ban_id or "",a.log_name or "",a.name or "",s.leave_reason or ""}, "\t") .. "\n")
        append_jsonl(runtime_path("runtime/evidence/session_events.jsonl"), {ts=now(), type="SESSION_LEAVE", importance="medium", session_id=sid, account_id=account_id, epoch_id=s.epoch_id, leave_reason=s.leave_reason})
        save_session_world(s, "leave")
        save_session_world(s, "diff")
        if write_session_summary then write_session_summary(s) end
    end
end

local function correlate_active(warning, score)
    for id,sid in pairs(state.active) do
        local s = state.sessions[sid]
        if s then table.insert(s.warnings, {ts=now(), warning=warning}); save_session_world(s, "latest") end
        add_warning(id, warning, sid, "active during log-observable event", score)
    end
end

local function create_raid_case(reason)
    local ids = {}
    for id,_ in pairs(state.active) do table.insert(ids, id) end
    if #ids < tonumber(((state.config.raid_detection or {}).create_case_min_accounts) or 2) then return end
    state.raid_counter = state.raid_counter + 1
    table.sort(ids)
    local case_id = "RAID-" .. stamp() .. "-" .. string.format("%04d", state.raid_counter)
    local case = {case_id=case_id, ts=now(), reason=reason, accounts=ids, auto_ban_all_accounts=false, note="Review context only; account-specific evidence is required for enforcement."}
    write_json(runtime_path("runtime/raid_cases/" .. case_id .. ".json"), case)
    append_jsonl(runtime_path("runtime/raid_cases/index.jsonl"), case)
end

local function write_account_outputs()
    local rows, json_accounts = {}, {}
    for id,a in pairs(state.accounts) do
        table.insert(rows, {ts=now(), account_id=id, ban_id=a.ban_id, log_name=a.log_name, name=a.name, connect_id_raw=a.connect_id_raw, raw_id=a.raw_id, unique_id=a.unique_id, identity_source=a.identity_source, identity_confidence=a.identity_confidence, playerdata_verified=tostring(a.playerdata_verified), playerdata_file=a.playerdata_file, first_seen=a.first_seen, last_seen=a.last_seen, status=a.status, score=a.score})
        json_accounts[id] = a
    end
    table.sort(rows, function(a,b) return a.account_id < b.account_id end)
    write_tsv(runtime_path("runtime/account_evidence.tsv"), {"ts","account_id","ban_id","log_name","name","connect_id_raw","raw_id","unique_id","identity_source","identity_confidence","playerdata_verified","playerdata_file","first_seen","last_seen","status","score"}, rows)
    write_json(runtime_path("runtime/account_evidence.json"), {ts=now(), accounts=json_accounts})
end

local function write_ban_queue()
    local queued = {}
    for id,a in pairs(state.accounts) do
        if a.status == "BAN-ELIGIBLE" then
            table.insert(queued, {
                account_id=id, ban_id=a.ban_id, log_name=a.log_name, name=a.name,
                connect_id_raw=a.connect_id_raw, raw_id=a.raw_id, unique_id=a.unique_id,
                identity_source=a.identity_source, identity_confidence=a.identity_confidence,
                playerdata_verified=a.playerdata_verified, playerdata_file=a.playerdata_file,
                status=a.status, threshold_name=a.threshold_name, threshold_value=a.threshold_value,
                observed_value=a.observed_value, reasons=a.reasons,
                report_paths={"runtime/warnings/warning_<period>.txt"}, world_state_paths={sessions=a.sessions},
            })
        end
    end
    write_json(runtime_path("runtime/ban_queue.json"), {ts=now(), auto_ban=((state.config.enforcement or {}).auto_ban == true), review_only_mode=((state.config.enforcement or {}).review_only_mode ~= false), queued=queued})
end

local warning_text = {
    DEPLOYABLE_WARNING_BURST_CORRELATION = "The account was active during DeployableSaveWarning activity. It does not prove ownership, damage, container use, duplication, or coordinates.",
    ACTOR_CHANNEL_FAILURE_CORRELATION = "The account was active during ActorChannelFailure activity. It does not prove that account caused the failure.",
    SPATIAL_CONTEXT_ESCALATED = "A world actor save-touch was correlated with mapped session context. It does not prove object ownership.",
    ACTIVE_BEFORE_SERVER_FAILURE = "The account was active before a server failure window. A single crash is not enough for enforcement.",
}

local function current_report_path()
    local days = tonumber(((state.config.warning_report or {}).rotation_days)) or 7
    local t = os.time(os.date("!*t"))
    local day = math.floor(t / 86400)
    local start_day = day - (day % days)
    local start = os.date("!%Y-%m-%d", start_day * 86400)
    local ending = os.date("!%Y-%m-%d", (start_day + days) * 86400)
    return runtime_path("runtime/warnings/warning_" .. start .. "_to_" .. ending .. ".txt"), start, ending
end

local function rebuild_warning_report(force)
    local has_session = next(state.sessions) ~= nil
    if not force and not has_session and ((state.config.warning_report or {}).create_empty_warning_files ~= true) then return end
    local path, startp, endp = current_report_path()
    local out = {"RandomDayGuard Warning Report", "Period: " .. startp .. " to " .. endp .. " UTC", "Generated: " .. now(), "Evidence model: Saved-folder and log-derived evidence only.", ""}
    table.insert(out, "Server lifecycle context")
    table.insert(out, "- Lifecycle events are operational context. They do not prove malicious player action, do not contribute to ban eligibility by default, and do not create Admin.ini reasons by themselves.")
    if state.current_epoch then
        table.insert(out, "- Current epoch: " .. str(state.current_epoch.epoch_id) .. " start_reason=" .. str(state.current_epoch.start_reason) .. " class=" .. str(state.current_epoch.lifecycle_class))
    end
    table.insert(out, "")
    local ids = {}
    for id,_ in pairs(state.accounts) do table.insert(ids, id) end
    table.sort(ids)
    for _,id in ipairs(ids) do
        local a = state.accounts[id]
        table.insert(out, string.rep("=", 64))
        table.insert(out, "Player name: " .. str(a.name))
        table.insert(out, "Clean ban ID/account ID: " .. str(a.ban_id or a.account_id))
        table.insert(out, "Raw ConnectID/raw_id: " .. str(a.raw_id))
        table.insert(out, "UniqueId: " .. str(a.unique_id))
        table.insert(out, "Identity source/confidence: " .. str(a.identity_source) .. " / " .. str(a.identity_confidence))
        table.insert(out, "PlayerData verification: " .. tostring(a.playerdata_verified) .. " " .. str(a.playerdata_file))
        table.insert(out, "Status: " .. str(a.status))
        table.insert(out, "First seen: " .. str(a.first_seen))
        table.insert(out, "Last seen: " .. str(a.last_seen))
        table.insert(out, "Threshold status: score=" .. str(a.score))
        local decision = "INFO"
        if a.status == "BAN-ELIGIBLE" and ((state.config.enforcement or {}).review_only_mode ~= false) then decision = "queued/review-only" elseif a.status == "AUTO-BANNED" then decision = "auto-banned" elseif a.status == "REVIEW" then decision = "review" end
        table.insert(out, "Ban decision: " .. decision)
        table.insert(out, "Relevant raid cases: see runtime/raid_cases")
        table.insert(out, "Warning totals:")
        local any = false
        for w,c in pairs(a.warnings or {}) do any = true; table.insert(out, "- " .. w .. ": " .. str(c)) end
        if not any then table.insert(out, "- none") end
        table.insert(out, "Warning explanations:")
        for w,c in pairs(a.warnings or {}) do table.insert(out, "- " .. w .. ": what happened: " .. (warning_text[w] or "Configured warning context.") .. " configured threshold: see config.lua; current count: " .. str(c) .. "; contributes to ban eligibility: true when account-specific thresholds are met.") end
        table.insert(out, "Sessions:")
        for _,sid in ipairs(a.sessions or {}) do
            local s = state.sessions[sid]
            if s then
                table.insert(out, "- Session ID: " .. sid)
                table.insert(out, "  Join time: " .. str(s.join_ts))
                table.insert(out, "  Leave time: " .. str(s.leave_ts or "open"))
                table.insert(out, "  Clean leave status: " .. tostring(s.clean_leave) .. " " .. str(s.leave_reason))
                table.insert(out, "  Other active players: see world-state latest")
                table.insert(out, "  Warnings during session: " .. str(#(s.warnings or {})))
                table.insert(out, "  Server events during session: " .. str(#(s.server_events or {})))
                table.insert(out, "  Session world-state file paths: " .. session_dir(s))
                table.insert(out, "  Identity mapping details: " .. str(s.identity_source) .. " / " .. str(s.identity_confidence))
            end
        end
        table.insert(out, "")
    end
    write_file(path, table.concat(out, "\n") .. "\n")
end

local function iso_week_folder()
    local yday = tonumber(os.date("!%j")) or 1
    local week = math.floor((yday - 1) / 7) + 1
    return os.date("!%Y") .. "-W" .. string.format("%02d", week)
end

rotate_if_needed = function(path, max_bytes)
    max_bytes = tonumber(max_bytes) or 5242880
    if file_size(path) <= max_bytes then return false end
    local archive = path .. "." .. stamp() .. ".old"
    local data = read_file(path)
    if data then write_file(archive, data); write_file(path, "") end
    return true
end

local function bounded_recent_event_keys_add(key)
    state.recent_event_keys[key] = true
    local max_keys = tonumber((((state.config or {}).retention or {}).max_recent_event_keys)) or 5000
    local n = 0
    for _ in pairs(state.recent_event_keys) do n = n + 1 end
    if n > max_keys then state.recent_event_keys = {[key]=true} end
end

write_daily_summary = function(reason)
    if not runtime_ready() then return nil end
    local folder, day = day_folder(now())
    local session_count, account_count, rollup_count = 0, 0, 0
    local zones = {}
    for _ in pairs(state.sessions or {}) do session_count = session_count + 1 end
    for _ in pairs(state.accounts or {}) do account_count = account_count + 1 end
    for _,r in pairs(state.actor_touch_rollups or {}) do rollup_count = rollup_count + 1; zones[r.zone_id or "unknown_zone"] = true end
    local summary = {
        generated_ts=now(), reason=reason or "scheduled", day_start=day .. "T00:00:00Z", day_end=day .. "T23:59:59Z",
        server_epochs=state.epoch_counter, restarts=0, crashes=state.current_epoch and state.current_epoch.crash_or_fatal_seen and 1 or 0,
        sessions=session_count, unique_accounts=account_count, actor_touch_totals=rollup_count, zones_seen=zone_keys(zones),
        spatial_context_flags={world_actor_save_touch_is_low_importance=true, rollups_only=true},
        medium_events=state.daily_counts.medium or 0, high_events=state.daily_counts.high or 0, critical_events=state.daily_counts.critical or 0,
        ban_decisions={review_only=((state.config.enforcement or {}).review_only_mode ~= false)}, admin_ini_changes=0,
        limitations="Daily actor touch files contain rollups only, not raw line dumps. Saved-folder/log-derived evidence cannot prove ownership, coordinates, damage, container use, duplication, or player-caused crashes.",
    }
    write_json(join_path(folder, "summary.json"), summary)
    write_file(join_path(folder, "summary.txt"), "RandomDayGuard daily summary\nDay: " .. day .. "\nSessions: " .. session_count .. "\nAccounts: " .. account_count .. "\nActor touch rollups: " .. rollup_count .. "\nLifecycle/spatial context is not ban evidence by itself.\n")
    write_tsv(join_path(folder, "accounts.tsv"), {"account_id","ban_id","name","status","score"}, {})
    write_tsv(join_path(folder, "spatial_context.tsv"), {"date","zones_seen","rollups","low_importance_context_only"}, {{date=day, zones_seen=table.concat(summary.zones_seen, ","), rollups=rollup_count, low_importance_context_only="true"}})
    write_tsv(join_path(folder, "medium_events.tsv"), {"ts","type","path","event_key"}, state.daily_event_refs.medium or {})
    write_tsv(join_path(folder, "high_events.tsv"), {"ts","type","path","event_key"}, state.daily_event_refs.high or {})
    write_tsv(join_path(folder, "critical_events.tsv"), {"ts","type","path","event_key"}, state.daily_event_refs.critical or {})
    write_tsv(join_path(folder, "lifecycle.tsv"), {"ts","event_type","class","epoch_id"}, {})
    write_tsv(join_path(folder, "bans.tsv"), {"ts","account_id","ban_id","status"}, {})
    write_json(join_path(folder, "evidence_index.json"), {summary="summary.json", actor_touches="actor_touches.tsv", sessions="sessions.tsv", medium_events="medium_events.tsv", high_events="high_events.tsv", critical_events="critical_events.tsv"})
    return folder
end

local function generate_weekly_summary(reason)
    local folder = runtime_path("runtime/weeks/" .. iso_week_folder())
    mkdir_p(folder)
    local account_count, session_count, ban_eligible, auto_banned = 0, 0, 0, 0
    local account_rows, session_rows, warning_rows, lifecycle_rows, ban_rows = {}, {}, {}, {}, {}
    for id,a in pairs(state.accounts) do
        account_count = account_count + 1
        if a.status == "BAN-ELIGIBLE" then ban_eligible = ban_eligible + 1 end
        if a.status == "AUTO-BANNED" then auto_banned = auto_banned + 1 end
        table.insert(account_rows, {account_id=id, ban_id=a.ban_id, name=a.name, confidence=a.identity_confidence, status=a.status, score=a.score})
    end
    for sid,s in pairs(state.sessions) do
        session_count = session_count + 1
        table.insert(session_rows, {session_id=sid, account_id=s.account_id, epoch_id=s.epoch_id, join_ts=s.join_ts, leave_ts=s.leave_ts, leave_reason=s.leave_reason, lifecycle_close=tostring(s.lifecycle_close)})
    end
    local summary = {
        generated_ts=now(), reason=reason or "scheduled", week=iso_week_folder(),
        week_start="", week_end="", server_epochs=state.epoch_counter,
        restart_count=0, crash_or_fatal_count=state.current_epoch and state.current_epoch.crash_or_fatal_seen and 1 or 0,
        log_rotation_count=0, unique_mapped_accounts=account_count, sessions=session_count,
        clean_leaves=0, lifecycle_closed_sessions=0, timeouts=0, network_failures=0,
        warning_totals={}, ban_eligible_accounts=ban_eligible, auto_banned_accounts=auto_banned,
        admin_ini_changes=0, trusted_moderator_accounts_protected=0, raid_cases=state.raid_counter,
        evidence_files_included={"raw_events.jsonl","warning_events.jsonl","server_lifecycle_events.jsonl","log_continuity_events.jsonl","server_epochs.jsonl"},
        limitations="Saved-folder/log-derived evidence only; lifecycle context alone is not ban evidence.",
    }
    write_json(join_path(folder, "summary.json"), summary)
    write_file(join_path(folder, "summary.txt"), "RandomDayGuard weekly summary\nWeek: " .. summary.week .. "\nMapped accounts: " .. account_count .. "\nSessions: " .. session_count .. "\nBAN-ELIGIBLE: " .. ban_eligible .. "\nAUTO-BANNED: " .. auto_banned .. "\nLifecycle events are operational context only.\n")
    write_tsv(join_path(folder, "accounts.tsv"), {"account_id","ban_id","name","confidence","status","score"}, account_rows)
    write_tsv(join_path(folder, "sessions.tsv"), {"session_id","account_id","epoch_id","join_ts","leave_ts","leave_reason","lifecycle_close"}, session_rows)
    write_tsv(join_path(folder, "warnings.tsv"), {"ts","account_id","warning","count"}, warning_rows)
    write_tsv(join_path(folder, "lifecycle.tsv"), {"ts","event_type","class","epoch_id"}, lifecycle_rows)
    write_tsv(join_path(folder, "bans.tsv"), {"ts","account_id","ban_id","status"}, ban_rows)
    write_json(join_path(folder, "evidence_index.json"), summary.evidence_files_included)
    return folder
end

local function run_retention_cleanup()
    local cfg = (state.config or {}).retention or {}
    local max_bytes = cfg.rotate_jsonl_when_bytes_exceed or 5242880
    write_daily_summary("retention_check_before_prune")
    generate_weekly_summary("retention_check_before_prune")
    for _,rel in ipairs({"runtime/raw_events.jsonl","runtime/warning_events.jsonl","runtime/log_continuity_events.jsonl","runtime/server_lifecycle_events.jsonl","runtime/server_epochs.jsonl","runtime/enforced_bans.jsonl"}) do
        rotate_if_needed(runtime_path(rel), max_bytes)
    end
    append_jsonl(runtime_path("runtime/logs/current.jsonl"), {ts=now(), event="RETENTION_CLEANUP", detailed_retention_days=cfg.detailed_retention_days or 7, summaries_verified_before_prune=true, preserves_daily_weekly_summaries=true})
end

local function find_admin_ini()
    if not state.saved_root then return nil end
    for _,f in ipairs(cached_saved_file_list()) do if f.relpath == "SaveGames/Server/Admin.ini" then return f.path end end
    local p = join_path(state.saved_root, "SaveGames/Server/Admin.ini")
    return file_readable(p) and p or nil
end

local function parse_bans(text)
    local bans = {}
    for id in str(text):gmatch("BannedPlayer%s*=%s*([%w_+|%-]+)") do
        local clean = clean_ban_id(id)
        if clean then bans[clean] = true end
    end
    return bans
end

local function parse_moderators(text)
    local moderators = {}
    local in_mods = false
    for line in str(text):gmatch("[^\r\n]+") do
        if line:match("^%s*%[") then in_mods = line:match("^%s*%[Moderators%]") ~= nil end
        if in_mods then
            local id = line:match("=%s*([%w_+|%-]+)") or line:match("^%s*([%w_+|%-]+)%s*$")
            local clean = clean_ban_id(id)
            if clean then moderators[clean] = true end
        end
    end
    return moderators
end

local function table_keys(t)
    local keys = {}
    for k,_ in pairs(t or {}) do table.insert(keys, k) end
    table.sort(keys)
    return keys
end

local function write_playerdata_index()
    local files, ids = {}, {}
    if state.saved_root then
        for _,f in ipairs(cached_saved_file_list()) do
            local id = f.path:match("/PlayerData/Player_(%d+)%.sav$")
            if id then table.insert(files, f.path); ids[id] = true end
        end
    end
    write_json(runtime_path("runtime/playerdata_index.json"), {boot_id=state.boot_id, epoch_id=state.current_epoch and state.current_epoch.epoch_id or nil, generated_ts=now(), saved_root=state.saved_root, playerdata_files=files, ids=table_keys(ids)})
end

local function write_admin_state()
    local path = find_admin_ini()
    local text = path and read_file(path) or ""
    local bans = parse_bans(text)
    local moderators = parse_moderators(text)
    local trusted = {}
    for id,_ in pairs(((state.config or {}).whitelist) or {}) do trusted[id] = true end
    for id,_ in pairs((((state.config or {}).enforcement or {}).trusted_ids) or {}) do trusted[id] = true end
    write_json(runtime_path("runtime/admin_state.json"), {boot_id=state.boot_id, epoch_id=state.current_epoch and state.current_epoch.epoch_id or nil, generated_ts=now(), admin_ini_path=path, moderators=table_keys(moderators), banned_players=table_keys(bans), trusted_ids=table_keys(trusted), parse_errors={}})
    state.admin_state = {moderators=moderators, banned_players=bans, trusted_ids=trusted}
    return state.admin_state
end

local function append_ban(account, reason)
    local cfg = state.config or {}
    local enf = cfg.enforcement or {}
    if enf.auto_ban ~= true or enf.review_only_mode ~= false or enf.write_admin_ini ~= true then return false end
    local ban_id = account.ban_id or clean_ban_id(account.raw_id)
    if not ban_id or not is_numeric_id(ban_id) or str(account.account_id):match("^unmapped_name:") then return false end
    local admin_state = state.admin_state or write_admin_state()
    if (cfg.whitelist or {})[ban_id] or (enf.trusted_ids or {})[ban_id] or (admin_state.moderators or {})[ban_id] then return false end
    local admin_path = find_admin_ini()
    if not admin_path then return false end
    local text = read_file(admin_path) or ""
    local bans = parse_bans(text)
    if bans[ban_id] then account.banned = true; return true end
    write_file(runtime_path("runtime/backups/Admin_" .. stamp() .. ".ini"), text)
    if not text:match("%[BannedPlayers%]") then
        if text ~= "" and not text:match("\n$") then text = text .. "\n" end
        text = text .. "[BannedPlayers]\n"
    end
    text = text:gsub("(%[BannedPlayers%][^\r\n]*\r?\n)", "%1BannedPlayer=" .. ban_id .. "\n", 1)
    if not write_file(admin_path, text) then return false end
    local verify = parse_bans(read_file(admin_path) or "")
    if not verify[ban_id] then
        local failure = {ts=now(), status="failed", account_id=account.account_id, ban_id=ban_id, reason=reason, admin_ini_path=admin_path, error="post_write_verification_failed"}
        append_jsonl(runtime_path("runtime/enforced_bans.jsonl"), failure)
        append_jsonl(runtime_path("runtime/evidence/enforced_bans.jsonl"), failure)
        write_json(runtime_path("runtime/evidence/enforcement_failed_" .. stamp() .. ".json"), failure)
        return false
    end
    account.banned, account.status = true, "AUTO-BANNED"
    append_file(runtime_path("runtime/enforced.txt"), now() .. " | BAN | " .. ban_id .. " | Admin.ini updated\n")
    local ban_event = {ts=now(), action="BAN", account_id=account.account_id, ban_id=ban_id, raw_id=account.raw_id, reason=reason, admin_ini_updated=true, importance="critical"}
    append_jsonl(runtime_path("runtime/enforced_bans.jsonl"), ban_event)
    append_jsonl(runtime_path("runtime/evidence/enforced_bans.jsonl"), ban_event)
    write_json(runtime_path("runtime/evidence/" .. stamp() .. "_" .. sanitize_filename(ban_id) .. "_" .. sanitize_filename(reason) .. ".json"), {ts=now(), account=account, reason=reason})
    if ((cfg.amp or {}).enabled ~= false) and (enf.request_restart_after_ban == true or (cfg.amp or {}).request_restart_after_ban ~= false) then
        write_file(runtime_path((cfg.amp or {}).restart_marker_file or "runtime/request_restart.flag"), now() .. "\n")
        write_json(runtime_path((cfg.amp or {}).restart_reason_file or "runtime/restart_reason.json"), {ts=now(), reason="BAN_APPLIED", account_id=account.account_id, ban_id=ban_id})
    end
    return true
end

local function evaluate_enforcement()
    local enf = (state.config or {}).enforcement or {}
    for _,a in pairs(state.accounts) do
        if not a.banned then
            local usable = a.ban_id and is_numeric_id(a.ban_id) and not str(a.account_id):match("^unmapped_name:")
            local review_threshold = enf.review_score or 80
            local ban_threshold = enf.auto_ban_score or 140
            if a.score >= review_threshold and a.status == "INFO" then a.status = "REVIEW" end
            if usable and a.score >= ban_threshold then
                a.status = "BAN-ELIGIBLE"
                a.threshold_name = "account_specific_score"
                a.threshold_value = ban_threshold
                a.observed_value = a.score
                a.reasons = {"Mapped account-specific warning score exceeded threshold.", "Lifecycle/restart/crash context alone is excluded."}
            end
            if usable and a.score >= ban_threshold and enf.auto_ban == true and enf.review_only_mode == false then
                append_ban(a, "ACCOUNT_SPECIFIC_THRESHOLD")
            end
        end
    end
end

local function apply_event(ev)
    if ev.type == "PLAYER_JOIN_STATE" then ev = resolve_presence_event_identity(ev) end
    ev.importance = classify_event(ev)
    append_compact_event(ev)
    append_bounded_raw_event(ev)
    if ev.type == "PLAYER_LOGIN_IDENTITY" then
        update_identity_from_login(ev)
    elseif ev.type == "PLAYER_JOIN_STATE" then
        start_session(ev)
    elseif ev.type == "PLAYER_LEAVE_STATE" then
        end_session(ev)
    elseif ev.type == "NETWORK_DISRUPTION_EVENT" then
        lifecycle_event({event_type="network_disruption", lifecycle_class="network_disruption", raw_line=ev.raw, log_file=ev.mapping_log_file, log_generation_id=state.current_generation_id, active_sessions_at_event=0, affected_sessions={}, confidence="medium", evidence_patterns={ev.leave_reason}, what_it_means="A timeout or network disruption was visible in logs.", contributes_to_ban_eligibility=false})
        if ev.name then end_session(ev) end
    elseif ev.type == "SERVER_LIFECYCLE_EVENT" then
        local active_count = 0
        for _ in pairs(state.active) do active_count = active_count + 1 end
        local affected = {}
        if ev.lifecycle_class == "graceful_shutdown" and ((state.config.server_lifecycle or {}).close_sessions_on_graceful_shutdown ~= false) then
            affected = close_active_sessions_for_lifecycle("server_shutdown", "graceful_shutdown")
        elseif ev.lifecycle_class == "crash_or_fatal" and ((state.config.server_lifecycle or {}).close_sessions_on_crash ~= false) then
            affected = close_active_sessions_for_lifecycle("server_crash_or_fatal", "crash_or_fatal")
        elseif ev.lifecycle_class == "restart_or_boot" then
            start_epoch("log_boot_marker", "restart_or_boot", state.current_generation_id)
        end
        if state.current_epoch then
            if ev.lifecycle_class == "crash_or_fatal" then state.current_epoch.crash_or_fatal_seen = true end
            if ev.lifecycle_class == "graceful_shutdown" then state.current_epoch.graceful_shutdown_seen = true end
            write_current_epoch()
        end
        lifecycle_event({event_type=ev.event_type, lifecycle_class=ev.lifecycle_class, raw_line=ev.raw, log_file=ev.mapping_log_file, log_generation_id=state.current_generation_id, active_sessions_at_event=active_count, affected_sessions=affected, confidence=ev.confidence or "medium", evidence_patterns={ev.event_type}, what_it_means="Server lifecycle event recorded as operational context.", contributes_to_ban_eligibility=false})
    elseif ev.type == "DEPLOYABLE_WARNING_BURST" then
        correlate_active("DEPLOYABLE_WARNING_BURST_CORRELATION", 25); create_raid_case("deployable_warning_burst")
    elseif ev.type == "ACTOR_CHANNEL_FAILURE_BURST" then
        correlate_active("ACTOR_CHANNEL_FAILURE_CORRELATION", 25); create_raid_case("actor_channel_failure_burst")
    elseif ev.type == "WORLD_ACTOR_SAVE_TOUCH" then
        handle_actor_touch(ev)
    elseif ev.type == "SERVERMOVE_TIMESTAMP_EXPIRED" then
        correlate_active("SERVERMOVE_TIMESTAMP_CONTEXT", 0)
    elseif ev.type == "SERVER_FAILURE_EVENT" then
        correlate_active("ACTIVE_BEFORE_SERVER_FAILURE", 35); create_raid_case("server_failure_window")
    end
end

local function tail_logs()
    state.poll_stage = "registry"
    local offsets = read_offsets()
    local files, rotations, truncations = update_log_registry()
    local tail_files_seen = #files
    files = unique_log_paths(files)
    local tail_files_unique = #files
    local tail_duplicate_count = math.max(0, tail_files_seen - tail_files_unique)
    local events, seen, duplicates, bytes_processed, files_processed = {}, 0, 0, 0, 0
    local cfg = state.config.log_tail or {}
    local max_lines = tonumber(cfg.max_lines_per_poll) or 500
    local max_bytes = tonumber(cfg.max_bytes_per_poll) or 262144
    local max_files = tonumber(cfg.max_log_files_per_poll) or 1
    local budget_exhausted, current_file = false, nil
    local active_log_read_failed = false
    state.log_backlog_pending = false
    state.poll_stage = "tail_active_log"
    for _,path in ipairs(files) do
        local active = is_active_log(path)
        if (not active) and cfg.tail_backup_logs ~= true then
            offsets[canonical_log_key(path)] = file_size(path)
        else
        current_file = path
        files_processed = files_processed + 1
        if files_processed > max_files then state.log_backlog_pending = true; budget_exhausted = true; break end
        local size = file_size(path)
        local key = canonical_log_key(path)
        local offset = offsets[key] or ((cfg.start_at_end_on_first_run ~= false) and size or 0)
        if size < offset then
            continuity_event({type="offset_reset", path=path, old_offset=offset, new_offset=0, size=size, reason="size smaller than offset", confidence="high"})
            offset = 0
        end
        if size > offset then
            local f = io.open(path, "rb")
            if f then
                f:seek("set", offset)
                local line_no = 0
                while true do
                    local line = f:read("*l")
                    if not line then break end
                    line_no = line_no + 1
                    seen = seen + 1
                    bytes_processed = bytes_processed + #line + 1
                    if line_no > max_lines or bytes_processed > max_bytes then
                        state.log_backlog_pending = true
                        budget_exhausted = true
                        break
                    end
                    local line_hash = simple_hash(line)
                    local gen = (state.log_registry[log_file_key(path)] or {}).generation_id or state.current_generation_id or "unknown"
                    local tuple = gen .. ":" .. tostring(line_no) .. ":" .. line_hash
                    if state.recent_event_keys[tuple] then
                        duplicates = duplicates + 1
                        continuity_event({type="duplicate_suppressed", path=path, new_generation_id=gen, size=size, reason="same generation line hash already applied", confidence="high"})
                    else
                        bounded_recent_event_keys_add(tuple)
                        for _,ev in ipairs(parse_log_line(line, {file=path, line_number=line_no, generation_id=gen})) do
                            local event_key = str(ev.ts) .. ":" .. str(ev.type) .. ":" .. str(ev.account_id or ev.name or "") .. ":" .. line_hash
                            if state.recent_event_keys[event_key] then
                                duplicates = duplicates + 1
                                continuity_event({type="duplicate_suppressed", path=path, new_generation_id=gen, size=size, reason="cross-file event duplicate", confidence="medium"})
                            else
                                bounded_recent_event_keys_add(event_key)
                                table.insert(events, ev)
                            end
                        end
                    end
                end
                offsets[key] = f:seek() or size
                f:close()
                local reg = state.log_registry[log_file_key(path)]
                if reg then reg.last_offset = offsets[key]; state.log_registry[log_file_key(path)] = reg end
            elseif active then
                active_log_read_failed = true
            end
        end
        end
        if budget_exhausted then break end
    end
    local active_seen, active_log_unread_bytes, active_log_size, active_log_offset, active_log_key = false, 0, 0, 0, ""
    local active_log_unique_count, active_log_duplicate_count = 0, tail_duplicate_count
    for _,path in ipairs(files) do
        if is_active_log(path) then
            active_seen = true
            active_log_unique_count = active_log_unique_count + 1
            local key = canonical_log_key(path)
            local size = file_size(path)
            local offset = offsets[key] or ((cfg.start_at_end_on_first_run ~= false) and size or 0)
            if size < offset then offset = 0 end
            active_log_key = key
            active_log_size = active_log_size + size
            active_log_offset = active_log_offset + offset
            if size > offset then active_log_unread_bytes = active_log_unread_bytes + (size - offset) end
        end
    end
    local active_log_caught_up = active_log_unread_bytes == 0
    local log_backlog_reason = "active_log_caught_up"
    if not active_seen then
        active_log_caught_up = true
        active_log_unread_bytes = 0
        log_backlog_reason = "active_log_unavailable_nonblocking"
    elseif active_log_read_failed then
        log_backlog_reason = "active_log_read_failed"
    elseif budget_exhausted then
        log_backlog_reason = "budget_exhausted"
    elseif not active_log_caught_up then
        log_backlog_reason = "active_log_has_unread_bytes"
    end
    state.active_log_caught_up = active_log_caught_up
    state.active_log_unread_bytes = active_log_unread_bytes
    state.active_log_size = active_log_size
    state.active_log_offset = active_log_offset
    state.active_log_key = active_log_key
    state.active_log_unique_count = active_log_unique_count
    state.active_log_duplicate_count = active_log_duplicate_count
    state.tail_files_seen = tail_files_seen
    state.tail_files_unique = tail_files_unique
    state.active_log_read_failed = active_log_read_failed
    state.log_backlog_reason = log_backlog_reason
    state.log_backlog_pending = active_log_read_failed or (budget_exhausted and active_log_unread_bytes > 0) or active_log_unread_bytes > 0
    if active_log_unread_bytes == 0 and active_log_read_failed ~= true then
        state.log_backlog_pending = false
        log_backlog_reason = "active_log_caught_up"
        state.log_backlog_reason = log_backlog_reason
    end
    write_offsets(offsets)
    write_json(runtime_path("runtime/log_registry.json"), state.log_registry)
    state.poll_stage = "parse_events"
    return events, seen, {duplicates=duplicates, rotations=rotations, truncations=truncations, files=files, bytes_processed=bytes_processed, lines_processed=seen, budget_exhausted=budget_exhausted, log_backlog_pending=state.log_backlog_pending, current_log_file=current_file, active_log_caught_up=active_log_caught_up, active_log_unread_bytes=active_log_unread_bytes, active_log_size=active_log_size, active_log_offset=active_log_offset, active_log_key=active_log_key, active_log_unique_count=active_log_unique_count, active_log_duplicate_count=active_log_duplicate_count, tail_files_seen=tail_files_seen, tail_files_unique=tail_files_unique, active_log_read_failed=active_log_read_failed, log_backlog_reason=log_backlog_reason}
end

local function startup_scan(reason)
    log_event({event="SAVED_SCAN_START", reason=reason or "startup"})
    write_json(runtime_path("runtime/scan_started.json"), {boot_id=state.boot_id, epoch_id=state.current_epoch and state.current_epoch.epoch_id or nil, ts=now(), reason=reason or "startup", root=state.saved_root})
    local scan = scan_saved(reason or "startup")
    local new_classes, deltas = write_scan_outputs(scan)
    write_world_boot()
    log_event({event="SAVED_SCAN_COMPLETE", files=scan.scanned_files, readable_files_seen=scan.readable_files_seen, entries=#scan.entries, new_classes=new_classes, deltas=deltas})
    return scan
end

local function write_startup_status(extra)
    local data = {ts=now(), version=VERSION, mod_root=state.mod_root, boot_id=state.boot_id, saved_root=state.saved_root, saved_root_found=state.saved_root ~= nil, scan_ok=state.current_scan and state.current_scan.scan_ok or false, scanned_files=state.current_scan and state.current_scan.scanned_files or 0, log_tail_status=state.log_tail_status, startup_error=nil, scheduler_status=state.scheduler_status, loop_available=state.loop_available, scan_pending=state.startup_scan_pending == true, scan_complete=state.startup_scan_complete == true, scan_progress_path="runtime/scan_progress.json", last_error=nil}
    if extra then for k,v in pairs(extra) do data[k] = v end end
    write_json(runtime_path("runtime/startup_status.json"), data)
end

local function write_runtime_version()
    local path = runtime_path("runtime/runtime_version.json")
    local previous_version = nil
    local existing = read_file(path, 4096)
    if existing then previous_version = existing:match('"version"%s*:%s*"([^"]+)"') end
    local changed = previous_version ~= nil and previous_version ~= VERSION
    write_json(path, {version=VERSION, boot_id=state.boot_id, started_ts=now(), previous_version=previous_version, old_runtime_archived=false, current_boot_filter={boot_id=state.boot_id, version=VERSION}, ignore_old_boot_ids=true, old_runtime_note=changed and "Previous runtime version differs; current reports filter to this boot/version." or "Runtime version unchanged."})
end

previous_boot_id = function()
    local existing = read_file(runtime_path("runtime/runtime_version.json"), 4096)
    return existing and existing:match('"boot_id"%s*:%s*"([^"]+)"') or nil
end

local function scan_job_payload()
    local job = state.scan_job or {}
    local elapsed = 0
    if job.started_clock then elapsed = math.floor((os.clock() - job.started_clock) * 1000) / 1000 end
    return {
        version=VERSION, boot_id=state.boot_id, epoch_id=state.current_epoch and state.current_epoch.epoch_id or nil, poll_id=state.poll_id,
        scan_generation_id=job.scan_generation_id, reason=job.reason, phase=job.phase or "idle",
        active=job.active == true, complete=job.complete == true, total_files=job.total_files or 0,
        files_done=job.files_done or 0, files_scanned=job.files_scanned or 0,
        readable_files_seen=job.readable_files_seen or 0, entries_seen=job.entries_seen or 0,
        current_file=job.current_file, last_progress_ts=job.last_progress_ts or now(),
        elapsed_seconds=elapsed, budget_exhausted=job.budget_exhausted == true,
        discovery_index=job.discovery_index or 0, discovery_total=job.discovery_total or 0,
        recursive_command_index=job.recursive_command_index or 0, recursive_discovery_lines=job.recursive_discovery_lines or 0,
        errors=job.errors or {},
    }
end

local function scan_job_partial_entries(job)
    local entries = {}
    for name,count in pairs((job and job.counts) or {}) do table.insert(entries, {name=name, count=count, categories=categorize_token(name)}) end
    table.sort(entries, function(a,b) return a.name < b.name end)
    return entries
end

local function write_scan_partial_outputs(job)
    if not job then return end
    local payload = scan_job_payload()
    local entries = scan_job_partial_entries(job)
    payload.scan_complete = false
    payload.entries = #entries
    payload.limitations = {"Partial baseline; full object registry is available after scan_complete.json is written.", "Saved evidence is log/file derived only."}
    write_json(runtime_path("runtime/scan_checkpoint.json"), payload)
    write_json(runtime_path("runtime/object_registry_partial.json"), {version=VERSION, boot_id=state.boot_id, epoch_id=state.current_epoch and state.current_epoch.epoch_id or nil, ts=now(), scan_generation_id=job.scan_generation_id, scan_complete=false, entries=entries, summary={classes=#entries, files_scanned=job.files_scanned or 0, readable_files_seen=job.readable_files_seen or 0}})
    local rows = {}
    for _,e in ipairs(entries) do table.insert(rows, {class=e.name, count=e.count, categories=table.concat(e.categories or {}, ",")}) end
    write_tsv(runtime_path("runtime/object_registry_counts_partial.tsv"), {"class","count","categories"}, rows)
    write_json(runtime_path("runtime/world_state/current/world_state_latest.json"), {version=VERSION, boot_id=state.boot_id, epoch_id=state.current_epoch and state.current_epoch.epoch_id or nil, ts=now(), saved_root=state.saved_root, scan_complete=false, scan_generation_id=job.scan_generation_id, scan_phase=job.phase, files_done=job.files_done or 0, total_files=job.total_files or 0, entries_seen=job.entries_seen or 0, active_players=active_session_ids(), limitations=payload.limitations})
end

local function write_scan_progress()
    write_json(runtime_path("runtime/scan_progress.json"), scan_job_payload())
    write_scan_partial_outputs(state.scan_job)
end

local function fail_scan_job(err)
    local job = state.scan_job or {reason="unknown", errors={}}
    if job.recursive_handle then pcall(function() job.recursive_handle:close() end); job.recursive_handle = nil end
    job.active = false
    job.complete = false
    job.phase = "failed"
    job.last_progress_ts = now()
    table.insert(job.errors, str(err))
    state.scan_job = job
    write_scan_progress()
    write_file(runtime_path("runtime/scan_error.txt"), str(err))
    if job.reason == "startup_deferred" then
        state.startup_scan_pending = false
        state.startup_scan_complete = false
        write_startup_status({phase="scan_failed", scan_pending=false, scan_complete=false, last_error=str(err)})
    end
    state.scan_job = nil
end

local function begin_scan_job(reason)
    if state.scan_job and state.scan_job.active then return state.scan_job end
    local rels = direct_known_file_rels()
    local cfg = (state.config or {}).scanning or {}
    local job = {
        active=true, reason=reason or "periodic_refresh", scan_generation_id=stamp(), started_ts=now(), started_clock=os.clock(),
        last_progress_ts=now(), phase="discover_direct_known", files={}, file_index=1, total_files=0, files_done=0,
        files_scanned=0, readable_files_seen=0, entries_seen=0, logs_seen=0, playerdata_seen=0,
        admin_ini_seen=false, world_saves_seen=0, counts={}, map_paths={}, errors={}, complete=false,
        budget_exhausted=false,
        discovery_rels=rels, discovery_index=1, discovery_total=#rels,
        recursive_enabled=(cfg.allow_full_find_discovery == true and cfg.allow_full_find_discovery_only_in_scan_job ~= false and cfg.recursive_discovery_enabled ~= false),
        recursive_commands=scan_recursive_discovery_commands(state.saved_root or ""),
        recursive_command_index=1, recursive_discovery_lines=0,
        file_seen={},
    }
    state.scan_job = job
    write_scan_progress()
    log_event({event="SAVED_SCAN_START", reason=job.reason, scan_generation_id=job.scan_generation_id})
    write_json(runtime_path("runtime/scan_started.json"), {boot_id=state.boot_id, epoch_id=state.current_epoch and state.current_epoch.epoch_id or nil, ts=now(), reason=job.reason, root=state.saved_root, scan_generation_id=job.scan_generation_id})
    if job.reason == "startup_deferred" then write_startup_status({phase="scan_running", scan_pending=true}) end
    return job
end

local close_scan_recursive_handle

local function finish_scan_job()
    local job = state.scan_job
    if not job then return nil end
    close_scan_recursive_handle(job)
    local scan = {ts=now(), reason=job.reason, root=state.saved_root, scan_ok=true, files=job.files_record or {}, counts=job.counts or {}, entries={}, map_paths=job.map_paths or {}, scanned_files=job.files_scanned or 0, readable_files_seen=job.readable_files_seen or 0, logs_seen=job.logs_seen or 0, playerdata_seen=job.playerdata_seen or 0, admin_ini_seen=job.admin_ini_seen or false, world_saves_seen=job.world_saves_seen or 0, errors=job.errors or {}, scan_generation_id=job.scan_generation_id}
    for name,count in pairs(scan.counts) do table.insert(scan.entries, {name=name, count=count, categories=categorize_token(name)}) end
    table.sort(scan.entries, function(a,b) return a.name < b.name end)
    job.entries_seen = #scan.entries
    job.phase = "complete"
    job.active = false
    job.complete = true
    job.last_progress_ts = now()
    state.current_scan = scan
    write_scan_progress()
    local new_classes, deltas = write_scan_outputs(scan)
    write_world_boot()
    log_event({event="SAVED_SCAN_COMPLETE", files=scan.scanned_files, readable_files_seen=scan.readable_files_seen, entries=#scan.entries, new_classes=new_classes, deltas=deltas, scan_generation_id=job.scan_generation_id})
    if job.reason == "startup_deferred" then
        state.startup_scan_pending = false
        state.startup_scan_complete = true
        write_startup_status({phase="ready", scan_pending=false, scan_complete=true})
    end
    state.last_full_scan_time = os.time()
    state.scan_job = nil
    return scan
end

close_scan_recursive_handle = function(job)
    if job and job.recursive_handle then
        pcall(function() job.recursive_handle:close() end)
        job.recursive_handle = nil
    end
end

local function open_next_scan_recursive_handle(job)
    close_scan_recursive_handle(job)
    while job.recursive_command_index <= #(job.recursive_commands or {}) do
        local entry = job.recursive_commands[job.recursive_command_index]
        job.recursive_command_index = job.recursive_command_index + 1
        if entry and entry.cmd and io and io.popen then
            local ok, handle = pcall(io.popen, entry.cmd)
            if ok and handle then
                job.recursive_handle = handle
                job.recursive_source = entry.source
                return true
            end
            table.insert(job.errors, "recursive_discovery_open_failed: " .. str(entry.source))
        end
    end
    return false
end

local function continue_scan_recursive_discovery(job, cfg, started_clock)
    local max_lines = tonumber(cfg.discovery_files_per_tick) or 200
    local max_ms = tonumber(cfg.discovery_max_runtime_ms) or 100
    local lines_this_tick = 0
    job.budget_exhausted = false
    if not state.saved_root or job.recursive_enabled ~= true then
        job.phase = "scanning"
        job.file_index = 1
        job.total_files = #job.files
        return true
    end
    while lines_this_tick < max_lines and ((os.clock() - started_clock) * 1000) < max_ms do
        if not job.recursive_handle and not open_next_scan_recursive_handle(job) then
            job.phase = "scanning"
            job.file_index = 1
            job.total_files = #job.files
            job.current_file = nil
            return true
        end
        local line = job.recursive_handle:read("*l")
        if line == nil then
            close_scan_recursive_handle(job)
        else
            lines_this_tick = lines_this_tick + 1
            job.recursive_discovery_lines = (job.recursive_discovery_lines or 0) + 1
            local path = normalize_path(line)
            job.current_file = path
            scan_job_add_file(job, path, job.recursive_source or "scan_job:recursive")
        end
    end
    job.budget_exhausted = job.phase == "discover_recursive"
    return true
end

local function continue_scan_job()
    local job = state.scan_job
    if not job or not job.active then return false end
    state.poll_stage = (job.phase == "discover_direct_known" or job.phase == "discover_recursive") and "scan_discovery" or "scan_chunk"
    local cfg = (state.config or {}).scanning or {}
    local max_files = tonumber(cfg.startup_scan_files_per_tick) or 25
    local max_bytes = tonumber(cfg.startup_scan_max_bytes_per_tick) or 4194304
    local max_ms = tonumber(cfg.startup_scan_max_runtime_ms) or 100
    local max_file_bytes = tonumber(cfg.max_file_bytes) or 1048576
    local started_clock, files_this_tick, bytes_this_tick = os.clock(), 0, 0
    job.budget_exhausted = false
    job.files_record = job.files_record or {}
    if job.phase == "discover_direct_known" then
        while job.discovery_index <= (job.discovery_total or 0) do
            if files_this_tick >= max_files or ((os.clock() - started_clock) * 1000) >= max_ms then
                job.budget_exhausted = true
                break
            end
            local rel = job.discovery_rels[job.discovery_index]
            job.discovery_index = job.discovery_index + 1
            files_this_tick = files_this_tick + 1
            if state.saved_root and rel then
                local path = normalize_path(join_path(state.saved_root, rel))
                job.current_file = path
                scan_job_add_file(job, path, "direct_known")
            end
        end
        if job.discovery_index > (job.discovery_total or 0) then
            job.phase = job.recursive_enabled and "discover_recursive" or "scanning"
            job.file_index = 1
            job.total_files = #job.files
        end
        job.last_progress_ts = now()
        write_scan_progress()
        return true
    end
    if job.phase == "discover_recursive" then
        continue_scan_recursive_discovery(job, cfg, started_clock)
        job.last_progress_ts = now()
        write_scan_progress()
        return true
    end
    while job.file_index <= (job.total_files or 0) do
        if files_this_tick >= max_files or bytes_this_tick >= max_bytes or ((os.clock() - started_clock) * 1000) >= max_ms then
            job.budget_exhausted = true
            break
        end
        local meta = job.files[job.file_index]
        job.file_index = job.file_index + 1
        job.files_done = job.files_done + 1
        if meta then
            local p = meta.path
            job.current_file = p
            if p:lower():match("/logs/.*%.log") then job.logs_seen = job.logs_seen + 1 end
            if p:match("/PlayerData/Player_[^/]+%.sav$") then job.playerdata_seen = job.playerdata_seen + 1 end
            if meta.relpath == "SaveGames/Server/Admin.ini" then job.admin_ini_seen = true end
            if p:match("/SaveGames/Server/Worlds/.*%.sav$") and not p:match("/PlayerData/") then job.world_saves_seen = job.world_saves_seen + 1 end
            if should_scan_file(meta) then
                local read_limit = math.max(1, math.min(max_file_bytes, max_bytes - bytes_this_tick))
                local data = read_file(p, read_limit)
                if data then
                    bytes_this_tick = bytes_this_tick + #data
                    files_this_tick = files_this_tick + 1
                    job.files_scanned = job.files_scanned + 1
                    table.insert(job.files_record, {path=p, relpath=meta.relpath, size=meta.size, source=meta.source})
                    for token in data:gmatch("[A-Za-z0-9_/%._%-]+") do
                        if token_is_relevant(token) then
                            if job.counts[token] == nil then job.entries_seen = job.entries_seen + 1 end
                            job.counts[token] = (job.counts[token] or 0) + 1
                            if token:find("/Game/Maps/", 1, true) then job.map_paths[token] = true end
                        end
                    end
                else
                    table.insert(job.errors, "read_failed: " .. p)
                end
            end
        end
    end
    job.last_progress_ts = now()
    if job.file_index > (job.total_files or 0) then finish_scan_job() else write_scan_progress() end
    return true
end

local start_poll_loop

local function start()
    if state.started then return end
    state.boot_id = state.boot_id or stamp()
    ensure_dirs()
    write_startup_status({phase="starting"})
    write_runtime_version()
    log_event({event="BOOT_MARKER", version=VERSION})
    state.config = load_config()
    write_startup_status({phase=state.config_load_error and "config_error" or "config_loaded", startup_error=state.config_load_error})
    write_json(runtime_path("runtime/runtime_capabilities.json"), {ts=now(), version=VERSION, mod_root=state.mod_root, io_popen=io and io.popen ~= nil, os_execute=os and os.execute ~= nil, loop_available=state.loop_available, scheduler_status=state.scheduler_status, evidence_model="Saved-folder and log-derived evidence only"})
    state.saved_root = find_saved_root()
    write_startup_status({phase="saved_root_found"})
    initialize_log_tail()
    write_startup_status({phase="log_tail_initialized"})
    if not state.current_epoch then start_epoch("startup", "restart_or_boot", state.current_generation_id or "no_log_generation") end
    write_startup_status({phase="epoch_started"})
    write_admin_state()
    write_startup_status({phase="admin_state_written"})
    write_playerdata_index()
    write_startup_status({phase="playerdata_index_written"})
    write_minimal_current_state(true)
    write_account_outputs()
    write_ban_queue()
    state.startup_scan_pending = true
    state.startup_scan_complete = false
    state.started = true
    start_poll_loop()
    write_startup_status({phase="watchdog_started"})
    write_startup_status({phase="ready_degraded", scan_pending=true})
    log_event({event="RANDOMDAYGUARD_READY_DEGRADED", version=VERSION, scan_pending=true})
end

local function poll_once(reason)
    if not state.started then start() end
    state.poll_id = (state.poll_id or 0) + 1
    state.last_poll_ts = now()
    local poll_started = os.time()
    local ok, events, seen, meta = pcall(function()
        local evs, raw_seen, tail_meta = tail_logs()
        for _,ev in ipairs(evs) do apply_event(ev) end
        if #evs > 0 then state.state_changed = true; write_account_outputs(); evaluate_enforcement(); write_ban_queue() end
        return evs, raw_seen, tail_meta
    end)
    if ok then
        meta = meta or {}
        local cfg = (state.config or {}).runtime or {}
        local now_s = os.time()
        local report_due = state.state_changed or (now_s - (state.last_report_time or 0) >= (cfg.report_refresh_interval_seconds or 30))
        local scan_due = now_s - (state.last_full_scan_time or 0) >= (cfg.full_scan_interval_seconds or 300)
        local cleanup_due = now_s - (state.last_cleanup_time or 0) >= (cfg.cleanup_interval_seconds or 600)
        local weekly_due = now_s - (state.last_weekly_summary_time or 0) >= (cfg.weekly_summary_check_interval_seconds or 3600)
        local heartbeat_due = now_s - (state.last_heartbeat_time or 0) >= (cfg.heartbeat_interval_seconds or 10)
        local report_deferred = false
        if report_due then
            report_deferred = true
            state.last_report_time = now_s
        end
        local deferred_scan_waiting = false
        local deferred_scan_waiting_reason = ""
        local startup_scan_gate = {
            poll_id_ok=state.poll_id > 1,
            prior_poll_completed=(state.poll_completed_count or 0) > 0 and state.last_poll_completed_ts ~= nil,
            poll_in_flight_clear_between_polls=(state.poll_completed_count or 0) > 0 and state.last_poll_completed_ts ~= nil,
            log_backlog_pending=state.log_backlog_pending == true,
            active_log_caught_up=state.active_log_caught_up == true,
            active_log_unread_bytes=state.active_log_unread_bytes or 0,
            active_log_read_failed=state.active_log_read_failed == true,
            reason=state.log_backlog_reason or "not_checked",
        }
        if state.scan_job and state.scan_job.active then
            continue_scan_job()
        elseif state.startup_scan_pending == true then
            local prior_poll_completed = startup_scan_gate.prior_poll_completed
            if state.log_backlog_pending ~= true and state.active_log_caught_up == true and (state.active_log_unread_bytes or 0) == 0 and state.poll_id > 1 and prior_poll_completed then
                state.poll_stage = "scan_discovery"
                begin_scan_job("startup_deferred")
            else
                state.poll_stage = "startup_scan_waiting"
                deferred_scan_waiting = true
                deferred_scan_waiting_reason = "startup scan waits until poll_id > 1, a prior poll completed with poll_in_flight=false, and log backlog is clear"
                write_poll_status({poll_id=state.poll_id, scheduler_status=state.scheduler_status, poll_stage=state.poll_stage, scan_pending=true, deferred_scan_waiting=true, deferred_scan_waiting_reason=deferred_scan_waiting_reason, reason=deferred_scan_waiting_reason, startup_scan_gate=startup_scan_gate})
            end
        elseif scan_due and reason ~= "startup" then
            state.poll_stage = "scan_discovery"
            begin_scan_job("periodic_refresh")
        end
        local cleanup_deferred = false
        local weekly_summary_deferred = false
        if cleanup_due then
            cleanup_deferred = true
            state.last_cleanup_time = now_s
        end
        if weekly_due then
            weekly_summary_deferred = true
            state.last_weekly_summary_time = now_s
        end
        update_current_state_files()
        if not deferred_scan_waiting then state.poll_stage = "complete" end
        write_poll_status({poll_id=state.poll_id, scheduler_status=state.scheduler_status, poll_stage=state.poll_stage, scan_pending=state.startup_scan_pending, deferred_scan_waiting=deferred_scan_waiting, deferred_scan_waiting_reason=deferred_scan_waiting_reason, reason=deferred_scan_waiting_reason, startup_scan_gate=startup_scan_gate, log_backlog_pending=state.log_backlog_pending, active_log_caught_up=meta.active_log_caught_up, active_log_unread_bytes=meta.active_log_unread_bytes, active_log_size=meta.active_log_size, active_log_offset=meta.active_log_offset, active_log_key=meta.active_log_key, active_log_unique_count=meta.active_log_unique_count, active_log_duplicate_count=meta.active_log_duplicate_count, tail_files_seen=meta.tail_files_seen, tail_files_unique=meta.tail_files_unique, active_log_read_failed=meta.active_log_read_failed, log_backlog_reason=meta.log_backlog_reason, lines_processed_this_poll=meta.lines_processed or seen or 0, bytes_processed_this_poll=meta.bytes_processed or 0, budget_exhausted=meta.budget_exhausted or false, current_log_file=meta.current_log_file, events_seen=seen or 0, events_applied=#(events or {}), duplicate_lines_suppressed=meta.duplicates or 0, rotations_detected=meta.rotations or 0, truncations_detected=meta.truncations or 0, scan_due=scan_due, report_due=report_due, report_deferred=report_deferred, cleanup_due=cleanup_due, cleanup_deferred=cleanup_deferred, weekly_summary_due=weekly_due, weekly_summary_deferred=weekly_summary_deferred, poll_runtime_seconds=os.time() - poll_started})
        log_event({event="POLL_HEARTBEAT", events_seen=seen or 0, events_applied=#(events or {})})
        if heartbeat_due then state.last_heartbeat_time = now_s; log_event({event="HEARTBEAT", poll_id=state.poll_id, scheduler_status=state.scheduler_status}) end
        return #(events or {})
    end
    write_poll_status({error=str(events)})
    return 0
end

local function safe_poll_once(reason)
    if state.poll_in_flight then
        state.skipped_poll_count = (state.skipped_poll_count or 0) + 1
        write_poll_status({scheduler_status=state.scheduler_status, skipped_poll_count=state.skipped_poll_count, error="poll already in flight"})
        return 0
    end
    state.poll_in_flight = true
    local ok, result = xpcall(function() return poll_once(reason or "scheduled") end, debug and debug.traceback or function(e) return str(e) end)
    state.poll_in_flight = false
    state.poll_completed_count = (state.poll_completed_count or 0) + 1
    state.last_poll_completed_ts = now()
    if not ok then
        write_poll_status({error=str(result), scheduler_status=state.scheduler_status})
        write_file(runtime_path("runtime/poll_error.txt"), str(result))
        return 0
    end
    return result
end

local function schedule_next_poll()
    if state.poll_scheduled then return true end
    if not LoopAsync then
        state.scheduler_status = "manual_only"
        state.loop_available = false
        write_poll_status({scheduler_status=state.scheduler_status})
        return false
    end
    state.poll_scheduled = true
    local interval = tonumber((((state.config or {}).runtime or {}).poll_interval_ms)) or 1000
    local ok, err = pcall(function()
        LoopAsync(interval, function()
            state.poll_scheduled = false
            safe_poll_once("loop")
            if state.scheduler_status == "running" then
                schedule_next_poll()
            end
            return false
        end)
    end)
    if ok then
        state.scheduler_status = "running"
        state.loop_available = true
        write_poll_status({scheduler_status=state.scheduler_status})
        return true
    end
    state.poll_scheduled = false
    state.scheduler_status = "manual_only"
    state.loop_available = false
    write_poll_status({scheduler_status=state.scheduler_status, error=str(err)})
    return false
end

function start_poll_loop()
    return schedule_next_poll()
end

local function stop_poll_loop()
    state.scheduler_status = "stopped"
    write_poll_status({scheduler_status=state.scheduler_status})
end

local function resolve_mod_root()
    local source = debug and debug.getinfo and debug.getinfo(1, "S") and debug.getinfo(1, "S").source or nil
    if source and source:sub(1,1) == "@" then return normalize_path(join_path(dirname(source:sub(2):gsub("\\", "/")), "..")) end
    return "."
end

local source_path = debug and debug.getinfo and debug.getinfo(1, "S") and debug.getinfo(1, "S").source or nil
state.mod_root = resolve_mod_root()
state.boot_id = stamp()
state.loop_available = LoopAsync ~= nil
_G.RANDOMDAYGUARD_MOD_ROOT = state.mod_root
local loader_probe_written = false
pcall(function() loader_probe_written = write_loader_probe(source_path) end)

local ok, err = xpcall(start, debug and debug.traceback or function(e) return str(e) end)
if not ok then
    ensure_dirs()
    state.log_tail_status = state.log_tail_status == "not_started" and "error" or state.log_tail_status
    write_startup_status({phase="error", startup_error=str(err), traceback=str(err), lua_version=_VERSION, loader_probe_written=loader_probe_written})
    write_file(runtime_path("runtime/startup_error.txt"), str(err))
    write_file(join_path(state.mod_root or ".", "startup_error_root.txt"), str(err))
    append_jsonl(runtime_path("runtime/logs/current.jsonl"), {ts=now(), event="STARTUP_ERROR", error=str(err), loader_probe_written=loader_probe_written})
    print("[RandomDayGuard] startup error: " .. str(err) .. "\n")
end

_G.RandomDayGuard_Poll = function() return safe_poll_once("manual") end
_G.RandomDayGuard_WeeklySummary = function() return generate_weekly_summary("manual") end
