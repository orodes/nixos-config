{ inputs, ... }:
{
  flake.modules.nixos.system-cli =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        system-default
        helix
        nh
      ];

      home-manager.sharedModules = with inputs.self.modules.homeManager; [
        fish
        lazygit
      ];

      environment.systemPackages = with pkgs; [
        vim
        curl
        wget
        eza
        ripgrep
        bat
        fastfetch
      ];

      services.openssh.enable = true;
      programs.fish.enable = true;
      networking.networkmanager.enable = true;
    };
}
