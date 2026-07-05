{ pkgs, ... }: 

let

withPlugins = pkgs.tmux.override {
};

configFile = pkgs.writeText "tmux.conf" ''
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",*:RGB"
set -g mouse on
set -g set-clipboard on

unbind C-b
set -g prefix C-a
bind-key C-a send-prefix
'';

in

pkgs.writeShellScriptBin "tmux" ''
${withPlugins}/bin/tmux -f ${configFile} "$@"
''


