{ inputs, ... }:
{
  flake.modules.nixos.sioyek = {
    nixpkgs.overlays = [
      (final: prev: {
        sioyek = final.symlinkJoin {
          name = "sioyek";
          paths = [ prev.sioyek ];
          nativeBuildInputs = [ final.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/sioyek \
              --set QT_QPA_PLATFORM xcb \
              --prefix LD_LIBRARY_PATH : ${final.pipewire}/lib
          '';
        };
      })
    ];

    home-manager.sharedModules = [ inputs.self.modules.homeManager.sioyek ];
  };

  flake.modules.homeManager.sioyek = {
    programs.sioyek = {
      enable = true;
      bindings = {
        "move_up" = "k";
        "move_down" = "j";
        "move_left" = "h";
        "move_right" = "l";
        "screen_down" = [
          "d"
          "<C-d>"
        ];
        "screen_up" = [
          "u"
          "<C-u>"
        ];
      };
    };
  };
}
