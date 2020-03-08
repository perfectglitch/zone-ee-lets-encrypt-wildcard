#!/bin/bash

# We'll be checking DNS record propagation through Google DNS server since that's what Lets Encrypt currently uses.
GOOGLE_DNS=8.8.8.8

function add_dns_entry(){
	# Extract second and top level domain.
	# Works for "foo.bar.tld" and "bar.tld", also "*.bar.tld".
	DOMAIN=$(echo $(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)' || expr match "$CERTBOT_DOMAIN" '\(.*\..*\)') | tr -d '\n')

	curl --silent -u $ZONE_API_USER:$ZONE_API_KEY \
	 -H "Content-Type: application/json" -X \
	 POST https://api.zone.eu/v2/dns/$DOMAIN/txt -d @- <<EOF
	{"destination":"$CERTBOT_VALIDATION", "name":"_acme-challenge.$DOMAIN"}
EOF
	echo ""
}

function wait_for_dns_propagation(){
	echo "Waiting for DNS entry to propagate..."

	dig_result=$(dig @$GOOGLE_DNS +short -t txt _acme-challenge.$DOMAIN)
	max_retries=90
	retry_delay=10
	retry_counter=0

	while [ -z "$dig_result" ]; do
		if [ $retry_counter -gt $max_retries ]; then
			echo "Waited for $(($max_retries * $retry_delay)) seconds but didn't see challenge DNS entry. Exiting."
			exit 1
		fi
		
		sleep $retry_delay && dig_result=$(dig @$GOOGLE_DNS +short -t txt _acme-challenge.$DOMAIN)
		retry_counter=$(($retry_counter+1))
	done
}

echo "Adding Lets Encrypt DNS challenge entries."

source $(dirname $0)/check_env.sh
add_dns_entry
wait_for_dns_propagation
# Optional sleep, sometimes DNS gets propagated to Google sooner than to Lets Encrypt
if [ -n "$ZONE_RETURN_DELAY" ] && [[ "$ZONE_RETURN_DELAY" =~ ^[0-9]+$ ]]; then
	echo "Waiting for $ZONE_RETURN_DELAY extra seconds for the record to propagate..."
	sleep $ZONE_RETURN_DELAY
fi

echo "Done adding Lets Encrypt DNS challenge entries."

exit 0
