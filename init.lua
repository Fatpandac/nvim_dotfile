vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

if vim.g.vscode then
  dofile(vim.api.nvim_get_runtime_file("lua/custom/vscode.lua", false)[1])
  return
end

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

if vim.uv.fs_stat(vim.g.base46_cache .. "defaults") then
  dofile(vim.g.base46_cache .. "defaults")
end

if vim.uv.fs_stat(vim.g.base46_cache .. "statusline") then
  dofile(vim.g.base46_cache .. "statusline")
end

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
