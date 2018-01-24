alias vi="vim"
# alias view="vim -R"

alias zshconfig="vi ~/.zshrc"
alias zz="source ~/.zshrc"

# Filesystem aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias l="ls -CF"
alias la="ls -AF"
alias ll="ls -lahF"
alias lld="ls -l | grep ^d"

alias rmf="rm -rf"
alias tf="tail -f"

# Helpers
alias grep='grep --color=auto'
alias df='df -h' # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder
alias groot='cd $(git rev-parse --show-toplevel 2> /dev/null || echo -n ".")'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en0' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en0 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# File size
alias fs="stat -f \"%z bytes\""

# ROT13-encode text. Works for decoding, too! ;)
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    alias "$method"="lwp-request -m '$method'"
done

# tmuxinator
alias mux="tmuxinator"

alias eucssh='cocot -t UTF-8 -p EUC-JP ssh'

alias svndiff='svn diff | vi -'
alias syncdir="rsync -av --exclude '*.svn' . "
alias b="bundle exec"
alias bb="bundle open"
alias sqlplus="rlwrap sqlplus"
alias use_php4="sudo a2dismod php5 && sudo service apache2 restart"
alias use_php5="sudo a2enmod php5 && sudo service apache2 restart"

alias top10="print -l -- \${(o)history%% *} | uniq -c | sort -nr | head -n 10"

alias all_key_bindings="for m (\$keymaps) bindkey -LM \$m"
alias all_zle_user_widgets="zle -lL"
alias all_zstyle="zstyle -L"
alias all_zmodload="zmodload -L"
