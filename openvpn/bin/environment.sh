#!/bin/bash

 # GERAL CONFIG 
export CONF_DIR="/openvpn/conf" 
export LOGS_DIR="/openvpn/logs" 
export KEY_DIR="/openvpn/keys" 
export OVPN_DIR="/etc/openvpn" # value used on Dockerfile.

export CA_CRT="ca.crt" 
export CA_KEY="ca.key" 
export DH="dh2048.pem" 
export OPVN_CNF="udp_srv.conf" 

# EASY RSA VARS
export EASY_RSA="$OVPN_DIR/easy-rsa" 
export OPENSSL="openssl" 
export PKCS11TOOL="pkcs11-tool" 
export GREP="grep" 
export KEY_CONFIG="$CONF_DIR/openssl.cnf" 
#  KEY_CONFIG="$EASY_RSA/whichopensslcnf $EASY_RSA" /

# keys details
export KEY_SIZE="2048" 
export CA_EXPIRE="3650" 
export KEY_EXPIRE="3650" 
export KEY_COUNTRY="UK" 
export KEY_PROVINCE="LDN" 
export KEY_CITY="LONDON" 
export KEY_ORG="MyOrg" 
export KEY_ALTNAMES="something" 
export KEY_EMAIL="my-vpn@myorg.net" 
export KEY_OU="MyOrganizationalUnit" 
# X509 Subject Field
export KEY_NAME="EasyRSA_CA" 
# PKCS11 fixes
export PKCS11_MODULE_PATH="dummy" 
export PKCS11_PIN="dummy" 
# server details
export SERVER_NAME="MyVPN" 
export SERVER_REMOTE_ADDR="v.rombaldo.com"