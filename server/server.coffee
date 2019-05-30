[log, to_fix] = require '../src/js/lib'
express = require 'express'
bodyParser = require 'body-parser'


keys = require '../keys.js'

Eos = require 'eosjs'

mysql = require 'mysql2/promise'

BigNumber = require 'bignumber.js'


TABLE = 'record'

FFFF = '0x10000000000'
MAX_BATCH = 128

HOST = 'acc_database_cnt'
#HOST = '127.0.0.1'


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
app.use bodyParser.urlencoded({extended: true})


app.use (req, res, next)->
	res.header 'Access-Control-Allow-Origin', '*'
	res.header 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'
	next()




app.post '/setRecord', (req, res)->

	try
		key = parseInt req.body.key
		if isNaN(key) or key < 0 or key is null
			res.send {'error': 'wrong key'}
			log JSON.stringify(req.body)
			return

		user_id = parseInt req.body.user_id
		if isNaN(user_id) or user_id < 0 or user_id >= 0xffffff or user_id is null
			res.send {'error': 'wrong user_id'}
			log JSON.stringify(req.body)
			return

		unless req.body.data
			res.send {'error': 'wrond data'}
			log JSON.stringify(req.body)
			return

		if req.body.data.length > 255
			res.send {'error': 'wrond data length'}
			return

		conn = await mysql.createConnection
			host: HOST
			user: 'root'
			password: keys.DB_PASSWORD
			database: keys.DATABASE

		tmp = await conn.execute "INSERT INTO #{keys.DATABASE}.records (record_key, user_id, data, write_state, blockchain, trx_id)
		VALUES(#{key}, #{user_id}, '#{req.body.data}', 0, 0, '')"

		conn.close()

		res.send {'status': 'ok'}

	catch err
		res.send {'error': 'server error'}
		log err

	return


app.get '/getQueue', (req, res)->

	try

		conn = await mysql.createConnection
			host: HOST
			user: 'root'
			password: keys.DB_PASSWORD
			database: keys.DATABASE

		tmp = await conn.execute "SELECT * FROM #{keys.DATABASE}.records"

		conn.close()

		res.send tmp[0]

	catch err
		res.send {'error': 'server error'}
		log err

	return


app.get '/getRecordQueue', (req, res)->

	try

		record_key = parseInt req.query.key

		if isNaN record_key
			res.send {'error': 'wrong key'}
			return

		user_id = parseInt req.query.user_id

		if isNaN user_id
			res.send {'error': 'wrong user_id'}
			return

		if user_id < 0 or user_id >= 0xffffff
			res.send {'error': 'wrong user id'}
			return

		conn = await mysql.createConnection
			host: HOST
			user: 'root'
			password: keys.DB_PASSWORD
			database: keys.DATABASE

		tmp = await conn.execute "SELECT * FROM #{keys.DATABASE}.records WHERE record_key=#{record_key} and user_id=#{user_id}"

		conn.close()

		if tmp.length then res.send {rows: tmp[0]} else res.send {'error': 'no data'}

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

		records = await eos.getTableRows
			code: keys.ACCOUNT
			scope: keys.ACCOUNT
			table: TABLE
			json: true
			lower_bound: low.toString()
			upper_bound: up.toString()
			limit: limit * 256

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

		if req.query.new_data and req.query.new_data is 'true' then new_date = true else new_data = false

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

		res.send {key: record_key, data: records.rows[0].data, history: records.rows.length}

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
			rows.push val.data

		res.send {rows}

	catch err
		res.send {'error': 'server error'}
		log err

	return


app.get '/getRecordsBatch', (req, res)->

	try

		user_id = parseInt req.query.user_id

		if req.query.new_data and req.query.new_data is 'true' then new_date = true else new_data = false

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

			rows.push {key: record_key, data: records.rows[0].data, history: records.rows.length}

		res.send {rows}

	catch err
		res.send {'error': 'server error'}
		log err

	return


app.use (req, res, next)->
	res.status 404
	res.send 'Not found'
	return


app.use (err, req, res, next)->
	log (new Date).getTime(), err
	res.status err.status || 500
	res.send 'Internal error'
	return


app.listen 8080, ->
	log (new Date).getTime(), 'Express server listening on port 8080'
	return



