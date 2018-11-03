[log, to_fix, CNS, asrt] = require './src/js/lib'
keys = require './keys.js'


Eos = require('eosjs');


NODE = 'http://jungle.cryptolions.io:18888'

config =
	chainId: '038f4b0fc8ff18a4f0842a8f0564611f6e96e8535901dd45e43ac8691a1c4dca'
	keyProvider: [keys.ACTIVE_PRV]
	httpEndpoint: NODE
	expireInSeconds: 60
	broadcast: true
	verbose: false
	sign: true


eos = Eos(config)

#eos.getInfo (error, result)=>
#	console.log error, result

#eos.getAccount('eosio').then (result)=>
#	log result
#.catch (error)=>
#	log error

init = ->

	try
		contract = await eos.contract keys.ACCOUNT
		res = await contract.setrecord keys.ACCOUNT, 111, 'ASDASDASDASDASD', {authorization:[keys.ACCOUNT]}
		log res
	catch err
		log err


#init()


eos.getTableRows
	code: keys.ACCOUNT
	scope: keys.ACCOUNT
	table: 'recordsdict3'
	json: true
#	lower_bound: 123
#	upper_bound: 124
.then (data)=>
	log data

.catch (err)=>
	log err


#scan = ->
#		actions = await eos.getActions keys.ACCOUNT, 10, 1
#		log actions
#
#scan()








