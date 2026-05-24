{ inputs, ... }:
{
  flake.modules.nixos.sioyek =
    { lib, sioyekScaleFactor ? null, ... }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          sioyek = final.symlinkJoin {
            name = "sioyek";
            paths = [ prev.sioyek ];
            nativeBuildInputs = [ final.makeWrapper ];
            postBuild =
              let
                args = lib.escapeShellArgs (
                  [ "--set" "QT_QPA_PLATFORM" "xcb" ]
                  ++ lib.optionals (sioyekScaleFactor != null) [
                    "--set"
                    "QT_SCALE_FACTOR"
                    (toString sioyekScaleFactor)
                  ]
                  ++ [ "--prefix" "LD_LIBRARY_PATH" ":" "${final.pipewire}/lib" ]
                );
              in
              ''wrapProgram $out/bin/sioyek ${args}'';
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
