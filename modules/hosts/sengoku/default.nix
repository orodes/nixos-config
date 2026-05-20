{ inputs, ... }:
{
  flake.modules.nixos.sengoku = {
    imports = with inputs.self.modules.nixos; [
      sengoku-hardware
      system-desktop
      nadeko
    ];

    networking.hostName = "sengoku";
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };

  flake.nixosConfigurations.sengoku = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.sengoku
      { nixpkgs.hostPlatform = "x86_64-linux"; }
    ];
  };
}
