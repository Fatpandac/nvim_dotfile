---@type MappingsTable
local M = {}

M.general = {
  n = {
    ["<leader>X"] = { ":BufOnly<CR>", "clear all buffer without current" },
    ["<leader>fa"] = { ":Telescope ast_grep<CR>", "Telescope by word" },
    ["gx"] = { "<esc>:URLOpenUnderCursor<CR>", "open current url" },
    ["<leader>fc"] = { ":Telescope commands<CR>", "open command" },
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
      "jump to previous cursor position",
    },
    ["cl"] = {
      function()
        local line = vim.fn.line "."
        local file = vim.fn.expand "%"
        vim.fn.setreg("+", file .. ":" .. line)
      end,
      "Copy current cursor position to clipboard",
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
    ["gbc"] = { "<Nop>", "Disable gcc" },
    ["<leader>f"] = {
      function()
        require("fine-cmdline").open({ default_value = "find " })
      end,
      "open find",
    },
  }
}

return M
