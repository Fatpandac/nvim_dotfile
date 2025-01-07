---@type MappingsTable
local M = {}

M.general = {
  n = {
    ["<leader>X"] = { ":BufOnly<CR>", "clear all buffer without current", opts = { nowait = true } },
    ["tj"] = { ":tabn<CR>", "go to next tab", opts = { nowait = true } },
    ["tk"] = { ":tabp<CR>", "go to preivous tab", opts = { nowait = true } },
    ["tn"] = { ":tabnew<CR>", "creat to new tab", opts = { nowait = true } },
    ["tx"] = { ":tabclose<CR>", "close current tab", opts = { nowait = true } },
    ["gx"] = { "<esc>:URLOpenUnderCursor<CR>", "open current url", opts = { nowait = true } },
    ["<leader>fc"] = { ":Telescope commands<CR>", "open command", opts = { nowait = true } },
    ["<leader>u"] = { ":UndotreeToggle<CR>", "open undo tree", opts = { nowait = true } },
    ["<leader>i"] = {
      ":lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({0}),{0})<CR>",
      "show inlay hit",
    },
    ["<leader>cc"] = {
      ":copen<CR>",
      "open quickfix list",
    },
    ["<C-j>"] = {
      "<C-i>",
      "jump to next cursor position",
      opts = { nowait = true, noremap = true },
    },
    ["<C-k>"] = {
      "<C-o>",
      "jump to preivous cursor position",
      opts = { nowait = true, noremap = true },
    },
    ["cl"] = {
      function()
        local line = vim.fn.line "."
        local file = vim.fn.expand "%"
        vim.fn.setreg("+", file .. ":" .. line)
      end,
      "Copy current cursor position to clipboard",
    },
    ["<leader>mr"] = {
      function()
        vim.cmd "make run"
      end,
      "Run makefile run",
      opts = { nowait = true },
    },
    ["<leader>mb"] = {
      function()
        vim.cmd "make build"
      end,
      "Run makefile build",
      opts = { nowait = true },
    },
    ["<C-n>"] = {
      function()
        if vim.bo.filetype == "netrw" then
          vim.cmd "Rex"
        else
          vim.cmd "Explore"
        end
      end,
      "open file explorer",
      opts = { nowait = true },
    },
    [":"] = {
      function()
        vim.cmd "FineCmdline"
      end,
      "open FineCmdline",
      opts = { nowait = true },
    },
    ["<leader>x"] = {
      function()
        if vim.bo.buftype == "quickfix" then
          vim.cmd "ccl"
        else
          require("nvchad.tabufline").close_buffer()
        end
      end,
      "clear all buffer without current",
      opts = { nowait = true },
    },
  },
}

return M
