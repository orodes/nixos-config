{ inputs, ... }:
{
  flake.modules.nixos.mpv = {
    home-manager.sharedModules = [ inputs.self.modules.homeManager.mpv ];
  };

  flake.modules.homeManager.mpv = {
    programs.mpv.enable = true;
  };
}
