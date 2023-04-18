#!/bin/sh

echo '\e[40m\e[92m'
echo '⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⣿⣿'
echo '⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⠀⣿⣿⣿'
echo '⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⢿⣿⣿⣿⣿⣿⡿⠿⣿⣿⡿⠿⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⣿⣿⠿⢿⣿⣿⠿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⠛⠀⢻⣿⣿'
echo '⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⠃⡀⠘⣿⣿⣿⣿⣿⡇⠀⠘⠟⠀⠀⣿⣿⣿⣿⣿⣶⠀⣶⣿⣿⣿⣿⣿⠀⡀⠙⣿⠀⣿⣿⣿⣿⣿⡟⠀⡀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿'
echo '⣿⠀⠿⠿⢿⣿⣿⣿⣿⠇⢀⣉⡀⠸⣿⣿⣿⣿⡇⠀⣦⣤⡆⠀⣿⣿⣿⣿⣿⠿⠀⠿⣿⣿⣿⣿⣿⠀⣷⣄⠈⠀⣿⣿⣿⣿⡿⠁⣈⣁⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿'
echo '⣿⣶⣶⣶⣾⣿⣿⣿⣿⣶⣾⣿⣷⣶⣿⣿⣿⣿⣷⣶⣿⣿⣷⣶⣿⣿⣿⣿⣿⣶⣶⣶⣿⣿⣿⣿⣿⣶⣿⣿⣷⣶⣿⣿⣿⣿⣷⣶⣿⣿⣷⣾⣿⣿⣿⣿⣿⣿⣿'
echo '\e[0m'

echo 'You node ID'
curl -X POST --data '{"jsonrpc":"2.0", "id" :1,"method" :"info.getNodeID"}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info | cut -d '"' -f 10

echo ' "
echo 'Your node uptime'
curl -X POST --data '{"jsonrpc":"2.0","id":1,"method" :"info.uptime"}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info|jq

echo 'Is your node bootstrapped?'
#!/bin/bash
starting_port=$1
[[ $starting_port ]] || starting_port=9650
for n in {0..6};do 
    for c in C P X;do
        curl -s -X POST --data '{
            "jsonrpc": "2.0",
            "method": "info.isBootstrapped",
            "params":{
             "chain":"'$c'"
            },
            "id": 1
        }' -H 'content-type:application/json;' 127.0.0.1:$((starting_port+n*10))/ext/info 
        # {"jsonrpc":"2.0","result":{"isBootstrapped":false},"id":1}
    done
done
