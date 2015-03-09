var dynamic_fields = new function() {
	this.provinceSelected = function(canton_id) {

	  	province_id = $('#employee_entity_attributes_addresses_attributes_0_province_id').val();
	  	attrSelected = false;

	  	$('#employee_entity_attributes_addresses_attributes_0_canton_id').find('option').remove();
		$('#employee_entity_attributes_addresses_attributes_0_district_id').find('option').remove();
		$(cantons).each(function() {
			if (this[0] == province_id) {
		    	if(canton_id == this[2]) {
		    		attrSelected = true;
		      		$('#employee_entity_attributes_addresses_attributes_0_canton_id').append("<option selected='selected' value='" + this[2] + "'>" + this[1] + "</option>");
		    	} else {
		      		$('#employee_entity_attributes_addresses_attributes_0_canton_id').append("<option value='" + this[2] + "'>" + this[1] + "</option>");
		    	}
		    }
		});

		if(attrSelected) {
		    $('#employee_entity_attributes_addresses_attributes_0_canton_id').prepend("<option value='' ></option>");
		} else {
		    $('#employee_entity_attributes_addresses_attributes_0_canton_id').prepend("<option value='' selected='selected'></option>");
		}

		dynamic_fields.cantonSelected();
	}

	this.cantonSelected = function(district_id) {
		canton_id = $('#employee_entity_attributes_addresses_attributes_0_canton_id').val();
		attrSelected = false;

		$('#employee_entity_attributes_addresses_attributes_0_district_id').find('option').remove();
		$(district).each(function() {
			if (this[0] == canton_id) {
				if(district_id == this[2]) {
					attrSelected = true;
					$('#employee_entity_attributes_addresses_attributes_0_district_id').append("<option selected='selected' value='" + this[2] + "'>" + this[1] + "</option>");
				} else {
					$('#employee_entity_attributes_addresses_attributes_0_district_id').append("<option value='" + this[2] + "'>" + this[1] + "</option>");
				}
			} 
		});
		if(attrSelected) {
			$('#employee_entity_attributes_addresses_attributes_0_district_id').prepend("<option value='' ></option>");
		} else {
			$('#employee_entity_attributes_addresses_attributes_0_district_id').prepend("<option value='' selected='selected'></option>");
		}
	}

	this.addFields = function(e) {
		var numberFields = parseInt($(this).next().val());
		if (numberFields < 3) {
			var time = new Date().getTime();
			var regexp = new RegExp($(this).data('id'), 'g');
			$(this).before($(this).data('fields').replace(regexp, time));
			numberFields += 1;
			$(this).next().val(numberFields);
			if (numberFields == 3) {
				$(this).hide();
			};
		};
		e.preventDefault();
	}

	this.removeFields = function(e) {
		var numberFields = parseInt($('#'+$(this).prev().attr('class')).next().val());
		if (numberFields > 1) {
			$(this).prev('input[type=hidden]').val(1);
			$(this).closest('.employee_contact_fields').hide();
			numberFields -= 1;
			$('#'+$(this).prev().attr('class')).next().val(numberFields);
			if (numberFields < 3) {
				$('#'+$(this).prev().attr('class')).show();
			};
		};
		e.preventDefault();
	}
	
	this.countFields = function() {
		var numberTelephoneFields = $('.telephone-field').length;
		var numberEmailFields = $('.email-field').length;
		$('input#count_phones_employees').val(numberTelephoneFields);
		$('input#count_emails_employees').val(numberEmailFields);
		if (numberTelephoneFields == 3) { 
			$('a.add-fields-telephone').hide(); 
		}; 
		if (numberEmailFields == 3) {
			$('a.add-fields-email').hide();
		};
	}
};

$(document).ready(function() {
	check_input_price_defined();
	$('#employee_birthday').datepicker();
	$('#employee_join_date').datepicker();
	dynamic_fields.countFields();
	$('div.employee_contact_fields a.telephone-remove.remove_fields:eq(0)').remove();
	$('div.employee_contact_fields a.email-remove.remove_fields:eq(0)').remove();

	var canton_id = $('#employee_entity_attributes_addresses_attributes_0_canton_id').val();
	var district_id = $('#employee_entity_attributes_addresses_attributes_0_district_id').val();
	dynamic_fields.provinceSelected(canton_id);
	dynamic_fields.cantonSelected(district_id);

	$('#employee_entity_attributes_addresses_attributes_0_province_id').change(dynamic_fields.provinceSelected);
	$('#employee_entity_attributes_addresses_attributes_0_canton_id').change(dynamic_fields.cantonSelected);	
	$('form').on('click', '.add_fields', dynamic_fields.addFields);	
	$('form').on('click', '.remove_fields', dynamic_fields.removeFields);

	$('#employee_price_defined_work').click(function(){
		check_input_price_defined();
	});

	function check_input_price_defined(){
		if($('#employee_price_defined_work').is(':checked')){
			$('#employee_wage_payment').attr('disabled','disabled');
			$('#employee_wage_payment').val('');
		} else {
			$('#employee_wage_payment').removeAttr('disabled');
		}
	}

	//Gets all data from employees
    $.getJSON('/employees/load_employees', function(employee_data) {
        $('#load_employee').autocomplete({
            source: $.map(employee_data, function(item){
                $.data(document.body, 'employee_'+ item.id+"", item.entity.name + ' ' + item.entity.surname);
                return{
                    label: item.entity.name + ' ' + item.entity.surname,
                    id: item.id
                }
            }),
            select: function( event, ui ) {
                if(ui.item.id){
                    $("#employee_employee_id").val(ui.item.id);
                }
            },
            focus: function(event, ui){
                $( "#load_employee" ).val(ui.item.label);
            },
            change: function(event, ui){
                if(!ui.item){
                    alert('Ningún resultado contiene ' + $( "#load_employee" ).val());
                    $( "#load_employee" ).val("");
                    $("#load_employee_id").val("");
                }
            }
        });
        $('#load_employee').removeClass('ui-autocomplete-input');
        if($("#employee_employee_id").val()){
            var load_employee_name = $.data(document.body, 'employee_' + $("#employee_employee_id").val()+'');
            $("#load_employee").val(load_employee_name);
        }
    });

	$('form').submit(function(e) {
		if(!$(this).parsley().validate()) {
			e.preventDefault();
		}
	});
})