{ inputs, ... }:
{
  flake-file.inputs.nixos-hardware = {
    url = "github:NixOS/nixos-hardware";
  };

  flake.modules.nixos.t490-hardware =
    { pkgs, ... }:
    {
      imports = [
        ./_hardware-configuration.nix
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490
      ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      services.libinput.touchpad = {
        naturalScrolling = true;
        tapping = true;
      };

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    };
}
