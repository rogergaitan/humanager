jQuery(document).ready ($) ->
  search_length = 3
  
  $("#search_form").submit (e) ->
    e.preventDefault()
    prepareSearch()

  $("#advanced_search_form").submit (e) ->
    e.preventDefault()
    prepareAdvancedSearch()
    
    
  prepareSearch =()->
    search = $("#search").val()
    validateFields("","","",search)
    if search
      if search.length > search_length
        search = $("#search").val().split(",")      
        ajaxCall(search)
        $("#products_notice").hide()
        $(".storage").show();

  prepareAdvancedSearch =()->
    code = $("#code").val()
    name = $("#name").val()
    part_number = $("#part_number").val()
    applications = $("#applications").val()
    validateFields(code, name, part_number)
    if ((code.length >= search_length) or (name.length >=search_length) or (part_number.length >=search_length) or (applications.length >= search_length))
      $.ajax
        url: "/products/search"
        dataType: "script"
        data: {
          "code"        : code if code.length >=search_length
          "name"        : name if name.length >=search_length
          "part_number" : part_number if part_number.length >= search_length
          "applications": applications if applications.length >= search_length
        }
        beforeSend: ()->
          $("span.spinner").show()
        complete: (data)->
          $("span.spinner").hide()
    

  ajaxCall = (call)->
    $.ajax
      url: "/products/search"
      dataType: "script"
      data: {"search" : call}
      beforeSend: ()->
          $("span.spinner").show()
      complete: (data)->
        $("span.spinner").hide()
       
  $(".pagination a").live "click", ->
    $.getScript @href
    false

  $(".case").live "click", ->
    $("#storage").append($(@).closest("tr")).find("input").remove()
    set_cart( cart_to_array() )
    false

  $("table#storage").on "click", "button.close", ->
    $(@).closest("tr").remove()
    set_cart( cart_to_array() )

  $("div#table_products").on "click", "button.close", ->
    $(@).closest("tr").remove()
  #$('#list').on("click", "span.expand_tree", treeviewhr.expand);

  $(".span2").html("")
  $(".row-fluid div").removeClass("span2")
  $(".row-fluid div").removeClass("span10");
  $(".row-fluid .span10").addClass("span12");
  $(".advanced_search").click (e) ->
    e.preventDefault()
    $("#advanced").toggle()
    $("#search_form").toggle() 

  validateFields = (code = "", name = "", part_number= "", search = "")->
    $("#advanced div").removeClass("error success info")
    $("#control-group.search").removeClass("error success info")
    if(code != null or name !=null or part_number != null)
      if (code.length < search_length and code != "")
        $(".control-group.code").addClass("error")
      else
        $(".control-group.code").addClass("success") if(code != "")

      if (name.length < search_length and name != "")
        $(".control-group.name").addClass("error")
      else
        $(".control-group.name").addClass("success") if(name != "")

      if (part_number.length < search_length and part_number != "")
        $(".control-group.part_number").addClass("error")
      else
        $(".control-group.part_number").addClass("success") if(part_number != "")
    if(search != null)
      search = search.replace(",","")
      if (search.length < search_length and search != "")
        $(".control-group.search").addClass("error")
      else
        $(".control-group.search").addClass("success") if(search != "")

  set_cart = (cart_products)->
    $.ajax
      url: "/products/set_cart"
      type: "POST"
      data: {
        "cart_products" : cart_products
      }
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $('meta[name="csrf-token"]').attr('content')

  get_cart = ()->
    $.ajax
      url: "/products/get_cart"
      type: "GET"
      dataType: "json"
      success: (data) ->
        if data
          items = []
          $.each data, (key, val) ->
            items.push("<tr><td></td>")
            $.each val, ( llave, valor) ->
              if llave == "code"
                items.push("<td><a href='/products/#{valor}'>#{valor}</a></td>") if valor
              else  
                items.push("<td>#{valor}</td>") if llave != "product"
            items.push("<td><button class='close'><i class='icon-remove'></i></button></td></tr>")
            $("#storage").append(items.join(""))

      error: (data) ->
        alert data

  cart_to_array = () ->
    $("#storage tbody tr").map(->
      $row = $(@)
      {
        'code': $row.find(":nth-child(1)").text()
        'product': $row.find(":nth-child(1)").text()
        'description': $row.find(":nth-child(3)").text()
        'part_number': $row.find(":nth-child(4)").text()
      }
    ).get()

  get_cart()

