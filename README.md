# Wildcard certs with Let's Encrypt in Zone.ee VPS using ZoneID API

## About

Wildcard cert update hooks for certbot-auto DNS authorization in Zone.ee VPS.

Some backstory: https://www.wizewarez.eu/2018/10/wildcard-certs-with-lets-encrypt-in-zoneee-linux-vps-using-zone-id-rest-api

ZoneID API reference: https://api.zone.eu/v2

## Setup

Upload these 3 files to your server.

When adding a new domain with certbot-auto, set `--manual-auth-hook` and `--manual-cleanup-hook` values as follows

* `--manual-auth-hook=/path/to/letsencrypt_add_dns.sh`
* `--manual-cleanup-hook=/path/to/letsencrypt_remove_dns.sh`

Set ZoneID API authentication env vars: ZONE_API_USER and ZONE_API_KEY. These will be used for adding/removing DNS entries.

## How it works

### `letsencrypt_add_dns.sh`

A new DNS entry is added using ZoneID API. Once the DNS entry is added, script checks Google DNS servers(8.8.8.8) for DNS record propagation using `dig` command.

### `letsencrypt_remove_dns`

Removes DNS entry using ZoneID API.

### `check_env.sh`

Used by both previous scripts to check that all required environment variables are present.
