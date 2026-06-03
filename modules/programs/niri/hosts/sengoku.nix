{ inputs, ... }:
{
  perSystem =
    { pkgs, self', ... }:
    {
      packages.niri-sengoku = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        imports = [
          self'.legacyPackages.niriNoctaliaModule
          inputs.self.lib.niriSettings.nadeko
          (
            { ... }:
            {
              settings.extraConfig = ''
                output "HDMI-A-1" {
                  mode "3440x1440@239.984"
                  scale 1.5
                  variable-refresh-rate on-demand=true
                }

                debug {
                  wait-for-frame-completion-before-queueing
                }
              '';
            }
          )
        ];
      };
    };
}
