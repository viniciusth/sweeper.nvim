---@diagnostic disable: missing-fields

local db = require('sqlite.db')
local tbl = require('sqlite.tbl')

local db_file = vim.fn.stdpath('data') .. '/sweeper.db'

local data = tbl.new('data', {
    keymap = { "text", required = true, primary = true },
    mode = { "text", required = true, primary = true },
    count = { "integer", required = true },
    last_used = { "timestamp", required = true },
})

local historical = tbl.new('historical', {
    keymap = { "text", required = true },
    mode = { "text", required = true },
    used_at = { "timestamp", required = true },
    metadata = { "luatable", required = true },
})

local function start()
    local conn = db:open(db_file)
    if not conn:exists('data') then
        conn:execute([[
            CREATE TABLE data (
                keymap TEXT NOT NULL,
                mode TEXT NOT NULL,
                count INTEGER NOT NULL,
                last_used TIMESTAMP NOT NULL,
                PRIMARY KEY (keymap, mode)
            );
        ]])
    end

    if not conn:exists('historical') then
        conn:execute([[
            CREATE TABLE historical (
                keymap TEXT NOT NULL,
                mode TEXT NOT NULL,
                used_at TIMESTAMP NOT NULL,
                metadata TEXT NOT NULL
            );
        ]])
    end

    conn:close()
end

local function create_values()
    ---@type Data
    local d = vim.g.sweeper_data
    -- string for values, build upsert query
    local values = "INSERT INTO data (keymap, mode, count, last_used) VALUES "
    local historical_values = {}
    for k, v in pairs(d.keymap_data) do
        if v.count > 0 then
            local mode = k:sub(1, 1)
            values = values .. string.format("('%s', '%s', %d, %d),", v.formatted_km, mode, v.count, v.last_used)
            d.keymap_data[k].count = 0
            local hist = d.keymap_historical[k]
            for _, h in ipairs(hist) do
                historical_values[#historical_values + 1] = {
                    keymap = h.formatted_km,
                    mode = mode,
                    used_at = h.used_at,
                    metadata = h.metadata,
                }
            end
            d.keymap_historical[k] = {}
        end
    end

    vim.g.sweeper_data = d

    values = values:sub(1, -2) ..
        " ON CONFLICT(keymap, mode) DO UPDATE SET count = count + excluded.count, last_used = excluded.last_used;"

    return values, historical_values
end

local function update()
    local vals, hist_vals = create_values()
    if #hist_vals == 0 then
        return
    end

    local conn = db:open(db_file)
    data:set_db(conn)
    historical:set_db(conn)

    -- upsert isnt supported, do manually
    conn:execute(vals)
    historical:insert(hist_vals)

    conn:close()
end


return {
    start = start,
    update = update,
}
