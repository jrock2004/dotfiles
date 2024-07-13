#!/usr/bin/env lua

local settings = require 'settings'
local colors = require 'colors'

Sbar.default {
  background = {
    color = colors.itembg,
    corner_radius = 5,
    height = 24,
  },
  padding_left = settings.paddings,
  padding_right = settings.paddings,
  updates = 'when_shown',
  icon = {
    color = colors.text,
    font = {
      family = settings.nerd_font,
      style = 'Semibold',
      size = 15.0,
    },
    padding_left = 10,
    padding_right = 4,
  },
  label = {
    color = colors.text,
    font = {
      family = settings.font,
      style = 'Semibold',
      size = 15.0,
    },
    padding_left = 4,
    padding_right = 10,
  },
}
