{ inputs, ... }:
let
  containerUrls = builtins.fromJSON (builtins.readFile (inputs.secrets + "/firefox-container-urls.json"));
in
{
  flake.modules.nixos.firefox = {
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.firefox
    ];
  };

  flake.modules.homeManager.firefox =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";

        languagePacks = [
          "en-US"
          "ja"
        ];

        policies = {
          AppAutoUpdate = false;
          BackgroundAppUpdate = false;

          DisableFirefoxStudies = true;
          DisableFirefoxAccounts = true;
          DisableFirefoxScreenshots = true;
          DisableForgetButton = true;
          DisableMasterPasswordCreation = true;
          DisableProfileImport = true;
          DisableProfileRefresh = true;
          DisableSetDesktopBackground = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisableFormHistory = true;
          DisablePasswordReveal = true;

          HttpsOnlyMode = "force_enabled";

          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };

          AutofillAddressEnabled = false;
          AutofillCreditCardEnabled = false;

          FirefoxHome = {
            TopSites = false;
            SponsoredTopSites = false;
          };

          BlockAboutProfiles = true;
          BlockAboutSupport = true;

          DisplayMenuBar = "never";
          DontCheckDefaultBrowser = true;
          HardwareAcceleration = true;
          OfferToSaveLogins = false;
          DefaultDownloadDirectory = "${config.home.homeDirectory}/Downloads";

          ExtensionSettings =
            let
              moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
            in
            {
              "*".installation_mode = "blocked";

              "uBlock0@raymondhill.net" = {
                install_url = moz "ublock-origin";
                installation_mode = "force_installed";
                updates_disabled = true;
              };

              "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                install_url = moz "bitwarden-password-manager";
                installation_mode = "force_installed";
                updates_disabled = true;
              };

              "hmc@sashanoraa.gay" = {
                install_url = moz "hm-containers";
                installation_mode = "force_installed";
                updates_disabled = true;
              };
            };

          "3rdparty".Extensions = {
            "uBlock0@raymondhill.net".adminSettings = {
              userSettings = rec {
                cloudStorageEnabled = lib.mkForce false;

                importedLists = [
                  "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
                  "https://cdn.jsdelivr.net/gh/BevizLaszlo/UBlock-Filters-for-Social-Media@latest/filterlist.txt"
                ];

                externalLists = lib.concatStringsSep "\n" importedLists;
              };

              selectedFilterLists = [
                "CZE-0"
                "adguard-generic"
                "adguard-annoyance"
                "adguard-social"
                "adguard-spyware-url"
                "easylist"
                "easyprivacy"
                "adguard-cookies"
                "fanboy-annoyance"
                "fanboy-cookiemonster"
                "fanboy-social"
                "fanboy-thirdparty_social"
                "ublock-annoyances"
                "ublock-cookies-adguard"
                "ublock-cookies-easylist"
                "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
                "https://cdn.jsdelivr.net/gh/BevizLaszlo/UBlock-Filters-for-Social-Media@latest/filterlist.txt"
                "plowe-0"
                "ublock-abuse"
                "ublock-badware"
                "ublock-filters"
                "ublock-privacy"
                "ublock-quick-fixes"
                "ublock-unbreak"
                "urlhaus-1"
              ];
            };
          };
        };

        profiles.default = {
          isDefault = true;

          containersForce = true;

          containers = {
            university = {
              id = 1;
              color = "blue";
              icon = "briefcase";
              name = "University";
            };
            finance = {
              id = 2;
              color = "green";
              icon = "dollar";
              name = "Finance";
            };
            shopping = {
              id = 3;
              color = "orange";
              icon = "cart";
              name = "Shopping";
            };
            google = {
              id = 4;
              color = "red";
              icon = "circle";
              name = "Google";
            };
            work = {
              id = 5;
              color = "yellow";
              icon = "briefcase";
              name = "Work";
            };
          };

          extensions.settings = {
            "hmc@sashanoraa.gay" = {
              force = true;
              settings.containers = containerUrls;
            };
          };

          search = {
            force = true;
            default = "Kagi";
            privateDefault = "ddg";

            engines = {
              "Kagi" = {
                urls = [
                  {
                    template = "https://kagi.com/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                definedAliases = [ "@k" ];
              };

              "ddg" = {
                urls = [
                  {
                    template = "https://duckduckgo.com/";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                definedAliases = [ "@ddg" ];
              };

              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              "Nix Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };

              "NixOS Wiki" = {
                urls = [
                  {
                    template = "https://wiki.nixos.org/w/index.php";
                    params = [
                      {
                        name = "search";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@nw" ];
              };
            };
          };
        };
      };
    };
}
