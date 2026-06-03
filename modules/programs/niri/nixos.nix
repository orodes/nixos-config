{ inputs, ... }:
{
  flake.modules.nixos.niri =
    { lib, pkgs, config, ... }:
    {
      programs.niri = {
        enable = true;
        package = lib.mkDefault (
          inputs.self.packages.${pkgs.stdenv.hostPlatform.system}."niri-${config.networking.hostName}"
          or inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.niri
        );
      };

      environment.systemPackages = [ pkgs.xwayland-satellite ];

      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
          user = "greeter";
        };
      };
    };
}
