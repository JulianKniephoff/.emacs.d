#!/bin/sh

emacs -Q --batch --funcall batch-byte-compile early-init.el
./scripts/restart.sh
