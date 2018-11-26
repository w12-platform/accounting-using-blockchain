[log, to_fix, CNS, asrt] = require './src/js/lib'
keys = require './keys.js'


Eos = require('eosjs');
BigNumber = require 'bignumber.js'


config =
	chainId: keys.CHAIN_ID
	keyProvider: [keys.ACTIVE_PRV]
	httpEndpoint: keys.NODE
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


user_id = 2
skip = 0
limit = 1


user_id = BigNumber user_id

low = user_id.multipliedBy('4294967296').plus skip
up = user_id.multipliedBy('4294967296').plus '0x100000000'

#	user_id = user_id.plus(123)
#	log user_id.toString(16)[-8..]
#	user_id = user_id.dividedToIntegerBy '4294967296'
#	log user_id.toString()


eos.getTableRows
	code: keys.ACCOUNT
	scope: keys.ACCOUNT
	table: 'recordsdict5'
	json: true
	lower_bound: low.toString()
	upper_bound: up.toString()
	limit: limit
.then (data)=>
	log data

.catch (err)=>
	log err


#scan = ->
#		actions = await eos.getActions keys.ACCOUNT, 10, 1
#		log actions
#
#scan()








