#!/bin/sh

rm -rf .cask
cask
emacs -Q --batch --funcall batch-byte-compile early-init.el
