jQuery(document).ready ($) ->

  $("#search_form").submit (e) ->
    e.preventDefault()
    prepareSearch()
    
  prepareSearch =()->
    search = $("#search").val().replace(", ", ",")
    
    search = $("#search").val().split(",")
    ajaxCall(call) for call in search when call.length  >= 2       
    $("#products_notice").hide()
    $('#table_products tbody tr').each ->
      if !$(@).find('input').is(':checked')
        $(@).remove()
      else
        $('#storage').append($(@)) 

  ajaxCall = (call)->
    $.ajax
      url: "/products/search"
      dataType: "script"
      data: {"search" : call}
      beforeSend: ()->

  #$("#table_products tbody tr td input[type=checkbox]").change ->
    #$('#storage').append($(@))     
  $(":checkbox").change ->
    if $(@).attr("checked")
      alert "hola"

###
$('#table_products tbody tr').each(function() {
  if (!$(this).find('input').is(':checked')) {
        $(this).remove();
  }});
###