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
  local output_name = name 
  local output_path = vim.fn.expand("%:p:h") .. "/" .. output_name

  local flags = "-Wall -Werror -g"
  local cmd = string.format('g++ -std=c++20 %s "%s" -o "%s" && "%s"', flags, filepath, output_path, output_path)

  require("nvchad.term").runner { 
    cmd = cmd, 
    id = "floatTerm", 
    pos = "float",
    clear_cmd = "clear"
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

-- SHARED HELPER: Generates the ID and Clean Text
-- Returns: clean_text, clean_id
local function get_id_info(text)
  local clean_text = text:match("^%s*(.-)%s*$") -- Trim whitespace
  -- Generate ID: lowercase -> replace spaces with dashes -> remove symbols
  local clean_id = clean_text:gsub("%s+", "-"):gsub("[^%a%d%-]", ""):lower() .. "-def"
  return clean_text, clean_id
end

-- ============================================================
-- 1. DEFINE MAPPINGS (<leader>dq)
-- Wraps text in <span id="...">...</span>
-- ============================================================

local function apply_def(text, is_visual)
  local clean_text, clean_id = get_id_info(text)
  local result = string.format('<span id="%s"><b><u>%s</u></b></span>', clean_id, clean_text)
  
  if is_visual then
    vim.fn.setreg("d", result)
    vim.cmd('normal! gv"dp')
  else
    vim.cmd('normal! "_diw')
    vim.api.nvim_put({result}, "c", false, true)
  end
end

map("v", "<leader>dq", function() 
  vim.cmd('normal! gv"dy') -- Yank selection
  apply_def(vim.fn.getreg("d"), true) 
end, { desc = "Create Definition (Visual)" })

map("n", "<leader>dq", function() 
  apply_def(vim.fn.expand("<cword>"), false) 
end, { desc = "Create Definition (Word)" })


-- ============================================================
-- 2. LINK MAPPINGS (<leader>dl)
-- Checks if definition exists, then wraps in [text](#id)
-- ============================================================

local function apply_link(text, is_visual)
  local clean_text, clean_id = get_id_info(text)
  
  -- Search for the ID in the file (n = do not move cursor, w = wrap around file)
  -- We look for the exact string: id="clean_id"
  local search_pattern = string.format('id="%s"', clean_id)
  local found_line = vim.fn.search(search_pattern, "nw")
  
  if found_line > 0 then
    -- Found! Create the link
    local result = string.format('[%s](#%s)', clean_text, clean_id)
    
    if is_visual then
      vim.fn.setreg("d", result)
      vim.cmd('normal! gv"dp')
    else
      vim.cmd('normal! "_diw')
      vim.api.nvim_put({result}, "c", false, true)
    end
    print("Linked to line " .. found_line)
  else
    -- Not found
    print("No definition found for ID: " .. clean_id)
  end
end

map("v", "<leader>dl", function() 
  vim.cmd('normal! gv"dy') -- Yank selection
  apply_link(vim.fn.getreg("d"), true) 
end, { desc = "Link to Definition (Visual)" })

map("n", "<leader>dl", function() 
  apply_link(vim.fn.expand("<cword>"), false) 
end, { desc = "Link to Definition (Word)" })

-- Neo-tree and CSV View mappings
map("n", "<C-n>", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
map("n", "<leader>nt", "<cmd>Neotree toggle<CR>", { desc = "Neo-tree Toggle" })
map("n", "<leader>ng", "<cmd>Neotree float git_status<CR>", { desc = "Neo-tree Git Status" })
map("n", "<leader>ns", "<cmd>Neotree float document_symbols<CR>", { desc = "Neo-tree Document Symbols" })
map("n", "<leader>cv", "<cmd>CsvViewToggle display_mode=border header_lnum=1<CR>", { desc = "Toggle CSV View" })

map("n", "<leader>vp", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file ~= "" then
    local cmd = string.format("TERM=xterm-256color CACA_DRIVER=ncurses mpv --vo=tct --really-quiet \"%s\"", file)
    require("snacks").terminal.open(cmd, {
      win = { position = "float" },
    })
  end
end, { desc = "Play Video in Float (mpv terminal)" })

