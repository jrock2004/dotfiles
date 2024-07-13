#!/usr/bin/env lua

local settings = require 'settings'
local icons = require 'icons'

local today = Sbar.add('item', 'calendar', {
  position = 'right',
  update_freq = 30,
})

local function date_update()
  local date = os.date(settings.date_format)

  today:set { icon = icons.calendar, label = date }
end

today:subscribe({ 'forced', 'routine' }, date_update)
