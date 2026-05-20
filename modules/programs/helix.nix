{ inputs, ... }:
{
  flake.modules.nixos.helix = {
    home-manager.sharedModules = [ inputs.self.modules.homeManager.helix ];
  };

  flake.modules.homeManager.helix =
    { pkgs, lib, ... }:
    {
      programs.helix = {
        enable = true;

        settings = {
          theme = "github_light_high_contrast";
          editor = {
            line-number = "relative";
            soft-wrap.enable = true;
            rulers = [ 80 ];
            auto-save = {
              focus-lost = true;
              after-delay = {
                enable = true;
                timeout = 3000;
              };
            };
          };
        };

        languages = {
          language-server = {
            nixd.command = lib.getExe pkgs.nixd;

            fish-lsp = {
              command = lib.getExe pkgs.fish-lsp;
              args = [ "start" ];
              environment.fish_lsp_show_client_popups = "false";
            };

            pylsp = {
              command = lib.getExe pkgs.python3Packages.python-lsp-server;
              config.pylsp.plugins = {
                black.enabled = false;
                pylsp_black.enabled = false;
                ruff.enabled = false;
                pylsp_ruff.enabled = false;
              };
            };

            ruff = {
              command = lib.getExe pkgs.ruff;
              args = [ "server" ];
            };

            clangd = {
              command = lib.getExe' pkgs.clang-tools "clangd";
              args = [ "--clang-tidy" ];
            };
          };

          language = [
            {
              name = "nix";
              language-servers = [ "nixd" ];
              formatter.command = lib.getExe pkgs.nixfmt;
              auto-format = true;
            }
            {
              name = "fish";
              language-servers = [ "fish-lsp" ];
            }
            {
              name = "python";
              language-servers = [
                "pylsp"
                "ruff"
              ];
              formatter = {
                command = lib.getExe pkgs.ruff;
                args = [
                  "format"
                  "--line-length"
                  "88"
                  "-"
                ];
              };
              auto-format = true;
            }
            {
              name = "c";
              language-servers = [ "clangd" ];
            }
            {
              name = "java";
              indent = {
                tab-width = 4;
                unit = " ";
              };
              formatter = {
                command = lib.getExe pkgs.google-java-format;
                args = [ "-" ];
              };
              auto-format = true;
            }
          ];
        };
      };
    };
}
