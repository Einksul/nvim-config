local nvlsp = require "nvchad.configs.lspconfig"

local servers = { "html", "cssls", "ts_ls", "pyright", "texlab" }

for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    install_pkgs = { lsp },
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
  
  vim.lsp.enable(lsp)
end

vim.lsp.config("clangd", {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--query-driver=C:/Strawberry/c/bin/g*",
  },
  init_options = {
      fallbackFlags = {
        "--target=x86_64-w64-mingw32",
        "-std=c++17",
      },
    },
  })

vim.lsp.enable("clangd")
