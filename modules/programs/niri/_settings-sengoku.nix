{ ... }:
{
  settings.extraConfig = ''
    output "HDMI-A-1" {
      mode "3440x1440@239.984"
      scale 1.5
      variable-refresh-rate on-demand=true
    }

    debug {
      wait-for-frame-completion-before-queueing
    }
  '';
}
