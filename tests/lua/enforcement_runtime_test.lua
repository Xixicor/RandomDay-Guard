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
    make_directory(normalize(path):match("^(.*)/[^/]+$") or ".")
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
    write_file(destination, assert(read_file(source), "cannot read source fixture file " .. source))
end

local function assert_true(value, message)
    if not value then error(message, 2) end
end

local function assert_equal(actual, expected, message)
    if actual ~= expected then
        error(message .. " (actual=" .. tostring(actual) .. ", expected=" .. tostring(expected) .. ")", 2)
    end
end

local function assert_contains(value, needle, message)
    assert_true(type(value) == "string" and value:find(needle, 1, true) ~= nil, message .. ": " .. tostring(value))
end

local function path_is_inside(root, path)
    root = normalize(root):lower()
    path = normalize(path):lower()
    return path == root or path:sub(1, #root + 1) == root .. "/"
end

local function find_named_upvalue(fn, target, seen, depth)
    if type(fn) ~= "function" or depth > 16 then return nil end
    seen = seen or {}
    if seen[fn] then return nil end
    seen[fn] = true
    for index=1,128 do
        local name, value = debug.getupvalue(fn, index)
        if not name then break end
        if name == target then return value end
    end
    for index=1,128 do
        local name, value = debug.getupvalue(fn, index)
        if not name then break end
        if type(value) == "function" then
            local found = find_named_upvalue(value, target, seen, depth + 1)
            if found ~= nil then return found end
        end
    end
    return nil
end

local function config_text(saved_root)
    return ([=[return {
    saved = {
        root_candidates = {%s},
        direct_known_files = {"Logs/AbioticFactor.log", "SaveGames/Server/Admin.ini"},
        allow_full_find_discovery = false,
    },
    runtime = {
        poll_interval_ms = 250,
        heartbeat_interval_seconds = 3600,
        full_scan_interval_seconds = 86400,
        report_refresh_interval_seconds = 86400,
        cleanup_interval_seconds = 86400,
        weekly_summary_check_interval_seconds = 86400,
    },
    log_tail = {
        start_at_end_on_first_run = true,
        tail_backup_logs = false,
        register_backup_logs = false,
        backfill_backup_logs_on_start = false,
        backfill_active_log_on_boot = false,
        max_lines_per_poll = 10,
        max_bytes_per_poll = 4096,
        max_log_files_per_poll = 1,
        max_runtime_ms = 50,
    },
    scanning = {
        full_scan_on_start = false,
        recursive_discovery_enabled = false,
        allow_full_find_discovery = false,
        startup_scan_files_per_tick = 1,
        startup_scan_max_bytes_per_tick = 1024,
        startup_scan_max_runtime_ms = 10,
    },
    forensic_rollup = {enabled = false, rebuild_on_start = false, atomic_write = true},
    reports = {enabled = false, routes = {}},
    notification = {enabled = false, routes = {}},
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
        require_playerdata_verified = false,
        minimum_identity_strength = 100,
        require_clean_ban_id = true,
        require_backup_success = true,
        require_write_readback = true,
        rollback_on_readback_failure = true,
        preserve_moderators = true,
        preserve_existing_bans = true,
        ban_on_threshold = true,
        require_account_specific_evidence = true,
        trusted_ids = {},
    },
    restart_request = {enabled = false},
}
]=]):format(string.format("%q", normalize(saved_root)))
end

local bootstrap_root = join(fixture_root, "_bootstrap")
local bootstrap_mod_root = join(bootstrap_root, "RandomDayGuard")
local bootstrap_scripts_root = join(bootstrap_mod_root, "Scripts")
local bootstrap_saved_root = join(bootstrap_root, "Saved")
make_directory(bootstrap_scripts_root)
make_directory(join(bootstrap_saved_root, "Logs"))
make_directory(join(bootstrap_saved_root, "SaveGames/Server"))
copy_file(join(repo_root, "RandomDayGuard/Scripts/main.lua"), join(bootstrap_scripts_root, "main.lua"))
copy_file(join(repo_root, "RandomDayGuard/Scripts/public_pipeline.lua"), join(bootstrap_scripts_root, "public_pipeline.lua"))
write_file(join(bootstrap_mod_root, "config.lua"), config_text(bootstrap_saved_root))
write_file(join(bootstrap_saved_root, "Logs/AbioticFactor.log"), "[fixture] server initialized\n")
write_file(join(bootstrap_saved_root, "SaveGames/Server/Admin.ini"), "[Moderators]\n[BannedPlayers]\n")

local previous = {
    LoopAsync = _G.LoopAsync,
    poll = _G.RandomDayGuard_Poll,
    summary = _G.RandomDayGuard_WeeklySummary,
    start_loop = _G.start_poll_loop,
    mod_root = _G.RANDOMDAYGUARD_MOD_ROOT,
}
_G.RandomDayGuard_Poll = nil
_G.RandomDayGuard_WeeklySummary = nil
_G.start_poll_loop = nil
_G.LoopAsync = function() return true end

local loader_ok, loader_error = xpcall(function()
    assert(loadfile(join(bootstrap_scripts_root, "main.lua")))()
end, debug.traceback)
assert_true(loader_ok, "actual loader failed: " .. tostring(loader_error))
assert_true(type(_G.RandomDayGuard_Poll) == "function", "loader did not expose the manual poll closure")
local runtime_append_ban = find_named_upvalue(_G.RandomDayGuard_Poll, "append_ban", {}, 0)
local runtime_state = find_named_upvalue(_G.RandomDayGuard_Poll, "state", {}, 0)
assert_true(type(runtime_append_ban) == "function", "actual append_ban closure was not reachable")
assert_true(type(runtime_state) == "table", "actual loader state was not reachable")

local function load_case(name, admin_text)
    local case_root = join(fixture_root, name)
    local mod_root = join(case_root, "RandomDayGuard")
    local saved_root = join(case_root, "Saved")
    local admin_path = join(saved_root, "SaveGames/Server/Admin.ini")
    make_directory(mod_root)
    make_directory(join(saved_root, "Logs"))
    make_directory(join(saved_root, "SaveGames/Server"))
    write_file(join(saved_root, "Logs/AbioticFactor.log"), "[fixture] server initialized\n")
    write_file(admin_path, admin_text)

    local state = runtime_state
    state.mod_root = mod_root
    state.saved_root = saved_root
    state.config.whitelist = {}
    state.config.admin_ini = {
        enabled = true,
        backup_before_write = true,
        prevent_duplicates = true,
        preserve_external_changes = true,
        atomic_write = true,
        relative_path = "SaveGames/Server/Admin.ini",
    }
    state.config.enforcement = {
        enabled = true,
        auto_ban = true,
        review_only_mode = false,
        write_admin_ini = true,
        request_restart_after_ban = false,
        require_playerdata_verified = false,
        minimum_identity_strength = 100,
        require_clean_ban_id = true,
        require_backup_success = true,
        require_write_readback = true,
        rollback_on_readback_failure = true,
        preserve_moderators = true,
        preserve_existing_bans = true,
        ban_on_threshold = true,
        require_account_specific_evidence = true,
        trusted_ids = {},
    }
    state.config.restart_request = {enabled = false}

    return {
        case_root = case_root,
        mod_root = mod_root,
        saved_root = saved_root,
        admin_path = admin_path,
        append_ban = runtime_append_ban,
        state = state,
        restore = function() end,
    }
end

local function account(id, raw, confidence)
    return {
        account_id = id,
        ban_id = id,
        connect_id_raw = raw,
        raw_id = raw,
        identity_confidence = confidence or "direct_login_request",
        playerdata_verified = false,
        score = 200,
        status = "BAN-ELIGIBLE",
        banned = false,
    }
end

local function invoke(context, operation, fault)
    local real_open = io.open
    local real_rename = os.rename
    local real_remove = os.remove
    local admin_reads = 0
    local backup_paths = {}
    local mismatch_path = join(context.case_root, "fault-readback.ini")
    local external_text = fault and fault.external_text or nil
    if fault and (fault.verify_mismatch or fault.verify_external_change) then
        write_file(mismatch_path, fault.mismatch_text or "[BannedPlayers]\n")
    end

    io.open = function(path, mode)
        local normalized = normalize(path)
        mode = mode or "r"
        if mode:find("w", 1, true) or mode:find("a", 1, true) then
            assert_true(path_is_inside(context.case_root, normalized), "write escaped fixture root: " .. normalized)
            if normalized:find("/runtime/backups/Admin_", 1, true) and normalized:match("%.ini$") then
                table.insert(backup_paths, normalized)
            end
        end
        if normalized == normalize(context.admin_path) and mode == "rb" then
            admin_reads = admin_reads + 1
            if fault and fault.concurrent_before_write and admin_reads == 3 then
                local handle = assert(real_open(context.admin_path, "wb"))
                assert(handle:write(external_text))
                assert(handle:close())
            elseif fault and (fault.verify_mismatch or fault.verify_external_change) and admin_reads == 4 then
                return real_open(mismatch_path, mode)
            elseif fault and fault.verify_external_change and admin_reads == 5 then
                local handle = assert(real_open(context.admin_path, "wb"))
                assert(handle:write(external_text))
                assert(handle:close())
            end
        end
        return real_open(path, mode)
    end
    os.rename = function(source, destination)
        assert_true(path_is_inside(context.case_root, source), "rename source escaped fixture root: " .. tostring(source))
        assert_true(path_is_inside(context.case_root, destination), "rename destination escaped fixture root: " .. tostring(destination))
        return real_rename(source, destination)
    end
    os.remove = function(path)
        assert_true(path_is_inside(context.case_root, path), "remove escaped fixture root: " .. tostring(path))
        return real_remove(path)
    end

    local ok, first, second = xpcall(operation, debug.traceback)
    io.open = real_open
    os.rename = real_rename
    os.remove = real_remove
    assert_true(ok, "actual append_ban invocation failed: " .. tostring(first))
    return first, second, backup_paths
end

local function failure_log(context)
    return read_file(join(context.mod_root, "runtime/enforced_bans.jsonl")) or ""
end

local original = "[Moderators]\r\nModerator=76561198000000001\r\n[BannedPlayers]\r\n; preserved trailing bytes\r\n"

do
    local context = load_case("success-and-duplicate", original)
    local id = "76561198000000111"
    local candidate = account(id, id .. "_+_|fixture-token")
    local first, second, backups = invoke(context, function()
        local inserted = context.append_ban(candidate, "FIXTURE_THRESHOLD")
        local duplicate = context.append_ban(candidate, "FIXTURE_THRESHOLD")
        return inserted, duplicate
    end)
    assert_true(first == true and second == true, "successful and duplicate insertions did not return true")
    local final = assert(read_file(context.admin_path), "successful Admin.ini vanished")
    local count = 0
    for _ in final:gmatch("BannedPlayer=" .. id) do count = count + 1 end
    assert_equal(count, 1, "duplicate insertion was not idempotent")
    assert_equal(#backups, 1, "successful plus duplicate insertion did not create exactly one backup")
    assert_equal(read_file(backups[1]), original, "Admin.ini backup was not byte-for-byte identical")
    assert_equal(candidate.status, "AUTO-BANNED", "successful transaction did not update account status")
    context.restore()
end

do
    local moderator = "76561198000000001"
    local context = load_case("moderator-rejection", original)
    local result, _, backups = invoke(context, function()
        return context.append_ban(account(moderator, moderator), "FIXTURE_THRESHOLD")
    end)
    assert_true(result == false, "moderator identity was not rejected")
    assert_equal(read_file(context.admin_path), original, "moderator rejection changed Admin.ini")
    assert_equal(#backups, 0, "moderator rejection created a backup")
    assert_contains(failure_log(context), '"error":"trusted_or_moderator_identity"', "moderator rejection omitted its failure code")
    context.restore()
end

do
    local trusted = "76561198000000122"
    local context = load_case("trusted-rejection", original)
    context.state.config.enforcement.trusted_ids[trusted] = true
    local result, _, backups = invoke(context, function()
        return context.append_ban(account(trusted, trusted), "FIXTURE_THRESHOLD")
    end)
    assert_true(result == false, "trusted identity was not rejected")
    assert_equal(read_file(context.admin_path), original, "trusted rejection changed Admin.ini")
    assert_equal(#backups, 0, "trusted rejection created a backup")
    assert_contains(failure_log(context), '"error":"trusted_or_moderator_identity"', "trusted rejection omitted its failure code")
    context.restore()
end

do
    local id = "76561198000000133"
    local context = load_case("weak-identity", original)
    local result = invoke(context, function()
        return context.append_ban(account(id, id, "playerdata_only"), "FIXTURE_THRESHOLD")
    end)
    assert_true(result == false, "weak identity was not rejected")
    assert_equal(read_file(context.admin_path), original, "weak identity changed Admin.ini")
    assert_contains(failure_log(context), '"error":"identity_strength_below_minimum"', "weak identity omitted its failure code")
    context.restore()
end

do
    local id = "76561198000000144"
    local context = load_case("malformed-identity", original)
    local result = invoke(context, function()
        return context.append_ban(account(id, id .. "-unexpected-suffix"), "FIXTURE_THRESHOLD")
    end)
    assert_true(result == false, "malformed identity was not rejected")
    assert_equal(read_file(context.admin_path), original, "malformed identity changed Admin.ini")
    assert_contains(failure_log(context), '"error":"clean_numeric_identity_required"', "malformed identity omitted its failure code")
    context.restore()
end

do
    local id = "76561198000000145"
    local context = load_case("malformed-supplied-ban-id", original)
    local candidate = account(id, id)
    candidate.ban_id = id .. "-unexpected-suffix"
    local result = invoke(context, function()
        return context.append_ban(candidate, "FIXTURE_THRESHOLD")
    end)
    assert_true(result == false, "malformed supplied ban ID was not rejected")
    assert_equal(read_file(context.admin_path), original, "malformed supplied ban ID changed Admin.ini")
    assert_contains(failure_log(context), '"error":"clean_numeric_identity_required"', "malformed supplied ban ID omitted its failure code")
    context.restore()
end

do
    local id = "76561198000000155"
    local external = original .. "; operator concurrent edit\r\n"
    local context = load_case("concurrent-change", original)
    local result, _, backups = invoke(context, function()
        return context.append_ban(account(id, id), "FIXTURE_THRESHOLD")
    end, {concurrent_before_write = true, external_text = external})
    assert_true(result == false, "concurrent Admin.ini modification was not rejected")
    assert_equal(read_file(context.admin_path), external, "concurrent Admin.ini bytes were overwritten")
    assert_equal(#backups, 1, "concurrent-change rejection did not preserve its verified snapshot backup")
    assert_equal(read_file(backups[1]), original, "concurrent-change backup was not byte-for-byte identical")
    assert_contains(failure_log(context), '"error":"admin_ini_external_change_detected"', "concurrent-change rejection omitted its failure code")
    context.restore()
end

do
    local id = "76561198000000166"
    local context = load_case("readback-rollback", original)
    local result, _, backups = invoke(context, function()
        return context.append_ban(account(id, id), "FIXTURE_THRESHOLD")
    end, {verify_mismatch = true, mismatch_text = original})
    assert_true(result == false, "failed readback did not fail closed")
    assert_equal(read_file(context.admin_path), original, "failed readback did not restore the exact backup")
    assert_equal(#backups, 1, "failed readback did not create exactly one backup")
    assert_equal(read_file(backups[1]), original, "rollback backup was not byte-for-byte identical")
    assert_contains(failure_log(context), '"error":"post_write_verification_failed"', "failed readback omitted its failure code")
    assert_contains(failure_log(context), '"rollback_success":true', "failed readback did not record successful rollback")
    context.restore()
end

do
    local id = "76561198000000177"
    local external = original .. "; external bytes after replacement\r\n"
    local context = load_case("rollback-refuses-external-change", original)
    local result = invoke(context, function()
        return context.append_ban(account(id, id), "FIXTURE_THRESHOLD")
    end, {verify_external_change = true, mismatch_text = original, external_text = external})
    assert_true(result == false, "external post-write change did not fail closed")
    assert_equal(read_file(context.admin_path), external, "rollback overwrote unknown external bytes")
    assert_contains(failure_log(context), '"rollback_refused_external_change":true', "rollback refusal was not recorded")
    context.restore()
end

_G.LoopAsync = previous.LoopAsync
_G.RandomDayGuard_Poll = previous.poll
_G.RandomDayGuard_WeeklySummary = previous.summary
_G.start_poll_loop = previous.start_loop
_G.RANDOMDAYGUARD_MOD_ROOT = previous.mod_root

print("REAL LUA ADMIN.INI ENFORCEMENT FIXTURE PASSED")
