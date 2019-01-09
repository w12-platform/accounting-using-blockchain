INFO_PAGE_COMPONENT =
	'
<div>
	<div class="container">
	<div class="content">


		<h1>W12 Accounting using blockchain</h1>



		</div>
	</div>
</div>
	'


INFO_PAGE = Vue.component 'info-page',
	template: INFO_PAGE_COMPONENT
	data: =>
		login: DATA.login
