#!/bin/bash
# set -x # uncomment to enable debug

umeevaloper=
moniker=
cli=$HOME/go/bin/umeed
SIDE_RPC="https://umeevengers-1b-rpc-1.nodes.guru" #RPC Nodes_guru
NODE_RPC="http://127.0.0.1:26657" #Your node RPC address, e.g. "http://127.0.0.1:26657"
now=$(date +%s%N)   # date in influx format
STATUS=$(curl -s "$NODE_RPC/status")
STATUS_RPC=$(curl -s "$SIDE_RPC/status")
CATCHING_UP=$(echo $STATUS | jq '.result.sync_info.catching_up')
CATCHING_UP_SIDE=$(echo $STATUS_RPC | jq '.result.sync_info.catching_up')

# latest_block_height node  RPC Nodes guru
LATEST_BLOCK_RPC=$(echo $STATUS_RPC | jq -r '.result.sync_info.latest_block_height')

# sync status + latest block of SIDE_RPC ( RPC Nodes guru )
# 0 - node is not synchronized; 1 -noda Nodes Guru stopped; if the node is synchronized, it shows the height of the node
curl -s "$SIDE_RPC/status"> /dev/null
if [ $CATCHING_UP_SIDE = "true" ]; then
    LATEST_BLOCK_RPC=0
elif [ $CATCHING_UP_SIDE = "false" ]; then
    LATEST_BLOCK_RPC=$LATEST_BLOCK_RPC
else
    LATEST_BLOCK_RPC=1
fi

# sync status of NODE_RPC ( Your node )
# 0 - Your node is synchronized; 1- Your node is not synchronized; 3 - Your noda stopped
if [ $CATCHING_UP = "true" ]; then
    CATCHING_UP=1
elif [ $CATCHING_UP = "false" ]; then
    CATCHING_UP=0
else
    CATCHING_UP=3; echo "nodemonitor,moniker=$moniker CATCHING_UP=3 $now"; exit
fi

# parameters of your node
LATEST_BLOCK=$(echo $STATUS | jq -r '.result.sync_info.latest_block_height')
VOTING_POWER=$(echo $STATUS | jq -r '.result.validator_info.voting_power')
jailed=$($cli q staking validator $umeevaloper -o json | jq '.jailed')

if [ $jailed = "true" ]; then
    status_jailed=0
else
    status_jailed=1
fi

# calculating percentages of missed blocks  // if you are in prison, then after you exit, the calculation will begin anew
miss_blocks=$($cli q slashing signing-info $($cli tendermint show-validator) -o json | jq -r '."missed_blocks_counter"')
total_Height_blocks=$($cli q slashing signing-info $($cli tendermint show-validator) -o json | jq -r '."index_offset"')
start_Height_blocks=$($cli q slashing signing-info $($cli tendermint show-validator) -o json | jq -r '."start_height"')
let blocks=$total_Height_blocks-$start_Height_blocks

if [ $miss_blocks -eq 0 ]; then
    pct_up_time=100
else
    skip_rate=$(echo "scale=4 ; 100 * $miss_blocks / $blocks" | bc)
    pct_up_time=$(echo "scale=4 ;  100 - $skip_rate" | bc)
fi

logentry="CATCHING_UP=$CATCHING_UP,miss_blocks=$miss_blocks,pct_up_time=$pct_up_time,LATEST_BLOCK=$LATEST_BLOCK,LATEST_BLOCK_RPC=$LATEST_BLOCK_RPC,VOTING_POWER=$VOTING_POWER,status_jailed=$status_jailed"
logentry="nodemonitor,moniker=$moniker $logentry $now"
echo $logentry

