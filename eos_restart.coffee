shell = require 'shelljs'
keys = require './keys'


dir = '/Users/gauss/_games/eosdev'
run = shell.exec

cleos = "docker exec eosdev_wallet /opt/eosio/bin/cleos -u #{keys.NODE} --wallet-url http://127.0.0.1:8888"


shell.cd dir
run 'docker stop eosdev_node'
run 'docker stop eosdev_wallet'
run "rm -rf #{dir}/node/data"
run "rm -rf #{dir}/wallet"
run "rm -f #{dir}/wallet.txt"
run 'docker-compose up -d'
run "#{cleos} wallet create --to-console >> ./wallet.txt"
run 'cat ./wallet.txt'
run "#{cleos} wallet import --private-key #{keys.EOSIO_PRV}"
run "#{cleos} wallet import --private-key #{keys.OWNER_PRV}"
run "#{cleos} wallet import --private-key #{keys.ACTIVE_PRV}"

run "#{cleos} wallet keys"
run "#{cleos} wallet list"
