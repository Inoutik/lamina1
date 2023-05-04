#!/bin/bash
echo '⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⣿⣿'
echo '⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⠀⣿⣿⣿'
echo '⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⢿⣿⣿⣿⣿⣿⡿⠿⣿⣿⡿⠿⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⣿⣿⠿⢿⣿⣿⠿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⠛⠀⢻⣿⣿'
echo '⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⠃⡀⠘⣿⣿⣿⣿⣿⡇⠀⠘⠟⠀⠀⣿⣿⣿⣿⣿⣶⠀⣶⣿⣿⣿⣿⣿⠀⡀⠙⣿⠀⣿⣿⣿⣿⣿⡟⠀⡀⢹⣿⣿⣿⣿⣿⣿⣿⣿'
echo '⣿⠀⠿⠿⢿⣿⣿⣿⣿⠇⢀⣉⡀⠸⣿⣿⣿⣿⡇⠀⣦⣤⡆⠀⣿⣿⣿⣿⣿⠿⠀⠿⣿⣿⣿⣿⣿⠀⣷⣄⠈⠀⣿⣿⣿⣿⡿⠁⣈⣁⠀⢻⣿⣿⣿⣿⣿⣿⣿'
echo '⣿⣶⣶⣶⣾⣿⣿⣿⣿⣶⣾⣿⣷⣶⣿⣿⣿⣿⣷⣶⣿⣿⣷⣶⣿⣿⣿⣿⣿⣶⣶⣶⣿⣿⣿⣿⣿⣶⣿⣿⣷⣶⣿⣿⣿⣿⣷⣶⣿⣿⣷⣾⣿⣿⣿⣿⣿⣿⣿'
echo ''
echo 'You node ID'
node_id=$(curl -s -X POST --data '{"jsonrpc":"2.0", "id" :1,"method" :"info.getNodeID"}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info | cut -d '"' -f 10)
echo $node_id
echo 'healty - ' | tr -d '\n'
curl -s -X POST --data '{"jsonrpc":"2.0","id":1,"method" :"health.health"}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/health | jq '.result.healthy'
echo ''
echo 'Current Lamina1 block on node'
curl -s -X POST --data '{ "jsonrpc":"2.0", "id":1, "method" :"eth_blockNumber", "params":[]}' -H 'content-type:application/json;' localhost:9650/ext/bc/C/rpc | jq '.result'
echo ''
echo 'Current Lamina1 block in blockchain'
curl -s -X POST --data '{ "jsonrpc":"2.0", "id":1, "method" :"eth_blockNumber", "params":[]}' -H 'content-type:application/json;' https://testnet5.lamina1.global/ext/bc/C/rpc | jq '.result'
echo ''
echo 'Your node uptime (node info)'
curl -s -X POST --data '{"jsonrpc":"2.0","id":1,"method" :"info.uptime"}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info | jq '.result'
echo ''
echo 'Your node uptime (Lamina1 rpc info)'
uptime=$(curl -sX POST --data '{"jsonrpc": "2.0","method": "platform.getCurrentValidators","params": {},"id": 1}' -H 'content-type:application/json;' https://testnet5.lamina1.global/ext/bc/P|jq -rC '.result.validators[]|select(.nodeID=="'$node_id'")|.uptime')
echo "$uptime*100" | bc -l
echo ''
echo 'Number of connected peers'
curl -s -X POST --data '{"jsonrpc":"2.0","id":1,"method" :"info.peers"}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info|jq '.result.numPeers'
echo ''
echo 'Is your node bootstrapped?'
starting_port=$1
[[ $starting_port ]] || starting_port=9650
for n in {0..0};do 
    for c in C P X;do
        echo $c 'chain - ' | tr -d '\n'
        curl -s -X POST --data '{
            "jsonrpc": "2.0",
            "method": "info.isBootstrapped",
            "params":{
             "chain":"'$c'"
            },
            "id": 1
        }' -H 'content-type:application/json;' 127.0.0.1:$((starting_port+n*10))/ext/info | jq '.result.isBootstrapped' 
    done
done
