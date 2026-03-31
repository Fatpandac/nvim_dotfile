local M = {}

local function select_one_or_multi(prompt_bufnr)
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require("telescope.actions").close(prompt_bufnr)
    for _, entry in pairs(multi) do
      if entry.path ~= nil then
        vim.cmd(string.format("%s %s", "edit", entry.path))
      end
    end
  else
    require("telescope.actions").select_default(prompt_bufnr)
  end
end

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "vue",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "python",
    "markdown",
    "markdown_inline",
  },
  indent = {
    enable = true,
    disable = {
      "python",
    },
  },
}

M.telescope = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = {
      "node_modules/",
      "^build/",
      "^dist/",
      "^release/",
      "yarn.lock$",
    },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { COLORTERM = "truecolor" },
    file_previewer = require("configs.image_preview").file_previewer,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    buffer_previewer_maker = require("configs.image_preview").buffer_previewer_maker,
    mappings = {
      n = {
        ["q"] = require("telescope.actions").close,
        ["<CR>"] = select_one_or_multi,
      },
      i = {
        ["<CR>"] = select_one_or_multi,
      },
    },
  },
  extensions_list = {
    "themes",
    "terms",
    "fzf",
    "ast_grep",
    file_browser = { hijack_netrw = true },
  },
}

return M
