{ inputs, ... }:
{
  flake.modules.nixos.system-desktop =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        system-cli
        niri
        noctalia
        firefox
        nautilus
        anki
        fcitx5
      ];

      security.polkit.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.common.default = "*";
      };

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      security.rtkit.enable = true;

      fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
          nerd-fonts.jetbrains-mono
        ];
        fontconfig.defaultFonts = {
          sansSerif = [ "Noto Sans CJK JP" "Noto Sans" ];
          serif = [ "Noto Serif CJK JP" ];
          monospace = [ "JetBrainsMono Nerd Font Mono" "Noto Sans Mono CJK JP" ];
        };
      };

      hardware.bluetooth.enable = true;
      hardware.bluetooth.settings.General.Experimental = true;
      hardware.bluetooth.settings.LE.ScanType = "active";

      environment.systemPackages = with pkgs; [
        xdg-utils
        brightnessctl
      ];
    };
}
