[log, to_fix] = require '../src/js/lib'
_ = require 'lodash'
express = require 'express'

keys = require '../keys.js'

Eos = require 'eosjs'

mysql = require 'mysql2/promise'


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

app.use express.static '../'
app.use express.static '../src'
app.use express.static '../dist'
app.use express.json()

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
		return if key is NaN or key < 0

		if req.body.sub_key
			sub_key = parseInt req.body.sub_key
			return if sub_key is NaN or sub_key < 0
		else
			sub_key = 'NULL'

		return unless req.body.data

		return if req.body.data.length > 128

		conn = await mysql.createConnection
			host:'127.0.0.1'
			user: 'root'
			password: keys.DB_PASSWORD
			database: 'test'

		tmp = await conn.execute "INSERT INTO test.records (record_key, data, write_flag) VALUES(#{key}, '#{req.body.data}', FALSE)"

		conn.close()

#		contract = await eos.contract keys.ACCOUNT
#		res = await contract.setrecord keys.ACCOUNT, key, req.body.data, {authorization:[keys.ACCOUNT]}

	catch err
		log err

		try
			res.send(err)
		catch err
			log err

	return


app.get '/getrecords', (req, res)->

	try
		records = await eos.getTableRows
			code: keys.ACCOUNT
			scope: keys.ACCOUNT
			table: 'records3'
			json: true
			limit: 1000

		dict = await eos.getTableRows
			code: keys.ACCOUNT
			scope: keys.ACCOUNT
			table: 'recordsdict3'
			json: true
			limit: 1000

		res.send {records, dict}

	catch err
		log err

	return


app.get '/getqueue', (req, res)->

	try
		conn = await mysql.createConnection
			host:'127.0.0.1'
			user: 'root'
			password: keys.DB_PASSWORD
			database: 'test'

		tmp = await conn.execute "SELECT * FROM test.records WHERE write_flag=FALSE"

		conn.close()

		res.send tmp[0]

	catch err
		log err

	return



#init = ->
#
#
#
#
#	key = 123
#	sub_key = 'NULL'
#	data = 'adasdasdasd'
#
#	conn = await mysql.createConnection
#		host:'127.0.0.1'
#		user: 'root'
#		database: 'test'
#
##"INSERT INTO customers (name, address) VALUES ('Company Inc', 'Highway 37')";
##	tmp = await conn.execute "INSERT INTO test.records5(record_key, sub_key, data, write_flag) VALUES(#{key}, #{sub_key}, '#{data}', FALSE)"
#	tmp = await conn.execute "SELECT * FROM test.records"
#
#	log tmp
#
#
#	conn.close()
#
#
#
#		#		contract = await eos.contract keys.ACCOUNT
#		#		res = await contract.setrecord keys.ACCOUNT, key, req.body.data, {authorization:[keys.ACCOUNT]}
#	return
#
#
#init()



# CREATE DATABASE test;
# CREATE TABLE test.records(
# 	`id` INT(11) NOT NULL AUTO_INCREMENT,
# 	`record_key` INT(11) NOT NULL,
# 	`data` CHAR(128) NOT NULL,
# 	`write_flag` BOOL NOT NULL,
# 	PRIMARY KEY(`id`)
# );

# ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY ''

# SELECT user, host FROM mysql.user;

# select * from test.records;

# drop table test.records;



app.listen 8080, ->
	log (new Date).getTime(), 'Express server listening on port 8080'
	return



