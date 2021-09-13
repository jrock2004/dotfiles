local icons = Lvim.icons

require('lspkind').init({
  with_text = false,
  symbol_map = {
    Text = icons.abc,
    Method = icons.container,
    Function = icons.container,
    Constructor = icons.container,
    Variable = '[' ..icons.hexCutOut.. ']',
    Class = icons.treeDiagram,
    Interface = icons.toggleSelected,
    Module = icons.curlies,
    Property = icons.wrench,
    Unit = icons.ruler,
    Value = icons.ruler,
    Enum = icons.rectangleIntersect,
    Keyword = icons.paragraph,
    Snippet = icons.emptyBox,
    Color = icons.paint,
    File = icons.fileNoLinesBg,
    Folder = icons.folderOpen,
    EnumMember = icons.sort,
    Constant = icons.box,
    Struct = icons.cubeTree
  },
})
