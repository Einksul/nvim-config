require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>e", function() vim.diagnostic.open_float() end, { desc = "Show line diagnostic" })
map("n", "<leader>cc", function()
  vim.cmd("write")
  
  local filepath = vim.fn.expand("%:p")
  local name = vim.fn.expand("%:t:r")
  local output_name = name .. ".exe" 
  local output_path = vim.fn.expand("%:p:h") .. "\\" .. output_name

  local flags = "-Wall -Werror -g"
  local cmd = string.format('cmd /c "cls && g++ -std=c++20 %s "%s" -o "%s" && "%s""\r', flags, filepath, output_path, output_path)

  require("nvchad.term").runner { 
    cmd = cmd, 
    id = "floatTerm", 
    pos = "float",
    clear_cmd = " "
  }
end, { desc = "compile c++ (float)" })

local dap = require("dap")
map("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint" })
map("n", "<leader>ds", function() dap.continue() end, { desc = "DAP Start/Continue" })
map("n", "<leader>di", function() dap.step_into() end, { desc = "DAP Step Into" })
map("n", "<leader>do", function() dap.step_over() end, { desc = "DAP Step Over" })
map("n", "<leader>dO", function() dap.step_out() end, { desc = "DAP Step Out" })
map("n", "<leader>dt", function() dap.terminate() end, { desc = "DAP Terminate" })
map("n", "<leader>dh", function() require("dap.ui.widgets").hover() end, { desc = "DAP Hover Variable" })
map("n", "<leader>du", function() 
  local widgets = require("dap.ui.widgets")
  widgets.sidebar(widgets.scopes).toggle() 
end, { desc = "DAP Debug UI (Scopes)" })
