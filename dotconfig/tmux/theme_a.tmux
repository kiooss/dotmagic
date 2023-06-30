#!/usr/bin/env bash
#===============================================================================
# for personal customize.
#===============================================================================

# $1: option
# $2: default value
tmux_get() {
  local value
  value="$(tmux show -gqv "$1")"
  [ "$value" != "" ] && echo "$value" || echo "$2"
}

# $1: option
# $2: value
tmux_set() {
  tmux set-option -g "$1" "$2"
}

# Options
right_arrow_icon=$(tmux_get '@tmux_power_right_arrow_icon' '')
left_arrow_icon=$(tmux_get '@tmux_power_left_arrow_icon' '')
session_icon="$(tmux_get '@tmux_power_session_icon' '')"
user_icon="$(tmux_get '@tmux_power_user_icon' '')"
time_icon="$(tmux_get '@tmux_power_time_icon' '')"
date_icon="$(tmux_get '@tmux_power_date_icon' '')"
prefix_highlight_pos=$(tmux_get @tmux_power_prefix_highlight_pos)
time_format=$(tmux_get @tmux_power_time_format '%T')
date_format=$(tmux_get @tmux_power_date_format '%F')
# short for Theme-Colour
TC=$(tmux_get '@tmux_power_theme' 'gold')
case $TC in
  'gold')
    TC='#ffb86c'
    ;;
  'redwine')
    TC='#b34a47'
    ;;
  'moon')
    TC='#00abab'
    ;;
  'forest')
    TC='#228b22'
    ;;
  'violet')
    TC='#9370db'
    ;;
  'snow')
    TC='#fffafa'
    ;;
  'coral')
    TC='#ff7f50'
    ;;
  'sky')
    TC='#87ceeb'
    ;;
  'default') # Useful when your term changes colour dynamically (e.g. pywal)
    TC='colour3'
    ;;
esac

G01=#080808 #232
G02=#121212 #233
G03=#1c1c1c #234
G04=#262626 #235
G05=#303030 #236
G06=#3a3a3a #237
G07=#444444 #238
G08=#4e4e4e #239
G09=#585858 #240
G10=#626262 #241
G11=#6c6c6c #242
G12=#767676 #243

FG="$G10"
# BG="$G04"
BG="default"

# # Status options
# tmux_set status-interval 1
# tmux_set status on

# Basic status bar colors
# tmux_set status-fg "$FG"
# tmux_set status-bg "$BG"
# tmux_set status-attr none

# tmux-prefix-highlight
tmux_set @prefix_highlight_fg "$BG"
tmux_set @prefix_highlight_bg "$FG"
tmux_set @prefix_highlight_show_copy_mode 'on'
tmux_set @prefix_highlight_copy_mode_attr "fg=$TC,bg=$BG,bold"
tmux_set @prefix_highlight_output_prefix "#[fg=$TC]#[bg=$BG]$left_arrow_icon#[bg=$TC]#[fg=$BG]"
tmux_set @prefix_highlight_output_suffix "#[fg=$TC]#[bg=$BG]$right_arrow_icon"

#     
# Left side of status bar
tmux_set status-left-bg "$G04"
tmux_set status-left-fg "$G12"
tmux_set status-left-length 150
user=$(whoami)
LS="#[fg=$G04,bg=$TC,bold] $user_icon $user@#h #[fg=$TC,bg=$G06,nobold]$right_arrow_icon#[fg=$TC,bg=$G06,italics,bold] $session_icon #S "
LS="$LS#[fg=$G06,bg=$BG]$right_arrow_icon"
if [[ $prefix_highlight_pos == 'L' || $prefix_highlight_pos == 'LR' ]]; then
  LS="$LS#{prefix_highlight}"
fi
tmux_set status-left "$LS"

# Right side of status bar
tmux_set status-right-bg "$G04"
tmux_set status-right-fg "$G12"
tmux_set status-right-length 150
RS="#[fg=$TC,bg=$G06,italics] $time_icon $time_format #[fg=$TC,bg=$G06]$left_arrow_icon#[fg=$G04,bg=$TC,italics] $date_icon $date_format "

RS="#[fg=blue,bg=$G07]#{ram_fg_color}  #{ram_icon} #{ram_percentage} #[fg=$G06,bg=$G07]$left_arrow_icon$RS"
RS="#[fg=$G01,bg=$BG]$left_arrow_icon#[fg=$TC,bg=$G01,italics]#{cpu_fg_color}  #{cpu_icon} #{cpu_percentage} #[fg=$G07,bg=$G01]$left_arrow_icon$RS"

if [[ $prefix_highlight_pos == 'R' || $prefix_highlight_pos == 'LR' ]]; then
  RS="#{prefix_highlight}$RS"
fi

tmux_set status-right "$RS"

# Window status
# [purple]="#fca7ea"
# [bg_dark]="#1e2030"
# [bg]="#222436"
# [bg_highlight]="#2f334d"
# [terminal_black]="#444a73"
# [fg]="#c8d3f5"
# [fg_dark]="#828bb8"
# [fg_gutter]="#3b4261"
# [dark3]="#545c7e"
# [comment]="#7a88cf"
# [dark5]="#737aa2"
# [blue0]="#3e68d7"
# [blue]="#82aaff"
# [cyan]="#86e1fc"
# [blue1]="#65bcff"
# [blue2]="#0db9d7"
# [blue5]="#89ddff"
# [blue6]="#b4f9f8"
# [blue7]="#394b70"
# [purple]="#fca7ea"
# [magenta2]="#ff007c"
# [magenta]="#c099ff"
# [orange]="#ff966c"
# [yellow]="#ffc777"
# [green]="#c3e88d"
# [green1]="#4fd6be"
# [green2]="#41a6b5"
# [teal]="#4fd6be"
# [red]="#ff757f"
# [red1]="#c53b53"
# [white]="#ffffff"

CURRENT_BG="#4fd6be"
NUM_BG="#fca7ea"
TITLE_FG="#ffffff"

tmux_set window-status-format " #[fg=#7a88cf]#I:#W#F "
tmux_set window-status-current-format "#[fg=$NUM_BG,bg=$BG]$left_arrow_icon#[fg=#222436,bg=$NUM_BG,italics,bold] #I #[fg=$TITLE_FG,bg=$CURRENT_BG,bold] #W #[fg=$CURRENT_BG,bg=$BG,nobold]$right_arrow_icon"

# Window separator
tmux_set window-status-separator ""

# Window status alignment
tmux_set status-justify centre

# Current window status
tmux_set window-status-current-style "fg=$TC,bg=$BG"
