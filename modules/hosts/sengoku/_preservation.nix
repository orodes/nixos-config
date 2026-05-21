{
  preservation = {
    enable = true;

    preserveAt."/persistent" = {
      directories = [
        "/etc/nixos"
        "/var/lib/bluetooth"
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
      ];

      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key";
          inInitrd = true;
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key.pub";
          inInitrd = true;
        }
      ];

      users.nadeko = {
        directories = [
          "Documents"
          ".ssh"
          ".mozilla"
          ".local/share/Anki2"
          ".local/share/local-audio-yomichan"
          ".config/vesktop"
        ];
      };
    };
  };
}
