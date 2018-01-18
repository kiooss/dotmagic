# Shell Configuration
# vi: sw=8 ts=8 noet

ostype() { echo $OSTYPE | tr '[A-Z]' '[a-z]'; }

export SHELL_PLATFORM='unknown'

case "$(ostype)" in
	*'linux'*	) SHELL_PLATFORM='linux'	;;
	*'darwin'*	) SHELL_PLATFORM='osx'		;;
	*'bsd'*		) SHELL_PLATFORM='bsd'		;;
esac
