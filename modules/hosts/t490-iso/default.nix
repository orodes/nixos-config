{ inputs, ... }:
let
  installerKey = builtins.path {
    path = builtins.toPath (builtins.getEnv "PWD" + "/keys/installer-key");
    name = "installer-key";
  };
  t490HostKey = builtins.path {
    path = builtins.toPath (builtins.getEnv "PWD" + "/keys/t490-host-key");
    name = "t490-host-key";
  };
in
{
  flake.modules.nixos.t490-iso =
    { pkgs, ... }:
    {
      imports = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ];

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      networking.networkmanager.enable = true;

      programs.ssh.extraConfig = ''
        Host github.com
          IdentityFile /etc/installer-key
          StrictHostKeyChecking accept-new
      '';

      system.activationScripts.installer-keys = ''
        install -Dm600 ${installerKey}  /etc/installer-key
        install -Dm600 ${t490HostKey}   /etc/t490-host-key
      '';

      environment.etc."installer-key.pub".source  = inputs.self + "/keys/installer-key.pub";
      environment.etc."t490-host-key.pub".source  = inputs.self + "/keys/t490-host-key.pub";

      environment.systemPackages = [
        pkgs.disko
        (pkgs.writeShellScriptBin "install-t490" ''
          set -euo pipefail

          echo "=== Generating swap key ==="
          dd if=/dev/urandom of=/tmp/swap.key bs=1 count=4096 status=none

          echo "=== Formatting disks ==="
          disko --mode destroy,format,mount --flake github:orodes/nixos-config#t490

          echo "=== Saving swap key ==="
          cp /tmp/swap.key /mnt/persistent/swap.key
          chmod 600 /mnt/persistent/swap.key
          shred -u /tmp/swap.key

          echo "=== Setting up host SSH keys ==="
          mkdir -p /mnt/persistent/etc/ssh
          cp /etc/t490-host-key     /mnt/persistent/etc/ssh/ssh_host_ed25519_key
          cp /etc/t490-host-key.pub /mnt/persistent/etc/ssh/ssh_host_ed25519_key.pub
          chmod 600 /mnt/persistent/etc/ssh/ssh_host_ed25519_key
          chmod 644 /mnt/persistent/etc/ssh/ssh_host_ed25519_key.pub

          echo "=== Installing NixOS ==="
          mkdir -p /mnt/etc/ssh
          cp /mnt/persistent/etc/ssh/ssh_host_ed25519_key     /mnt/etc/ssh/
          cp /mnt/persistent/etc/ssh/ssh_host_ed25519_key.pub /mnt/etc/ssh/
          chmod 600 /mnt/etc/ssh/ssh_host_ed25519_key
          nixos-install --flake github:orodes/nixos-config#t490 --no-root-passwd

          echo "=== Setting up SSH access for first boot ==="
          mkdir -p /mnt/persistent/home/thinkpad/.ssh
          cp /etc/installer-key     /mnt/persistent/home/thinkpad/.ssh/id_ed25519
          cp /etc/installer-key.pub /mnt/persistent/home/thinkpad/.ssh/id_ed25519.pub
          cat /etc/installer-key.pub >> /mnt/persistent/home/thinkpad/.ssh/authorized_keys
          chmod 700 /mnt/persistent/home/thinkpad/.ssh
          chmod 600 /mnt/persistent/home/thinkpad/.ssh/id_ed25519
          chmod 600 /mnt/persistent/home/thinkpad/.ssh/authorized_keys
          chown -R 1000:1000 /mnt/persistent/home/thinkpad/.ssh

          echo ""
          echo "=== Done ==="
          echo ""
          echo "SSH in with the installer key:"
          echo "  ssh -i keys/installer-key thinkpad@t490"
        '')
      ];
    };

  flake.nixosConfigurations.t490-iso = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.t490-iso
      { nixpkgs.hostPlatform = "x86_64-linux"; }
    ];
  };

  perSystem = { ... }: {
    packages.iso-t490 = inputs.self.nixosConfigurations.t490-iso.config.system.build.isoImage;
  };
}
