jQuery(document).ready(function($) {
	
var product,html, _i, _len, _results;
		_results = [];
		html = [];

$("#fo").submit(function(e) {
	e.preventDefault();
	$.ajax({
			url:'/products/search',
			dataType: "json", 
			success: function(product_array  ) {
				$.each (product_array, function(key, val){	
							html.push("<tr><td>" + val.name + "</td><td>" + val.part_number + "</td></tr>");					
			});			
			$('#table_products > tbody').append(html.join(''));			
			}
	});
	//e.stopPropagation();
});
});
/*
jQuery(document).ready ($) ->

  $("#search_form").submit (e) ->
    html = []
    e.preventDefault()
    form = $(@).serialize()
    $.ajax
      url: "/products/search"
      dataType: "json"
      data: form
      success: (product_array) ->
        if product_array
          $.each product_array, (key, val) ->
            html.push "<tr><td>" + val.name + "</td><td>" + val.part_number + "</td></tr>"
          $("#table_products > tbody").append html.join("")
*/