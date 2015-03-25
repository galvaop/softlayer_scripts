#!/bin/bash
# Switch sotlayer account updating the config and vpn files

select account in ~/bin/sl_credentials/*; do
	echo "Configuring account $account"
	break;
done

source $account

# Configure api access
cat > ~/.softlayer <<EOT
[softlayer]
username = $USER
api_key = $API_KEY
endpoint_url = https://api.softlayer.com/xmlrpc/v3.1/
EOT
chmod 600 ~/.softlayer

# Configure vpn access script
cat > ~/.sl_env <<EOT
USER="$USER"
API_KEY="$API_KEY"
VPN_PASS="$VPN_PASS"
EOT
chmod 600 ~/.sl_env

echo "Switched account to $USER."
