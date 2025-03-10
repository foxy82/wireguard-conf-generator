#!/bin/bash

# Either set NORDVPN_ACCESS_TOKEN in your environment or paste it in here
if [ -z "${NORDVPN_ACCESS_TOKEN}" ]; then
  NORDVPN_ACCESS_TOKEN="your_actual_token_here"
fi

# Step 1: Get your private key
echo "Getting private key..."
PRIVATE_KEY=$(curl -s -u "token:$NORD_ACCESS_TOKEN" https://api.nordvpn.com/v1/users/services/credentials | jq -r .nordlynx_private_key)

# Step 2: Get server info
echo "Getting server information..."
SERVER_INFO=$(curl -s "https://api.nordvpn.com/v1/servers/recommendations?&filters\[servers_technologies\]\[identifier\]=wireguard_udp&limit=1")

# Parse the output based on the format you provided
SERVER_DATA=$(echo "$SERVER_INFO" | jq -r '.[]|.hostname, .station, (.locations|.[]|.country|.city.name), (.locations|.[]|.country|.name), (.technologies|.[].metadata|.[].value), .load')

# Read the data into variables line by line
readarray -t SERVER_LINES <<< "$SERVER_DATA"

HOSTNAME="${SERVER_LINES[0]}"
ENDPOINT="${SERVER_LINES[1]}"
CITY="${SERVER_LINES[2]}"
COUNTRY="${SERVER_LINES[3]}"
PUBLIC_KEY="${SERVER_LINES[4]}"
SERVER_LOAD="${SERVER_LINES[6]}"  # Load is on line 7 (index 6)

# Print server information for verification
echo "Selected server: $HOSTNAME ($CITY, $COUNTRY)"
echo "Server load: $SERVER_LOAD%"
echo "Endpoint: $ENDPOINT"
echo "Public key: $PUBLIC_KEY"

# Step 3: Create config file named after the hostname
CONFIG_FILE="${HOSTNAME}-wireguard.conf"

cat > "$CONFIG_FILE" << EOF
[Interface]
PrivateKey = $PRIVATE_KEY
Address = 10.5.0.2/32
DNS = 9.9.9.9

[Peer]
PublicKey = $PUBLIC_KEY
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = $ENDPOINT:51820
EOF

echo "Configuration file created: $CONFIG_FILE"
