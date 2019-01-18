CNS =
	YELLOW: '\x1b[33m'
	RED: '\x1b[31m'
	GREEN: '\x1b[32m'
	STACK: 'STACK'
	ASRT: 'ASRT'

#log = (val...)->
#
#	if val[0] and val[0] is CNS.STACK
#
#		val.shift()
#
#		stack = new Error().stack
#
#		if '@' in stack
#			name = stack.split('@')[1].split('\n')[1]
#			val.unshift name if name isnt 'Object.<anonymous>'
#		else
#			arr = stack.split('at')[2].split(' ')
#			val.unshift arr[1] if arr.length > 2 and arr[1] isnt 'Server.<anonymous>'
#
#	console.log val...
#
#	return


log = console.log


set_item_ls = (key, val)->
	window?.localStorage?.setItem?(key, val)
	return


get_item_ls = (key)->
	return window?.localStorage?.getItem?(key)


remove_item_ls = (key)->
	window?.localStorage?.removeItem(key)
	return


get_real_display = (elem)->
	if elem.currentStyle
		return elem.currentStyle.display
	else if window.getComputedStyle
		computedStyle = window.getComputedStyle(elem, null)
		return computedStyle.getPropertyValue('display')


hide = (el)->
	el.style.display = "none"
	return


lib_display_cashe = {}


show = (el)->
	return if get_real_display(el) isnt 'none'

	old = el.getAttribute("displayOld")

	el.style.display = old || ""

	if get_real_display(el) is "none"
		nodeName = el.nodeName
		body = document.body
		display = null

		if lib_display_cashe[nodeName]
			display = lib_display_cashe[nodeName]
		else
			testElem = document.createElement(nodeName)
			body.appendChild(testElem)
			display = get_real_display(testElem)

			if display is "none"
				display = "block"

			body.removeChild(testElem)
			lib_display_cashe[nodeName] = display

		el.setAttribute('displayOld', display)
		el.style.display = display

	return


get_el = (id)->
	document.getElementById(id)


scale_wnd = (canvas, offset)->

	if offset
		window_height = window.innerHeight - offset
	else
		window_height = window.innerHeight

	scaleX = window.innerWidth / canvas.offsetWidth
	scaleY = window_height / canvas.offsetHeight

	scale = Math.min(scaleX, scaleY)
	canvas.style.transformOrigin = "0 0"
	canvas.style.transform = "scale(" + scale + ")"

	if canvas.offsetWidth > canvas.offsetHeight
		if canvas.offsetWidth * scale < window.innerWidth
			center = "horizontally"
		else
			center = "vertically"
	else
		if canvas.offsetHeight * scale < window_height
			center = "vertically"
		else
			center = "horizontally"

	if center is "horizontally"
		margin = (window.innerWidth - canvas.offsetWidth * scale) / 2
		canvas.style.marginTop = 0 + "px"
		canvas.style.marginBottom = 0 + "px"
		canvas.style.marginLeft = margin + "px"
		canvas.style.marginRight = margin + "px"

	if center is "vertically"
		margin = (window_height - canvas.offsetHeight * scale) / 2
		canvas.style.marginTop = margin + "px"
		canvas.style.marginBottom = margin + "px"
		canvas.style.marginLeft = 0 + "px"
		canvas.style.marginRight = 0 + "px"

	canvas.style.paddingLeft = 0 + "px"
	canvas.style.paddingRight = 0 + "px"
	canvas.style.paddingTop = 0 + "px"
	canvas.style.paddingBottom = 0 + "px"
	canvas.style.display = "block"

#	document.body.style.backgroundColor = backgroundColor;

#  //Fix some quirkiness in scaling for Safari
#  var ua = navigator.userAgent.toLowerCase();
#  if (ua.indexOf("safari") != -1) {
#    if (ua.indexOf("chrome") > -1) {
#      // Chrome
#    } else {
#      // Safari
#      //canvas.style.maxHeight = "100%";
#      //canvas.style.minHeight = "100%";
#    }
#  }
#
#  //5. Return the `scale` value. This is important, because you'll nee this value
#  //for correct hit testing between the pointer and sprites
	return scale


USER_REQUESTS = []
USER_REQUEST = null

get_user = (provider, id, obj, cb)->

	USER_REQUESTS.push {provider: provider, id: id, obj: obj, cb: cb} if provider and id and obj

	if USER_REQUEST is null and USER_REQUESTS.length > 0 then USER_REQUEST = USER_REQUESTS.shift() else return

	if USER_REQUEST.provider is 'github'
		axios.get 'https://api.github.com/users/' + USER_REQUEST.id
		.then (res)=>
			if res.status is 200
				USER_REQUEST.obj.user = USER_REQUEST.id
				USER_REQUEST.obj.avatar = res.data.avatar_url
				USER_REQUEST.obj.avatar_alt = USER_REQUEST.id
				USER_REQUEST.obj.user_url = res.data.htm_url
				USER_REQUEST.cb() if USER_REQUEST.cb
				USER_REQUEST = null
				get_user()
			return
		.catch (err)=>
			USER_REQUEST = null
			get_user()
			return
	return


`
function add_css(rules)
{
  var styleEl = document.createElement('style'),
      styleSheet;

  // Append style element to head
  document.head.appendChild(styleEl);

  // Grab style sheet
  styleSheet = styleEl.sheet;

  for (var i = 0, rl = rules.length; i < rl; i++) {
    var j = 1, rule = rules[i], selector = rules[i][0], propStr = '';
    // If the second argument of a rule is an array of arrays, correct our variables.
    if (Object.prototype.toString.call(rule[1][0]) === '[object Array]') {
      rule = rule[1];
      j = 0;
    }

    for (var pl = rule.length; j < pl; j++) {
      var prop = rule[j];
      propStr += prop[0] + ':' + prop[1] + (prop[2] ? ' !important' : '') + ';\n';
    }

    // Insert CSS Rule
    styleSheet.insertRule(selector + '{' + propStr + '}', styleSheet.cssRules.length);
  }
}


function inc_time(duration, web3js)
{
	const id = Date.now();

	if(web3js) web3 = web3js;

	return new Promise((resolve, reject) =>
	{
		web3.currentProvider.sendAsync(
			{
				jsonrpc: '2.0',
				method: 'evm_increaseTime',
				params: [duration],
				id: id,
			}, err1 =>
			{
			if (err1) return reject(err1);
			web3.currentProvider.sendAsync(
				{jsonrpc: '2.0', method: 'evm_mine', id: id + 1},
				(err2, res) =>
					{
						return err2 ? reject(err2) : resolve(res);
					});
			});
	});
}
`


ASRT_PASSED_CNT = 0
ASRT_FAILED_CNT = 0


asrt = (msg, val)->
	if val is CNS.ASRT
		if ASRT_PASSED_CNT is 0 and ASRT_FAILED_CNT is 0
			log msg
		else
			if ASRT_FAILED_CNT > 0
				log CNS.RED, msg + ' - FAILED ' + ASRT_FAILED_CNT
			else
				log CNS.GREEN, msg + ' - PASSED ' + ASRT_PASSED_CNT
			ASRT_PASSED_CNT = 0
			ASRT_FAILED_CNT = 0
	else
		if val
			ASRT_PASSED_CNT++
			log CNS.GREEN, msg + ' passed ' + ASRT_PASSED_CNT
		else
			ASRT_FAILED_CNT++
			log CNS.RED, msg + ' failed ' + ASRT_FAILED_CNT


to_fix_ui = (val, fix=5)->
	arr = val.split('.')
	return arr[0] if arr.length < 2
	if arr[1].length < fix then arr[0] + '.' + arr[1][...fix] else '~' + arr[0] + '.' + arr[1][...fix]


to_fix = (val, fix=5)->
	arr = val.split('.')
	return arr[0] if arr.length < 2
	arr[0] + '.' + arr[1][...fix]


bytes32string = (val)->

	codes = []
	codes.push parseInt(arr[0] + arr[1], 16) for arr in _.chunk val[2...], 2 when arr[0] isnt '0' or arr[1] isnt '0'

	str = ''
	str += String.fromCharCode code for code in codes

	return str


stringbytes32 = (val)->

	res = '0x'
	for index in [0...32]
		if index < val.length
			code = val.charCodeAt(index).toString(16)
			code = '0' + code if code.length < 2
			res += code
		else
			res += '00'

	return res


module.exports = [log, to_fix, get_user, inc_time, CNS, asrt] if module?

