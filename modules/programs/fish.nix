{ ... }:
{
  flake.modules.homeManager.fish =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        zellij
        xcp
        curlie
        trash-cli
        gping
      ];

      programs.zoxide.enable = true;

      services.ssh-agent.enable = true;

      programs.fish = {
        enable = true;

        functions.fish_greeting = "";

        shellAbbrs = {
          ls = "eza";
          cat = "bat";
          ss = "zellij -l welcome";
          cd = "z";
          cdi = "zi";
          cp = "xcp";
          grep = "rg";
          curl = "curlie";
          rm = "trash";
          ping = "gping";
          sl = "eza";
          l = "eza --group --header --group-directories-first --long --git --all --binary --all --icons always";
          tree = "eza --tree";
          sudo = "sudo -E -s";
        };

        interactiveShellInit = ''
          fish_vi_key_bindings
          set fish_cursor_default block blink
          set fish_cursor_insert line blink
          set fish_cursor_replace_one underscore blink
          set fish_cursor_visual block
        '';
      };
    };
}
