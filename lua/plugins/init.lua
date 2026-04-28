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
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      image = {
        enabled = true,
        doc = {
          inline = false, -- Try disabling inline to see if it improves float behavior
          float = true,   -- Explicitly enable floats if supported
          max_width = 50,
          max_height = 20,
        },
        math = {
          enabled = true,
          typst = true,
          scale = 1.5, -- Increase scale for better visibility in floats
        },
      },
      terminal = {
        enabled = true,
      },
    },
    config = function(_, opts)
      -- Fix for ImageMagick 6 (Ubuntu 22.04)
      local bin_path = vim.fn.expand("~/.config/nvim/bin")
      vim.env.PATH = bin_path .. ":" .. vim.env.PATH
      
      require("snacks").setup(opts)
    end,
  },

  -- PDF Reader integration with snacks.nvim
  {
    "r-pletnev/pdfreader.nvim",
    lazy = false,
    dependencies = { "folke/snacks.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      require("pdfreader").setup()
    end,
  },

  -- Markdown Rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "tex" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      file_types = { "markdown", "tex" },
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
      vim.g.vimtex_view_method = "zathura" 
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
{
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
      },
      source_selector = {
        winbar = true,
        statusline = false,
        sources = {
          { source = "filesystem" },
          { source = "buffers" },
          { source = "git_status" },
          { source = "document_symbols" },
        },
      },
      window = {
        mappings = {
          ["V"] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            local cmd = string.format("TERM=xterm-256color CACA_DRIVER=ncurses mpv --vo=tct --really-quiet \"%s\"", path)
            require("snacks").terminal.open(cmd, {
              win = { position = "float" },
            })
          end,
          ["P"] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            -- pdftotext with page separators for easier navigation in less
            local cmd = string.format("pdftotext -layout -nopgbrk \"%s\" - | less", path)
            require("snacks").terminal.open(cmd, {
              win = { position = "float" },
            })
          end,
          ["Z"] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.jobstart({"zathura", path}, {detach = true})
            vim.notify("Opening in Zathura: " .. vim.fn.fnamemodify(path, ":t"))
          end,
          ["<cr>"] = function(state)
            local node = state.tree:get_node()
            if node.type == "file" and node.ext == "pdf" then
              vim.cmd("edit " .. node:get_id())
              -- Ensure we are in the buffer
              vim.cmd("wincmd l") 
            else
              state.commands["open"](state)
            end
          end,
          ["Y"] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            local rel_path = vim.fn.fnamemodify(path, ":~:.")
            vim.fn.setreg("+", rel_path)
            vim.fn.setreg('"', rel_path)
            vim.notify("Copied relative path: " .. rel_path)
          end,
          ["gy"] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path)
            vim.fn.setreg('"', path)
            vim.notify("Copied absolute path: " .. path)
          end,
        },
      },
    })
  end,
},
{
  "hat0uma/csvview.nvim",
  config = function()
    require("csvview").setup()
  end,
  cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
},
}
