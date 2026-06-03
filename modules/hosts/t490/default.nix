{ inputs, ... }:
{
  flake.modules.nixos.t490 =
    { lib, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        t490-hardware
        system-desktop
        thinkpad
        secrets
      ] ++ [
        inputs.disko.nixosModules.disko
        inputs.preservation.nixosModules.default
        ./_disko.nix
        ./_preservation.nix
      ];

      networking.hostName = "t490";
      security.sudo.wheelNeedsPassword = false;
      fileSystems."/persistent".neededForBoot = true;
      systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      programs.nh.flake = lib.mkForce "/home/thinkpad/.config/nixos-config";

      boot.initrd.secrets."/swap.key" = "/persistent/swap.key";
      boot.initrd.luks.devices.cryptswap.keyFile = lib.mkForce "/swap.key";
      boot.resumeDevice = "/dev/mapper/cryptswap";
    };

  flake.nixosConfigurations.t490 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.t490
      { nixpkgs.hostPlatform = "x86_64-linux"; }
    ];
  };
}
