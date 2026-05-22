{ ... }:
{
  flake.modules.nixos.stremio =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (pkgs.stremio-linux-shell.overrideAttrs (old: {
          patches = old.patches ++ [ ./stremio-clipboard.patch ];
          preFixup = (old.preFixup or "") + ''
            gappsWrapperArgs+=(
              --prefix PATH : "${pkgs.wl-clipboard}/bin"
            )
          '';
        }))
      ];
    };
}
