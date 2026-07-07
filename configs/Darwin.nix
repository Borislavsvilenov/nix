{ pkgs, self, ... }: 

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
    [
      pkgs.iterm2
      pkgs.google-chrome
      pkgs.qbittorrent
      pkgs.ffmpeg
      pkgs.nodejs
      pkgs.python3
    ];

  programs.bash = {
    enable = true;
    interactiveShellInit = ''
      export BASH_SILENCE_DEPRECATION_WARNING=1
      '';
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.shells = [ pkgs.bashInteractive ];
  
  homebrew = {
    enable = true;
    brews = [
      "mas"
    ];
    casks = [
      "hiddenbar"
        "stats"
    ];
    masApps = {
    };
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  system.stateVersion = 6;
  system.primaryUser = "samson";

  security.pam.services.sudo_local.touchIdAuth = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.magnification = true;
  system.defaults.dock.largesize = 72;
  system.defaults.dock.show-recents = false;
  system.defaults.dock.persistent-apps = [
    "/Applications/Nix Apps/Google Chrome.app"
      "/Applications/Nix Apps/iTerm2.app"
      "/System/Applications/System Settings.app"
  ];

  system.defaults.finder.FXPreferredViewStyle = "clmv";
  system.defaults.finder.AppleShowAllExtensions = true;

  system.defaults.screencapture.location = "~/Pictures/screenshots";

  system.defaults.loginwindow.GuestEnabled = false;

  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  system.defaults.NSGlobalDomain.KeyRepeat = 2;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
