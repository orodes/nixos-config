{ inputs, ... }:
{
  flake.modules.nixos.system-default = {
    imports = with inputs.self.modules.nixos; [
      home-manager
      secrets
    ];

    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };

    time.timeZone = "Australia/Sydney";
    i18n.defaultLocale = "en_AU.UTF-8";
    system.stateVersion = "25.11";
  };
}
