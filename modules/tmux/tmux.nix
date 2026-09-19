{ pkgs, ... }: 

{
  perSystem = { pkgs, ... }: let
  
  plugins = with pkgs.tmuxPlugins; [
    vim-tmux-navigator
  ];

  pluginCmds = builtins.concatStringsSep "\n" (
      map (p: "run-shell ${p.rtp || p}/share/tmux-plugins/${p.pluginName || p.pname}/${p.pluginName || p.pname}.tmux") plugins
    );

  tmuxConf = pkgs.writeText "tmux.conf" (builtins.readFile ./tmux.conf);

  tmuxApp = pkgs.writeShellScriptBin "tmux" ''
    exec ${pkgs.tmux}/bin/tmux -f ${tmuxConf} "$@"

    ${pluginCmds}
  '';

  in {
    packages.tmux = tmuxApp;

    devShells.tmux = pkgs.mkShell {
      buildInputs = [ tmuxApp ];
      shellHook = ''
        exec tmux
      '';
    };
  };
}
