$(document).ready ->
  $("form#new_product_application").submit (e)->
    e.preventDefault()
    ajaxCall()
    $("#product_application").val("")
    false
	$("div.applications").on "click", ".remove_application", ()->
		$(@).closest("li").remove()
  false

ajaxCall = ()->
  $.ajax
    url: "/product_applications/"
    type: "POST"
    dataType: "script"
    data:
    	product_application =  
    		name: $(".form_application:last").val()
    		product_id: $(".form_application:first").val()
    beforeSend: (xhr)->
      xhr.setRequestHeader "X-CSRF-Token", $('meta[name="csrf-token"]').attr('content')
      $("span.spinner").show()
    complete: (data)->
      $("span.spinner").hide()

delet_application = ()->
  $.ajax
    url: "/product_applications/"
    type: "DELETE"
    dataType: "script"
    data:
      product_application =  
        name: $("#product_application").val()
        product_id: $("#app_product_id").val()
    beforeSend: (xhr)->
      xhr.setRequestHeader "X-CSRF-Token", $('meta[name="csrf-token"]').attr('content')
      $("span.spinner").show()
    complete: (data)->
      $("span.spinner").hide()
      


