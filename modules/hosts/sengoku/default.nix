{ inputs, ... }:
{
  flake.modules.nixos.sengoku =
    { lib, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        sengoku-hardware
        system-desktop
        nadeko
        secrets
      ] ++ [
        inputs.disko.nixosModules.disko
        inputs.preservation.nixosModules.default
        ./_disko.nix
        ./_preservation.nix
      ];

      networking.hostName = "sengoku";
      security.sudo.wheelNeedsPassword = false;
      fileSystems."/persistent".neededForBoot = true;
      systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot.initrd.secrets."/swap.key" = "/persistent/swap.key";
      boot.initrd.luks.devices.cryptswap.keyFile = lib.mkForce "/swap.key";
      boot.resumeDevice = "/dev/mapper/cryptswap";
    };

  flake.nixosConfigurations.sengoku = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.sengoku
      { nixpkgs.hostPlatform = "x86_64-linux"; }
    ];
  };
}
