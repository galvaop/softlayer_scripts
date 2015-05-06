#!/bin/bash
# Switch sotlayer account updating the config and vpn files
#

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

# Configure sl environment
cp $account ~/.sl_env
chmod 600 ~/.sl_env

echo "Switched account to $USER."
