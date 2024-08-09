if vim.g.loaded_sweeper then
    return
end

vim.g.sweeper_loaded = true

require('sweeper.db').start()

---@type Data
vim.g.sweeper_data = {
    keymap_data = {},
    keymap_historical = {},
    keymaps = {},
}

vim.api.nvim_create_user_command('Sweeper', 'lua require("sweeper").sweep()', { nargs = 0 })

vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function()
        require('sweeper.db').update()
    end
})

vim.on_key(function(_, typed)
    require('sweeper.handler').handle_keymap(typed)
end)

---@diagnostic disable-next-line: undefined-field
local timer = vim.uv.new_timer()

timer:start(0, 5000, vim.schedule_wrap(function()
    require('sweeper.db').update()
end))

vim.defer_fn(function()
    require('sweeper.keymaps').setup_data_keymaps()
end, 0)

