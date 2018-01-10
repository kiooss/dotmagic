autoload -U add-zsh-hook

function auto-ls-after-cd() {
  emulate -L zsh
  # Only in response to a user-initiated `cd`, not indirectly (eg. via another
  # function).
  if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
    ls -AlhF --color
  fi
}

add-zsh-hook chpwd auto-ls-after-cd
