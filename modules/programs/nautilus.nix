{ inputs, ... }:
{
  flake.modules.nixos.nautilus =
    { pkgs, ... }:
    {
      programs.nautilus-open-any-terminal = {
        enable = true;
        terminal = "foot";
      };
      services.udisks2.enable = true;
      services.gvfs.enable = true;
      services.gnome.sushi.enable = true;
      environment.systemPackages = with pkgs; [ nautilus ];
      home-manager.sharedModules = [ inputs.self.modules.homeManager.nautilus ];
    };

  flake.modules.homeManager.nautilus =
    { pkgs, ... }:
    {
      gtk = {
        enable = true;
        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };
      };
    };
}
