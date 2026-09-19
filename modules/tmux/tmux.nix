{ pkgs, ... }: 

let
plugins = with pkgs.tmuxPlugins; [
  vim-tmux-navigator
  catppuccin
];

pluginCmds = builtins.concatStringsSep "\n" (
  map (p: 
    let
      path = p.rtp or "${p}/share/tmux-plugins/${p.pluginName or p.pname}";
      name = p.pluginName or p.pname;
    in 
      "run ${path}/${name}.tmux"
    ) plugins
  );

tmuxConf = pkgs.writeText "tmux.conf" ''
  ${builtins.readFile ./tmux.conf}
  ${pluginCmds}
'';

tmuxApp = pkgs.writeShellScriptBin "tmux" ''
  exec ${pkgs.tmux}/bin/tmux -f ${tmuxConf} "$@"
'';

in {
  packages.tmux = tmuxApp;

  devShells.tmux = pkgs.mkShell {
    buildInputs = [ tmuxApp ];
    shellHook = ''
      exec tmux
      '';
  };
}

