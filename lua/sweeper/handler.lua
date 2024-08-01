local function default_keymap_data()
    return {
        count = 0,
        last_used = os.time(),
    }
end

local function handle_keymap(km)
    local mode = vim.api.nvim_get_mode().mode
    local km_key = mode .. '--//--' .. km
    local sweeper_data = vim.g.sweeper_data
    sweeper_data.needs_write = true
    local cmd = sweeper_data.keymaps[km_key]
    if cmd == nil then
        return
    end

    km = vim.api.nvim_replace_termcodes(km, true, false, true)

    if sweeper_data.keymap_data[km_key] == nil then
        sweeper_data.keymap_data[km_key] = default_keymap_data()
    end
    sweeper_data.keymap_data[km_key].count = sweeper_data.keymap_data[km_key].count + 1
    sweeper_data.keymap_data[km_key].last_used = os.time()
    sweeper_data.keymap_data[km_key].cmd = cmd
    sweeper_data.keymap_data[km_key].formatted_km = km
    sweeper_data.keymap_data[km_key].mode = mode

    if sweeper_data.keymap_historical[km_key] == nil then
        sweeper_data.keymap_historical[km_key] = {}
    end
    local hist = sweeper_data.keymap_historical[km_key]
    hist[#hist + 1] = {
        formatted_km = km,
        mode = mode,
        used_at = os.time(),
        metadata = {},
    }

    vim.g.sweeper_data = sweeper_data
end


return {
    handle_keymap = handle_keymap
}
