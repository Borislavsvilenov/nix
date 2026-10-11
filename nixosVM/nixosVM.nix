{ self, pkgs, inputs, ... }: 

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
    [
      inputs.configs.packages.aarch64-linux.nvim
      inputs.configs.packages.aarch64-linux.tmux
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
    blesh.enable = true;

    shellAliases = {
      gl = "git log --oneline";
      la = "ls -la";
      cls = "clear";

      rebuild-darwin = "sudo darwin-rebuild switch --flake ~/nix/darwin#samson";
    };

    promptInit = ''
      PS1='\[\e[38;5;33;1m\]\u\[\e[0m\] \[\e[38;5;51;1;3m\]\W\[\e[0m\] \[\e[38;5;214m\]#\[\e[0m\] '
      '';
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.shells = [ pkgs.bashInteractive ];

  nixpkgs.hostPlatform = "aarch64-linux";
}
