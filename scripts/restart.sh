#!/bin/sh

case $(uname) in
	Linux)
		systemctl --user daemon-reload
		systemctl --user restart emacs
		;;
	Darwin)
		launchctl kickstart -k gui/$(id -u)/com.juliankniephoff.emacs
		;;
esac
