#!/usr/bin/env lua

local settings = require 'settings'
local icons = require 'icons'

local cpu = Sbar.add('item', 'cpu', {
  position = 'right',
  update_freq = 2,
  icon = icons.cpu,
})

local function cpu_update()
  Sbar.exec('sh ~/.config/sketchybar/plugins/cpu.sh', function(percent)
    cpu:set { label = percent }
  end)
end
-- local core_count = ''
-- local core_count = Sbar.exec 'sysctl -n machdep.cpu.thread_count'
-- local cpu_info = ''
-- local cpu_sys = ''
-- local cpu_user = ''

--   Sbar.exec('sysctl -n machdep.cpu.thread_count', function(core_count)
--     Sbar.exec('ps -eo pcpu,user', function(cpu_info)
--       cpu:set { label = cpu_info }
--
--       Sbar.exec(
--         'echo ' .. cpu_info .. ' | grep -v $(whoami)',
--         -- 'echo '
--         --   .. cpu_info
--         --   .. ' | grep -v $(whoami) | sed "s/[^ 0-9.]//g" | awk "{sum+=$1} END {print sum/(100.0 * '
--         --   .. core_count
--         --   .. ')}"',
--         function(cpu_sys)
--           cpu:set { label = cpu_sys }
--           --     Sbar.exec(
--           --       'echo '
--           --         .. cpu_info
--           --         .. ' | grep $(whoami) | sed "s/[^ 0-9.]//g" | awk "{sum+=$1} END {print sum/(100.0 * '
--           --         .. core_count
--           --         .. ')}"',
--           --       function(cpu_user)
--           --         Sbar.exec(
--           --           'echo "' .. cpu_sys .. ' ' .. cpu_user .. '" | awk "{printf "%.0f\n", ($1 + $2)*100}"',
--           --           function(cpu_percentage)
--           --             cpu:set { label = cpu_info }
--           --           end
--           --         )
--           --       end
--           --     )
--         end
--       )
--     end)
--   end)
-- end

cpu:subscribe({ 'forced', 'routine' }, cpu_update)
