#!/bin/bash
localhost=127.0.0.1:9650
lamina1rpc=rpc-testnet.lamina1.com
echo '⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⣿⣿'
echo '⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⠀⣿⣿⣿'
echo '⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⢿⣿⣿⣿⣿⣿⡿⠿⣿⣿⡿⠿⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⣿⣿⠿⢿⣿⣿⠿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⠛⠀⢻⣿⣿'
echo '⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⠃⡀⠘⣿⣿⣿⣿⣿⡇⠀⠘⠟⠀⠀⣿⣿⣿⣿⣿⣶⠀⣶⣿⣿⣿⣿⣿⠀⡀⠙⣿⠀⣿⣿⣿⣿⣿⡟⠀⡀⢹⣿⣿⣿⣿⣿⣿⣿⣿'
echo '⣿⠀⠿⠿⢿⣿⣿⣿⣿⠇⢀⣉⡀⠸⣿⣿⣿⣿⡇⠀⣦⣤⡆⠀⣿⣿⣿⣿⣿⠿⠀⠿⣿⣿⣿⣿⣿⠀⣷⣄⠈⠀⣿⣿⣿⣿⡿⠁⣈⣁⠀⢻⣿⣿⣿⣿⣿⣿⣿'
echo '⣿⣶⣶⣶⣾⣿⣿⣿⣿⣶⣾⣿⣷⣶⣿⣿⣿⣿⣷⣶⣿⣿⣷⣶⣿⣿⣿⣿⣿⣶⣶⣶⣿⣿⣿⣿⣿⣶⣿⣿⣷⣶⣿⣿⣿⣿⣷⣶⣿⣿⣷⣾⣿⣿⣿⣿⣿⣿⣿'
echo ''
echo 'You node ID'
node_id=$(curl -s -X POST --data '{"jsonrpc":"2.0", "id" :1,"method" :"info.getNodeID"}' -H 'content-type:application/json;' $localhost/ext/info | cut -d '"' -f 10)
echo $node_id
echo 'healty - ' | tr -d '\n'
curl -s -X POST --data '{"jsonrpc":"2.0","id":1,"method" :"health.health"}' -H 'content-type:application/json;' $localhost/ext/health | jq '.result.healthy'
echo ''
echo 'Current Lamina1 block on node'
localblock=$(curl -s -X POST --data '{ "jsonrpc":"2.0", "id":1, "method" :"eth_blockNumber", "params":[]}' -H 'content-type:application/json;' $localhost/ext/bc/C/rpc | jq '.result')
echo -n $localblock; echo -n " - "; echo $localblock | xargs printf "%d"
echo ''
echo ''
echo 'Current Lamina1 block in blockchain'
lamina1block=$(curl -s -X POST --data '{ "jsonrpc":"2.0", "id":1, "method" :"eth_blockNumber", "params":[]}' -H 'content-type:application/json;' https://$lamina1rpc/ext/bc/C/rpc | jq '.result')
echo -n $lamina1block; echo -n " - "; echo $lamina1block | xargs printf "%d"
echo ''
echo ''
echo 'Your node uptime (node info)'
curl -s -X POST --data '{"jsonrpc":"2.0","id":1,"method" :"info.uptime"}' -H 'content-type:application/json;' $localhost/ext/info | jq '.result'
echo ''
echo 'Your node uptime (Lamina1 rpc info)'
uptime=$(curl -sX POST --data '{"jsonrpc": "2.0","method": "platform.getCurrentValidators","params": {},"id": 1}' -H 'content-type:application/json;' https://$lamina1rpc/ext/bc/P|jq -rC '.result.validators[]|select(.nodeID=="'$node_id'")|.uptime')
echo "$uptime" | bc -l
echo ''
echo 'Number of connected peers'
curl -s -X POST --data '{"jsonrpc":"2.0","id":1,"method" :"info.peers"}' -H 'content-type:application/json;' $localhost/ext/info|jq '.result.numPeers'
echo ''
cd /etc/lamina1/configs/testnet5/
a=$(curl -sS -X POST --data '{"jsonrpc": "2.0","method": "platform.getBlockchains","params": {},"id": 1}' -H 'content-type:application/json;' http://$localhost/ext/bc/P |jq .result.blockchains[])
subnets=($(jq -r '."track-subnets"' < default.json))
[[ -e local.json ]] && subnets+=($(jq -r '."track-subnets"' < local.json))
bcids=()
for subnet in ${subnets[*]};do 
   bcids+=($(jq -r <<<"$a"    'select(.subnetID=="'$subnet'").id' ))
done
echo 'Is your node bootstrapped?'
for c in C P X ${bcids[*]};do
echo $c 'chain - ' | tr -d '\n'
curl -sS -X POST --data '{
    "jsonrpc": "2.0",
    "method": "info.isBootstrapped",
    "params":{
     "chain":"'$c'"
    },
    "id": 1
}' -H 'content-type:application/json;' $localhost/ext/info | jq '.result.isBootstrapped' 
done
