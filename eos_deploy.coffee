shell = require 'shelljs'
keys = require './keys'


dir = '/Users/gauss/_games/eosdev'
run = shell.exec

cleos = "docker exec eosdev_wallet /opt/eosio/bin/cleos -u #{keys.NODE} --wallet-url http://127.0.0.1:8888"


shell.cd dir
run "#{cleos} set contract #{keys.ACCOUNT} /work/w12eosbook -p #{keys.ACCOUNT}@active"
