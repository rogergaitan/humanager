Purchase = {
	search_length: 3
	option_imported: "imported" #ENUM
	product_code: '.product_code'
	product_description: '.product_description'
}
$(document).ready ->
	Purchase.disable_validations()
	$("table.table_items tr").eq(1).find(".remove_row").remove()
	$("form").submit () -> Purchase.submit_purchase()
	$('form').on 'click', '.add_item', Purchase.add_field
	$('form').on 'click', '.add_payment', Purchase.add_payment	
	$('form').on 'click', '.remove_row', Purchase.remove_row
	$('form').on 'change', '#purchase_purchase_type', ()-> Purchase.imported()
	$('form').on 'change', '.cost_unit, .product_discount, .quantity', () ->
		Purchase.row_total($(@).closest("tr"))
	$("table.table_items").on "focus", "input.product_description", () ->  
    Purchase.search_products(Purchase.product_description, this)
	$("table.table_items").on "focus", "input.product_code", () ->  
    Purchase.search_products(Purchase.product_code, this)
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
	$("form").on "focus", "input#purchase_vendor_name", () ->
    Purchase.search_vendor()
	$("#search").keyup () ->
		if $("#search").val().length >= Purchase.search_length
	    $.ajax
	      url: "/purchases/search"
	      dataType: "script"
	      data:
	      	search : $("#search").val()

Purchase.search_products = (field, input) ->
	that = $(input).closest("tr")
	description = that.find("input.product_description")
	code = that.find("input.product_code")
	product_id = that.find("input.product_id")
	$("table.table_items " + field ).autocomplete
    minLength: Purchase.search_length
    source: (request, response) ->
      $.ajax
        url: "/products/search"
        dataType: "json"
        data:
          search: request.term
        success: (data) ->
          if field is Purchase.product_code
            response $.map(data, (item) ->
              label:item.code 
              id:   item.code
              name: item.name
              product_id: item.id
            )
          if field is Purchase.product_description
            response $.map(data, (item) ->
              label:  item.name 
              id:   item.code
              product_id: item.id
            )
    select: (event, ui) ->
      product_id.val ui.item.product_id
      description.val ui.item.name if field is Purchase.product_code
      description.trigger("change") if field is Purchase.product_code
      code.val ui.item.id if field is Purchase.product_description
      code.trigger("change") if field is Purchase.product_description
    focus:  (event, ui) ->
      description.val ui.item.name if field is Purchase.product_code
      code.val ui.item.id if field is Purchase.product_description
    change: (event, ui) ->
      unless ui.item
        $(this).val ""
        description.val ""
        code.val ""
        product_id.val ""

Purchase.search_vendor = ()->
	$("#purchase_vendor_name").autocomplete
	 	minLength: Purchase.search_length
	  autoFocus: true
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
	  select: (event, ui) ->
	    $("#purchase_vendor_id").val ui.item.id
	    $("#purchase_vendor_id").trigger("change")
	    $(@).val ui.item.label
	    $(@).trigger("change")
	  focus: (event, ui) ->
	    $(@).val ui.item.label
	  change: (event, ui) ->
	    unless ui.item
	      $("#vendor_text").val ""
	      $("#purchase_vendor_id").val ""

Purchase.add_field = (e)->
	form = $("form").attr("id")
	time = new Date().getTime()
	regexp = new RegExp($('.add_item').data('id'), 'g')
	$('.table_items').append($('.add_item').data('fields').replace(regexp, time))
	e.preventDefault()
	Purchase.disable_validations()
	false

Purchase.add_payment = (e)->
	form = $("form").attr("id")
	time = new Date().getTime()
	regexp = new RegExp($('.add_payment').data('id'), 'g')
	$('.payment_options').append($('.add_payment').data('fields').replace(regexp, time))
	e.preventDefault()
	Purchase.disable_validations()
	return false

Purchase.remove_row = () ->
	$(@).closest("tr").hide() if (!$(@).closest("tr").is($(".table tbody tr:first")))
	$(@).closest("tr").find(".cost_total").val(0)
	$(@).prev('input[type=hidden]').val(1)
	Purchase.sub_total()
	Purchase.total()

Purchase.row_total = (row) ->
	quantity = parseFloat ($(row).find(".quantity").val())
	cost_unit = parseFloat ($(row).find(".cost_unit").val())
	discount = parseFloat ($(row).find(".product_discount").val())
	if discount > 0 
		_total = (quantity * cost_unit) - (quantity * cost_unit * discount/100 ) 
	else
		_total =  (quantity * cost_unit)	  	
	$(row).find(".cost_total").val(_total)
	Purchase.sub_total()
	Purchase.total()

Purchase.sub_total = () ->
	sum_subtotal = null;
	$('.table_items .cost_total').each ()->
		sum_subtotal += parseFloat($(@).val())
	$("#purchase_subtotal").val(sum_subtotal) 

Purchase.total = () -> $("#purchase_total").val($("#purchase_subtotal").val())	

Purchase.imported = () ->
	if ($("#purchase_purchase_type").val() == Purchase.option_imported)
		$(".imported").show() 
	else
		$(".imported").hide() 

Purchase.submit_purchase = () ->
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

Purchase.disable_validations = ()->
	$("form").enableClientSideValidations()
	$(".cost_total").disableClientSideValidations();
	if $("#purchase_document_number").hasClass("auto")
		$("#purchase_document_number").disableClientSideValidations();	