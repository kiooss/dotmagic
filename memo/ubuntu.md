#### switch shell and login screen
CTRL+ALT+F1 = go to sheel
CTRL+ALT+F7 = go to login screen

#### when can't display unicode char.
export LANG=C

#### apt error
check the error
`$ sudo dpkg --audit`
re configure
`$ sudo dpkg --configure squid3`

/var/lib/dpkg/info に特定なファイルを削除

もう一回configure
`$ sudo dpkg --configure squid3`
