#!/usr/bin/env lua

local settings = require 'settings'
local icons = require 'icons'

local battery = Sbar.add('item', 'battery', {
  position = 'right',
  update_freq = 120,
})

local function battery_update()
  Sbar.exec('pmset -g batt', function(batt_info)
    local icon = icons.battery_0

    if string.find(batt_info, 'AC Power') then
      icon = icons.battery_charging
    else
      local found, _, charge = batt_info:find '(%d+)%%'
      if found then
        charge = tonumber(charge)
      end

      if found and charge > 80 then
        icon = icons.battery_100
      elseif found and charge > 60 then
        icon = icons.battery_75
      elseif found and charge > 40 then
        icon = icons.battery_50
      elseif found and charge > 20 then
        icon = icons.battery_25
      else
        icon = icons.battery_0
      end
    end

    -- get battery percentage
    local percentage = string.match(batt_info, '(%d+)%%')

    battery:set { icon = icon, label = percentage .. '%' }
  end)
end

battery:subscribe({ 'routine', 'power_source_change', 'system_woke' }, battery_update)
