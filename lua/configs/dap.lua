local dap = require("dap")
local is_windows = vim.fn.has('win32') == 1
local extension = is_windows and ".exe" or ""

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    -- Append extension only if on Windows
    command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb" .. extension,
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
      -- Append extension only if on Windows
      return vim.fn.expand("%:p:r") .. extension
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
