#!/bin/bash

function remove_dns_entry(){
	# Extract second and top level domain.
	# Works for "foo.bar.tld" and "bar.tld", also "*.bar.tld".
	DOMAIN=$(echo $(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)' || expr match "$CERTBOT_DOMAIN" '\(.*\..*\)') | tr -d '\n')

	curl -s https://api.zone.eu/v2/dns/$DOMAIN/txt -u $ZONE_API_USER:$ZONE_API_KEY | jq -c -r '.[] | select(.name | contains("_acme-challenge")) | .id' | xargs -I {} -n 1 curl --silent -u $ZONE_API_USER:$ZONE_API_KEY -X DELETE https://api.zone.eu/v2/dns/$DOMAIN/txt/{} 
}

echo "Removing Lets Encrypt DNS challenge entry."

source $(dirname $0)/check_env.sh
remove_dns_entry

echo "Done removing Lets Encrypt DNS challenge entry."

exit 0