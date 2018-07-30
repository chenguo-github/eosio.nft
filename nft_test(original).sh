#! /bin/bash
set -e
set -u
set -o pipefail


# docker run -t -i -v /Users/guoguo/Desktop:/hostdata  eosio/eos-dev /bin/bash
# docker run -t -i -v /home/guochen/Desktop:/hostdata  eosio/eos-dev /bin/bash
# eosiocpp -o eosio.nft.wast eosio.nft.cpp
# eosiocpp -g eosio.nft.abi eosio.nft.cpp
# alias cleos="docker-compose exec keosd /opt/eosio/bin/cleos -u http://nodeosd:8888 --wallet-url http://localhost:8888"



cleos="docker-compose exec keosd /opt/eosio/bin/cleos -u http://nodeosd:8888 --wallet-url http://localhost:8888"

echo "---------------- Start Docker! ----------------";
docker-compose down
docker-compose up -d


echo "---------------- Create A Wallet! ----------------";
${cleos} wallet create


echo "---------------- Import Test Key! ----------------";
${cleos} wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3


echo "---------------- Create Test Account! ----------------";
${cleos} create account eosio eosio.nft123 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
${cleos} create account eosio 12345tester1 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
${cleos} create account eosio 12345tester2 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
${cleos} create account eosio 12345tester3 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
${cleos} get accounts EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV



echo "---------------- Deploy Contract! ----------------";
${cleos} set contract eosio.nft123 hostdata/eos/contracts/eosio.nft -p eosio.nft123



echo "---------------- Create EDOG Token! ----------------";
${cleos} push action eosio.nft123 create '[ "12345tester1", "EDOG"]' -p eosio.nft123
${cleos} push action eosio.nft123 create '[ "12345tester1", "ZOD"]' -p eosio.nft123



echo "---------------- Get Table Info! ----------------";
echo "=== token table: ===";
${cleos} get table eosio.nft123 eosio.nft123 token



echo "---------------- Issue 12345Tester1 Three Dogs and Zods! ----------------";
${cleos} push action eosio.nft123 issue '[ "12345tester1", "3 EDOG", ["dog1", "dog2", "dog3"], "ETHERDOG", "IssueTest"]' -p 12345tester1
${cleos} push action eosio.nft123 issue '[ "12345tester1", "3 ZOD", ["zod1", "zod2", "zod3"], "ZODIAC", "IssueTest"]' -p 12345tester1
echo "---------------- Get Table Info! ----------------";
echo "=== token table: ===";
${cleos} get table eosio.nft123 eosio.nft123 token



echo "---------------- Transfer dog1 to 12345tester2! ----------------";
${cleos} push action eosio.nft123 transfer '[ "12345tester1", "12345tester2", "0", "TransferTest" ]' -p 12345tester1
echo "---------------- Get Table Info! ----------------";
echo "=== token table: ===";
${cleos} get table eosio.nft123 eosio.nft123 token



echo "---------------- Transfer dog1 to 12345tester3! ----------------";
${cleos} push action eosio.nft123 transfer '[ "12345tester2", "12345tester3", "0", "TransferTest" ]' -p 12345tester2
echo "---------------- Get Table Info! ----------------";
echo "=== token table: ===";
${cleos} get table eosio.nft123 eosio.nft123 token



echo "---------------- Burn dog2 From 12345tester1! ----------------";
${cleos} push action eosio.nft123 burn '[ "12345tester1", "1" ]' -p 12345tester1
echo "---------------- Get Table Info! ----------------";
echo "=== token table: ===";
${cleos} get table eosio.nft123 eosio.nft123 token



echo "---------------- setrampayer! ----------------";
${cleos} push action eosio.nft123 setrampayer '[ "12345tester3", "0" ]' -p 12345tester3
echo "---------------- Get Table Info! ----------------";
echo "=== token table: ===";
${cleos} get table eosio.nft123 eosio.nft123 token
echo "=== 12345tester1 table: ===";
${cleos} get table eosio.nft123 12345tester1 accounts
echo "=== 12345tester2 table: ===";
${cleos} get table eosio.nft123 12345tester2 accounts
echo "=== 12345tester3 table: ===";
${cleos} get table eosio.nft123 12345tester3 accounts
echo "=== EDOG table: ===";
${cleos} get table eosio.nft123 EDOG stat
echo "=== ZOD table: ===";
${cleos} get table eosio.nft123 ZOD stat



echo "---------------- Clear Balance! ----------------";
${cleos} push action eosio.nft123 clearbalance '[ "12345tester3", "1 EDOG" ]' -p eosio.nft123
echo "---------------- Get Table Info! ----------------";
echo "=== token table: ===";
${cleos} get table eosio.nft123 eosio.nft123 token
echo "=== 12345tester1 table: ===";
${cleos} get table eosio.nft123 12345tester1 accounts
echo "=== 12345tester2 table: ===";
${cleos} get table eosio.nft123 12345tester2 accounts
echo "=== 12345tester3 table: ===";
${cleos} get table eosio.nft123 12345tester3 accounts
echo "=== EDOG table: ===";
${cleos} get table eosio.nft123 EDOG stat
echo "=== ZOD table: ===";
${cleos} get table eosio.nft123 ZOD stat



echo "---------------- Clear Balance! ----------------";
${cleos} push action eosio.nft123 clearsymbol '[ "0 ZOD" ]' -p eosio.nft123
echo "---------------- Get Table Info! ----------------";
echo "=== token table: ===";
${cleos} get table eosio.nft123 eosio.nft123 token
echo "=== 12345tester1 table: ===";
${cleos} get table eosio.nft123 12345tester1 accounts
echo "=== 12345tester2 table: ===";
${cleos} get table eosio.nft123 12345tester2 accounts
echo "=== 12345tester3 table: ===";
${cleos} get table eosio.nft123 12345tester3 accounts
echo "=== EDOG table: ===";
${cleos} get table eosio.nft123 EDOG stat
echo "=== ZOD table: ===";
${cleos} get table eosio.nft123 ZOD stat



echo "---------------- Clear Tokens! ----------------";
${cleos} push action eosio.nft123 cleartokens '[]' -p eosio.nft123
echo "---------------- Get Table Info! ----------------";
echo "=== token table: ===";
${cleos} get table eosio.nft123 eosio.nft123 token
echo "=== 12345tester1 table: ===";
${cleos} get table eosio.nft123 12345tester1 accounts
echo "=== 12345tester2 table: ===";
${cleos} get table eosio.nft123 12345tester2 accounts
echo "=== 12345tester3 table: ===";
${cleos} get table eosio.nft123 12345tester3 accounts
echo "=== EDOG table: ===";
${cleos} get table eosio.nft123 EDOG stat
echo "=== ZOD table: ===";
${cleos} get table eosio.nft123 ZOD stat






echo "---------------- End Docker! ----------------";
docker-compose down



