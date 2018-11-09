MAIN_PAGE_COMPONENT =
	'
<div>
	<div ref="container" class="container">
		<div class="sb3">
			<b-field
				:message="key_msg"
				label="Key integer > 0"
				:type="key_type">
				<b-input
					v-model="key"
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

		<button class="button is-primary sb11" @click="setrecord()">Set data</button>


		<h3 class="title is-3">SQL Database queue</h3>

		<table class="table">
			<thead>
				<tr>
					<th>Id</th>
					<th>Record key</th>
					<th>Data</th>
					<th>Write flag</th>
				</tr>
			</thead>
			<tbody>
				<tr v-for="val in queue"
					class="table-tiem">
					<td>{{val.id}}</td>
					<td>{{val.record_key}}</td>
					<td>{{val.data}}</td>
					<td>{{val.write_flag}}</td>
				</tr>
			</tbody>
		</table>

		<h3 class="title is-3">EOS Contract dictionary</h3>

		<table class="table">
			<thead>
				<tr>
					<th>Key</th>
				</tr>
			</thead>
			<tbody>
				<tr v-for="val in dict"
					@click="set_view(val)"
					class="table-item">
					<td>{{val.key}}</td>
				</tr>
			</tbody>
		</table>

		<h3 class="title is-3 sb5">EOS Contract records</h3>

		<table class="table">
			<thead>
				<tr>
					<th>Record</th>
				</tr>
			</thead>
			<tbody>
				<tr v-for="val in records_view"
					class="table-item">
					<td>{{val.data}}</td>
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
		record: 'asdasdasd'
		record_msg: ''
		record_type: ''
		records: []
		dict: []
		records_view: []
		queue: []



	created: ->
		return


	mounted: ->
		@update()
		return



	methods:

		setrecord: ->
			try
				res = await axios.post 'http://185.5.249.203:8080/setrecord',
#				res = await axios.post 'http://127.0.0.1:8080/setrecord',
					key: @key
					data: @record

				log res

			catch err
				log err

			return


		update: ->

			try
				res = await axios.get 'http://185.5.249.203:8080/getrecords'
#				res = await axios.get 'http://127.0.0.1:8080/getrecords'

				@records = res.data.records.rows
				@dict = res.data.dict.rows

				res = await axios.get 'http://185.5.249.203:8080/getqueue'
#				res = await axios.get 'http://127.0.0.1:8080/getqueue'
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






