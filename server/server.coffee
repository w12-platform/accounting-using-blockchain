[log, to_fix] = require '../src/js/lib'
_ = require 'lodash'
express = require 'express'

keys = require '../keys.js'

Eos = require 'eosjs'

mysql = require 'mysql2/promise'

BigNumber = require 'bignumber.js'


TABLE = 'records11e'

FFFF = '0x10000000000'
MAX_BATCH = 128


config =
	chainId: keys.CHAIN_ID
	keyProvider: [keys.ACTIVE_PRV]
	httpEndpoint: keys.NODE
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


app.post '/setRecord', (req, res)->

	try
		key = parseInt req.body.key
		return if key is NaN or key < 0

		user_id = parseInt req.body.user_id
		return if user_id is NaN or user_id < 0 or user_id >= 0xffffff

		return unless req.body.data

		return if req.body.data.length > 255

		conn = await mysql.createConnection
			host:'127.0.0.1'
			user: 'root'
			password: keys.DB_PASSWORD
			database: 'test'

		tmp = await conn.execute "INSERT INTO test.records (record_key, user_id, data, write_flag, blockchain)
		VALUES(#{key}, #{user_id}, '#{req.body.data}', 0, 0)"

		conn.close()

	catch err
		log err

		try
			res.send(err)
		catch err
			log err

	return


app.get '/getQueue', (req, res)->

	try

		conn = await mysql.createConnection
			host:'127.0.0.1'
			user: 'root'
			password: keys.DB_PASSWORD
			database: 'test'

		tmp = await conn.execute "SELECT * FROM test.records"

		conn.close()

		res.send tmp[0]

	catch err
		res.send {'error': 'server error'}
		log err

	return


app.get '/getUserRecords', (req, res)->

	try



		user_id = parseInt req.query.user_id
		start_key = parseInt req.query.start_key
		limit = parseInt req.query.limit

		if isNaN user_id
			res.send {'error': 'wrong user id'}
			return

		if user_id < 0 or user_id >= 0xffffff
			res.send {'error': 'wrong user id'}
			return

		start_key = 0 if isNaN start_key
		start_key = 0 if start_key < 0

		limit = 10 if isNaN limit
		limit = 10 if limit < 1

		user_id = BigNumber user_id

		low = user_id.times(FFFF).plus BigNumber(start_key).times(256)
		up = user_id.times(FFFF).plus(FFFF).minus(1)

		log up.toString()

		records = await eos.getTableRows
			code: keys.ACCOUNT
			scope: keys.ACCOUNT
			table: TABLE
			json: true
			lower_bound: low.toString()
			upper_bound: up.toString()
			limit: limit * 256

		log records

		rows = []
		row = null
		key = 0

		more = false

		for val in records.rows
			len = BigNumber val.key
			if len.mod(256).eq(0)
				if rows.length >= limit
					more = true
					break
				row = val
				key = len.mod(FFFF).idiv(256).toString()
				row.history = 1
				row.key = key
				rows.push row

			else
				row.history += 1
				row.key = key
				rows[rows.length - 1] = row

		res.send {more, rows}

	catch err
		res.send {'error': 'server error'}
		log err

	return



app.get '/getRecord', (req, res)->

	try

		user_id = parseInt req.query.user_id
		record_key = parseInt req.query.key

		if isNaN user_id
			res.send {'error': 'wrong user id'}
			return

		if user_id < 0 or user_id >= 0xffffff
			res.send {'error': 'wrong user id'}
			return

		if isNaN record_key
			res.send {'error': 'wrong key'}
			return

		if record_key < 0
			res.send {'error': 'wrong key'}
			return

		user_id = BigNumber user_id

		low = user_id.times(FFFF).plus BigNumber(record_key).times(256)
		up = low.plus 255

		records = await eos.getTableRows
			code: keys.ACCOUNT
			scope: keys.ACCOUNT
			table: TABLE
			json: true
			lower_bound: low.toString()
			upper_bound: up.toString()
			limit: 256

		if records.rows.length is 0
			res.send {'error': 'no data'}
			return

		res.send {key: record_key, data: records.rows[records.rows.length - 1].data, history: records.rows.length}

	catch err
		res.send {'error': 'server error'}
		log err

	return


app.get '/getRecordHistory', (req, res)->

	try

		user_id = parseInt req.query.user_id
		record_key = parseInt req.query.key

		if isNaN user_id
			res.send {'error': 'wrong user id'}
			return

		if user_id < 0 or user_id >= 0xffffff
			res.send {'error': 'wrong user id'}
			return

		if isNaN record_key
			res.send {'error': 'wrong key'}
			return

		if record_key < 0
			res.send {'error': 'wrong key'}
			return

		user_id = BigNumber user_id

		low = user_id.times(FFFF).plus BigNumber(record_key).times(256)
		up = low.plus 255

		records = await eos.getTableRows
			code: keys.ACCOUNT
			scope: keys.ACCOUNT
			table: TABLE
			json: true
			lower_bound: low.toString()
			upper_bound: up.toString()
			limit: 256

		if records.rows.length is 0
			res.send {'error': 'no data'}
			return

		rows = []

		for val in records.rows
			val.key = record_key
			rows.push val

		res.send {rows}

	catch err
		res.send {'error': 'server error'}
		log err

	return


app.get '/getRecordsBatch', (req, res)->

	try

		user_id = parseInt req.query.user_id

		unless req.query.keys
			res.send {'error': 'wrong key'}
			return

		arr = req.query.keys.split ','

		if arr.length > MAX_BATCH
			res.send {'error': 'wrong batch length'}
			return

		keys_arr = []

		for val in arr
			val = parseInt val
			if isNaN val
				res.send {'error': 'wrong key'}
				return
			if val < 0
				res.send {'error': 'wrong key'}
				return
			keys_arr.push val


		if isNaN user_id
			res.send {'error': 'wrong user id'}
			return

		if user_id < 0 or user_id >= 0xffffff
			res.send {'error': 'wrong user id'}
			return

		user_id = BigNumber user_id

		rows = []

		for record_key in keys_arr

			low = user_id.times(FFFF).plus BigNumber(record_key).times(256)
			up = low.plus 255

			records = await eos.getTableRows
				code: keys.ACCOUNT
				scope: keys.ACCOUNT
				table: TABLE
				json: true
				lower_bound: low.toString()
				upper_bound: up.toString()
				limit: 256

			if records.rows.length is 0
				res.send {'error': 'no data'}
				return

			rows.push {key: record_key, data: records.rows[records.rows.length - 1].data, history: records.rows.length}

		res.send rows

	catch err
		res.send {'error': 'server error'}
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
# 	`user_id` INT(11) NOT NULL,
# 	`data` CHAR(128) NOT NULL,
# 	`write_flag` BOOL NOT NULL,
# 	`blockchain` CHAR(1) NOT NULL,
# 	PRIMARY KEY(`id`)
# );

# ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '78DnW946U9r726oBuga6'

# SELECT user, host FROM mysql.user;

# select * from test.records;
# drop table test.records;







app.listen 8080, ->
	log (new Date).getTime(), 'Express server listening on port 8080'
	return



