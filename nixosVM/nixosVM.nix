{ self, pkgs, ... }: 

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
    [
      pkgs.google-chrome
      pkgs.cmake
      pkgs.git
      pkgs.kitty
      pkgs.hyprland
      pkgs.hyprpaper
      pkgs.wayvnc
    ];

  programs.bash = {
    enable = true;
    interactiveShellInit = ''

      '';
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.shells = [ pkgs.bashInteractive ];

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  nixpkgs.hostPlatform = "aarch64-linux";
}
