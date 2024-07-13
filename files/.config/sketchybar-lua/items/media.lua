#!/usr/bin/env lua

local icons = require 'icons'
local colors = require 'colors'

local media = Sbar.add('item', 'media', {
  background = {
    drawing = 'off',
  },
  icon = {
    color = colors.accent,
    padding_left = 0,
  },
  label = {
    color = colors.accent,
    max_chars = 20,
  },
  scroll_texts = 'on',
  position = 'e',
  updates = true,
})

media:subscribe('media_change', function(env)
  media:set {
    drawing = (env.INFO.state == 'playing') and true or false,
    label = env.INFO.artist .. ': ' .. env.INFO.title,
    icon = icons.music,
  }
end)
