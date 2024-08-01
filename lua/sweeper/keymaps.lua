---@diagnostic disable: undefined-field

local function get_keymaps()
    local modes = {'n', 'v', 'x', 'c', 'i'}
    local keymaps = {}
    for _, mode in ipairs(modes) do
        local kms = vim.api.nvim_get_keymap(mode)
        for _, km in ipairs(kms) do
            local key = mode .. '--//--' .. km.lhsraw
            if km.rhs ~= '' and km.rhs ~= nil then
                keymaps[key] = km.rhs
            elseif km.callback ~= nil then
                keymaps[key] = '<anonymous>'
            end
        end
    end

    return keymaps
end

local function setup_data_keymaps()
    local sweeper_data = vim.g.sweeper_data
    sweeper_data.keymaps = get_keymaps()
    for km, cmd in pairs(sweeper_data.keymaps) do
        if sweeper_data.keymap_data[km] == nil then
            sweeper_data.keymap_data[km] = {
                count = 0,
                last_used = os.time(),
                cmd = cmd,
                metadata = {}
            }
        end
    end
    vim.g.sweeper_data = sweeper_data
end

return {
    setup_data_keymaps = setup_data_keymaps,
}
