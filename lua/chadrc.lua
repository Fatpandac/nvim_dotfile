local highlights = require "custom.highlights"
local mason = require("custom.configs.overrides").mason

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "bearded-arc",
  theme_toggle = { "bearded-arc", "one_light" },
  hl_override = highlights.override,
  hl_add = highlights.add,
}

M.mason = {
  pkgs = mason.ensure_installed,
}

return M
