Invoice =
  search_length: 3
  code: '.code'
  description: '.description' 

Invoice.add_items = (e) ->
  time = new Date().getTime()
  regexp = new RegExp($(".add_item").data("id"), "g")
  $("table.invoice_items").append $(".add_item").data("fields").replace(regexp, time)
  e.preventDefault()
  $("form").enableClientSideValidations()
  $(".cost_total").disableClientSideValidations();
  $(".tax").disableClientSideValidations();

Invoice.search_customer = () ->
  $("#invoice_customer_name").autocomplete
    minLength: Invoice.search_length
    autoFocus: true
    source: (request, response) ->
      $.ajax
        url: "/customers/search_customer"
        dataType: "json"
        data:
          search: request.term
        success: (data) ->
          response $.map(data, (item) ->
            label: item.name + " " + item.surname
            id: item.id
          )
    select: (event, ui) ->      
      $("#invoice_customer_name").val ui.item.label
      $("#invoice_customer_name").trigger("change")
      $("#invoice_customer_id").val ui.item.id
      $("#invoice_customer_id").trigger("change")
    focus: (event, ui) ->
      $("#invoice_customer_name").val ui.item.label
      $("#invoice_customer_id").val ui.item.id
    change: (event, ui) ->
      unless ui.item
        $("#invoice_customer_name").val("")
        $("#invoice_customer_id").val("")
  false

Invoice.remove_fields = (e) ->
  $(this).prev("input[type=hidden]").val 1
  $(this).closest("tr").hide()
  $(this).closest("tr").find(".cost_total").val(0)
  Invoice.invoice_total()
  e.preventDefault()

Invoice.search = () -> 
  term = $("#search").val()
  if term.length >= Invoice.search_length 
    $.ajax
      url: "/invoices/search"
      dataType: "script"
      data:{
        search: term
      }

Invoice.row_total = (row) ->
  row_quantity = parseFloat($(row).find(".quantity").val())
  row_discount = parseFloat($(row).find(".discount").val()) / 100
  row_cost_unit = parseFloat($(row).find(".cost_unit").val())
  
  if row_discount > 0 and row_quantity > 0 and row_cost_unit > 0
    _total = (row_quantity * row_cost_unit) - (row_quantity * row_cost_unit * row_discount / 100 ) 
  else if row_quantity > 0  and row_cost_unit > 0
    _total =  (row_quantity * row_cost_unit)      
    $(row).find(".cost_total").val(_total)
  else
    _total = 0
  $(row).find(".cost_total").val(_total)
  Invoice.invoice_total()

Invoice.invoice_total = () ->
  sum_total = null;
  $('table.invoice_items .cost_total').each ()->
    sum_total += parseFloat($(@).val())
  $("#invoice_total").val(sum_total) 

Invoice.search_products = (field, input)->
  that = $(input).closest("tr") 
  description = that.find("input.description")
  code = that.find("input.code")
  product_id = that.find("input.product_id")
  $("table.invoice_items " + field ).autocomplete
    minLength: Invoice.search_length
    source: (request, response) ->
      $.ajax
        url: "/products/search"
        dataType: "json"
        data:{
          code: request.term if field is Invoice.code
          name: request.term if field is Invoice.description
        }
        success: (data) ->
          if field is Invoice.code
            response $.map(data, (item) ->
              label:item.code 
              id:   item.code
              name: item.name
              product_id: item.id
            )
          if field is Invoice.description
            response $.map(data, (item) ->
              label:  item.name 
              id:   item.code
              product_id: item.id
            )
    select: (event, ui) ->
      description.val ui.item.name if field is Invoice.code
      description.trigger("change") if field is Invoice.code
      code.trigger("change") if field is Invoice.description
      code.val ui.item.id if field is Invoice.description
      product_id.val ui.item.product_id
    focus:  (event, ui) ->
      description.val ui.item.name if field is Invoice.code
      code.val ui.item.id if field is Invoice.description
    change: (event, ui) ->
      unless ui.item
        $(this).val ""
        description.val("")
        code.val("")
        product_id.val("")
  false

Invoice.quantity_for_sale = (row)->
  ordered = row.find(".ordered")
  available = row.find(".available")
  product_id = row.find(".product_id").val()
  quantity = row.find(".quantity")
  if product_id
    $.ajax
      url: "/products/quantity_available"
      dataType: "json"
      data:
        id: product_id
      success: (data)->
        available.val(data.stock)
        quantity.removeAttr('readonly')
        quantity.val(if data.stock < ordered.val() then data.stock else ordered.val())
        quantity.trigger('change') and quantity.trigger('blur') if parseFloat(quantity.val()) >= 0

$(document).ready ->
  $(".cost_total").disableClientSideValidations();
  $(".tax").disableClientSideValidations();
  # $("table.invoice_items tr").eq(1).find(".remove_row").remove()
  $("form").on "click", ".add_item", Invoice.add_items
  $("form").on "click", ".remove_row", Invoice.remove_fields
  $("form").on "focus", "input.description", () ->  
    Invoice.search_products(Invoice.description, this)
  $("form").on "focus", "input.code", () ->
    Invoice.search_products(Invoice.code, this)
  $("form").on "focus", "input#invoice_customer_name", () ->
    Invoice.search_customer()
  $("table.invoice_items").on "change", ".quantity, .discount, .cost_unit", ->
    Invoice.row_total($(this).closest("tr"))
  $("table.invoice_items").on "change", ".ordered", ->
    row = $(this).closest("tr")
    quantity = row.find('.quantity')
    if parseInt($(this).val()) > 0
      Invoice.quantity_for_sale(row)
    else
      quantity.attr('readonly', true)
      quantity.val('')
  $("#search").keyup () -> Invoice.search()

  $("div#invoices").on "click",".pag a", ->
    $.getScript @href
    false
  $("#default_index").click (e)->
    e.preventDefault()
    $.ajax
      url: "/invoices"
      dataType: "script"
      complete: (data)->
        $("#search").val("")
  false
