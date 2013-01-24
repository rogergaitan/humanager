
	action_add_item = function(e) {
		var form, regexp, time;
		form = $("form").attr("id");
		time = new Date().getTime();
		regexp = new RegExp($('.add_item').data('id'), 'g');
		$('.table_items').append($('.add_item').data('fields').replace(regexp, time));
		e.preventDefault();		
		$("form").enableClientSideValidations();
		return false;
	}; 

	action_remove_item = function() {
		if (!$(this).closest("tr").is($(".table tbody tr:first"))) {
				$(this).closest("tr").hide();
		}
		$(this).closest("tr").find(".item_type").remove();
		$(this).prev('input[type=hidden]').val(1);
		$(this).closest("tr").find(".item_name").remove();
		$(this).closest("tr").find(".item_id").remove();
		$(this).closest("tr").find(".discount").remove();
	};

	action_reset_type = function() {
		$(this).closest("tr").find(".item_name").val("");
		$(this).closest("tr").find(".item_id").val("");
		$(this).closest("tr").find(".discount").val("");
	}

$(document).ready(function() {

	$('form').on('change', '.item_type', action_reset_type);

	$('form').on('click', '.add_item', action_add_item);

	$('form').on('click', '.remove_item', action_remove_item);
	
	$("table tr").eq(1).find(".remove_item").remove();
	
	$('form').on('focus', '.item_name', function() {
		var URL = '/products/search.json';
		if($(this).closest("tr").find(".item_type").val() != 'product') {
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