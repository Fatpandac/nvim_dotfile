local null_ls = require "null-ls"

local b = null_ls.builtins

local function add_source(sources, source)
  if source then
    table.insert(sources, source)
  end
end

local sources = {}

add_source(sources, b.formatting.gofmt)
add_source(sources, b.formatting.goimports)
add_source(sources, b.formatting.prettier)

if b.formatting.black then
  add_source(sources, b.formatting.black.with { filetypes = { "python" } })
end

null_ls.setup {
  debug = true,
  sources = sources,
}
