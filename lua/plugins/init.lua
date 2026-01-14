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
    build = ":TSUpdate",

    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },

    opts = {
      install = { compilers = { "zig" } },
      ensure_installed = {
        "vim", "lua", "vimdoc", "html", "css", 
        "javascript", "typescript", "python", "cpp", "markdown"
      },
      highlight = { enable = true },
textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer", -- Select around function
            ["if"] = "@function.inner", -- Select inside function
            ["ac"] = "@class.outer",    -- Select around class
            ["ic"] = "@class.inner",    -- Select inside class
            ["aa"] = "@parameter.outer", -- Select around argument
            ["ia"] = "@parameter.inner", -- Select inside argument
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer", -- Jump to next function start
            ["]c"] = "@class.outer",    -- Jump to next class start
          },
          goto_previous_start = {
            ["[f"] = "@function.outer", -- Jump to prev function start
            ["[c"] = "@class.outer",    -- Jump to prev class start
          },
        },
      },


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
      vim.g.vimtex_view_method = "general" 
    end
  },
{
  "stevearc/oil.nvim",
  opts = {},
  lazy = false,
},
{
  "mfussenegger/nvim-dap",
  config = function()
    require "configs.dap" 
  end,
},
}
