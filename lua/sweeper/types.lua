

---@class Data
---@field keymap_data table<string, KeymapData>
---@field keymap_historical table<string, KeymapHistorical[]>
---@field keymaps table<string, string>
local Data = {}

---@class KeymapData
---@field count number
---@field last_used number
---@field cmd string
---@field formatted_km string
---@field mode string
local KeymapData = {}

---@class KeymapHistorical
---@field formatted_km string
---@field mode string
---@field used_at number
---@field metadata table
local KeymapHistorical = {}
