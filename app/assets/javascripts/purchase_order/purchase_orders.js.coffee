purchase_order_subtotal = () ->
  sum_subtotal = null;
  $('#products_items .cost_total').each ()->
    sum_subtotal += parseFloat($(@).val())
  $("#purchase_order_subtotal").val(sum_subtotal) 

purchase_order_total = () ->
  $("#purchase_order_total").val($("#purchase_order_subtotal").val() + $("#purchase_order_taxes").val() )

row_total = (row) ->
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
  purchase_order_subtotal()
  purchase_order_total()

$(document).ready ->
  $(".cost_total").disableClientSideValidations();
  $("table#products_items tr").eq(1).find(".remove_row").remove()
  
  $("form").on "click", ".add_items", add_items
  $("form").on "click", ".remove_row", removeFields
  $("div.modal-body").on "click", "#entity-to-vendor", convertEntityToVendor
  request_search_vendors()

  $("form").on "focus", "input.description", () ->  
    search_products(".description")

  $("form").on "focus", "input.code", () ->
    search_products(".code")
  
  
  $("div.modal-body").on "click", "#cancel-convert", (e) ->
    e.preventDefault()
    resetFieldsErrors "new_vendor"
    $(".closeVendor").trigger "click"
  $("#products_items").on "change", ".quantity", () ->
    row_total($(this).closest("tr"))
  $("#products_items").on "change", ".discount", () ->
    row_total($(this).closest("tr"))
  $("#products_items").on "change", ".cost_unit", () ->
    row_total($(this).closest("tr"))
  if $(".payment_number").val()
    $("div.purchase_order_payments").show()
  
  $("form").on "change", "#order_payment", ()->
    $("div.purchase_order_payments").toggle()
    if $("table#order_payment_table tbody tr").length is 0
      add_payment()
    #   $("#order_payment_table").append $(".add_payment").data("fields")
    $("form.new_purchase_order").enableClientSideValidations()
    $(".cost_total").disableClientSideValidations();
  false

search_length = 3
convertingEntity = null

convertEntityToVendor = (e) ->
  e.preventDefault()
  convertingEntity.abort()  if convertingEntity
  entityid = $("#vendor_entity_attributes_entityid").val()
  convertingEntity = $.ajax("/purchase_orders/to_vendor",
    type: "post"
    data:
      entityid: entityid

    dataType: "json"
    cache: false
    timeout: 5000
    beforeSend: (vendor) ->
      $("#status-vendor").hide()
      $("#vendor-spinner").show()
      $("section.nav").empty().show()

    complete: (vendor) ->
      $("#vendor-spinner").hide()
      $("#status-vendor").show()
      resetFieldsErrors "new_vendor"
      $(".closeVendor").trigger "click"
      convertingEntity = null

    success: (vendor) ->
      $("#purchase_order_vendor_id").val vendor.id
      $("#vendor_text").val vendor.entity.name + " " + vendor.entity.surname
      $("section.nav").html("<div class=\"notice\">Proveedor creado correctamente</div>").delay(10000).fadeOut()

    error: (vendor) ->
      $("section.nav").html("<div class=\"alert alert-error\">Error: La entidad especificada es un proveedor</div>").delay(10000).fadeOut()  unless vendor.statusText is "abort"
  )

add_payment = () ->
  time = new Date().getTime()
  regexp = new RegExp($(".add_payment").data("id"), "g")
  $("#order_payment_table").append $(".add_payment").data("fields").replace(regexp, time)

add_items = (e) ->
  time = new Date().getTime()
  regexp = new RegExp($(".add_fields").data("id"), "g")
  $("#products_items").append $(".add_items").data("fields").replace(regexp, time)
  e.preventDefault()
  $("form.new_purchase_order").enableClientSideValidations()
  $(".cost_total").disableClientSideValidations();

removeFields = (e) ->
  $(this).prev("input[type=hidden]").val 1
  $(this).closest("tr").hide()
  $(this).closest("tr").find(".cost_total").val(0)
  purchase_order_subtotal()
  purchase_order_total()
  e.preventDefault()

search_products = (field)->
  $("#products_items " + field ).autocomplete
    minLength: 3
    source: (request, response) ->
      $.ajax
        url: "/purchase_orders/search_product.json"
        dataType: "json"
        data:
          search: request.term
        success: (data) ->
          if field is ".code"
            response $.map(data, (item) ->
              label:item.code 
              id:   item.code
              name: item.name
            )
          if field is ".description"
            response $.map(data, (item) ->
              label:  item.name 
              id:   item.code
            )
    select: (event, ui) ->
      $(this).closest("tr").find("input.description").val ui.item.name if field is ".code"
      $(this).closest("tr").find("input.code").val ui.item.id if field is ".description"
    focus:  (event, ui) ->
      $(this).closest("tr").find("input.description").val ui.item.name if field is ".code"
      $(this).closest("tr").find("input.code").val ui.item.id if field is ".description"
    change: (event, ui) ->
      unless ui.item
        $(this).val ""
        $(this).closest("tr").find("input.description").val "" if field is ".code"
        $(this).closest("tr").find("input.code").val "" if field is ".description"
  false

request_search_vendors = ->
  $(".vendor_name").autocomplete
    minLength: search_length
    source: (request, response) ->
      $.ajax
        url: "/purchase_orders/search_vendor.json"
        dataType: "json"
        data:
          search: request.term
        success: (data) ->
          response $.map(data, (item) ->
            label: item.name + " " + item.surname
            id: item.id
          )
    select: (event, ui) ->
      $("#purchase_order_vendor_id").val ui.item.id
      $(this).val ui.item.label
    focus: (event, ui) ->
      $(this).val ui.item.label
    change: (event, ui) ->
      unless ui.item
        $(".vendor_name").val ""
        $("#purchase_order_vendor_id").val ""

resetFieldsErrors = (form) ->
  $("form#" + form)[0].reset()
  $("#" + form).find("[data-validate]:input").each ->
    $(this).removeData()

  $(".message").remove()
  $("#status-vendor").remove()

  #request_search_products()

addField_newItem = (e) ->
  action_add_field e

validation_add_item = (element) ->
  validation = false
  $(element).find("input:not(\".none\")").each ->
    if $(this).val()
      validation = true
    else
      validation = false
      false

  validation

item_cost_total = (quantity, cost) ->
  quantity * cost

search_input_for_calculate = (temp_tr) ->
  item_cost_total temp_tr.find(".quantity").val(), temp_tr.find(".cost_unit").val()

cost_live_calculate = (e) ->
  temp_tr = $("#products_items").find("tr").has("#" + $(this).attr("id"))
  if temp_tr
    temp_tr.find(".cost_total").val search_input_for_calculate(temp_tr)
    calculate_subtotal()
    calculate_total()

calculate_subtotal = ->
  sum_subtotal = 0
  $("#products_items .cost_total").each ->
    sum_subtotal += parseFloat($(this).val())

  $(".subtotal").val sum_subtotal

calculate_tax = ->
  0

  #search_products()
  #request_search_vendors()
  # $("form").on "keydown", "#container_new_item .calculate", (event) ->
  #   key = event.keyCode or event.which
  #   if key is 13
  #     $(".add_fields").trigger "click"
  #     event.stopPropagation()
  #     event.preventDefault()