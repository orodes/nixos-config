{ inputs, ... }:
{
  flake-file.inputs.agenix = {
    url = "github:ryantm/agenix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake-file.inputs.secrets = {
    url = "git+ssh://git@github.com/orodes/nixos-secrets";
    flake = false;
  };

  flake.modules.nixos.secrets =
    { pkgs, ... }:
    {
      imports = [ inputs.agenix.nixosModules.default ];
      environment.systemPackages = [
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
