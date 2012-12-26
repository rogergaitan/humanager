jQuery(document).ready ($) ->

	$("form#product_applications").on "submit", (e) ->
		e.preventDefault()
		ajaxCall()
		#$("div.applications").append -> 
		#	'<div class="btn-group"><button class="btn">'+ $("#product_application").val()+'<button class="btn remove_application"><i class="icon-remove"></i></button></button></div>'
		$("#product_application").val("")

	$("div.applications").on "click", ".remove_application", ()->
		$(@).closest("li").remove()

ajaxCall = ()->
  $.ajax
    url: "/product_applications/"
    type: "POST"
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
      


