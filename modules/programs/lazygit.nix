{ ... }:
{
  flake.modules.homeManager.lazygit = {
    programs.lazygit = {
      enable = true;
      settings.keybinding.universal.remove = "<disabled>";
    };
  };
}
