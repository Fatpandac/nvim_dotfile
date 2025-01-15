---@type MappingsTable
local M = {}

M.general = {
  n = {
    ["<leader>X"] = { ":BufOnly<CR>", "clear all buffer without current" },
    ["tj"] = { ":tabn<CR>", "go to next tab" },
    ["tk"] = { ":tabp<CR>", "go to preivous tab" },
    ["tn"] = { ":tabnew<CR>", "creat to new tab" },
    ["tx"] = { ":tabclose<CR>", "close current tab" },
    ["gx"] = { "<esc>:URLOpenUnderCursor<CR>", "open current url" },
    ["<leader>fc"] = { ":Telescope commands<CR>", "open command" },
    ["<leader>u"] = { ":UndotreeToggle<CR>", "open undo tree" },
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
    },
    ["<C-k>"] = {
      "<C-o>",
      "jump to preivous cursor position",
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
    },
    ["<leader>mb"] = {
      function()
        vim.cmd "make build"
      end,
      "Run makefile build",
    },
    ["<C-n>"] = {
      function()
        vim.cmd "Yazi"
      end,
      "open file explorer",
    },
    [":"] = {
      function()
        vim.cmd "FineCmdline"
      end,
      "open FineCmdline",
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
    },
    ["<leader>c"] = {
      function()
        vim.cmd "lua require('silicon').visualise_cmdline({to_clip = true})"
      end,
      "Copy code to png into clipboard",
    },
  },
}

return M
