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

#### How can I restore configuration files?
1. Find out [what package installed the config file][1]:

        $ dpkg -S unity-greeter.conf
        unity-greeter: /etc/lightdm/unity-greeter.conf

  As you can see, the name of the package is `unity-greeter`.

 If you deleted a directory, like `/etc/pam.d`, you can list every package that added to it by using the directory path:

        $ dpkg -S /etc/pam.d
         login, sudo, libpam-runtime, cups-daemon, openssh-server, cron, policykit-1, at, samba-common, ppp, accountsservice, dovecot-core, passwd: /etc/pam.d

2. Rename (or delete) the config file you wish to restore:

        sudo mv -i /etc/lightdm/unity-greeter.conf /etc/lightdm/unity-greeter.conf.bak

3. Run the following command, replacing `<package-name>` with the name of the package:

        sudo apt-get -o Dpkg::Options::="--force-confmiss" install --reinstall <package-name>

 And for restoring the directory:

        sudo apt-get -o Dpkg::Options::="--force-confmiss" install --reinstall $(dpkg -S /etc/some/directory | sed 's/,//g; s/:.*//')

4. If everything worked as expected, you should get this message:

        Configuration file `/etc/lightdm/unity-greeter.conf', does not exist on system.
        Installing new config file as you requested.

4. A Practical example when needing to reinstall all of the PulseAudio configuration files:

        apt-cache pkgnames pulse | xargs -n 1 apt-get -o Dpkg::Options::="--force-confmiss" install --reinstall
  [1]: https://askubuntu.com/questions/481/how-do-i-find-the-package-that-provides-a-file

#### EOF
