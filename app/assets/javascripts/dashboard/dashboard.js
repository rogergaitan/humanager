load_purchase_orders = function(e) {
	if($('#purchase_orders').length > 0) {
		e.preventDefault();
		if(!$('#purchase_orders').is(':empty')) {
			$.ajax({
				url: '/purchase_orders',
				dataType: 'script',
			});
		}
	}	
};

load_purchases = function(e) {
	e.preventDefault();
	if(!$('#purchases').is(':empty')) {
		$.ajax({
			url: '/purchases',
			dataType: 'script',
		});
	}
};

load_quotations = function(e) {
	e.preventDefault();
	if(!$('#quotations').is(':empty')) {
		$.ajax({
			url: '/quotations',
			dataType: 'script',
		});
	}
};

search_products = function() {
	return $(this).autocomplete({
		source: function(request, response) {
			return $.ajax({
				url: "/products/search",
				dataType: "json",
				data: {
					search: request.term
				},
				success: function(data) {
					return response($.map(data, function(item) {
						return {
							product_id: item.id,
							id: item.code,
							label: item.name
						};
					}));
				}
			});
		},
		minLength: 3,
		select: function(event, ui) {
			$("#product_id").val(ui.item.product_id);
			$("#product_code").val(ui.item.id);
			return $(this).val(ui.item.label);
		},
		focus: function(event, ui) {
			$("#product_id").val(ui.item.product_id);
			$("#product_code").val(ui.item.id);
			return $(this).val(ui.item.label);
		},
		change: function(event, ui) {
			if (!ui.item) {
				$("#product_id").val("");
				$("#product_code").val("");
				return $(this).val("");
			}
		}
	});
	return false;
};

$(document).ready(function() {
	
	$(document).on('ready', load_purchase_orders);
	
	$('ul.nav').on('click', '#load_purchase_orders', load_purchase_orders);	

	$('ul.nav').on('click', '#load_purchases', load_purchases);

	$('ul.nav').on('click', '#load_quotations', load_quotations);

	$('form#product_search').on('focus', '#product_name', search_products);
});