shell = require 'shelljs'
keys = require './keys'


# NODE = 'http://node:8888'
NODE = 'http://jungle.cryptolions.io:18888'


dir = process.argv[2]
run = shell.exec

cleos = "docker exec eosdev_wallet /opt/eosio/bin/cleos -u #{NODE} --wallet-url http://127.0.0.1:8888"


shell.cd dir
run "#{cleos} set contract #{keys.ACCOUNT} /work/w12eosbook -p #{keys.ACCOUNT}@active"
