return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', 
    opts = require "configs.conform",
  },

  -- Markdown Rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      latex = { enabled = true },
    },
  },
{
    "nvim-treesitter/nvim-treesitter",
    -- Use 'build' to ensure it runs when updated
    build = ":TSUpdate",
    opts = {
      install = { compilers = { "zig" } },
      ensure_installed = {
        "vim", "lua", "vimdoc", "html", "css", 
        "javascript", "typescript", "python", "cpp", "markdown"
      },
      highlight = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      require("nvim-treesitter.install").compilers = { "zig" }
    end,
  },
{
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install", 
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },
  -- LATEX: Compilation and Features
  {
    "lervag/vimtex",
    lazy = false,     -- We want this to load immediately to detect filetypes
    init = function()
      -- Use a generic viewer or a specific one like SumatraPDF if you have it
      vim.g.vimtex_view_method = "general" 
    end
  },
}
