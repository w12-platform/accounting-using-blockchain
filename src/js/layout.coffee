DATA =
	login:
		eth: null

HUB = {}

PAGE_SIZE = 25



LAYOUT_COMPONENT =
'
<div>
	<nav class="navbar is-warning sb3">

		<div class="navbar-brand">

			<a class="flag" href="#/">
				<img src="/img/flag.png" alt="CHOAM">
			</a>

			<a class="navbar-item sr3" href="#/">
				W12 EOS Book
			</a>

			<div class="navbar-burger burger" data-target="navbar">
				<span></span>
				<span></span>
				<span></span>
			</div>

		</div>

		<div id="navbar" class="navbar-menu">

			<div class="navbar-start">

				<a class="navbar-item" href="#/info">
					Info
				</a>

			</div>

			<div class="navbar-end">
			</div>

		</div>
	</nav>

	<div id="content">
		<keep-alive>
			<router-view >
			</router-view>
		</keep-alive>
	</div>

</div>
	'


LAYOUT = Vue.component 'layout',
	template: LAYOUT_COMPONENT


	data: =>
		DATA


	created: ->
		HUB = @$root
		return


	mounted: ->
		return


	methods:

		scan: ->
			return


bn = (val)->
	new Eth.BN val, 10