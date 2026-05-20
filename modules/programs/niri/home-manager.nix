{ ... }:
{
  flake.modules.homeManager.niri =
    { pkgs, ... }:
    {
      programs.foot = {
        enable = true;
        settings.main.font = "JetBrainsMono Nerd Font Mono:size=12";
      };

      systemd.user.services.polkit-gnome-authentication-agent-1 = {
        Unit = {
          Description = "polkit-gnome-authentication-agent-1";
          After = "graphical-session.target";
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
