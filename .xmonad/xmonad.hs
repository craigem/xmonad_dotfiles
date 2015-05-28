import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do
        xmproc <- spawnPipe "/usr/bin/xmobar /home/craige/.xmobarrc"
        xmonad $ defaultConfig
                { focusFollowsMouse = False
                , terminal = "terminology"
                , manageHook = manageDocks <+> manageHook defaultConfig
                , layoutHook = avoidStruts $ layoutHook defaultConfig
                , logHook = dynamicLogWithPP $ xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
                , modMask = mod4Mask -- Rebind Mod to the Windows key
                --, borderWidth = 1
                } `additionalKeys`
                        -- Lock the screen
                        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
                        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
                        , ((0, xK_Print), spawn "scrot")
                        -- Turn off the display port
                        , ((mod4Mask, xK_d), spawn "/usr/bin/xrandr --output DP1 --off")
                        -- Turn on the display port and set it as the primary display
                        , ((mod4Mask .|. shiftMask, xK_d), spawn "/usr/bin/xrandr --output DP1 --primary ; /usr/bin/xrandr --output LVDS1 --mode 1280x800; /usr/bin/xrandr --output DP1 --mode 2560x1440; /usr/bin/xrandr --output DP1 --left-of LVDS1")
                        , ((0 , 0x1008FF11), spawn "amixer set Master 2%-")
                        , ((0 , 0x1008FF13), spawn "amixer set Master 2%+")
                        , ((0 , 0x1008FF12), spawn "amixer set Master toggle")
                ]
