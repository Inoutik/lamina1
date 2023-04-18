#!/bin/bash

echo -e '\e[40m\e[92m'
echo -e '                                                   '
echo -e ' /$$   /$$                 /$$                     '
echo -e '| $$$ | $$                | $$                     '
echo -e '| $$$$| $$  /$$$$$$   /$$$$$$$  /$$$$$$   /$$$$$$$ '
echo -e '| $$ $$ $$ /$$__  $$ /$$__  $$ /$$__  $$ /$$_____/ '
echo -e '| $$  $$$$| $$  \ $$| $$  | $$| $$$$$$$$|  $$$$$$  '
echo -e '| $$\  $$$| $$  | $$| $$  | $$| $$_____/ \____  $$ '
echo -e '| $$ \  $$|  $$$$$$/|  $$$$$$$|  $$$$$$$ /$$$$$$$/ '
echo -e '|__/  \__/ \______/  \_______/ \_______/|_______/  '
echo -e '                                                   '
echo -e '  /$$$$$$                                          '
echo -e ' /$$__  $$                                         '
echo -e '| $$  \__/ /$$   /$$  /$$$$$$  /$$   /$$           '
echo -e '| $$ /$$$$| $$  | $$ /$$__  $$| $$  | $$           '
echo -e '| $$|_  $$| $$  | $$| $$  \__/| $$  | $$           '
echo -e '| $$  \ $$| $$  | $$| $$      | $$  | $$           '
echo -e '|  $$$$$$/|  $$$$$$/| $$      |  $$$$$$/           '
echo -e ' \______/  \______/ |__/       \______/            '
echo -e '                                                   '
echo -e '\e[0m'

echo -e '\e[40m\e[92m'
echo -e '                                                   '
echo -e '⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⣿⣿'
echo -e '⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⠀⣿⣿⣿'
echo -e '⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⢿⣿⣿⣿⣿⣿⡿⠿⣿⣿⡿⠿⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⣿⣿⠿⢿⣿⣿⠿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⠛⠀⢻⣿⣿'
echo -e '⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⠃⡀⠘⣿⣿⣿⣿⣿⡇⠀⠘⠟⠀⠀⣿⣿⣿⣿⣿⣶⠀⣶⣿⣿⣿⣿⣿⠀⡀⠙⣿⠀⣿⣿⣿⣿⣿⡟⠀⡀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿'
echo -e '⣿⠀⠿⠿⢿⣿⣿⣿⣿⠇⢀⣉⡀⠸⣿⣿⣿⣿⡇⠀⣦⣤⡆⠀⣿⣿⣿⣿⣿⠿⠀⠿⣿⣿⣿⣿⣿⠀⣷⣄⠈⠀⣿⣿⣿⣿⡿⠁⣈⣁⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿'
echo -e '⣿⣶⣶⣶⣾⣿⣿⣿⣿⣶⣾⣿⣷⣶⣿⣿⣿⣿⣷⣶⣿⣿⣷⣶⣿⣿⣿⣿⣿⣶⣶⣶⣿⣿⣿⣿⣿⣶⣿⣿⣷⣶⣿⣿⣿⣿⣷⣶⣿⣿⣷⣾⣿⣿⣿⣿⣿⣿⣿'
echo -e '                                                   '
echo -e '\e[0m'

echo -e 'You node ID'

curl -X POST --data '{                                                                                           "jsonrpc":"2.0",
    "id"     :1,                                                                                                            "method" :"info.getNodeID"
    }' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info |
    cut -d '"' -f 10

echo -e 'Is your node bootstrapped?'

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