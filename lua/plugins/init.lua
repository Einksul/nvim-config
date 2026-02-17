return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = {
      ensure_installed = {
        "lua-language-server", "clangd", "codelldb", "pyright", 
        "stylua", "prettier", "latexindent"
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})
    end,
  },

  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', 
    opts = require "configs.conform",
  },

  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
  },
  {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    config = function()
      require("image").setup({
        backend = "kitty",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "markdown", "vimwiki" },
          },
        },
        max_height_window_percentage = 50,
      })
    end
  },

  -- Markdown Rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      latex = { enabled = true },
      html = { enabled = true },
      render_modes = { 'n', 'c', 'i', 'v', 'V' },
      anti_conceal = { enabled = false },
    },
    config = function(_, opts)
        require("render-markdown").setup(opts)
    end,
  },
{
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",

    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },

    config = function()
      -- Setup Treesitter
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "vim", "lua", "vimdoc", "html", "css", 
          "javascript", "typescript", "python", "cpp", "markdown", "markdown_inline", "regex", "latex"
        },
        highlight = { enable = true },
      })
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
