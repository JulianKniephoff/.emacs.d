#!/bin/sh

ssh-add -l |
	grep -q $(ssh-keygen -lf ~/.ssh/github | cut -d' ' -f2) ||
	ssh-add ~/.ssh/github

./scripts/pull.sh

rm -rf .cask || exit 1
cask || cask || exit 1

./scripts/recompile.sh

git add .cask
git commit -m updates
git push
