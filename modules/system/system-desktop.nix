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
