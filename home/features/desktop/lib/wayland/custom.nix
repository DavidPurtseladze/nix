/* Waybar Modules - Custom Modules */
/* Basically created to reduce the lines in Waybar Modules bank */
/* NOTE: This is only for Custom Modules */
/* Custom Modules like weather browser, tty, file manager at the beginning */
{
    "custom/file_manager" = {
        "format" = " ";
        "on-click" = "xdg-open . &";
        "tooltip" = true;
        "tooltip-format" = "File Manager";
    };

    "custom/browser" = {
        "format" = " ";
        "on-click" = "xdg-open https://";
        "tooltip" = true;
        "tooltip-format" = "Launch Browser";
    };

    "custom/reboot" = {
        "format" = "󰜉";
        "on-click" = "systemctl reboot";
        "tooltip" = true;
        "tooltip-format" = "Left Click: Reboot";
    };
        
    "custom/quit" = {
        "format" = "󰗼";
        "on-click" = "hyprctl dispatch exit";
        "tooltip" = true;
        "tooltip-format" = "Left Click: Exit Hyprland";
    };

    "custom/swaync" = {
        "tooltip" = true;
        "tooltip-format" = "Left Click: Launch Notification Center\nRight Click: Do not Disturb";
        "format" = "{} {icon} ";
        "format-icons" = {
            "notification" = "<span foreground='red'><sup></sup></span>";
            "none" = "";
            "dnd-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-none" = "";
            "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "inhibited-none" = "";
            "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-inhibited-none" = "";
        };
        "return-type" = "json";
        "exec-if" = "which swaync-client";
        "exec" = "swaync-client -swb";
        "on-click" = "sleep 0.1 && swaync-client -t -sw";
        "on-click-right" = "swaync-client -d -sw";
        "escape" = true;
    };
    
    "custom/separator#dot" = {
        "format" = "";
        "interval" = "once";
        "tooltip" = false;
    };

    "custom/separator#dot-line" = {
        "format" = "";
        "interval" = "once";
        "tooltip" = false;
    };

    "custom/separator#line" = {
        "format" = "|";
        "interval" = "once";
        "tooltip" = false;
    };

    "custom/separator#blank" = {
        "format" = "";
        "interval" = "once";
        "tooltip" = false;
    };

    "custom/separator#blank_2" = {
        "format" = "  ";
        "interval" = "once";
        "tooltip" = false;
    };

    "custom/separator#blank_3" = {
        "format" = "   ";
        "interval" = "once";
        "tooltip" = false;
    };

    "custom/arrow1" = {
        "format" = "";
        "tooltip" = false;
    };

    "custom/arrow2" = {
        "format" = "";
        "tooltip" = false;
    };

    "custom/arrow3" = {
        "format" = "";
        "tooltip" = false;
    };

    "custom/arrow4" = {
        "format" = "";
        "tooltip" = false;
    };

    "custom/arrow5" = {
        "format" = "";
        "tooltip" = false;
    };

    "custom/arrow6" = {
        "format" = "";
        "tooltip" = false;
    };

    "custom/arrow7" = {
        "format" = "";
        "tooltip" = false;
    };

    "custom/arrow8" = {
        "format" = "";
        "tooltip" = false;
    };

    "custom/arrow9" = {
        "format" = "";
        "tooltip" = false;
    };

    "custom/arrow10" = {
        "format" = "";
        "tooltip" = false;
    };

    "custom/power" = {
        "format" = "⏻";
        "on-click" = "wlogout -p layer-shell";
        "tooltip" = true;
        "tooltip-format" ="Logout Menu";
    };

    "custom/cycle_wall" = {
        "format" = " ";
        "on-click" = "wallpaper-select";
        "on-click-right" = "wallpaper-random";
        "tooltip" = true;
        "tooltip-format" = "Left Click: Wallpaper Menu\nRight Click: Random Wallpaper";
    };
}
