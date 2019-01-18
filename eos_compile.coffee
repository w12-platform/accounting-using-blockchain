shell = require 'shelljs'


dir = '/Users/gauss/_games/eosdev'
run = shell.exec


shell.cp '-R', './contracts_eos/w12eosbook.cpp', "#{dir}/work/w12eosbook/w12eosbook.cpp"
shell.cp '-R', './contracts_eos/w12eosbook.hpp', "#{dir}/work/w12eosbook/w12eosbook.hpp"

shell.cd dir
run './scripts/eosiocpp.sh -o /work/w12eosbook/w12eosbook.wast /work/w12eosbook/w12eosbook.cpp'
run './scripts/eosiocpp.sh -g /work/w12eosbook/w12eosbook.abi /work/w12eosbook/w12eosbook.cpp'