{ inputs, ... }:
{
  perSystem =
    { pkgs, self', ... }:
    {
      packages.niri-t490 = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        imports = [
          self'.legacyPackages.niriNoctaliaModule
          inputs.self.lib.niriSettings.thinkpad
          (
            { ... }:
            {
              settings.extraConfig = ''
                output "eDP-1" {
                  mode "1920x1080@60.000"
                  scale 1.25
                }
              '';
            }
          )
        ];
      };
    };
}
