local db = require('sweeper.db')

local function sweep()
    print(vim.inspect(vim.g.sweeper_data))
end

local function save()
    db.update(vim.g.sweeper_data)
end

return {
    sweep = sweep,
    save = save
}
