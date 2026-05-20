{ ... }:
{
  flake.modules.homeManager.git =
    {
      lib,
      gitProfiles ? { },
      defaultGitProfileName ? null,
      ...
    }:
    let
      profiles = lib.attrValues gitProfiles;
      defaultProfile =
        if defaultGitProfileName != null && gitProfiles ? ${defaultGitProfileName} then
          gitProfiles.${defaultGitProfileName}
        else
          null;
      defaultIncludes = lib.optional (defaultProfile != null) { path = defaultProfile.identityPath; };
    in
    {
      programs.git = {
        enable = true;
        includes = defaultIncludes ++ lib.concatMap (p: [
          {
            condition = p.dirCondition;
            path = p.identityPath;
          }
          {
            condition = p.remoteCondition;
            path = p.identityPath;
          }
        ]) profiles;
      };

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = lib.foldl' lib.mergeAttrs { } (
          map (
            p:
            lib.mapAttrs' (
              alias: hostname:
              lib.nameValuePair alias {
                HostName = hostname;
                User = "git";
                IdentityFile = p.sshKeyPath;
              }
            ) p.sshHosts
          ) profiles
        );
      };
    };
}
