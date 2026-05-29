{ inputs, ... }:
{
  flake.modules.nixos.latex =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [ inputs.self.modules.homeManager.latex ];

      environment.systemPackages = [
        pkgs.kile
        pkgs.texlive.combined.scheme-full
      ];
    };

  flake.modules.homeManager.latex =
    { pkgs, lib, ... }:
    {
      programs.helix.languages = {
        language-server.texlab = {
          command = lib.getExe pkgs.texlab;
        };

        language = [
          {
            name = "latex";
            language-servers = [ "texlab" ];
            auto-format = true;
          }
        ];
      };
    };
}
