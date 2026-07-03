{ pkgs, self, ... }:

{
  home.username = "samson";
  home.homeDirectory = "/Users/samson";

  home.packages = with pkgs; [
    git
      tmux
      self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
      pkgs.bashInteractive
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings.user.name = "Borislavsvilenov";
    settings.user.email = "bobo.svilenov@gmail.com";
  };

  programs.bash = {
    enable = true;

    shellAliases = {
      gl = "git log --oneline";
      la = "ls -la";
      cls = "clear";

      rebuild = "sudo darwin-rebuild switch --flake ~/nix#samson";
    };

    initExtra = ''
      
    '';
  };

  home.stateVersion = "26.05";
}
