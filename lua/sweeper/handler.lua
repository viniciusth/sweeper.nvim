local function default_keymap_data()
    return {
        count = 0,
        last_used = os.time(),
    }
end

local function handle_keymap(km)
    local sweeper_data = vim.g.sweeper_data
    sweeper_data.needs_write = true
    local cmd = sweeper_data.keymaps[km]
    if cmd == nil then
        return
    end

    km = vim.api.nvim_replace_termcodes(km, true, false, true)

    if sweeper_data.keymap_data[km] == nil then
        sweeper_data.keymap_data[km] = default_keymap_data()
    end
    sweeper_data.keymap_data[km].count = sweeper_data.keymap_data[km].count + 1
    sweeper_data.keymap_data[km].last_used = os.time()
    sweeper_data.keymap_data[km].cmd = cmd
    sweeper_data.keymap_data[km].formatted_km = km

    if sweeper_data.keymap_historical[km] == nil then
        sweeper_data.keymap_historical[km] = {}
    end
    local hist = sweeper_data.keymap_historical[km]
    hist[#hist + 1] = {
        formatted_km = km,
        used_at = os.time(),
        metadata = {},
    }

    vim.g.sweeper_data = sweeper_data
end


return {
    handle_keymap = handle_keymap
}
