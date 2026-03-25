---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "bearded-arc",
  theme_toggle = { "bearded-arc", "one_light" },
  hl_override = {
    Comment = {
      italic = true,
    },
  },
  hl_add = {
    NvimTreeOpenedFolderName = { fg = "green", bold = true },
  },
}

M.mason = {
  pkgs = {
    "lua-language-server",
    "stylua",
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",
    "clangd",
    "clang-format",
  },
}

return M
