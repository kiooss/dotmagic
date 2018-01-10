typeset -Ag abbreviations

abbreviations=(
    "gti"    "git"
    "gt"     "git"
    "gi"     "git"
    "w"      "watch "
    "tx"     "tar xzvf"
    "tc"     "tar czvf"
    "tf"     "tail -f"
    "gc"     "git commit"
    "gl"     "git ls-tree --name-only -r HEAD"
    "my"     "mysql -u root"
    "mt"     "make-tags"
    "mc"     "mycli -u root"
    "mtp"    "make-tags-php"
)

magic-abbrev-expand() {
     local left prefix
     left=$(echo -nE "$LBUFFER" | sed -e "s/[_a-zA-Z0-9]*$//")
     prefix=$(echo -nE "$LBUFFER" | sed -e "s/.*[^_a-zA-Z0-9]\([_a-zA-Z0-9]*\)$/\1/")
     LBUFFER=$left${abbreviations[$prefix]:-$prefix}" "
}

no-magic-abbrev-expand() {
    LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey   " "    magic-abbrev-expand
bindkey   "^x "  no-magic-abbrev-expand