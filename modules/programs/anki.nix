{ inputs, ... }:
{
  flake.modules.nixos.anki = {
    nixpkgs.overlays = [
      (final: prev: {
        ankiAddons = prev.ankiAddons // {
          local-audio-yomichan = prev.ankiAddons.local-audio-yomichan.overrideAttrs (old: {
            postPatch = (old.postPatch or "") + ''
              substituteInPlace util.py \
                --replace-fail \
                'return get_program_root_dir() / "user_files"' \
                'return get_linux_data_dir()'
            '';
          });
        };
      })
    ];

    home-manager.sharedModules = [
      inputs.self.modules.homeManager.anki
    ];
  };

  flake.modules.homeManager.anki =
    {
      pkgs,
      ankiSyncUsernameFile ? null,
      ankiSyncKeyFile ? null,
      ...
    }:
    {
      programs.anki = {
        enable = true;
        addons = with pkgs.ankiAddons; [
          anki-connect
          local-audio-yomichan
          puppy-reinforcement
          review-heatmap
          passfail2
          yomichan-forvo-server
        ];
        profiles."User 1" = {
          sync = {
            usernameFile = ankiSyncUsernameFile;
            keyFile = ankiSyncKeyFile;
          };
        };
      };
    };
}
