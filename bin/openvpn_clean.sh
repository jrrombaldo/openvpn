#!/bin/bash

# if debug enabled, print all executed commands
if [ "$DEBUG" == "1" ]; then set -x; fi
set -e # Exit immediately if a command exits with a non-zero status.


$EASY_RSA/clean-all
rm -rf $CONF_DIR/*
rm -rf $KEY_DIR/*

echo "-> safe to ignore warning, directories have to be preserved, only client conf files to be deleted"
rm -f /openvpn/*
