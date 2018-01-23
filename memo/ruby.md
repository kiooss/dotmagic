# rbenv

rbenv installation directory can often be the same as `RBENV_ROOT`, but they
can also be separate. The default value of `RBENV_ROOT` is `~/.rbenv`.

Setting explicit `RBENV_ROOT` only when you want to install rbenv and the ruby
versions / plugins other than `~/.rbenv`.

If you install rbenv in other place, but without set `RBENV_ROOT`, then the
rubies and plugins etc will still go for `~/.rbenv` (the default value of
`RBENV_ROOT`).
