{ inputs, ... }:
{
  flake.modules.nixos.sengoku-iso =
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

      environment.etc."installer-key" = {
        source = builtins.path {
          path = builtins.toPath (builtins.getEnv "PWD" + "/keys/installer-key");
          name = "installer-key";
        };
        mode = "0600";
      };
      environment.etc."installer-key.pub".source = inputs.self + "/keys/installer-key.pub";

      environment.etc."sengoku-host-key" = {
        source = builtins.path {
          path = builtins.toPath (builtins.getEnv "PWD" + "/keys/sengoku-host-key");
          name = "sengoku-host-key";
        };
        mode = "0600";
      };
      environment.etc."sengoku-host-key.pub".source = inputs.self + "/keys/sengoku-host-key.pub";

      environment.systemPackages = [
        pkgs.disko
        (pkgs.writeShellScriptBin "install-sengoku" ''
          set -euo pipefail

          echo "=== Generating swap key ==="
          dd if=/dev/urandom of=/tmp/swap.key bs=1 count=4096 status=none

          echo "=== Formatting disks ==="
          disko --mode destroy,format,mount --flake github:orodes/nixos-config#sengoku

          echo "=== Saving swap key ==="
          cp /tmp/swap.key /mnt/persistent/swap.key
          chmod 600 /mnt/persistent/swap.key
          shred -u /tmp/swap.key

          echo "=== Installing NixOS ==="
          nixos-install --flake github:orodes/nixos-config#sengoku --no-root-passwd

          echo "=== Setting up host SSH keys ==="
          mkdir -p /mnt/persistent/etc/ssh
          cp /etc/sengoku-host-key     /mnt/persistent/etc/ssh/ssh_host_ed25519_key
          cp /etc/sengoku-host-key.pub /mnt/persistent/etc/ssh/ssh_host_ed25519_key.pub
          chmod 600 /mnt/persistent/etc/ssh/ssh_host_ed25519_key
          chmod 644 /mnt/persistent/etc/ssh/ssh_host_ed25519_key.pub

          echo "=== Setting up SSH access for first boot ==="
          mkdir -p /mnt/persistent/home/nadeko/.ssh
          cp /etc/installer-key     /mnt/persistent/home/nadeko/.ssh/id_ed25519
          cp /etc/installer-key.pub /mnt/persistent/home/nadeko/.ssh/id_ed25519.pub
          cat /etc/installer-key.pub >> /mnt/persistent/home/nadeko/.ssh/authorized_keys
          chmod 700 /mnt/persistent/home/nadeko/.ssh
          chmod 600 /mnt/persistent/home/nadeko/.ssh/id_ed25519
          chmod 600 /mnt/persistent/home/nadeko/.ssh/authorized_keys
          nixos-enter --root /mnt -- chown -R nadeko:users /home/nadeko/.ssh

          echo ""
          echo "=== Done ==="
          echo ""
          echo "SSH in with the installer key:"
          echo "  ssh -i keys/installer-key nadeko@sengoku"
        '')
      ];
    };

  flake.nixosConfigurations.sengoku-iso = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.sengoku-iso
      { nixpkgs.hostPlatform = "x86_64-linux"; }
    ];
  };

  perSystem = { ... }: {
    packages.iso = inputs.self.nixosConfigurations.sengoku-iso.config.system.build.isoImage;
  };
}
