$(document).ready(function() {
	$(".item_type").change(function() {
		$(".item_name").val("");
		$(".item_id").val("");
		$(".discount").val("");
	});
	
	$("form").on('focus', '.item_name', function() {
		var URL = '/products/search.json';
		if($(".item_type").val() != "product") {
			URL = '/sublines/search.json';
		}
		return $(this).autocomplete({
			source: function(request, response) {
				return $.ajax({
					url: URL,
					dataType: "json",
					data: {
						name: request.term
					},
					success: function(data) {
						return response($.map(data, function(item) {
							return {
								label: item.name,
								id: item.id,
								code: item.code
							};
						}));
					}
				});
			},
			minLength: 3,
			select: function(event, ui) {
				//$("#purchase_product_id").val(ui.item.id);
				$(this).closest("tr").find("input.item_id").val(ui.item.code);
				$(this).closest("tr").find("input.item_id").trigger("change");
				return $(this).val(ui.item.label);
			},
			focus: function(event, ui) {
				$(this).val(ui.item.label);
				return $(this).closest("tr").find("input.item_id").val(ui.item.code);
			},
			change: function(event, ui) {
				$(this).next("#not-found").remove();
				if (!ui.item) {
					$(this).val("");
					$(this).closest("tr").find("input.item_id").val("");
					return $("#item_id").val("");
				}
			}
		});
	});
})