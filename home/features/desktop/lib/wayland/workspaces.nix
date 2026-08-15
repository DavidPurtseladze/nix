# Bank of alternate hyprland/workspaces styles - pick ONE by referencing its
# name (e.g. "hyprland/workspaces#kanji") in modules-left/-center/-right.
# Defining a style here does nothing on its own until it's referenced there.
{
  # Circle style
  "hyprland/workspaces" = {
    active-only = false;
    all-outputs = true;
    format = "{icon}";
    show-special = false;
    on-click = "activate";
    on-scroll-up = "hyprctl dispatch workspace e+1";
    on-scroll-down = "hyprctl dispatch workspace e-1";
    persistent-workspaces = {
      "*" = 5;
    };
    format-icons = {
      active = "";
      default = "";
    };
  };

  # ROMAN Numerals style
  "hyprland/workspaces#roman" = {
    active-only = false;
    all-outputs = true;
    format = "{icon}";
    show-special = false;
    on-click = "activate";
    on-scroll-up = "hyprctl dispatch workspace e+1";
    on-scroll-down = "hyprctl dispatch workspace e-1";
    persistent-workspaces = {
      "*" = 5;
    };
    format-icons = {
      "1" = "I";
      "2" = "II";
      "3" = "III";
      "4" = "IV";
      "5" = "V";
      "6" = "VI";
      "7" = "VII";
      "8" = "VIII";
      "9" = "IX";
      "10" = "X";
    };
  };

  # PACMAN Style
  "hyprland/workspaces#pacman" = {
    active-only = false;
    all-outputs = true;
    format = "{icon}";
    on-click = "activate";
    on-scroll-up = "hyprctl dispatch workspace e+1";
    on-scroll-down = "hyprctl dispatch workspace e-1";
    show-special = false;
    persistent-workspaces = {
      "*" = 5;
    };
    format-icons = {
      active = "<span font='12'>󰮯</span>";
      empty = "<span font='8'></span>";
      default = "󰊠";
    };
  };

  # Kanji / Japanese style
  "hyprland/workspaces#kanji" = {
    disable-scroll = true;
    show-special = false;
    all-outputs = true;
    format = "{icon}";
    persistent-workspaces = {
      "*" = 5;
    };
    format-icons = {
      "1" = "一";
      "2" = "二";
      "3" = "三";
      "4" = "四";
      "5" = "五";
      "6" = "六";
      "7" = "七";
      "8" = "八";
      "9" = "九";
      "10" = "十";
    };
  };

  # numbers style
  "hyprland/workspaces#numbers" = {
    active-only = false;
    all-outputs = true;
    format = "{icon}";
    show-special = false;
    on-click = "activate";
    on-scroll-up = "hyprctl dispatch workspace e+1";
    on-scroll-down = "hyprctl dispatch workspace e-1";
    persistent-workspaces = {
      "*" = 5;
    };
    format-icons = {
      "1" = "1";
      "2" = "2";
      "3" = "3";
      "4" = "4";
      "5" = "5";
      "6" = "6";
      "7" = "7";
      "8" = "8";
      "9" = "9";
      "10" = "10";
    };
  };

  # NUMBERS and ICONS style with per-app window rewrite
  "hyprland/workspaces#rw" = {
    disable-scroll = true;
    all-outputs = true;
    warp-on-scroll = false;
    sort-by-number = true;
    show-special = false;
    on-click = "activate";
    on-scroll-up = "hyprctl dispatch workspace e+1";
    on-scroll-down = "hyprctl dispatch workspace e-1";
    persistent-workspaces = {
      "*" = 5;
    };
    format = "{icon} {windows}";
    format-window-separator = " ";
    window-rewrite-default = " ";
    window-rewrite = {
      "title<.*amazon.*>" = " ";

      "class<firefox|org.mozilla.firefox|librewolf|floorp|mercury-browser|[Cc]achy-browser>" = " ";
      "class<zen-beta>" = "󰰷 ";
      "class<waterfox|waterfox-bin>" = " ";
      "class<microsoft-edge>" = " ";
      "class<Chromium|Thorium|[Cc]hrome>" = " ";
      "class<brave-browser>" = "🦁 ";
      "class<tor browser>" = " ";
      "class<firefox-developer-edition>" = "🦊 ";

      "class<kitty|konsole>" = " ";
      "class<kitty-dropterm>" = " ";
      "class<com.mitchellh.ghostty>" = " ";
      "class<org.wezfurlong.wezterm>" = " ";

      "class<[Tt]hunderbird|[Tt]hunderbird-esr>" = " ";
      "class<eu.betterbird.Betterbird>" = " ";
      "title<.*gmail.*>" = "󰊫 ";

      "class<[Tt]elegram-desktop|org.telegram.desktop|io.github.tdesktop_x64.TDesktop>" = " ";
      "class<discord|[Ww]ebcord|Vesktop>" = " ";
      "title<.*whatsapp.*>" = " ";
      "title<.*zapzap.*>" = " ";
      "title<.*messenger.*>" = " ";
      "title<.*facebook.*>" = " ";
      "title<.*reddit.*>" = " ";

      "title<.*ChatGPT.*>" = "󰚩 ";
      "title<.*deepseek.*>" = "󰚩 ";
      "title<.*qwen.*>" = "󰚩 ";
      "class<subl>" = "󰅳 ";
      "class<slack>" = " ";

      "class<mpv>" = " ";
      "class<celluloid|Zoom>" = " ";
      "class<Cider>" = "󰎆 ";
      "title<.*Picture-in-Picture.*>" = " ";
      "title<.*youtube.*>" = " ";
      "class<vlc>" = "󰕼 ";
      "title<.*cmus.*>" = " ";
      "class<[Ss]potify>" = " ";

      "class<virt-manager>" = " ";
      "class<.virt-manager-wrapped>" = " ";
      "class<virtualbox manager>" = "💽 ";
      "title<virtualbox>" = "💽 ";
      "class<remmina>" = "🖥️ ";

      "class<VSCode|code-url-handler|code-oss|codium|codium-url-handler|VSCodium>" = "󰨞 ";
      "class<dev.zed.Zed>" = "󰵁";
      "class<codeblocks>" = "󰅩 ";
      "title<.*github.*>" = " ";
      "class<mousepad>" = " ";
      "class<libreoffice-writer>" = " ";
      "class<libreoffice-startcenter>" = "󰏆 ";
      "class<libreoffice-calc>" = " ";
      "title<.*nvim ~.*>" = " ";
      "title<.*vim.*>" = " ";
      "title<.*nvim.*>" = " ";
      "title<.*figma.*>" = " ";
      "title<.*jira.*>" = " ";
      "class<jetbrains-idea>" = " ";
      "class<obs|com.obsproject.Studio>" = " ";
      "class<polkit-gnome-authentication-agent-1>" = "󰒃 ";
      "class<nwg-look>" = " ";
      "class<[Pp]avucontrol|org.pulseaudio.pavucontrol>" = "󱡫 ";
      "class<steam>" = " ";
      "class<thunar|nemo>" = "󰝰 ";
      "class<Gparted>" = "";
      "class<gimp>" = " ";
      "class<emulator>" = "📱 ";
      "class<android-studio>" = " ";
      "class<org.pipewire.Helvum>" = "󰓃";
      "class<localsend>" = "";
      "class<PrusaSlicer|UltiMaker-Cura|OrcaSlicer>" = "󰹛";
    };
  };
}
