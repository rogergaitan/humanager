jQuery(document).ready ($) ->

  $("#search_form").submit (e) ->
    e.preventDefault()
    prepareSearch()
    
  prepareSearch =()->
    search = $("#search").val().replace(", ", ",")
    
    search = $("#search").val().split(",")
    ajaxCall(call) for call in search when call.length  >= 3       
    $("#products_notice").hide()
    
    #$('#table_products tbody tr').each ->
    #  if !$(@).find('input').is(':checked')
    #    $(@).remove()
    #  else
    #    $('#storage').append($(@)) 

  ajaxCall = (call)->
    $.ajax
      url: "/products/search"
      dataType: "script"
      data: {"search" : call}
      beforeSend: ()->

  #$("#table_products tbody tr td input[type=checkbox]").change ->
    #$('#storage').append($(@))     
  
        
  $(".pagination a").live "click", ->
    $.getScript @href
    false

  $(".case").live "click", ->
    $("#storage").append($(@).closest("tr")).find("input").remove()
    false


###
$(".case").on("click", (function() {
    $("#storage").append($(this).closest("tr")).find("input").remove();
}));

$('#table_products tbody tr').each(function() {
  if (!$(this).find('input').is(':checked')) {
        $(this).remove();
  }});
###