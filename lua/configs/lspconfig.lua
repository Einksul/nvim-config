local nvlsp = require "nvchad.configs.lspconfig"

-- 1. Define standard servers
local servers = { "html", "cssls", "ts_ls", "pyright", "texlab" }

-- 2. Setup standard servers using the new 0.11 API
for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    install_pkgs = { lsp }, -- For Mason integration
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
  
  -- Trigger the start of the server
  vim.lsp.enable(lsp)
end

-- 3. Setup clangd with Zig-specific flags
vim.lsp.config("clangd", {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--query-driver=**\\zig.exe", -- Link to Zig headers
  },
})

vim.lsp.enable("clangd")
