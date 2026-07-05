{ pkgs, self, ... }:

{
  home.username = "samson";
  home.homeDirectory = "/Users/samson";

  home.packages = with pkgs; [
    git
      self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
      self.packages.${pkgs.stdenv.hostPlatform.system}.tmux
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
      PS1='\[\e[38;5;33;1m\]\u\[\e[0m\] \[\e[38;5;51;1;3m\]\W\[\e[0m\] \[\e[38;5;214m\]#\[\e[0m\] '
    '';
  };

  home.stateVersion = "26.05";
}
