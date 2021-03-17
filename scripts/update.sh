#!/bin/sh

ssh-add ~/.ssh/github
rm -rf .cask
cask
./scripts/recompile.sh
git add .cask
git commit -m updates
git push
