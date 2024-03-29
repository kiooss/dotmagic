export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

setopt NO_BG_NICE
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
#setopt IGNORE_EOF
setopt PROMPT_SUBST
setopt nonomatch

#In the line editor, the number of filenames to list without asking first.
#If set to zero, the shell asks only if the listing would scroll off the screen.
LISTMAX=0
# display how long all tasks over 10 seconds take
REPORTTIME=10

# history
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY SHARE_HISTORY
setopt APPEND_HISTORY

setopt COMPLETE_ALIASES
#GLOBDOTS lets files beginning with a . be matched without explicitly specifying the dot.
setopt GLOBDOTS

# only crerect commands but not parameters.
setopt CORRECT
unsetopt CORRECT_ALL

autoload -Uz zmv
alias zmv='noglob zmv -W'

