{ inputs, ... }:
{
  flake.lib.niriSettings.nadeko = ./_settings-niri.nix;

  flake.modules.nixos.nh = {
    programs.nh.flake = "/home/nadeko/.config/nixos-config";
  };

  flake.modules.nixos.nadeko =
    { config, pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        anki
        loupe
        mpv
        steam
        heroic
        sober
        stremio
        sioyek
        latex
      ];

      users.users.nadeko = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
        ];
        shell = pkgs.fish;
      };

      age.secrets.nadeko-password = {
        file = inputs.secrets + "/nadeko-password.age";
      };

      systemd.services.nadeko-password = {
        description = "Set nadeko password from agenix secret";
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.shadow ];
        script = ''
          echo "nadeko:$(cat ${config.age.secrets.nadeko-password.path})" | chpasswd -e
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

      age.secrets.git-identity-personal = {
        file = inputs.secrets + "/git-identity-personal.age";
        owner = "nadeko";
      };

      age.secrets.git-identity-university = {
        file = inputs.secrets + "/git-identity-university.age";
        owner = "nadeko";
      };

      age.secrets.ssh-key-personal = {
        file = inputs.secrets + "/ssh-key-personal.age";
        owner = "nadeko";
        mode = "0600";
      };

      age.secrets.ssh-key-university = {
        file = inputs.secrets + "/ssh-key-university.age";
        owner = "nadeko";
        mode = "0600";
      };

      age.secrets.anki-username = {
        file = inputs.secrets + "/anki-username.age";
        owner = "nadeko";
      };

      age.secrets.anki-sync-key = {
        file = inputs.secrets + "/anki-sync-key.age";
        owner = "nadeko";
      };

      home-manager.users.nadeko = {
        imports = with inputs.self.modules.homeManager; [
          nadeko
          niri
          git
        ];
        _module.args.ankiSyncUsernameFile = config.age.secrets.anki-username.path;
        _module.args.ankiSyncKeyFile = config.age.secrets.anki-sync-key.path;
        _module.args.defaultGitProfileName = "personal";
        _module.args.gitProfiles = {
          personal = {
            dirCondition = "gitdir:~/Documents/Personal/**";
            remoteCondition = "hasconfig:remote.*.url:*github.com-personal*";
            identityPath = config.age.secrets.git-identity-personal.path;
            sshKeyPath = config.age.secrets.ssh-key-personal.path;
            sshHosts = {
              "github.com-personal" = "github.com";
            };
          };
          university = {
            dirCondition = "gitdir:~/Documents/University/**";
            remoteCondition = "hasconfig:remote.*.url:*github.com-university*";
            identityPath = config.age.secrets.git-identity-university.path;
            sshKeyPath = config.age.secrets.ssh-key-university.path;
            sshHosts = {
              "github.com-university" = "github.com";
            };
          };
        };
      };
    };

  flake.modules.homeManager.nadeko =
    { pkgs, ... }:
    {
      home = {
        stateVersion = "25.11";
        username = "nadeko";
        homeDirectory = "/home/nadeko";
      };

      xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";

      home.packages = with pkgs; [
        vesktop
        libreoffice
      ];

      programs.noctalia-shell.settings = {
        general.avatarImage = toString (inputs.self + "/assets/nadeko/face.jpg");
        wallpaper.directory = toString (inputs.self + "/assets/nadeko/wallpapers");
      };
    };
}
