local utils = require "lvim.utils"
-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- leader
lvim.leader = ","

-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true

-- misc settings
lvim.transparent_window = true
lvim.format_on_save.enabled = true

-- custom keymaps
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<leader>,"] = ":w<cr>"
lvim.keys.normal_mode["Y"] = "y$"

-- colorscheme
-- lvim.colorscheme = "oxocarbon"

-- whichkey updates
lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>TroubleToggle<cr>", "trouble" },
  w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
  d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

-- auto commands
lvim.autocommands = {
  {
    { "BufWinEnter", "BufRead", "BufNewFile" },
    {
      pattern = "*",
      command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
    }
  },
  {
    "BufRead", {
    pattern = { "*.dockerfile*" },
    command = "set filetype=dockerfile"
  },
  },
  {
    "BufRead", {
    pattern = { "*.handlebars*" },
    command = "set filetype=handlebars"
  },
  },
  {
    "BufRead", {
    pattern = { "*.env*" },
    command = "set filetype=sh"
  },
  },
  {
    "FileType", {
    pattern = { "gitcommit", "markdown" },
    callback = function()
      vim.wo.wrap = true
      vim.wo.spell = true
    end,
  }
  },
  {
    "TextYankPost", {
    callback = function()
      vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
    end,
  }
  },
}

-- default plugin overrides
lvim.builtin.bufferline.active = false

-- my plugins
lvim.plugins = {
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup()     -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
        require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
      end, 100)
    end,
  },
  {
    "tpope/vim-surround",
    -- setup = function()
    --  vim.o.timeoutlen = 500
    -- end
  },
  {
    "tpope/vim-repeat",
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "css", "scss", "html", "javascript" }, {
        RGB = true,      -- #RGB hex codes
        RRGGBB = true,   -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true,   -- CSS rgb() and rgba() functions
        hsl_fn = true,   -- CSS hsl() and hsla() functions
        css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },
  {
    "dmmulroy/tsc.nvim",
    config = function()
      require("tsc").setup({
        enable_progress_notifications = true,
      })
    end,
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000"
      })
    end,
  },
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        lsp = {
          hover = {
            enabled = false
          },
          signature = {
            enabled = false
          }
        }
      })
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
  {
    "ggandor/flit.nvim",
    config = function()
      require("flit").setup({
        keys = { f = 'f', F = 'F', t = 't', T = 'T' },
        -- A string like "nv", "nvo", "o", etc.
        labeled_modes = "v",
        multiline = true,
        -- Like `leap`s similar argument (call-specific overrides).
        -- E.g.: opts = { equivalence_classes = {} }
        opts = {}
      })
    end,
    dependencies = {
      "ggandor/leap.nvim"
    }
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
  },
}

-- formatters
local formatters = require "lvim.lsp.null-ls.formatters"

formatters.setup {
  {
    name = "prettier",
    args = { "--config-precedence", "prefer-file" },
    filetypes = { "typescript", "typescriptreact" },
  }
}

-- linters
local linters = require "lvim.lsp.null-ls.linters"

local function eslint_config()
  if utils.is_file(".eslintrc.json") then
    return ".eslintrc.json"
  elseif utils.is_file(".eslintrc.js") then
    return ".eslintrc.js"
  elseif utils.is_file(".eslintrc.yaml") then
    return ".eslintrc.yaml"
  elseif utils.is_file(".eslintrc.yml") then
    return ".eslintrc.yml"
  elseif utils.is_file(".eslintrc") then
    return ".eslintrc"
  end

  local f = io.open("package.json", "r")

  if f ~= nil then
    local package = f:read("*all")

    if package:find('"eslintConfig"') then
      io.close(f)
      return "package.json"
    end

    io.close(f)

    return "package.json"
  end

  return nil
end

linters.setup {
  {
    command = "eslint",
    filetypes = { "typescript", "typescriptreact" },
    args = { "--config", eslint_config() },
  }
}

-- lsp managers
require("lvim.lsp.manager").setup("emmet_ls", {
  cmd = { "emmet-ls", "--stdio" },
  filetypes = {
    "html",
    "css",
    "scss",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "haml",
    "xml",
    "xsl",
    "pug",
    "slim",
    "sass",
    "stylus",
    "less",
    "sss",
    "hbs",
    "handlebars",
  },
  init_options = {
    emmet = {
      showExpandedAbbreviation = "always",
      showAbbreviationSuggestions = true,
    },
  },
})

-- require("lvim.lsp.manager").setup "tailwindcss"
