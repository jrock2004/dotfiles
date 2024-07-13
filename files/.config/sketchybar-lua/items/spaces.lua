#!/usr/bin/env lua

local colors = require 'colors'
local icons = require 'icons'

local spaces = {}

local function space_selection(env)
  if env.SELECTED == 'true' then
    Sbar.set(env.NAME, {
      background = {
        drawing = 'on',
        color = colors.accent,
      },
      label = {
        color = colors.bar,
      },
      icon = {
        color = colors.bar,
      },
    })
  else
    Sbar.set(env.NAME, {
      background = {
        drawing = 'off',
      },
      label = {
        color = colors.accent,
      },
      icon = {
        color = colors.accent,
      },
    })
  end
end

for i = 1, 10, 1 do
  local space = Sbar.add('space', {
    associated_space = i,
    icon = i,
    label = {
      font = ' sketchybar-app-font:Regular:16.0',
      padding_right = 20,
      y_offset = -1,
    },
  })

  space:subscribe('space_change', space_selection)
end

local seperator = Sbar.add('space_separator', {
  position = 'left',
  -- icon = icons.separator,
  icon = {
    color = colors.accent,
    padding_left = 4,
  },
})

-- seperator:subscribe('space_separator', function(env)
--   print(env)
-- end)
