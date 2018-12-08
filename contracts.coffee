[log, to_fix, CNS, asrt] = require './src/js/lib'
keys = require './keys.js'


Eos = require('eosjs');
BigNumber = require 'bignumber.js'

axios = require 'axios'


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


#user_id = 2
#skip = 0
#limit = 10
#
#user_id = BigNumber user_id
#
#low = user_id.times('0x10000000000').plus skip
#up = low.plus '0x10000000000'
#
#	user_id = user_id.plus(123)
#	log user_id.toString(16)[-8..]
#	user_id = user_id.dividedToIntegerBy '4294967296'
#	log user_id.toString()

#eos.getTableRows
#	code: keys.ACCOUNT
#	scope: keys.ACCOUNT
#	table: 'records12c'
#	json: true
#.then (data)=>
#	log data
#	log data.rows.length
#
#.catch (err)=>
#	log err


#scan = ->
#		actions = await eos.getActions keys.ACCOUNT, 10, 1
#		log actions
#
#scan()


#get = ->
#	res = await axios.get 'http://127.0.0.1:8080/getUserRecords',
#		params:
#			user_id: '0'
#			start_key: '0'
#			limit: 10
#	log res.data

get = ->
	res = await axios.get 'http://127.0.0.1:8080/getUserRecords',
		params:
			user_id: '1'
			key: '0'
			limit: 2
	log res.data


get = ->
	res = await axios.get 'http://127.0.0.1:8080/getRecordsBatch',
		params:
			user_id: '1'
			keys: '0,1'
	log res.data


get()














