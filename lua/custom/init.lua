require("custom.base")

-- Auto resize panes when resizing nvim window
local autocmd = vim.api.nvim_create_autocmd

autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

autocmd({ "BufEnter", "WinEnter" }, {
  pattern = "*",
  command = "set statusline=%{repeat('',winwidth('.'))}",
})

autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*/Work/*" },
  command = "Copilot disable",
})
