DATA_PATH = vim.fn.stdpath 'data'
DOTFILES_PATH = os.getenv 'HOME' .. '/.dotfiles'
NVIM_PATH = os.getenv 'HOME' .. '/.config/nvim'
SUMNEKO_PATH = os.getenv 'HOME' .. '/lua-language-server'

Lvim = {
  leader = ',',
  colorscheme = 'onedarker',
  packerInstallPath = DATA_PATH .. '/site/pack/packer/start/packer.nvim',
  vsnip_dir = NVIM_PATH .. '/snippets',

  eslintChecker = function ()
    local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)
    local packageJson = vim.fn.glob("package.json", 0, 1)

    if not vim.tbl_isempty(eslintrc) then
      return true
    end

    if not vim.tbl_isempty(packageJson) then
      if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
        return true
      end
    end

    return false
  end,

  formatters = {
    eslint = function()
      local eslint = 'eslint'
      local localEslint = 'node_modules/.bin/eslint'

      if vim.fn.executable(localEslint) == 1 then
        eslint = localEslint
      elseif vim.fn.executable(eslint) == 1 then
        eslint = 'eslint'
      else
        return {}
      end

      return {
        lintCommand = eslint .. " -f unix --stdin --stdin-filename ${INPUT}",
        -- lintCommand = "eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}",
        lintSource = "eslint",
        lintIgnoreExitCode = true,
        lintStdin = true,
        lintFormats = {"%f:%l:%c: %m"},
        formatCommand = eslint .. " --fix-to-stdout --stdin --stdin-filename ${INPUT}",
        -- formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename ${INPUT}",
        formatStdin = true
      }
    end,
    lua = function()
      -- TODO: Need to fix this at somet point
      return {
        formatCommand = "lua-format --tab-width=2 --no-use-tab --double-quote-to-single-quote --stdin",
        formatStdin = true
      }
    end,
    prettier = function()
      local prettier = 'prettier'
      local localPrettier = 'node_modules/.bin/prettier'

      if vim.fn.executable(localPrettier) == 1 then
        prettier = localPrettier
      elseif vim.fn.executable(prettier) == 1 then
        prettier = 'prettier'
      else
        return {}
      end

      return {
        formatCommand = prettier .. ' --config-precedence prefer-file --stdin-filepath ${INPUT}',
        -- formatCommand = 'prettier --config-precedence prefer-file --stdin-filepath ${INPUT}',
        formatStdin = true,
      }
    end,
  },

  icons = {
    bomb = '  ',
    scissors = '  ',
    warningCircle = '  ',
    warningTriangle = '  ',
    warningTriangleNoBg = '  ',
    info = '  ',
    infoNoBg = '  ',
    error = '  ',
    errorSlash = ' ﰸ ',
    fileNoBg = '  ',
    fileCutCorner = '  ',
    fileBg = '  ',
    fileNoLines = '  ',
    fileNoLinesBg = '  ',
    folder = '  ',
    folderOpen = '  ',
    folderNoBg = '  ',
    folderOpenNoBg = '  ',
    scope = '  ',
    pie = '  ',
    ribbon = '  ',
    ribbonNoBg = '  ',
    database = ' ﬘ ',
    box = '  ',
    key = '  ',
    toggleSelected = ' 蘒',
    curlies = '  ',
    lightbulb = '  ',
    m = ' m ',
    f = '  ',
    settings = '  ',
    gears = '  ',
    container = '  ',
    threeDots = '  ',
    threeDotsBoxed = '  ',
    calculator = '  ',
    hexCutOut = '  ',
    vim = '  ',
    pencil = '  ',
    tree = '  ',
    treeDiagram = '  ',
    happyFace = ' ﲃ ',
    emptyBox = '  ',
    fileCopy = '  ',
    timer = '  ',
    t = '  ',
    abc = '  ',
    numbers = '  ',
    wrench = '  ',
    ruler = ' 塞',
    rectangleIntersect = ' 練',
    paragraph = '  ',
    paint = '  ',
    sort = '  ',
    cubeTree = '  ',
    search = '  ',
    arrowReturn = '  ',
    git = '  ',
    gitAdd = '  ',
    gitChange = ' 柳',
    gitRemove = '  ',
  },
  colors = {
    bg = '#2E2E2E',
    yellow = '#DCDCAA',
    dark_yellow = '#D7BA7D',
    cyan = '#4EC9B0',
    green = '#608B4E',
    light_green = '#B5CEA8',
    string_orange = '#CE9178',
    orange = '#FF8800',
    purple = '#C586C0',
    magenta = '#D16D9E',
    grey = '#858585',
    blue = '#569CD6',
    vivid_blue = '#4FC1FF',
    light_blue = '#9CDCFE',
    red = '#D16969',
    error_red = '#F44747',
    info_yellow = '#FFCC66'
  },
}

return Lvim
