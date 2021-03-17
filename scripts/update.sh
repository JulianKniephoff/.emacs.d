#!/bin/sh

rm -rf .cask
cask
./scripts/recompile.sh
git add .cask
git commit -m updates
ssh-add ~/.ssh/github
git push
