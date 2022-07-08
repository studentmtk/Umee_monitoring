# A small instruction on how to set up a simple notification in a telegram about the status of your Peggo

 * First you need to register a bot and get its id and token.
 * There is a special bot for this >>>  https://telegram.me/botfather
 * Write to him  "/start"
 * Then the command to create your bot "/newbot"
 * Then come up with a name for your bot and write it. If it is already in use, the bot will ask you to come up with another name.
 * If successful, you will see information with your token data for accessing the HTTP API
 * Write down the token data, they will be useful to us later
 * Visit your bot and click start
 * Now we need to find your telegram account ID
 * Visit the bot and click start. https://telegram.me/getmyid_bot
 * Great, now we just need to set up a small script.


#### 1. create a directory

```
cd $HOME; mkdir $HOME/Umee_alert_Peggo

```
#### 2. creating a file with the API list ( rpc nodes are taken from here https://github.com/umee-network/umee/tree/main/networks/umee-1 )
```
echo "http://localhost:1317
https://api.athena.main.network.umee.cc
https://api.aphrodite.main.network.umee.cc
https://api.apollo.main.network.umee.cc
https://api.artemis.main.network.umee.cc
https://api.beluga.main.network.umee.cc
https://api.blue.main.network.umee.cc
https://api.bottlenose.main.network.umee.cc" > $HOME/Umee_alert_Peggo/API_Umee.txt

```
#### 3. let's create a script
```
sudo apt install nano
nano $HOME/Umee_alert_Peggo/Umee_alert_Peggo.sh

```
#### 4. Don't forget to insert your values TG_BOT, TG_ID, orchAddress
#### optional: edit the MSG, specify the description you want to receive
```
#!/bin/bash

# Telegram bot API
TG_BOT=""
# Telegram chat ID
TG_ID=""
# your orchestrator address
orchAddress=

# checking node sync
while read  line; do
  api=$line
  CHECK_API=$(curl -s $api/syncing | jq -r '.syncing')
if [[ $CHECK_API == false ]]; then
  break
fi
done < $HOME/Umee_alert_Peggo/API_Umee.txt

if [[ $CHECK_API != false ]]; then
  MSG="узлы Umee_API не синхронизированы *** nodes Umee_API are not sync"
  curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_BOT/sendMessage?chat_id=$TG_ID&text=$MSG"
  exit
fi

# Get list of validators
curl -s $api/cosmos/staking/v1beta1/validators?status=BOND_STATUS_BONDED | jq -r '.validators[]' | jq -r '.operator_address' > $HOME/Umee_alert_Peggo/validator_address.txt
# clearing old values
: > $HOME/Umee_alert_Peggo/EventNonce.txt

# get list of EventNonce
for ((i=1;i<=100;i++)); do

validator_address=$(cat $HOME/Umee_alert_Peggo/validator_address.txt | sed ''$i'!D')
ork=$(curl -s $api/gravity/v1beta/query_delegate_keys_by_validator?validator_address=$validator_address | jq -r '.orchestrator_address')
curl -s $api/gravity/v1beta/oracle/eventnonce/$ork | jq -r '.event_nonce' >> $HOME/Umee_alert_Peggo/EventNonce.txt
done

# comparison of nonce for peggo
ownEventNonce=$(curl -s $api/gravity/v1beta/oracle/eventnonce/$orchAddress | jq -r '.event_nonce')

# optional : threshold ownEventNonce
# let ownEventNonce=$ownEventNonce+10

#ownEventNonce=1000

for ((i=1;i<=100;i++)); do
  EventNonce=$(cat $HOME/Umee_alert_Peggo/EventNonce.txt | sed ''$i'!D')
  if [[ $ownEventNonce -lt $EventNonce ]]; then
    MSG="проверить peggo *** check your peggo  "
    curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_BOT/sendMessage?chat_id=$TG_ID&text=$MSG"
    break
  fi
done

```
```
sudo chmod 744 $HOME/Umee_alert_Peggo/Umee_alert_Peggo.sh

```
#### 5. Let's just put the script in Cron
```
 crontab -e
 
```
 
 #### We will make the script run every half hour. Add this line at the end
```
*/30  * * * *  $HOME/Umee_alert_Peggo/Umee_alert_Peggo.sh

```

#### 6. To test the script, uncomment #ownEventNonce=1000 and run it
```
bash -x $HOME/Umee_alert_Peggo/Umee_alert_Peggo.sh

```
#### After testing, don't forget to comment on this line again
  






