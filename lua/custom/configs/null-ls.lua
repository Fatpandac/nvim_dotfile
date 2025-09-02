local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {
  b.formatting.gofmt,
  b.formatting.goimports,
  -- so prettier works only on these filetypes
  b.formatting.prettier,
  b.formatting.black.with { filetypes = { "python" } },
  b.formatting.jq.with { filetypes = { "json" } },
}

null_ls.setup {
  debug = true,
  sources = sources,
}
