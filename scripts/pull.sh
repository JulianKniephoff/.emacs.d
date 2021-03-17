#!/bin/sh

ssh-add ~/.ssh/github
git pull
./scripts/recompile.sh
