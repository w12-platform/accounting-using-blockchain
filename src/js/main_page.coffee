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

		<table class="table">
			<thead>
				<tr>
					<th>Key</th>
					<th>Record</th>
				</tr>
			</thead>
			<tbody>
				<tr v-for="val in records"
					class="table-item">
					<td>{{val.key}}</td>
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


	created: ->
		return


	mounted: ->
		@update()
		return


	methods:

		setrecord: ->
			try
				res = await axios.post 'http://localhost:8080/setrecord',
					key: @key
					data: @record

				log res

			catch err
				log err

			return


		update: ->

			try
				res = await axios.get 'http://localhost:8080/getrecords'

				@records = res.data.rows

			catch err
				log err



			setTimeout =>
				@update()
			,3000
			return

