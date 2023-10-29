#!/bin/sh

case $(uname) in
	Linux)
		yay -S emacs
		systemctl --user daemon-reload
		systemctl --user enable emacs
		;;
	Darwin)
		cp util/launch-agent.plist ~/Library/LaunchAgents/com.juliankniephoff.emacs.plist
		launchctl -w ~/Library/LaunchAgents/com.juliankniephoff.emacs.plist
		;;
esac

./scripts/recompile.sh
