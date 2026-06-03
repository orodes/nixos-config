{ inputs, ... }:
{
  flake.lib.niriSettings.thinkpad = ./_settings-niri.nix;

  flake.modules.nixos.thinkpad =
    { config, pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        loupe
        mpv
        sioyek
        latex
      ];

      users.users.thinkpad = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
        ];
        shell = pkgs.fish;
      };

      age.secrets.thinkpad-password = {
        file = inputs.secrets + "/thinkpad-password.age";
      };

      systemd.services.thinkpad-password = {
        description = "Set thinkpad password from agenix secret";
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.shadow ];
        script = ''
          echo "thinkpad:$(cat ${config.age.secrets.thinkpad-password.path})" | chpasswd -e
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

      age.secrets.git-identity-personal = {
        file = inputs.secrets + "/git-identity-personal.age";
        owner = "thinkpad";
      };

      age.secrets.git-identity-university = {
        file = inputs.secrets + "/git-identity-university.age";
        owner = "thinkpad";
      };

      age.secrets.ssh-key-personal = {
        file = inputs.secrets + "/ssh-key-personal.age";
        owner = "thinkpad";
        mode = "0600";
      };

      age.secrets.ssh-key-university = {
        file = inputs.secrets + "/ssh-key-university.age";
        owner = "thinkpad";
        mode = "0600";
      };

      home-manager.users.thinkpad = {
        imports = with inputs.self.modules.homeManager; [
          thinkpad
          niri
          git
        ];
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

  flake.modules.homeManager.thinkpad =
    { pkgs, ... }:
    {
      home = {
        stateVersion = "25.11";
        username = "thinkpad";
        homeDirectory = "/home/thinkpad";
      };

      xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";

      home.packages = with pkgs; [
        libreoffice
      ];

      programs.noctalia-shell.settings = {
        general.avatarImage = toString (inputs.self + "/assets/nadeko/face.jpg");
        wallpaper.directory = toString (inputs.self + "/assets/nadeko/wallpapers");
      };
    };
}
