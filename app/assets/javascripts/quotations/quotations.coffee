Quotation =
  search_length: 3

$(document).ready ->
  $(".cost_total").disableClientSideValidations();
  $(".tax").disableClientSideValidations();
  $("table.quotation_items tr").eq(1).find(".remove_row").remove()
  $("form").on "click", ".add_item", Quotation.add_items
  $("form").on "click", ".remove_row", Quotation.remove_fields
  $("form").on "focus", "input.description", () ->  
    Quotation.search_products(".description")
  $("form").on "focus", "input.code", () ->
    Quotation.search_products(".code")
  $("form").on "focus", "input#quotation_customer_name", () ->
    Quotation.search_customer("customer")
  $("table.quotation_items").on "change", ".quantity, .discount, .cost_unit", ->
    Quotation.row_total($(this).closest("tr"))
  $("#search").keyup () -> Quotation.search()

  $("div#quotations").on "click",".pag a", ->
    $.getScript @href
    false
  $("#default_index").click (e)->
    e.preventDefault()
    $.ajax
      url: "/quotations"
      dataType: "script"
      complete: (data)->
        $("#search").val("")
  false

Quotation.search = () -> 
  term = $("#search").val()
  if term.length >= Quotation.search_length 
    $.ajax
      url: "/quotations/search"
      dataType: "script"
      data:{
        search: term
      }

Quotation.remove_fields = (e) ->
  $(this).prev("input[type=hidden]").val 1
  $(this).closest("tr").hide()
  $(this).closest("tr").find(".cost_total").val(0)
  Quotation.quotation_total()
  e.preventDefault()

Quotation.search_products = (field)->
  $("table.quotation_items " + field ).autocomplete
    minLength: Quotation.search_length

    source: (request, response) ->
      $.ajax
        url: "/products/search"
        dataType: "json"
        data:
          search: request.term
        success: (data) ->
          if field is ".code"
            response $.map(data, (item) ->
              label:item.code 
              id:   item.code
              name: item.name
              product_id: item.id
            )
          if field is ".description"
            response $.map(data, (item) ->
              label:  item.name 
              id:   item.code
              product_id: item.id
            )
    select: (event, ui) ->
      that = $(this).closest("tr")
      that.find("input.description").val ui.item.name if field is ".code"
      that.find("input.code").val ui.item.id if field is ".description"
      that.find("input.product_id").val ui.item.product_id
      that.find("input.description").trigger("change") if field is ".code"
      that.find("input.code").trigger("change") if field is ".description"
    focus:  (event, ui) ->
      that = $(this).closest("tr")
      that.find("input.description").val ui.item.name if field is ".code"
      that.find("input.code").val ui.item.id if field is ".description"
    change: (event, ui) ->
      unless ui.item
        that = $(this).closest("tr")
        $(this).val ""
        that.find("input.description").val ""
        that.find("input.code").val ""
        that.find("input.product_id").val ""
  false

Quotation.search_customer = (customer) ->
  $("#quotation_customer_name").autocomplete
    minLength: Quotation.search_length
    autoFocus: true
    source: (request, response) ->
      $.ajax
        url: "/quotations/search_customer"
        dataType: "json"
        data:
          search: request.term
        success: (data) ->
          response $.map(data, (item) ->
            label: item.name + " " + item.surname
            id: item.id
          )
    select: (event, ui) ->
      $("#quotation_customer_id").val ui.item.id
      $(this).val ui.item.label
    focus: (event, ui) ->
      $(this).val ui.item.label
      $("#quotation_customer_id").val ui.item.id
    change: (event, ui) ->
      unless ui.item
        $(this).val ""
        $("#quotation_customer_id").val ""

Quotation.add_items = (e) ->
  time = new Date().getTime()
  regexp = new RegExp($(".add_item").data("id"), "g")
  $("table.quotation_items").append $(".add_item").data("fields").replace(regexp, time)
  e.preventDefault()
  $("form").enableClientSideValidations()
  $(".cost_total").disableClientSideValidations();
  $(".tax").disableClientSideValidations();

Quotation.row_total = (row) ->
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
  Quotation.quotation_total()

Quotation.quotation_total = () ->
  sum_total = null;
  $('table.quotation_items .cost_total').each ()->
    sum_total += parseFloat($(@).val())
  $("#quotation_total").val(sum_total) 
