local null_ls = require "null-ls"

local builtins = null_ls.builtins

local function add_source(sources, source)
  if source then
    table.insert(sources, source)
  end
end

local sources = {}

add_source(sources, builtins.formatting.gofmt)
add_source(sources, builtins.formatting.goimports)
add_source(sources, builtins.formatting.prettier)

if builtins.formatting.black then
  add_source(sources, builtins.formatting.black.with { filetypes = { "python" } })
end

null_ls.setup {
  debug = true,
  sources = sources,
}
