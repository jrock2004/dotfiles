--------------------------------------------------------------------------------
-- IMPORTS
--------------------------------------------------------------------------------

-- Foundations
import XMonad -- standard xmonad library
import XMonad.Config.Desktop -- default desktopConfig
import System.IO

-- Data
import Data.Monoid

-- Layouts
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns

import XMonad.Util.EZConfig (additionalKeysP, mkKeymap)
import XMonad.Util.Run -- used to run external processes
import XMonad.Util.SpawnOnce -- used to run a program once on login
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import Graphics.X11.ExtraTypes.XF86

--------------------------------------------------------------------------------
-- VARIABLES AND DEFAULT PROGRAMS
--------------------------------------------------------------------------------

-- Setting mod key
myModMask = mod4Mask

-- Applications
myTerminal = "alacritty"
myStatusBar = "polybar"
-- myMenu = "xmobar -x 0 /home/jcostanzo/.config/xmobar/xmobarrc"
myMenu = "dmenu_run -fn \"Operator Mono Nerd Font:size=12\" -p \"➜ \" -nf \"#c5c8c6\" -sf \"#f0c674\" -sb \"#282c34\""

--------------------------------------------------------------------------------
-- KEYBINDINGS
--------------------------------------------------------------------------------

myKeys :: [(String, X ())]
myKeys =
  [
    -- Recompile & Restart Xmonad
    ("M-q", spawn "xmonad --recompile; xmonad --restart"),

    -- Launch my menu
    ("M-p", spawn myMenu),

    -- Volume down
    ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -10%"),

    -- Volume up
    ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +10%"),

    -- Mute Volume
    ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle"),

    -- Screenshot whole page
    ("M-C-S-3", spawn "scrot"),

    -- Screenshot whole page
    ("M-C-S-4", spawn "scrot -s"),
    
    -- Launch to show keymapping
    ("M-S-/", spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
  ]

--------------------------------------------------------------------------------
-- AESTHETICS
--------------------------------------------------------------------------------

myBorderWidth = 2 -- sets the width of the borders

myNormalBorderColor = "#282c34"
myFocusedBorderColor = "#f0c674"

mySpacing = spacingRaw True (Border 0 15 10 10) True (Border 10 10 10 10) True

myLayout = mySpacing $ avoidStruts (tiled ||| ThreeCol 1 (3/100) (1/2) ||| ThreeColMid 1 (3/100) (1/2) ||| Mirror tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

--------------------------------------------------------------------------------
-- LOGHOOK
--------------------------------------------------------------------------------

myLogHook = return ()

--------------------------------------------------------------------------------
-- STARTUP HOOK
--------------------------------------------------------------------------------

myStartupHook = do
  spawnOnce "nitrogen --restore &"
  spawnOnce "picom -b &"
  spawnOnce "xautolock -time 10 -locker slock"

--------------------------------------------------------------------------------
-- MANAGEHOOK
-- special rules based on window types
--------------------------------------------------------------------------------

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

--------------------------------------------------------------------------------
-- WORKSPACES
--------------------------------------------------------------------------------

myWorkspaces :: [String]
myWorkspaces = ["1:dev", "2:chat", "3:browser", "4:music", "5:vm"]

--------------------------------------------------------------------------------
-- MAIN
-- putting it all together
--------------------------------------------------------------------------------

main :: IO ()
main = do
  xmproc <- spawnPipe myStatusBar
  xmonad $ ewmh $ docks $ defaults

defaults = def {
  -- general
  modMask = myModMask,
  terminal = myTerminal,

  -- aesthetics
  borderWidth = myBorderWidth,
  normalBorderColor = myNormalBorderColor,
  focusedBorderColor = myFocusedBorderColor,
  layoutHook = myLayout,

  -- workspaces
  workspaces = myWorkspaces,

  -- hooks
  manageHook = myManageHook <+> manageDocks,
  logHook = myLogHook,
  startupHook = myStartupHook
} `additionalKeysP` myKeys

--------------------------------------------------------------------------------
-- HELP
-- Used to show keymaps
--------------------------------------------------------------------------------

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
