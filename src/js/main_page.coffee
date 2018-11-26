MAIN_PAGE_COMPONENT =
	'
<div>
	<div ref="container" class="container">

		<h3 class="title is-3">Set Record</h3>

		<div class="sb3">
			<b-field
				:message="key_msg"
				label="Key - 32 bit integer > 0"
				:type="key_type">
				<b-input
					v-model="key"
					placeholder="123">
				</b-input>
			</b-field>
		</div>


		<div class="sb3">
			<b-field label="User id - 32 bit integer > 0">
				<b-input
					v-model="user_id"
					placeholder="123">
				</b-input>
			</b-field>
		</div>

		<div class="sb3">
			<b-field
				:message="record_msg"
				label="Record"
				:type="record_type">
				<b-input
					v-model="record"
					placeholder="asdasdasd">
				</b-input>
			</b-field>
		</div>

		<button class="button is-primary sb11" @click="set_record()">Set data</button>


		<h3 class="title is-3">Get user records</h3>

		<div class="sb3">
			<b-field label="User id - 32 bit integer > 0">
				<b-input
					v-model="user_id"
					placeholder="123">
				</b-input>
			</b-field>
		</div>

		<div class="sb3">
			<b-field label="Start key - 32 bit integer > 0, not required, default 0">
				<b-input
					v-model="start_key"
					placeholder="0">
				</b-input>
			</b-field>
		</div>

		<div class="sb3">
			<b-field label="Limit - integer > 0, not required, default 10">
				<b-input
					v-model="limit"
					placeholder="10">
				</b-input>
			</b-field>
		</div>

		<button class="button is-primary sb3" @click="get_user_records()">Get records</button>


		<h3 class="title is-3">User records</h3>

		<table class="table">
			<thead>
				<tr>
					<th>Key</th>
					<th>Data</th>
				</tr>
			</thead>
			<tbody>
				<tr v-for="val in records"
					@click="set_view(val)"
					class="table-item">
					<td>{{val.key}}</td>
					<td>{{val.data}}</td>
				</tr>
			</tbody>
		</table>


		<h3 class="title is-3">SQL Database</h3>

		<table class="table">
			<thead>
				<tr>
					<th>Id</th>
					<th>Record key</th>
					<th>User Id</th>
					<th>Data</th>
					<th>Write flag</th>
					<th>Blockchain</th>
				</tr>
			</thead>
			<tbody>
				<tr v-for="val in queue"
					class="table-tiem">
					<td>{{val.id}}</td>
					<td>{{val.record_key}}</td>
					<td>{{val.user_id}}</td>
					<td>{{val.data}}</td>
					<td>{{val.write_flag}}</td>
					<td>{{val.blockchain}}</td>
				</tr>
			</tbody>
		</table>

	</div>

</div>
	'

MAIN_PAGE = Vue.component 'main-page',
	template: MAIN_PAGE_COMPONENT
	data: =>
		login: DATA.login
		key: 0
		key_msg: ''
		key_type: ''
		user_id: 0
		start_key: 0
		limit: 10
		record: 'asdasdasd'
		record_msg: ''
		record_type: ''
		records: []
		queue: []



	created: ->
		return


	mounted: ->
		@update()
		return



	methods:

		set_record: ->
			try
				res = await axios.post 'http://185.5.249.203:8080/setRecord',
#				res = await axios.post 'http://127.0.0.1:8080/setRecord',
					key: @key
					user_id: @user_id
					data: @record

				log res

			catch err
				log err

			return


		get_user_records: ->
			try
				res = await axios.get 'http://185.5.249.203:8080/getUserRecords',
#				res = await axios.get 'http://127.0.0.1:8080/getUserRecords',
					params:
						user_id: @user_id
						start_key: @start_key
						limit: @limit

				@records = res.data.rows

			catch err
				log err

			return




		update: ->

			try
				res = await axios.get 'http://185.5.249.203:8080/getQueue'
#				res = await axios.get 'http://127.0.0.1:8080/getQueue'
				@queue = res.data

			catch err
				log err


			setTimeout =>
				@update()
			,3000
			return


		set_view: (record_dict)->

			@records_view = []

			for val in record_dict.dict
				@records_view.push @records[val]

			return






