# Startup Files

There are five startup files that zsh will read commands from:

$ZDOTDIR/.zshenv
$ZDOTDIR/.zprofile
$ZDOTDIR/.zshrc
$ZDOTDIR/.zlogin
$ZDOTDIR/.zlogout

If ZDOTDIR is not set, then the value of HOME is used; this is the usual case.

'.zshenv' is sourced on all invocations of the shell, unless the -f option is
set. It should contain commands to set the command search path, plus other
important environment variables. '.zshenv' should not contain commands that
produce output or assume the shell is attached to a tty.

'.zshrc' is sourced in interactive shells. It should contain commands to set up
aliases, functions, options, key bindings, etc.

'.zlogin' is sourced in login shells. It should contain commands that should be
executed only in login shells. '.zlogout' is sourced when login shells exit.
'.zprofile' is similar to '.zlogin', except that it is sourced before '.zshrc'.
'.zprofile' is meant as an alternative to '.zlogin' for ksh fans; the two are
not intended to be used together, although this could certainly be done if
desired. '.zlogin' is not the place for alias definitions, options, environment
variable settings, etc.; as a general rule, it should not change the shell
environment at all. Rather, it should be used to set the terminal type and run a
series of external commands (fortune, msgs, etc).

# Shell Types

*Interactive*: As the term implies: Interactive means that the commands are run
with user-interaction from keyboard. E.g. the shell can prompt the user to enter
input.

*Non-interactive*: the shell is probably run from an automated process so it
can't assume if can request input or that someone will see the output. E.g Maybe
it is best to write output to a log-file.

*Login*: Means that the shell is run as part of the login of the user to the
system. Typically used to do any configuration that a user needs/wants to
establish his work-environment.

*Non-login*: Any other shell run by the user after logging on, or which is run
by any automated process which is not coupled to a logged in user.
