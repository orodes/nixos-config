{ ... }:
{
  flake.modules.nixos.sengoku-hardware =
    { config, ... }:
    {
      imports = [ ./_hardware-configuration.nix ];

      boot.kernelParams = [ "nvme_core.default_ps_max_latency_us=0" ];
      boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" ];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        LIBVA_DRIVER_NAME = "nvidia";
      };
    };
}
