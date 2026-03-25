vim.g.toggle_theme_icon = ""
vim.g.nvim_tree_respect_buf_cwd = 1

vim.g.netrw_dynamic_maxfilenamelen = 32
vim.g.netrw_preview = 1
vim.g.netrw_alto = 0

vim.opt.laststatus = 0
vim.opt.foldmethod = "indent"
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 1
vim.opt.foldlevelstart = 99
vim.opt.ttyfast = true
vim.opt.regexpengine = 0
vim.opt.relativenumber = true
vim.opt.conceallevel = 2
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

vim.g.mapleader = " "
vim.keymap.set("n", "j", ":call VSCodeCall('cursorDown')<CR>", { noremap = false, silent = true })
vim.keymap.set("n", "k", ":call VSCodeCall('cursorUp')<CR>", { noremap = false, silent = true })
vim.keymap.set("n", "<leader>x", ":call VSCodeNotify('workbench.action.closeActiveEditor')<CR>", { silent = true })
vim.keymap.set("n", "<leader>X", ":call VSCodeNotify('workbench.action.closeOtherEditors')<CR>", { silent = true })
vim.keymap.set("n", "<leader>ff", ":call VSCodeNotify('fzfsearch.search.file.toggle')<CR>", { silent = true })
vim.keymap.set("n", "<leader>fw", ":call VSCodeNotify('fzfsearch.search.content.toggle')<CR>", { silent = true })
vim.keymap.set("n", "<leader>fg", ":call VSCodeNotify('fzfsearch.search.repo.toggle')<CR>", { silent = true })
vim.keymap.set("n", "<leader>gt", ":call VSCodeNotify('fzfsearch.search.gitStatus.toggle')<CR>", { silent = true })
vim.keymap.set("n", "<leader>fm", ":call VSCodeNotify('editor.action.formatDocument')<CR>", { silent = true })
vim.keymap.set("n", "za", ":call VSCodeNotify('editor.toggleFold')<CR>", { silent = true })
vim.keymap.set("n", "]d", ":call VSCodeNotify('editor.action.marker.nextInFiles')<CR>", { silent = true })
vim.keymap.set("n", "[d", ":call VSCodeNotify('editor.action.marker.prevInFiles')<CR>", { silent = true })
vim.keymap.set("n", "gd", ":call VSCodeNotify('editor.action.revealDefinition')<CR>", { silent = true })
vim.keymap.set("n", "gr", ":call VSCodeNotify('editor.action.goToReferences')<CR>", { silent = true })
vim.keymap.set("n", "gg", ":call VSCodeNotify('list.focusFirst')<CR>", { silent = true })
vim.keymap.set("n", "gg", ":call VSCodeNotify('cursorTop')<CR>", { silent = true })
vim.keymap.set("n", "ra", ":call VSCodeNotify('editor.action.rename')<CR>", { silent = true })
vim.keymap.set("n", "cl", function()
  local line = vim.fn.line "."
  local file = vim.fn.expand "%"
  vim.fn.setreg("+", file .. ":" .. line)
end, { silent = true })
vim.keymap.set("n", "<Esc>", "<cmd> noh <CR>", { silent = true })
