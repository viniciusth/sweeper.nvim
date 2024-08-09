
local function sweep()
    print(vim.inspect(vim.g.sweeper_data))
end

return {
    sweep = sweep,
}
