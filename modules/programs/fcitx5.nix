{ inputs, ... }:
{
  flake.modules.nixos.fcitx5 =
    { pkgs, ... }:
    {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.addons = with pkgs; [
          fcitx5-mozc-ut
          fcitx5-gtk
        ];
      };

      home-manager.sharedModules = [ inputs.self.modules.homeManager.fcitx5 ];
    };

  flake.modules.homeManager.fcitx5 =
    { pkgs, ... }:
    {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          addons = with pkgs; [ fcitx5-mozc-ut ];
          waylandFrontend = true;
          settings.inputMethod = {
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "mozc";
            };
            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "mozc";
            GroupOrder."0" = "Default";
          };
        };
      };
    };
}
