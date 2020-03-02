#!/bin/bash

# One can set credentials and parameters also here
#ZONE_API_USER=virt000
#ZONE_API_KEY=000000000000000000000000000000000000000000000
#ZONE_RETURN_DELAY=300


echo "Checking env vars."

vars_missing=0

if [ -z "$CERTBOT_DOMAIN" ]; then
    echo "CERTBOT_DOMAIN not set."
    vars_missing=1
fi
if [ -z "$CERTBOT_VALIDATION" ]; then
    echo "CERTBOT_VALIDATION not set."
    vars_missing=1
fi
if [ -z "$ZONE_API_USER" ]; then
    echo "ZONE_API_USER not set"
    vars_missing=1
fi  
if [ -z "$ZONE_API_KEY" ]; then
    echo "ZONE_API_KEY not set"
    vars_missing=1
fi

if [ $vars_missing -eq 1 ]; then
	echo "Not all required env vars are set, exiting."
	exit 1
fi

echo "Env vars OK."
