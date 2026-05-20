{ ... }:
{
  flake.modules.nixos.nh = {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep-since 4d --keep 3";
      };
    };
  };
}
