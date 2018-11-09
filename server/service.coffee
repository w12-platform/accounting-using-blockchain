[log, to_fix] = require '../src/js/lib'
Eos = require 'eosjs'
mysql = require 'mysql2/promise'
cron = require 'node-cron'
keys = require '../keys.js'


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

cron.schedule '7,20,30,50,58 * * * * *', =>

	try
		step()


	catch err
		log err

	return


step = ->

	conn = await mysql.createConnection
		host:'127.0.0.1'
		user: 'root'
		password: keys.DB_PASSWORD
		database: 'test'

	tmp = await conn.execute "SELECT * FROM test.records WHERE write_flag=FALSE"

	if tmp[0].length > 0
		id = tmp[0][0].id
		key = tmp[0][0].record_key
		data = tmp[0][0].data

		contract = await eos.contract keys.ACCOUNT
		res = await contract.setrecord keys.ACCOUNT, key, data, {authorization:[keys.ACCOUNT]}

		res = await conn.execute "UPDATE test.records SET write_flag=TRUE WHERE id=#{id}"

	conn.close()


