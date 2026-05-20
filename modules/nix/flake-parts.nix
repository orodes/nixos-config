{ inputs, lib, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.flake-file.flakeModules.default
  ];

  flake-file.inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    flake-file.url = lib.mkDefault "github:vic/flake-file";
  };

  flake-file.outputs = "dendritic";

  systems = [ "x86_64-linux" ];
}
