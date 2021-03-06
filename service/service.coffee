[log, to_fix] = require '../src/js/lib'
Eos = require 'eosjs'
mysql = require 'mysql2/promise'
cron = require 'node-cron'
keys = require '../keys.js'
BigNumber = require 'bignumber.js'



config =
	chainId: keys.CHAIN_ID
	keyProvider: [keys.ACTIVE_PRV]
	httpEndpoint: keys.NODE
	expireInSeconds: 60
	broadcast: true
	verbose: false
	sign: true


FFFF = '0x10000000000'

TABLE = 'record'


eos = Eos(config)


conn = null


delay = (ms)->
	return new Promise (resolve, reject)=>
		setTimeout resolve, ms


connect = ->

	await delay 55000

	conn = await mysql.createConnection
		host: 'acc_database_cnt'
		user: 'root'
		password: keys.DB_PASSWORD
		database: keys.DATABASE


	cron.schedule '7,20,30,50,58 * * * * *', =>

		try
			step()


		catch err
			log err

		return

	return


connect()


step = ->

	tmp = await conn.execute "SELECT * FROM #{keys.DATABASE}.records WHERE write_state=0"

	if tmp[0].length > 0
		sql_id = tmp[0][0].id

		user_id = tmp[0][0].user_id
		key = tmp[0][0].record_key
		data = tmp[0][0].data

		[res, bc_key] = await set_record user_id, key, data

		if res?.transaction_id
			res = await conn.execute "UPDATE #{keys.DATABASE}.records SET write_state=#{1}, trx_id=\"#{res.transaction_id}\", bc_key=\"#{bc_key}\" WHERE id=#{sql_id}"

	return


set_record = (user_id, record_key, data)->

	key = BigNumber(record_key).times 256

	low = BigNumber(user_id).times(FFFF).plus key
	up = low.plus 256

	arr = await eos.getTableRows
		code: keys.ACCOUNT
		scope: keys.ACCOUNT
		table: TABLE
		json: true
		lower_bound: low.toString()
		upper_bound: up.toString()
		limit: 255

	return [2, null] if arr.rows.length > 255

	key = low.plus arr.rows.length

	contract = await eos.contract keys.ACCOUNT

	try
		res = await contract.setrecord keys.ACCOUNT, key.toString(), data, {authorization:[keys.ACCOUNT]}
	catch err
		res = err

	return [res, key.toString()]
