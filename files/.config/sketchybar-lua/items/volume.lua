#!/usr/bin/env lua

local icons = require 'icons'

local volume = Sbar.add('item', 'volume', {
  position = 'right',
})

volume:subscribe('volume_change', function(env)
  local vol = tonumber(env.INFO)
  local icon = icons.volume_mute

  if vol > 60 then
    icon = icons.volume_high
  elseif vol > 30 then
    icon = icons.volume_medium
  elseif vol > 10 then
    icon = icons.volume_low
  end

  volume:set { icon = icon, label = env.INFO .. '%' }
end)
