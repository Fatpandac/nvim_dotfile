require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<leader>X", "<cmd>BufOnly<CR>", { desc = "clear all buffer without current" })
map("n", "<leader>fa", "<cmd>Telescope ast_grep<CR>", { desc = "telescope ast grep" })
map("n", "<leader>gb", function()
  require("gitsigns").blame_line()
end, { desc = "git blame line" })
map("n", "]c", function()
  if vim.wo.diff then
    return "]c"
  end

  vim.schedule(function()
    require("gitsigns").next_hunk()
  end)

  return "<Ignore>"
end, { desc = "Jump to next hunk", expr = true })
map("n", "[c", function()
  if vim.wo.diff then
    return "[c"
  end

  vim.schedule(function()
    require("gitsigns").prev_hunk()
  end)

  return "<Ignore>"
end, { desc = "Jump to prev hunk", expr = true })
map("n", "<leader>rh", function()
  require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })
map("n", "<leader>ph", function()
  require("gitsigns").preview_hunk()
end, { desc = "Preview hunk" })
map("n", "<leader>td", function()
  require("gitsigns").toggle_deleted()
end, { desc = "Toggle deleted" })
map("n", "gx", function()
  local url = vim.fn.expand "<cfile>"
  if url ~= "" then
    vim.ui.open(url)
  end
end, { desc = "open current url" })
map("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "open command" })
map("n", "<leader>cc", "<cmd>copen<CR>", { desc = "open quickfix list" })
map("n", "<leader>fm", function()
  require("conform").format { async = true, lsp_format = "fallback" }
end, { desc = "format buffer" })
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

map("t", "<C-x>", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), { desc = "Escape terminal mode" })

map("v", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
map("v", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
map("v", "<", "<gv", { desc = "Indent line" })
map("v", ">", ">gv", { desc = "Indent line" })
map("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle comment" })

map("x", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
map("x", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
map("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Dont copy replaced text", silent = true })
