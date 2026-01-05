{ config, pkgs, inputs, lib, stateVersion, options, ... }:
{
  #############
  # Networking
  #############

  networking.networkmanager.enable = true;
  networking.firewall.allowedUDPPorts = [
    1194 # KIT VPN
  ];

  services.printing.enable = true;

  ########
  # Sound
  ########

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ##############
  # Environment
  ##############

  environment.sessionVariables = {
    # Fix for VSCode on Wayland
    NIXOS_OZONE_WL = "1";

    # Firefox
    MOZ_ENABLE_WAYLAND = "1";

    JAVA_HOME = "${pkgs.jdk21.home}";
  };


  #################
  # Users & Groups
  #################

  users.defaultUserShell = pkgs.nushell;

  # User list
  users.users.carl = {
    isNormalUser = true;
    description = "Carl Schierig";
    extraGroups = [ "networkmanager" "wheel" "i2c" "docker" "vboxusers" ];
  };

  users.groups = {
    i2c = { };
  };

  ###############
  # Localisation
  ###############

  modules.localisation = {
    timeZone = "Europe/Berlin";
    language = {
      system = "en_GB";
      formats = "de_DE";
    };
  };

  ###########
  # Packages
  ###########

  # Binary caches
  nix.settings.substituters = [ "https://nix-community.cachix.org" ];
  nix.settings.trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];

  environment.systemPackages = with pkgs; [
    # Desktop Applications
    firefox-wayland
    vlc
    onlyoffice-bin
    signal-desktop
    papers


    # Terminal/Shell

    wezterm

    ## Cli

    bat
    broot
    dottor
    fend
    fzf
    wget
    zellij
    zoxide

    # Development

    dotnet-sdk_8
    lldb
    typst

    jdk21
    (python3.withPackages (ps: with ps; [ pip ]))

    # Git
    git
    git-lfs
    gh
    commitizen

    (vscode-with-extensions.override {
      vscodeExtensions = (with vscode-extensions; [
        rust-lang.rust-analyzer
        vadimcn.vscode-lldb
        vscode-extensions.ms-dotnettools.csharp
        ms-python.python
        ms-python.debugpy

        dart-code.dart-code
        dart-code.flutter
      ]) ++ (with vscode-marketplace; [
        # Theming
        pkief.material-icon-theme
        dracula-theme.theme-dracula
        usernamehw.errorlens
        avetis.tokyo-night
        wayou.vscode-todo-highlight
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons

        # Minecraft
        stevertus.mcscript
        levertion.mcjson

        # Languages
        tamasfe.even-better-toml
        jnoortheen.nix-ide
        slevesque.shader

        asvetliakov.vscode-neovim
        streetsidesoftware.code-spell-checker

        ms-dotnettools.vscode-dotnet-runtime
        editorconfig.editorconfig
      ]);
    })

    # Gaming
    prismlauncher
    packwiz
    (vintagestory.overrideAttrs rec {
      version = "1.19.7";
      src = fetchurl {
        url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
        hash = "sha256-C+vPsoMlo6EKmzf+XkvIhrDGG7EccU8c36GZt0/1r1Q=";
      };
    })
  ];

  # GnuPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    # pinentryPackage = pkgs.;
  };

  # Fonts
  fonts.packages = with pkgs; [
    fira-code
    (nerdfonts.override {
      fonts = [ "FiraCode" ];
    })
  ];

  # Gaming
  programs.gamemode.enable = true;

  # programs.java = {
  #   enable = true;
  #   package = pkgs.jdk21;
  # };

  # dynamically linked stuff
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc

      # Minecraft
      libpulseaudio
      libGL
      glfw
      openal
      stdenv.cc.cc.lib
    ];
  };

  ##########
  # Drivers
  ##########

  # Firmware
  services.fwupd.enable = true;

  #########
  # Kernel
  #########

  boot = {
    kernelPackages = pkgs.linuxPackages_latest; # Always use latest stable kernel
    supportedFilesystems = [ "ntfs" ];
    initrd.verbose = false;
  };

  #############
  # Booting
  #############

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 25;
    };
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };
}
