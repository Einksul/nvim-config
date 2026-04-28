require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- Ensure PDF Reader mappings are active in PDF buffers
autocmd("FileType", {
  pattern = "pdf",
  callback = function()
    local map = vim.keymap.set
    local opts = { buffer = true, silent = true }
    
    -- Force pdfreader mappings if they aren't loading
    map("n", "n", "<cmd>PDFReader n<CR>", opts)
    map("n", "p", "<cmd>PDFReader p<CR>", opts)
    map("n", "z", "<cmd>PDFReader z<CR>", opts)
    map("n", "x", "<cmd>PDFReader x<CR>", opts)
    map("n", "q", "<cmd>PDFReader q<CR>", opts)
  end,
})

-- Enable rendering for LaTeX files by setting conceallevel
autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
})
