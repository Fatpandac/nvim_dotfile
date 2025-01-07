local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {
  -- webdev stuff
  b.formatting.eslint_d,
  -- so prettier works only on these filetypes
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css", "vue", "json"} },
  b.formatting.black.with { filetypes = { "python" } },

  -- Lua
  b.formatting.stylua,
}

null_ls.setup {
  debug = true,
  sources = sources,
}

