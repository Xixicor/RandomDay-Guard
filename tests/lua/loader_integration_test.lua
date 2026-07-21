local repo_root = assert(arg[1], "repository root argument is required")
local fixture_root = assert(arg[2], "fixture root argument is required")

local function normalize(path)
    return tostring(path or ""):gsub("\\", "/"):gsub("/+", "/"):gsub("/$", "")
end

local function join(a, b)
    return normalize(a) .. "/" .. tostring(b or ""):gsub("\\", "/"):gsub("^/+", "")
end

local function quote(path)
    return '"' .. tostring(path):gsub('"', '') .. '"'
end

local IS_WINDOWS = package and package.config and package.config:sub(1, 1) == "\\"
local CREATED_DIRECTORIES = {}

local function make_directory(path)
    path = normalize(path)
    local cache_key = IS_WINDOWS and path:lower() or path
    if CREATED_DIRECTORIES[cache_key] then return end
    if os and os.execute then
        local shell_path = quote(IS_WINDOWS and path:gsub("/", "\\") or path)
        local command = IS_WINDOWS
            and ("cmd /c if not exist " .. shell_path .. " mkdir " .. shell_path .. " >nul 2>nul")
            or ("mkdir -p " .. shell_path .. " 2>/dev/null")
        local ok, result, _, code = pcall(os.execute, command)
        if ok and (result == true or result == 0 or code == 0) then CREATED_DIRECTORIES[cache_key] = true end
    end
end

local function write_file(path, value)
    local handle, err = io.open(path, "wb")
    assert(handle, "cannot write fixture file " .. path .. ": " .. tostring(err))
    assert(handle:write(value))
    assert(handle:close())
end

local function read_file(path)
    local handle = io.open(path, "rb")
    if not handle then return nil end
    local value = handle:read("*a")
    handle:close()
    return value
end

local function copy_file(source, destination)
    local value = assert(read_file(source), "cannot read source fixture file " .. source)
    write_file(destination, value)
end

local function assert_true(value, message)
    if not value then error(message, 2) end
end

local function assert_contains(value, needle, message)
    assert_true(type(value) == "string" and value:find(needle, 1, true) ~= nil, message .. ": " .. tostring(value))
end

local function assert_not_contains(value, needle, message)
    assert_true(type(value) ~= "string" or value:find(needle, 1, true) == nil, message .. ": " .. tostring(value))
end

local function callback_state(callback)
    for index=1,64 do
        local name, value = debug.getupvalue(callback, index)
        if not name then break end
        if name == "state" and type(value) == "table" then return value end
    end
    return nil
end

local function config_text(saved_root, enabled)
    return ([=[return {
    enabled = %s,
    saved = {
        root_candidates = {%s},
        direct_known_files = {
            "Logs/AbioticFactor.log",
            "SaveGames/Server/Admin.ini",
            "SaveGames/Server/Worlds/IntegrationWorld/PlayerData/Player_76561198000000001.sav",
        },
        allow_full_find_discovery = false,
    },
    log_tail = {
        start_at_end_on_first_run = false,
        tail_backup_logs = false,
        register_backup_logs = false,
        backfill_backup_logs_on_start = false,
        backfill_active_log_on_boot = true,
        max_lines_per_poll = 100,
        max_bytes_per_poll = 65536,
        max_log_files_per_poll = 1,
        max_runtime_ms = 250,
    },
    runtime = {
        poll_interval_ms = 250,
        heartbeat_interval_seconds = 3600,
        max_poll_runtime_ms = 250,
        max_lines_per_poll = 100,
        max_bytes_per_poll = 65536,
        max_events_per_poll = 50,
        full_scan_interval_seconds = 86400,
        report_refresh_interval_seconds = 0,
        cleanup_interval_seconds = 86400,
        weekly_summary_check_interval_seconds = 86400,
    },
    scanning = {
        full_scan_on_start = false,
        recursive_discovery_enabled = false,
        allow_full_find_discovery = false,
        startup_scan_files_per_tick = 1,
        startup_scan_max_bytes_per_tick = 4096,
        startup_scan_max_runtime_ms = 10,
        write_scan_progress = true,
    },
    forensic_rollup = {
        enabled = false,
        rebuild_on_start = false,
        atomic_write = true,
    },
    source_accounting = {
        enabled = true,
        require_terminal_status = true,
        distinguish_current_from_historical = true,
        slow_world_scan_blocks_current_reports = false,
    },
    reports = {
        enabled = true,
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
        enabled = true,
        mode = "local_file_outbox",
        output_root = "runtime/notifications/pending",
        include_expected_empty = true,
        routes = {
            server_status = true,
            daily_rollup = true,
            player_activity = true,
            case_review = true,
            critical_guard = true,
        },
    },
    admin_ini = {
        enabled = true,
        backup_before_write = true,
        prevent_duplicates = true,
        preserve_external_changes = true,
        atomic_write = true,
        relative_path = "SaveGames/Server/Admin.ini",
    },
    enforcement = {
        enabled = true,
        auto_ban = false,
        review_only_mode = true,
        write_admin_ini = false,
        request_restart_after_ban = false,
        minimum_identity_strength = 100,
        require_account_specific_evidence = true,
    },
}
]=]):format(tostring(enabled ~= false), string.format("%q", normalize(saved_root)))
end

local function prepare_case(name, block_final_logs, enabled)
    local case_root = join(fixture_root, name)
    local mod_root = join(case_root, "RandomDayGuard")
    local scripts_root = join(mod_root, "Scripts")
    local saved_root = join(case_root, "Saved (Servidor Principal)")
    local playerdata_root = join(saved_root, "SaveGames/Server/Worlds/IntegrationWorld/PlayerData")
    make_directory(scripts_root)
    make_directory(join(saved_root, "Logs"))
    make_directory(join(saved_root, "SaveGames/Server"))
    make_directory(playerdata_root)
    copy_file(join(repo_root, "RandomDayGuard/Scripts/main.lua"), join(scripts_root, "main.lua"))
    copy_file(join(repo_root, "RandomDayGuard/Scripts/public_pipeline.lua"), join(scripts_root, "public_pipeline.lua"))
    write_file(join(mod_root, "config.lua"), config_text(saved_root, enabled))
    write_file(join(saved_root, "Logs/AbioticFactor.log"), "[2026.07.16-12.00.00:000][  0]LogInit: Display: Game server initialized\n")
    write_file(join(saved_root, "SaveGames/Server/Admin.ini"), "[Moderators]\nModerator=76561198000000001\n[BannedPlayers]\n")
    write_file(join(playerdata_root, "Player_76561198000000001.sav"), "fixture-playerdata")
    if block_final_logs then
        make_directory(join(mod_root, "runtime"))
        write_file(join(mod_root, "runtime/final_logs"), "blocked-by-real-file")
    end
    return mod_root
end

local function run_loader_case(name, block_final_logs)
    local mod_root = prepare_case(name, block_final_logs)
    local callbacks = {}
    local previous_loop_async = _G.LoopAsync
    local previous_poll = _G.RandomDayGuard_Poll
    local previous_summary = _G.RandomDayGuard_WeeklySummary
    local previous_start_loop = _G.start_poll_loop
    local previous_mod_root = _G.RANDOMDAYGUARD_MOD_ROOT
    local real_execute = os.execute

    _G.RandomDayGuard_Poll = nil
    _G.RandomDayGuard_WeeklySummary = nil
    _G.start_poll_loop = nil
    _G.LoopAsync = function(interval, callback)
        table.insert(callbacks, {interval=interval, callback=callback})
        return true
    end

    local ok, err = xpcall(function()
        assert(loadfile(join(mod_root, "Scripts/main.lua")))()
    end, debug.traceback)
    assert_true(ok, "actual loader failed: " .. tostring(err))
    assert_true(#callbacks == 1, "loader did not register exactly one LoopAsync owner")
    assert_true(callbacks[1].interval == 250, "loader did not preserve configured bounded poll interval")
    assert_true(type(_G.RandomDayGuard_Poll) == "function", "loader did not expose bounded manual poll")

    local owner_state = assert(callback_state(callbacks[1].callback), "LoopAsync callback did not retain scheduler state")
    assert_true(owner_state.scheduler_status == "running", "scheduler was not running after owner registration")
    os.execute = function(command)
        if tostring(command):match("^sleep%s+") then
            owner_state.scheduler_status = "stopped"
            return true
        end
        return real_execute(command)
    end
    local callback_ok, callback_result = xpcall(callbacks[1].callback, debug.traceback)
    os.execute = real_execute
    assert_true(callback_ok, "LoopAsync owner callback failed: " .. tostring(callback_result))
    assert_true(callback_result == true, "LoopAsync owner callback did not terminate cleanly")
    assert_true(owner_state.poll_id >= 1, "scheduled poll body was not entered")
    assert_true(owner_state.poll_completed_count >= 1, "scheduled poll was not finalized")
    assert_true(owner_state.poll_in_flight == false, "scheduled poll remained in flight")
    assert_true(owner_state.report_worker_in_flight == false, "report worker remained in flight")

    _G.LoopAsync = previous_loop_async
    _G.RandomDayGuard_Poll = previous_poll
    _G.RandomDayGuard_WeeklySummary = previous_summary
    _G.start_poll_loop = previous_start_loop
    _G.RANDOMDAYGUARD_MOD_ROOT = previous_mod_root
    return mod_root, owner_state
end

local success_root = run_loader_case("Loader Integration (Current)", false)
local success_runtime = join(success_root, "runtime")
local poll_status = assert(read_file(join(success_runtime, "current/poll_status.json")), "real current poll status was not written")
assert_contains(poll_status, '"poll_in_flight":false', "terminal poll status did not clear in-flight state")
assert_not_contains(poll_status, '"poll_completed_count":0', "terminal poll status did not persist completion count")
assert_contains(poll_status, '"scheduler_status":"running"', "terminal poll status lost running scheduler state")
assert_true(read_file(join(success_runtime, "history/public_accounts.tsv")) ~= nil, "loader did not create the public history directory contract")

for _,route in ipairs({"server_status", "daily_rollup", "player_activity", "case_review", "critical_guard"}) do
    local structured = assert(read_file(join(success_runtime, "final_logs/" .. route .. "_latest.json")), "missing real structured route output: " .. route)
    local translated = assert(read_file(join(success_runtime, "final_logs/" .. route .. "_latest.txt")), "missing real translated route output: " .. route)
    local pending = assert(read_file(join(success_runtime, "notifications/pending/" .. route .. "_latest.json")), "missing real pending route output: " .. route)
    assert_contains(structured, '"route":"' .. route .. '"', "structured output has wrong route ownership")
    assert_contains(translated, route, "translated output has wrong route ownership")
    assert_contains(pending, '"route":"' .. route .. '"', "pending output has wrong route ownership")
    assert_contains(pending, '"delivery_backend":"none"', "public outbox acquired a delivery backend")
    assert_contains(pending, '"delivery_attempted":false', "public outbox claimed delivery")
    assert_not_contains(pending:lower(), "webhook", "public outbox leaked a webhook field")
end

local route_proof = assert(read_file(join(success_runtime, "final_logs/route_proof.json")), "real route proof was not written")
assert_contains(route_proof, '"current_cycle_lineage_complete":true', "route proof did not bind current-cycle lineage")
assert_contains(route_proof, '"route":"server_status"', "route proof omitted server-status ownership")
assert_contains(assert(read_file(join(success_runtime, "public_pipeline_status.json"))), '"status":"refreshed"', "real report opportunity did not complete")

local failure_root = run_loader_case("Loader Integration (Write Failure)", true)
local failure_runtime = join(failure_root, "runtime")
local failure_poll = assert(read_file(join(failure_runtime, "current/poll_status.json")), "failure case did not persist poll finalization")
assert_contains(failure_poll, '"poll_in_flight":false', "failure case left poll in flight")
assert_not_contains(failure_poll, '"poll_completed_count":0', "failure case did not record completed poll")
assert_true(read_file(join(failure_runtime, "final_logs")) == "blocked-by-real-file", "failure fixture did not preserve the blocking file")
assert_true(read_file(join(failure_runtime, "final_logs/route_proof.json")) == nil, "blocked final-log directory unexpectedly produced route proof")
local failure_pending = assert(read_file(join(failure_runtime, "notifications/pending/server_status_latest.json")), "failure case omitted suppression envelope")
assert_contains(failure_pending, '"route_proof_status":"missing"', "failure envelope did not fail route proof closed")
assert_contains(failure_pending, '"delivery_eligible":false', "failure envelope remained delivery eligible")
assert_contains(failure_pending, '"status":"suppressed_current_cycle"', "failure envelope did not record suppression")
assert_contains(assert(read_file(join(failure_runtime, "public_pipeline_status.json"))), '"status":"deferred"', "write failure was not exported truthfully")

local function run_disabled_case()
    local mod_root = prepare_case("Loader Integration (Disabled)", false, false)
    local callbacks = {}
    local previous_loop_async = _G.LoopAsync
    local previous_poll = _G.RandomDayGuard_Poll
    local previous_summary = _G.RandomDayGuard_WeeklySummary
    local previous_start_loop = _G.start_poll_loop
    local previous_mod_root = _G.RANDOMDAYGUARD_MOD_ROOT

    _G.RandomDayGuard_Poll = nil
    _G.RandomDayGuard_WeeklySummary = nil
    _G.start_poll_loop = nil
    _G.LoopAsync = function(interval, callback)
        table.insert(callbacks, {interval=interval, callback=callback})
        return true
    end

    local ok, err = xpcall(function()
        assert(loadfile(join(mod_root, "Scripts/main.lua")))()
    end, debug.traceback)
    assert_true(ok, "disabled loader failed: " .. tostring(err))
    assert_true(#callbacks == 0, "disabled Guard registered a LoopAsync scheduler")
    assert_true(type(_G.RandomDayGuard_Poll) == "function", "disabled Guard omitted its bounded manual status entrypoint")
    assert_true(_G.RandomDayGuard_Poll() == 0, "disabled Guard manual poll did not remain inert")

    local runtime = join(mod_root, "runtime")
    local startup = assert(read_file(join(runtime, "startup_status.json")), "disabled startup status was not written")
    local poll = assert(read_file(join(runtime, "current/poll_status.json")), "disabled poll status was not written")
    assert_contains(startup, '"phase":"disabled"', "disabled startup phase was not explicit")
    assert_contains(startup, '"scheduler_status":"disabled"', "disabled startup status claimed an active scheduler")
    assert_contains(poll, '"poll_stage":"disabled"', "disabled poll stage was not explicit")
    assert_contains(poll, '"poll_in_flight":false', "disabled Guard claimed a poll was in flight")
    assert_true(read_file(join(runtime, "saved_root_probe.json")) == nil, "disabled Guard traversed Saved roots")
    assert_true(read_file(join(runtime, "final_logs/route_proof.json")) == nil, "disabled Guard generated reports")

    _G.LoopAsync = previous_loop_async
    _G.RandomDayGuard_Poll = previous_poll
    _G.RandomDayGuard_WeeklySummary = previous_summary
    _G.start_poll_loop = previous_start_loop
    _G.RANDOMDAYGUARD_MOD_ROOT = previous_mod_root
end

run_disabled_case()

print("REAL LUA LOADER INTEGRATION FIXTURE PASSED")
