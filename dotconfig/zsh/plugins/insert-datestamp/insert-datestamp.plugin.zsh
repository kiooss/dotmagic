insert-datestamp() { LBUFFER+=${(%):-'%D{%Y%m%d%H%M%S}'}; }
zle -N insert-datestamp
bindkey '\ed' insert-datestamp
