local wezterm = require("wezterm")

local function font_with_fallback(name, params)
  local names = { name, "Apple Color Emoji", "azuki_font" }
  return wezterm.font_with_fallback(names, params)
end

local font_name = "Comic Code Ligatures"

return {
  front_end = "OpenGL",

  color_scheme = 'Catppuccin Mocha',

  -- Font Config
  font = font_with_fallback(font_name),
  font_rules = {
    {
      italic = true,
      font = font_with_fallback(font_name, { italic = true }),
    },
    {
      italic = false,
      font = font_with_fallback(font_name, { bold = true }),
    },
    {
      intensity = "Bold",
      font = font_with_fallback(font_name, { bold = true }),
    },
  },
  warn_about_missing_glyphs = true,
  font_size = 13,
  line_height = 1.0,
  dpi = 96.0,

  -- Cursor style
  default_cursor_style = "BlinkingUnderline",

  -- X11
  enable_wayland = true,

  -- Aesthetic Night Colorscheme
  bold_brightens_ansi_colors = true,
  -- Padding
  window_padding = {
    left = 25,
    right = 25,
    top = 25,
    bottom = 25,
  },

  -- Tab Bar
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  show_tab_index_in_tab_bar = false,
  tab_bar_at_bottom = true,

  -- General
  automatically_reload_config = true,
  inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
  window_background_opacity = 0.8,
  window_close_confirmation = "NeverPrompt",
  window_frame = { active_titlebar_bg = "#45475a", font = font_with_fallback(font_name, { bold = true }) },
}
