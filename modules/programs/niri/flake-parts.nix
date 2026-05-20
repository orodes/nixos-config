{ inputs, ... }:
{
  flake-file.inputs.wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

  perSystem =
    { pkgs, self', ... }:
    {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        imports = [
          (
            { lib, ... }:
            {
              settings = {
                spawn-at-startup = [ (lib.getExe self'.packages.noctalia) ];
                binds."Mod+S".spawn-sh = "${lib.getExe self'.packages.noctalia} ipc call launcher toggle";
              };
            }
          )
          ./_settings-nadeko.nix
          ./_settings-sengoku.nix
        ];
      };
    };
}
