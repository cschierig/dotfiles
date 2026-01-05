{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.localisation;
in {
  options.modules.localisation = {
    timeZone = mkOption {
      default = "UTC";
      example = "Europe/Berlin";
      description = "the time zone of your system";
      type = types.str;
    };
    language = {
      system = mkOption {
        default = "en_GB";
        example = "de_DE";
        description = "the interface language of your system";
        type = types.str;
      };
      formats = mkOption {
        default = cfg.language.system;
        example = "de_DE";
        description = "the language used for formatting of numbers, dates, etc.";
        type = types.str;
      };
      # Formats
      monetaryFormat = mkOption {
        default = null;
        example = "de_DE";
        description = "the monetary format of your system";
        type = types.nullOr types.str;
      };
      numericFormat = mkOption {
        default = null;
        example = "de_DE";
        description = "the numeric format of your system";
        type = types.nullOr types.str;
      };
      timeFormat = mkOption {
        default = null;
        example = "de_DE";
        description = "the time format of your system";
        type = types.nullOr types.str;
      };
      addressFormat = mkOption {
        default = null;
        example = "de_DE";
        description = "the address format of your system";
        type = types.nullOr types.str;
      };
      measurementFormat = mkOption {
        default = null;
        example = "de_DE";
        description = "the measurement format of your system";
        type = types.nullOr types.str;
      };
    };
  };

  config = {
    # Time zone.
    time.timeZone = cfg.timeZone;

    # Locales
    # Only supports utf8 for now
    i18n = {
      defaultLocale = cfg.language.system + ".utf8";
      extraLocaleSettings = {
        # POSIX
        # TODO: determine if I need to change this 
        LC_CTYPE = cfg.language.system + ".utf8";
        LC_COLLATE = cfg.language.system + ".utf8"; 
        LC_MESSAGES = cfg.language.system + ".utf8"; 
        LC_MONETARY = optionalString (cfg.language ? monetaryFormat) (cfg.language.formats + ".utf8");
        LC_NUMERIC = optionalString (cfg.language ? numericFormat) (cfg.language.formats + ".utf8");
        LC_TIME = optionalString (cfg.language ? timeFormat) (cfg.language.formats + ".utf8");
        # GNU extensions
        LC_ADDRESS = optionalString (cfg.language ? addressFormat) (cfg.language.formats + ".utf8");
        LC_IDENTIFICATION = cfg.language.system + ".utf8";
        LC_MEASUREMENT = optionalString (cfg.language ? measurementFormat) (cfg.language.formats + ".utf8");
        LC_NAME = cfg.language.system + ".utf8";
        LC_PAPER = cfg.language.formats + ".utf8";
        LC_TELEPHONE = cfg.language.formats + ".utf8";
      };
    };

    # Keymap in X11
    services.xserver.xkb = {
      layout = "de";
      variant = "";
    };
    console.keyMap = "de"; # Console keymap
  };
}
