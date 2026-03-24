require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<leader>X", "<cmd>BufOnly<CR>", { desc = "clear all buffer without current" })
map("n", "<leader>fa", "<cmd>Telescope ast_grep<CR>", { desc = "telescope ast grep" })
map("n", "gx", "<esc><cmd>URLOpenUnderCursor<CR>", { desc = "open current url" })
map("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "open command" })
map("n", "<leader>cc", "<cmd>copen<CR>", { desc = "open quickfix list" })
map("n", "<C-j>", "<C-i>", { desc = "jump to next cursor position" })
map("n", "<C-k>", "<C-o>", { desc = "jump to previous cursor position" })
map("n", "cl", function()
  local line = vim.fn.line "."
  local file = vim.fn.expand "%"
  vim.fn.setreg("+", file .. ":" .. line)
end, { desc = "copy current cursor position to clipboard" })
map("n", "<C-n>", "<cmd>Yazi<CR>", { desc = "open file explorer" })
map("n", ":", "<cmd>FineCmdline<CR>", { desc = "open FineCmdline" })
map("n", "<leader>x", function()
  if vim.bo.buftype == "quickfix" then
    vim.cmd "ccl"
  else
    require("nvchad.tabufline").close_buffer()
  end
end, { desc = "close quickfix or buffer" })
map("n", "gbc", "<Nop>", { desc = "disable gcc" })
