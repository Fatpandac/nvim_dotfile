vim.g.toggle_theme_icon = ""
vim.g.nvim_tree_respect_buf_cwd = 1

vim.g.netrw_dynamic_maxfilenamelen = 32
vim.g.netrw_preview = 1
vim.g.netrw_alto = 0

vim.opt.laststatus = 0

vim.opt.foldmethod = "indent"
vim.opt.foldcolumn = "0"
vim.opt_local.foldlevel = 1
vim.opt.foldlevelstart = 99
vim.opt.ttyfast = true
vim.opt.regexpengine = 0
vim.opt.relativenumber = true
vim.opt_local.conceallevel = 2
vim.opt.virtualedit = "block"

vim.opt.wrap = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv "HOME" .. "/.vim/undodir"

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.colorcolumn = "80"

vim.opt.mouse = ""
vim.opt.updatetime = 4000

vim.loader.enable()

vim.g.clipboard = {
  name = "pbcopy",
  copy = {
    ["+"] = "pbcopy",
    ["*"] = "pbcopy",
  },
  paste = {
    ["+"] = "pbpaste",
    ["*"] = "pbpaste",
  },
  cache_enabled = 0,
}

-- Auto resize panes when resizing nvim window
local autocmd = vim.api.nvim_create_autocmd

autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

autocmd({"BufEnter", "WinEnter"}, {
  pattern = "*",
  command = "set statusline=%{repeat('',winwidth('.'))}",
})
