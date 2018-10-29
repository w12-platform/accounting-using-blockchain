INFO_PAGE_COMPONENT =
	'
<div>
	<div class="container">
	<div class="content">

		<a href="https://en.wikipedia.org/wiki/Organizations_of_the_Dune_universe#CHOAM">
			<h1>W12 EOS BOOK</h1>
		</a>

		<p>
			Contract: asdasdasdasdasdasd
		</p>

		</div>
	</div>
</div>
	'


INFO_PAGE = Vue.component 'info-page',
	template: INFO_PAGE_COMPONENT
	data: =>
		login: DATA.login
