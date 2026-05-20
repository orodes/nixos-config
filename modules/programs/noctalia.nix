{ inputs, ... }:
{
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia-shell";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.noctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

  flake.modules.nixos.noctalia =
    { ... }:
    {
      nix.settings = {
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };

      services.upower.enable = true;
      services.power-profiles-daemon.enable = true;

      home-manager.sharedModules = [ inputs.self.modules.homeManager.noctalia ];
    };

  flake.modules.homeManager.noctalia =
    { ... }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia-shell = {
        enable = true;

        settings = {
          location = {
            name = "Sydney";
            autoLocate = false;
            use12hourFormat = true;
          };

          bar.widgets.left = [
            { id = "Launcher"; }
            {
              id = "Clock";
              formatHorizontal = "dd.MM.yyyy h:mm AP";
              formatVertical = "h:mm AP - dd MM";
              tooltipFormat = "dd.MM.yyyy h:mm AP";
            }
            { id = "SystemMonitor"; }
            { id = "ActiveWindow"; }
            { id = "MediaMini"; }
          ];
        };

        colors = {
          mError = "#fb4934";
          mHover = "#83a598";
          mOnError = "#282828";
          mOnHover = "#282828";
          mOnPrimary = "#282828";
          mOnSecondary = "#282828";
          mOnSurface = "#fbf1c7";
          mOnSurfaceVariant = "#ebdbb2";
          mOnTertiary = "#282828";
          mOutline = "#57514e";
          mPrimary = "#b8bb26";
          mSecondary = "#fabd2f";
          mShadow = "#282828";
          mSurface = "#282828";
          mSurfaceVariant = "#3c3836";
          mTertiary = "#83a598";
        };
      };

      xdg.configFile."noctalia/settings.json".force = true;
      xdg.configFile."noctalia/colors.json".force = true;
    };
}
