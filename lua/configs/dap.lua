local dap = require("dap")

local mason_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb.exe"

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = mason_path,
    args = { "--port", "${port}" },
    detached = false,
  },
}

dap.configurations.cpp = {
  {
    name = "Launch File",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.expand("%:p:r") .. ".exe"
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#ff0000' })
vim.fn.sign_define('DapBreakpoint', { 
  text = '●', 
  texthl = 'DapBreakpoint',
  linehl = '', 
  numhl = '' 
})

vim.fn.sign_define('DapStopped', { 
  text = '▶', 
  texthl = 'DiagnosticWarn', 
  linehl = 'Visual', 
  numhl = 'DiagnosticWarn' 
})

dap.configurations.c = dap.configurations.cpp
