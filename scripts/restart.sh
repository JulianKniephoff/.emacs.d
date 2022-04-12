#!/bin/sh

systemctl --user daemon-reload
systemctl --user restart emacs
