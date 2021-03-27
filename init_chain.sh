#!/bin/bash -e

cd
curl https://testnet.agoric.com/network-config > chain.json
chainName=`jq -r .chainName < chain.json`
echo "ChainName=$chainName"

ag-chain-cosmos init --chain-id $chainName $(cat ~/moniker)

curl https://testnet.agoric.com/genesis.json > $HOME/.ag-chain-cosmos/config/genesis.json 
ag-chain-cosmos unsafe-reset-all

peers=`jq '.peers | join(",")' < chain.json`
sed -i -e "s/^persistent_peers *=.*/persistent_peers = $peers/" $HOME/.ag-chain-cosmos/config/config.toml
sed -i -e 's/^\(timeout_commit *=\).*/\1 "5s"/' $HOME/.ag-chain-cosmos/config/config.toml
