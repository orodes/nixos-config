{ ... }:
{
  flake.modules.nixos.loupe =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.loupe ];
    };
}
