return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = function(_, opts)
      local uv = vim.uv or vim.loop

      -- Root detection: look upward for common project markers
      local function find_project_root(start)
        local markers = { ".git", "pnpm-workspace.yaml" }
        local dir = start or vim.fn.getcwd()

        dir = vim.fs.normalize(dir)

        -- climb upwards until filesystem root
        while dir and dir ~= "/" do
          for _, m in ipairs(markers) do
            if uv.fs_stat(dir .. "/" .. m) then
              return dir
            end
          end

          local parent = vim.fs.dirname(dir)

          if not parent or parent == dir then
            break
          end

          dir = parent
        end

        return vim.fn.getcwd()
      end

      -- Find the first matching file upwards from root
      local function find_upwards(name, startdir)
        local found = vim.fs.find(name, {
          path = startdir or vim.fn.getcwd(),
          upward = true,
          stop = vim.loop.os_homedir(),
        })

        return found and found[1] or nil
      end

      local function read_file(path)
        if path and vim.fn.filereadable(path) == 1 then
          return table.concat(vim.fn.readfile(path), "\n")
        end

        return nil
      end

      local fallback_file = vim.fn.expand("~/.dotfiles/instructions/vscode/copilot-instructions.md")

      -- Resolve best file: project → fallback
      local function resolve_rules_file()
        local root = find_project_root(vim.fn.getcwd())
        local project_file = find_upwards(".github/copilot-instructions.md", root)

        if project_file and vim.fn.filereadable(project_file) == 1 then
          return project_file
        end

        if vim.fn.filereadable(fallback_file) == 1 then
          return fallback_file
        end

        return nil
      end

      local function load_rules()
        local picked = resolve_rules_file()
        local rules = read_file(picked) or ""

        if picked and rules ~= "" then
          vim.notify(("CopilotChat: loaded rules from %s"):format(picked), vim.log.levels.INFO)
        else
          vim.notify("CopilotChat: no rules file found (project or fallback)", vim.log.levels.WARN)
        end

        return rules
      end

      -- Initial load (must be a string or table, not a function)
      opts.system_prompt = load_rules()

      -- Helper to (re)apply at runtime
      local function reload_rules()
        local rules = load_rules()
        local ok, chat = pcall(require, "CopilotChat")

        if ok and chat and type(chat.setup) == "function" then
          chat.setup(vim.tbl_extend("force", opts, { system_prompt = rules }))
          vim.notify("CopilotChat: system_prompt reloaded", vim.log.levels.INFO)
        else
          -- Fallback: set config field if available, otherwise user can restart
          pcall(function()
            require("CopilotChat.config").options.system_prompt = rules
            vim.notify("CopilotChat: system_prompt updated in config", vim.log.levels.INFO)
          end)
        end
      end

      -- User command to force reload
      vim.api.nvim_create_user_command("CopilotChatReloadRules", reload_rules, {})

      -- Auto-reload when either file is written
      -- 1) project file anywhere under current workspace
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("CopilotChatRulesAutoReload", { clear = true }),
        pattern = {
          "**/.github/copilot-instructions.md",
          fallback_file, -- absolute path is fine
        },
        callback = function()
          reload_rules()
        end,
        desc = "Reload CopilotChat rules when instructions file is saved",
      })

      return opts
    end,
  },
}
