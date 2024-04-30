local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {
  -- webdev stuff
  -- b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier,
  b.formatting.rustywind,

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,
  -- Rust
  b.formatting.rustfmt
}

null_ls.setup {
  sources = sources,
}
