#!/bin/bash
localhost=127.0.0.1:9650
lamina1rpc=rpc-betanet.lamina1.com

echo '⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⣿⣿'
echo '⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⠀⣿⣿⣿'
echo '⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⢿⣿⣿⣿⣿⣿⡿⠿⣿⣿⡿⠿⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⣿⣿⠿⢿⣿⣿⠿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⠛⠀⢻⣿⣿'
echo '⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⠃⡀⠘⣿⣿⣿⣿⣿⡇⠀⠘⠟⠀⠀⣿⣿⣿⣿⣿⣶⠀⣶⣿⣿⣿⣿⣿⠀⡀⠙⣿⠀⣿⣿⣿⣿⣿⡟⠀⡀⢹⣿⣿⣿⣿⣿⣿⣿⣿'
echo '⣿⠀⠿⠿⢿⣿⣿⣿⣿⠇⢀⣉⡀⠸⣿⣿⣿⣿⡇⠀⣦⣤⡆⠀⣿⣿⣿⣿⣿⠿⠀⠿⣿⣿⣿⣿⣿⠀⣷⣄⠈⠀⣿⣿⣿⣿⡿⠁⣈⣁⠀⢻⣿⣿⣿⣿⣿⣿⣿'
echo '⣿⣶⣶⣶⣾⣿⣿⣿⣿⣶⣾⣿⣷⣶⣿⣿⣿⣿⣷⣶⣿⣿⣷⣶⣿⣿⣿⣿⣿⣶⣶⣶⣿⣿⣿⣿⣿⣶⣿⣿⣷⣶⣿⣿⣿⣿⣷⣶⣿⣿⣷⣾⣿⣿⣿⣿⣿⣿⣿'
echo ''
echo 'Your node IDs'
node_id=$(curl -s -X POST --data '{"jsonrpc":"2.0", "id" :1,"method" :"info.getNodeID"}' -H 'content-type:application/json;' $localhost/ext/info | cut -d '"' -f 10)
node_pk=$(curl -s -X POST --data '{"jsonrpc":"2.0", "id" :1,"method" :"info.getNodeID"}' -H 'content-type:application/json;' $localhost/ext/info | jq -r .result.nodePOP.publicKey)
node_pop=$(curl -s -X POST --data '{"jsonrpc":"2.0", "id" :1,"method" :"info.getNodeID"}' -H 'content-type:application/json;' $localhost/ext/info | jq -r .result.nodePOP.proofOfPossession)
echo $node_id
echo NodePK-$node_pk
echo NodePOP-$node_pop
echo 'healthy - ' | tr -d '\n'
curl -s -X POST --data '{"jsonrpc":"2.0","id":1,"method" :"health.health"}' -H 'content-type:application/json;' $localhost/ext/health | jq '.result.healthy'
echo ''
echo 'Current Lamina1 block on node (betanet)'
localblock=$(curl -s -X POST --data '{ "jsonrpc":"2.0", "id":1, "method" :"eth_blockNumber", "params":[]}' -H 'content-type:application/json;' $localhost/ext/bc/C/rpc | jq '.result')
echo -n $localblock; echo -n " - "; echo $localblock | xargs printf "%d"
echo ''
echo 'Current Lamina1 block in blockchain (betanet)'
lamina1block=$(curl -s -X POST --data '{ "jsonrpc":"2.0", "id":1, "method" :"eth_blockNumber", "params":[]}' -H 'content-type:application/json;' https://$lamina1rpc/ext/bc/C/rpc | jq '.result')
echo -n $lamina1block; echo -n " - "; echo $lamina1block | xargs printf "%d"
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

echo ''
echo 'Stake Info'
# Function to format value in K and M
format_value() {
    local ret=$1
    if (( $(echo "$ret > 1000" |bc -l) )); then
        ret=$(echo "scale=3; $ret / 1000" | bc)
        if (( $(echo "$ret > 1000" |bc -l) )); then
            ret=$(echo "scale=3; $ret / 1000" | bc)
            ret="$ret M"
        else
            ret="$ret K"
        fi
    fi
    echo $ret
}

# Get current validators
data=$(curl -sS -X POST --data '{"jsonrpc":"2.0","id":1,"method":"platform.getCurrentValidators", "params": {"nodeIDs": ["'$node_id'"]}}' \
    -H 'content-type:application/json;' $localhost/ext/bc/P |
    jq '.result.validators[] | select(.nodeID=="'$node_id'")')
	
echo $data
[[ $data ]] || {
    # Check if node is in pending validators
    pending=$(curl -sS -X POST --data '{"jsonrpc":"2.0","id":1,"method":"platform.getPendingValidators", "params": {"nodeIDs": ["'$node_id'"]}}' \
        -H 'content-type:application/json;' $localhost/ext/bc/P |
        jq '.result.validators[] | select(.nodeID=="'$node_id'")')
    [[ $pending ]] || {
        echo "$node_id not staked yet"
        exit -1
    }
    # Check start time
    start=$(echo $pending | jq -r '.startTime')
    start=$(date -d "@$start" "+%Y-%m-%d %H:%M:%S" -u)
    echo -e "$node_id found in pending validators\nStart Time: $start UTC"
    exit -1
}	

# Get validator info
# Uptime
uptime=$(echo $data | jq -r '.uptime')
# Start time
start=$(echo $data | jq -r '.startTime')
start=$(date -d "@$start" "+%Y-%m-%d %H:%M:%S" -u)
# End Time
endtime=$(echo $data | jq -r '.endTime')
endtime=$(date -d "@$endtime" "+%Y-%m-%d %H:%M:%S" -u)
# Delegation fee
fee=$(echo $data | jq -r '.delegationFee')
# Number of delegators
dels=$(echo $data | jq -r '.delegators | length')
# Delegated Stake
if [[ $dels -eq 0 ]]; then
    stake=0
    rewards=0
else
    stake=$(echo $data | jq -r '[.delegators[] | .stakeAmount | tonumber] | add / 1000000000')
    stake=$(format_value $stake)
    # Potential Delegation Rewards
    rewards=$(echo $data | jq -r '[.delegators[] | .potentialReward | tonumber] | add')
    rewards=$(echo "scale=9; $rewards * $fee / 100000000000 " | bc -l)
    rewards=$(format_value $rewards)
fi
# Accrued Delegation Rewards
accrued_rewards=$(echo $data | jq -r '.accruedDelegateeReward | tonumber / 1000000000')
accrued_rewards=$(format_value $accrued_rewards)
# Delegation Rewards Destination
rewards_owner=$(echo $data | jq -r '.delegationRewardOwner.addresses[0]')

L1uptime=$(curl -sX POST --data '{"jsonrpc": "2.0","method": "platform.getCurrentValidators","params": {},"id": 1}' -H 'content-type:application/json;' https://$lamina1rpc/ext/bc/P|jq -rC '.result.validators[]|select(.nodeID=="'$node_id'")|.uptime')

# Print info
echo "Start Time: $start UTC"
echo "End Time: $endtime UTC"
echo "Uptime (node info): $uptime%"
echo "Uptime (Lamina1 rpc info): $L1uptime%"
echo "Delegation fee: $fee%"
echo "Delegators: $dels"
echo "Delegated stake: $stake L1"
echo "Potential Delegation Rewards: $rewards L1"
echo "Accrued Delegation Rewards: $accrued_rewards L1"
echo "Delegation Rewards Destination: $rewards_owner"
