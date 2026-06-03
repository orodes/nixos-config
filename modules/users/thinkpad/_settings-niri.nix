{ lib, pkgs, ... }:
{
  settings = {
    input = {
      keyboard.xkb.layout = "us";
      mouse = {
        accel-speed = -0.3;
        accel-profile = "flat";
      };
    };

    layout = {
      gaps = 8;
      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
      ];
      default-column-width.proportion = 0.5;
    };

    environment.QS_ICON_THEME = "Adwaita";

    binds = {
      "Mod+Return".spawn-sh = lib.getExe pkgs.foot;
      "Mod+Q".close-window = _: { };

      "Mod+F".fullscreen-window = _: { };
      "Mod+Shift+F".maximize-column = _: { };
      "Mod+R".switch-preset-column-width = _: { };
      "Mod+Shift+E".quit = _: { };
      "Mod+Shift+Slash".show-hotkey-overlay = _: { };

      "Mod+H".focus-column-left = _: { };
      "Mod+L".focus-column-right = _: { };
      "Mod+J".focus-window-down = _: { };
      "Mod+K".focus-window-up = _: { };

      "Mod+Shift+H".move-column-left = _: { };
      "Mod+Shift+L".move-column-right = _: { };
      "Mod+Shift+J".move-window-down = _: { };
      "Mod+Shift+K".move-window-up = _: { };

      "Mod+1".focus-workspace = 1;
      "Mod+2".focus-workspace = 2;
      "Mod+3".focus-workspace = 3;
      "Mod+4".focus-workspace = 4;
      "Mod+5".focus-workspace = 5;

      "Mod+Shift+1".move-column-to-workspace = 1;
      "Mod+Shift+2".move-column-to-workspace = 2;
      "Mod+Shift+3".move-column-to-workspace = 3;
      "Mod+Shift+4".move-column-to-workspace = 4;
      "Mod+Shift+5".move-column-to-workspace = 5;

      "Mod+Minus".set-column-width = "-10%";
      "Mod+Equal".set-column-width = "+10%";

      "Print".screenshot = _: { };
      "Ctrl+Print".screenshot-screen = _: { };
      "Alt+Print".screenshot-window = _: { };

      "Mod+Shift+Ctrl+T".toggle-debug-tint = _: { };
      "Mod+Shift+Ctrl+D".debug-toggle-damage = _: { };

      "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+";
      "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      "XF86AudioMicMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      "XF86MonBrightnessUp".spawn-sh = "brightnessctl set 5%+";
      "XF86MonBrightnessDown".spawn-sh = "brightnessctl set 5%-";
    };
  };
}
