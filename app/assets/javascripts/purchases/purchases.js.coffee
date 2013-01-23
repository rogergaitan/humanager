#If you don't know coffeescript, you should learn and to check this file as JS, compile it on Sublime-Text or go to the browser.
numericality =
	numericality:
		greater_than: 0
		messages:
			greater_than: "Mayor a 0"
			numericality: "Solo números"

presence =
	presence:
		message: "Campo requerido"

validations = 
	numericality: numericality.numericality 
	presence: presence.presence

discount_validations =
	numericality:
		#greater_than_or_equal_to: 0
		#less_than: 100
		messages:
			#greater_than_or_equal_to: "Mayor o igual a 0"
			numericality: "Solo números"
			less_than: "Menor a 100"

action_add_field = (e)->
	form = $("form").attr("id")
	time = new Date().getTime()
	regexp = new RegExp($('.add_item').data('id'), 'g')
	$('.table_items').append($('.add_item').data('fields').replace(regexp, time))
	
	e.preventDefault()
	ClientSideValidations.forms[form].validators["purchase[purchase_items_attributes]["+time+"][product_id]"] =
		presence
	ClientSideValidations.forms[form].validators["purchase[purchase_items_attributes]["+time+"][warehouse_id]"] =
		presence
	ClientSideValidations.forms[form].validators["purchase[purchase_items_attributes]["+time+"][description]"] =
		presence
	ClientSideValidations.forms[form].validators["purchase[purchase_items_attributes]["+time+"][quantity]"] =
		validations
	ClientSideValidations.forms[form].validators["purchase[purchase_items_attributes]["+time+"][cost_unit]"] =
		validations
	ClientSideValidations.forms[form].validators["purchase[purchase_items_attributes]["+time+"][cost_total]"] =
		validations
	ClientSideValidations.forms[form].validators["purchase[purchase_items_attributes]["+time+"][discount]"] =
		discount_validations
	$("form").enableClientSideValidations()
	return false

add_payment = (e)->
	form = $("form").attr("id")
	time = new Date().getTime()
	regexp = new RegExp($('.add_payment').data('id'), 'g')
	$('.payment_options').append($('.add_payment').data('fields').replace(regexp, time))
	e.preventDefault()
	ClientSideValidations.forms[form].validators["purchase[purchase_payment_options_attributes]["+time+"][number]"] =
		presence
	ClientSideValidations.forms[form].validators["purchase[purchase_payment_options_attributes]["+time+"][amount]"] =
		validations
	return false

remove_row = () ->
	$(@).closest("tr").hide() if (!$(@).closest("tr").is($(".table tbody tr:first")))
	$(@).closest("tr").find(".cost_total").remove()
	$(@).prev('input[type=hidden]').val(1)
	$(@).closest("tr").find(".product_code").remove()
	$(@).closest("tr").find(".product_description").remove()
	$(@).closest("tr").find(".quantity").remove()
	$(@).closest("tr").find(".cost_unit").remove()
	sub_total()
	total()

row_total = (row) ->
	quantity = parseFloat ($(row).find(".quantity").val())
	cost_unit = parseFloat ($(row).find(".cost_unit").val())
	discount = parseFloat ($(row).find(".product_discount").val())
	if discount > 0 
		_total = (quantity * cost_unit) - (quantity * cost_unit * discount/100 ) 
	else
		_total =  (quantity * cost_unit)	  	
	$(row).find(".cost_total").val(_total)
	
	sub_total()
	total()

sub_total = () ->
	sum_subtotal = null;
	$('.table_items .cost_total').each ()->
		sum_subtotal += parseFloat($(@).val())
	$("#purchase_subtotal").val(sum_subtotal) 

total = () ->
	$("#purchase_total").val($("#purchase_subtotal").val() + $("#purchase_taxes").val() )	

show_imported_fields = () ->
	if ($("#purchase_purchase_type").val() == "imported")
		$(".imported").show() 
	else
		$(".imported").hide() 

submitPurchase = () ->
	sum_amount = 0;
	valid = true;
	$(".amount").each () ->
		sum_amount += parseFloat($(@).val())
	if (sum_amount == parseFloat($(".total").val())) and sum_amount != 0
		return valid
	else
		valid = false
		$('#messages').html('<div class="alert alert-error">El total debe coincidir con la suma de los pagos.</div>');
		return valid


$(document).ready ->
	$("form").submit () ->
		console.log "Inside submit acction"
		submitPurchase()
	id = $("form").attr("id")
	#form = $("form")
	$('form').on 'click', '.add_item', action_add_field
	$('form').on 'click', '.add_payment', add_payment	
	$('form').on('click', '.remove_row', remove_row)
	$('form').on 'change', '#purchase_purchase_type', show_imported_fields
	$('form').on 'keyup', '.cost_unit', () ->
		row_total($(@).closest("tr"))
		$(@).closest("tr").find("input.cost_total").trigger("change")
	$('form').on 'keyup', '.quantity', () ->
		row_total($(@).closest("tr"))
		$(@).closest("tr").find("input.cost_total").trigger("change")
	$("table tr").eq(1).find(".remove_row").remove()
		
	$('form').on 'keypress', '.cost_total', (event)->
		key = event.keyCode or event.which
		if (key == 13)
			$(".add_item").trigger("click")
			event.stopPropagation()
			event.preventDefault()
			return false
	$("#purchases").on "click",".pag a", ->
    $.getScript @href
    false

	$("#purchase_vendor_name").autocomplete
	  source: (request, response) ->
	    $.ajax
	      url: "/purchases/search_vendor.json"
	      dataType: "json"
	      data:
	        search: request.term
	      success: (data) ->
	        response $.map(data, (item) ->
	          label: item.name + " " + item.surname
	          id: item.id
	        )
	  minLength: 3
	  autoFocus: true
	  select: (event, ui) ->
	    $("#purchase_vendor_id").val ui.item.id
	    $(@).val ui.item.label
	  focus: (event, ui) ->
	    $(@).val ui.item.label
	  change: (event, ui) ->
	    $(@).next("#not-found").remove()
	    unless ui.item
	      $(@).after "<label id=\"not-found\" for=\"" + $(@).attr("id") + "\" class=\"error\">Ningún resultado para: \"" + $(@).val() + "\"</label"
	      $("#vendor_text").val ""
	      $("#purchase_vendor_id").val ""

	$("form").on 'focus', '.product_code', ->
		$(@).autocomplete
		  source: (request, response) ->
		    $.ajax
		      url: "/products/search.json"
		      dataType: "json"
		      data:
		        code: request.term
		      success: (data) ->
		        response $.map(data, (item) ->
		          label: item.code
		          id: item.id
		          name: item.name
		        )
		  minLength: 3
		  select: (event, ui) ->
		    $("#purchase_product_id").val ui.item.id
		    $(@).closest("tr").find("input.product_description").val ui.item.name
		    $(@).closest("tr").find("input.product_description").trigger("change")
		    $(@).val ui.item.label
		  focus: (event, ui) ->
		    $(@).val ui.item.label
		    $(@).closest("tr").find("input.product_description").val ui.item.name
		  change: (event, ui) ->
		    $(@).next("#not-found").remove()
		    unless ui.item
		      #$(@).after "<label id=\"not-found\" for=\"" + $(@).attr("id") + "\" class=\"error\">0 Resultados\"</label"
		      $(@).val ""
		      $(@).closest("tr").find("input.product_description").val ""
		      $("#purchase_product_id").val ""

	$("form").on 'focus', '.product_description', ->
		$(@).autocomplete
		  source: (request, response) ->
		    $.ajax
		      url: "/products/search.json"
		      dataType: "json"
		      data:
		        name: request.term
		      success: (data) ->
		        response $.map(data, (item) ->
		          label: item.name
		          id: item.id
		          code: item.code
		        )
		  minLength: 3
		  select: (event, ui) ->
		    $("#purchase_product_id").val ui.item.id
		    $(@).closest("tr").find("input.product_code").val ui.item.code
		    $(@).closest("tr").find("input.product_code").trigger("change")
		    $(@).val ui.item.label
		  focus: (event, ui) ->
		    $(@).val ui.item.label
		    $(@).closest("tr").find("input.product_code").val ui.item.code
		  change: (event, ui) ->
		    $(@).next("#not-found").remove()
		    unless ui.item
		      #$(@).after "<label id=\"not-found\" for=\"" + $(@).attr("id") + "\" class=\"error\">0 Resultados\"</label"
		      $(@).val ""
		      $(@).closest("tr").find("input.product_code").val ""
		      $("#purchase_product_id").val ""

	$("#search").keyup () ->
		if $("#search").val().length >= 3
	    $.ajax
	      url: "/purchases/search"
	      dataType: "script"
	      data:
	      	search : $("#search").val()
	      beforeSend: ()->
	        $("span.spinner").show()
	      complete: (data)->
	        $("span.spinner").hide()