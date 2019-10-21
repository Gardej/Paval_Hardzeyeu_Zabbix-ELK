#!/bin/sh
# var
HOST_NAME='MY-AGENT'
SERVER='192.168.56.77'
IP='192.168.56.177'
API='http://192.168.56.77/zabbix/api_jsonrpc.php'

# credo
ZABBIX_USER='Admin'
ZABBIX_PASS='zabbix'

# auth
auth() {
curl -i -X POST -H 'Content-Type: application/json-rpc' -d "{
    \"jsonrpc\": \"2.0\",
    \"method\": \"user.login\",
    \"params\": {
        \"user\": \"$ZABBIX_USER\",
        \"password\": \"$ZABBIX_PASS\"
    },
    \"id\": 1
}" $API
}
authtoken=$(auth)
TOKEN=$(echo $authtoken | cut -d'"' -f 8)
echo $TOKEN

# Create host group
create_hg() { curl -i -X POST -H 'Content-Type: application/json-rpc' -d "{
    \"jsonrpc\": \"2.0\",
    \"method\": \"hostgroup.create\",
    \"params\": {
        \"name\": \"CloudHosts\"
    },
    \"auth\": \"$TOKEN\",
    \"id\": 1 
}" $API
}
create_hg > /dev/null

# Get host group ID
get_hg_id() { curl -i -X POST -H 'Content-Type: application/json-rpc' -d "{
    \"jsonrpc\": \"2.0\",
    \"method\": \"hostgroup.get\",
    \"params\": {
        \"output\": \"extend\",
        \"filter\": {
        \"name\": \"CloudHosts\"
       }
    },
    \"auth\": \"$TOKEN\",
    \"id\": 1
}" $API
}
grpid=$(get_hg_id)
GROUPID=$(echo $grpid | cut -d '"' -f 10)
echo $GROUPID

# Create agent with template and group
create_agent() {
curl -i -X POST -H 'Content-Type: application/json-rpc' -d "{
    \"jsonrpc\": \"2.0\",
    \"method\": \"host.create\",
    \"params\": {
        \"host\": \"$HOST_NAME\",
        \"interfaces\": [
            {
                \"type\": 1,
                \"main\": 1,
                \"useip\": 1,
                \"ip\": \"$IP\",
                \"dns\": \"\",
                \"port\": \"10050\"
            }
        ],
        \"groups\": [
            {
                \"groupid\": \"$GROUPID\"
            }
        ],
        \"templates\": [
            {
                \"templateid\": \"10001\"
            }
        ]        
    },
    \"auth\": \"$TOKEN\",
    \"id\": 1 
 }" $API
}
create_agent >> /dev/null
