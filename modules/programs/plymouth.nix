{ ... }:
{
  flake.modules.nixos.plymouth =
    { pkgs, ... }:
    {
      boot.plymouth = {
        enable = true;
        theme = "pixels";
        themePackages = [
          (pkgs.adi1090x-plymouth-themes.override {
            selected_themes = [ "pixels" ];
          })
        ];
      };
    };
}
