[log, to_fix] = require('../src/js/lib')
_ = require('lodash')
express = require('express')

keys = require '../keys.js'

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

app = express()

app.use(express.static('../'))
app.use(express.static('../src'))
app.use(express.static('../dist'))
app.use(express.json())

app.use (req, res, next)->
	res.header 'Access-Control-Allow-Origin', '*'
	res.header 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'
	next()


#app.use (req, res, next)->
#	res.status 404
#	res.send 'Not found'
#	return


app.use (err, req, res, next)->
	log (new Date).getTime(), err
	res.status err.status || 500
	res.send 'Internal error'
	return


app.post '/setrecord', (req, res)->


	try
		key = parseInt req.body.key
		return if key < 0

		contract = await eos.contract keys.ACCOUNT
		res = await contract.setrecord keys.ACCOUNT, key, req.body.data, {authorization:[keys.ACCOUNT]}

		log res

	catch err
		log err

		try
			res.send(err)
		catch err
			log err

	return


app.get '/getrecords', (req, res)->

	try
		data = await eos.getTableRows
			code: keys.ACCOUNT
			scope: keys.ACCOUNT
			table: 'records'
			json: true
			limit: 1000

		res.send data

	catch err
		log err

	return


app.listen 8080, ->
	log (new Date).getTime(), 'Express server listening on port 8080'
	return

