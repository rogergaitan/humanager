$(document).ready ->
	$('div.well').on 'click', '.new_payment_type', () ->
		$("#new_payment_type").find("input[type=text]").val("")
	