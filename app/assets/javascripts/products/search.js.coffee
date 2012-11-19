jQuery(document).ready ($) ->

  $("#search_form").submit (e) ->
    e.preventDefault()
    prepareSearch()

  $("#advanced_search_form").submit (e) ->
    e.preventDefault()
    prepareAdvancedSearch()
    
    
  prepareSearch =()->
    search = $("#search").val()
    if search
      if search.length > 3
        search = $("#search").val().split(",")      
        ajaxCall(search)
        $("#products_notice").hide()
        $(".storage").show();

  prepareAdvancedSearch =()->
    code = $("#code").val()
    name = $("#name").val()
    part_number = $("#part_number").val()
    if (code.length <= 3) or (name.length <=3) or (part_number.length <=3)
      before = new Date().getTime()
      $.ajax
        url: "/products/search"
        dataType: "script"
        data: {
          "code"        : code
          "name"        : name
          "part_number" : part_number
        }
        beforeSend: ()->
        complete: (data)->
    if (code.length <= 3) and (name.length <=3) and (part_number.length <=3)
      $(".control-group").addClass("error")
    if (code.length > 3)
      $(".control-group code").addClass("success")

  ajaxCall = (call)->
    $.ajax
      url: "/products/search"
      dataType: "script"
      data: {"search" : call}
      beforeSend: ()->
      complete: (data)->
        
       
  $(".pagination a").live "click", ->
    $.getScript @href
    false

  $(".case").live "click", ->
    $("#storage").append($(@).closest("tr")).find("input").remove()
    false

  $(".storage").hide()
  $(".span2").html("")
  $(".row-fluid div").removeClass("span2")
  $(".row-fluid div").removeClass("span10");
  $(".row-fluid .span10").addClass("span12");
  $(".advanced_search").click ->
    $("#advanced").toggle()
    $("#search_form").toggle()  

