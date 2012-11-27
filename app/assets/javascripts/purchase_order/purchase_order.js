/*Function the action new field*/
var action_add_field = function(e){
	var time = new Date().getTime();
	var regexp = new RegExp($('.add_fields').data('id'), 'g');
	$('#container_new_item').append($('.add_fields').data('fields')
									.replace(regexp, time));
	$('#container_new_item').find('input').eq(0).addClass('none').end()
							.eq(4).addClass('none');
	e.preventDefault();
	request_search_products();
};


/* validate the actual field added and add the new fields*/
var addFields_items = function(e) {
	var temp_tr = $('#container_new_item').find('tr');
	if(validation_add_item(temp_tr)){
		temp_tr.find('.cost_total').val(search_input_for_calculate(temp_tr));
		$('.header_items').after(temp_tr);
		$('#products_items').find('tbody tr  input').not('.calculate')
							.attr('readonly',true).end()
							.removeClass('none').end()
							.find('a').removeClass('none').end()
							.find('label').remove();
		action_add_field(e);
		calculate_subtotal();
		calculate_total();
	}
	e.preventDefault();
};

/*Add the first fields*/
var addField_newItem = function(e){
	action_add_field(e);
	//
};

/*Validate if the fields have something for add to the table*/
var validation_add_item = function(element){
	var validation = false;
	$(element).find('input:not(".none")').each(function(){
		if($(this).val()){
			validation = true;
		}else{
			validation = false;
			return false;
		}
	});
	return validation;
};

/*Calulate the cost*/
var item_cost_total = function(quantity,cost){
	return quantity * cost;
	//
};

/*Search the input into the rows for make the calculation*/
var search_input_for_calculate = function(temp_tr){
	return item_cost_total(temp_tr.find('.quantity').val(),
						   temp_tr.find('.cost_unit').val());								
};

/*Calculate the cost into the table*/
var cost_live_calculate = function(e){
	var temp_tr = $('#products_items').find('tr').has('#'+$(this).attr('id'));
	if(temp_tr){
		temp_tr.find('.cost_total').val(search_input_for_calculate(temp_tr));
		calculate_subtotal();
		calculate_total();	
	}	
};

/*Remove the row in the table*/
var removeFields = function (e) {
	$(this).parent().closest('tr').remove();
	e.preventDefault();
};

/*Calculte the subtotal amount*/
var calculate_subtotal = function(){
	var sum_subtotal = 0;
	$('#products_items .cost_total').each(function(){
		sum_subtotal += parseFloat($(this).val());
	});
	$('.subtotal').val(sum_subtotal);
};

/*Calculate the taxes*/
var calculate_tax = function(){
	return 0;
	//
};

/*Calculate the total amount*/
var calculate_total = function(){
	$('.total').val(parseFloat($('.subtotal').val())+ parseFloat(calculate_tax()));
};

var request_search_products = function(){
	$( "#container_new_item .description" ).autocomplete({
            source: function( request, response ) {
                $.ajax({
                    url: "/purchase_orders/searchProduct.json",
                    dataType: "json",
                    data: {
                        search: request.term,
                    },
                    success: function( data ) {
                        response( $.map( data, function( item ) {
                            return {
                                label: item.name + " "+ item.part_number +" "+ item.model,
                                id: item.code,
                                cost: item.cost
                            }
                        }));
                    }
                });
            },
            minLength: 3,
            select: function( event, ui ) {
                $( "#container_new_item .code").val(ui.item.id);
                $( this).val(ui.item.label);
                $( "#container_new_item .cost_unit").val(ui.item.cost);
            },
            focus: function(event, ui){
                $( this ).val(ui.item.label);
            }
    });
}

var request_search_vendors = function(){
	$( "#vendor_text" ).autocomplete({
            source: function( request, response ) {
                $.ajax({
                    url: "/purchase_orders/searchVendor.json",
                    dataType: "json",
                    data: {
                        search: request.term,
                    },
                    success: function( data ) {
                        response( $.map( data, function( item ) {
                            return {
                                label: item.name + " "+ item.surname ,
                                id: item.id
                            }
                        }));
                    }
                });
            },
            minLength: 3,
            select: function( event, ui ) {
                $( "#purchase_order_vendor_id").val(ui.item.id);
                $( this).val(ui.item.label);
            },
            focus: function(event, ui){
                $( this ).val(ui.item.label);
            }
    });
};
var convertingEntity = null;
var convertEntityToVendor = function(e) {
	e.preventDefault();
	if (convertingEntity) {
		convertingEntity.abort();
	}
	var entityid = $('#vendor_entity_attributes_entityid').val();
	convertingEntity = $.ajax('/purchase_orders/tovendor', {
		type: 'post',
		data: { 'entityid' : entityid },
		dataType: 'json',
		cache: false,
		timeout: 5000,
		beforeSend: function(vendor) {
			$('#status-vendor').hide();
			$('#vendor-spinner').show();
			$('section.nav').empty().show();
		},
		complete: function(vendor) {
			$('#vendor-spinner').hide();
			$('#status-vendor').show();
			resetFieldsErrors('new_vendor');
			$(".closeVendor").trigger("click");
			convertingEntity = null;
		},
		success: function(vendor) {
			$('#purchase_order_vendor_id').val(vendor.id);
			$('#vendor_text').val(vendor.entity.name + ' ' + vendor.entity.surname);
			$('section.nav').html('<div class="notice">Proveedor creado correctamente</div>').delay(10000).fadeOut();
		},
		error: function(vendor) {
			if (vendor.statusText != "abort") {
				$('section.nav').html('<div class="alert alert-error">Error: La entidad especificada es un proveedor</div>').delay(10000).fadeOut();
			}
		}
	})
}

function resetFieldsErrors (form) {
	$('form#'+form)[0].reset();
	$('#'+form).find('[data-validate]:input').each(function() {
		$(this).removeData();
	});
	$('.message').remove();
	$('#status-vendor').remove();
}


$(document).ready(function(){
	$('form').on('click', '.add_fields', addFields_items);
	$('form').on('click', '.add_field_fake', addField_newItem);
	$('form').on('click', '.remove_fields', removeFields);
	$('.add_field_fake').trigger('click');
	$('form').on('keyup', '.calculate', cost_live_calculate);
	$('#products_items').find('label').remove();
	$('form.new_purchase_order').submit(function(){
		$('#container_new_item input').attr('disabled',true);
	});	
  	request_search_vendors();
  	$('form').on('keydown','#container_new_item .calculate',function (event) {
        var key = event.keyCode || event.which;
        if (key == 13) {
		   $('.add_fields').trigger('click');
		   event.stopPropagation();
		   event.preventDefault();
		} 
    });
	$('div.modal-body').on('click', '#entity-to-vendor', convertEntityToVendor);
	$('div.modal-body').on('click', '#cancel-convert', function(e) {
		e.preventDefault();
		resetFieldsErrors('new_vendor');
		$(".closeVendor").trigger("click");
	});
	$('#products_items').find('tbody tr  input').not('.calculate')
							.attr('readonly',true).end();
	$('#products_items').find("a").removeClass('none').end();
});