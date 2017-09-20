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


	$('#employee_number_of_dependents, #employee_marital_status, #employee_department_id, #employee_payment_unit_id').change(function() {
    var modelName = $('form:eq(0)').data('modelName');
    var referenceId = $('form:eq(0)').data('referenceId');
    resources.updateValidation(modelName, referenceId);
  });

	check_input_price_defined();
	$('#employee_birthday').datepicker({
    format: 'dd/mm/yyyy',
    autoclose: true,
    language: "es"
  });
	$('#employee_join_date').datepicker({
    format: 'dd/mm/yyyy',
    autoclose: true,
    language: "es"
  });
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
      $('#employee_currency_id').attr('disabled', 'disabled');
		} else {
			$('#employee_wage_payment').removeAttr('disabled');
      $('#employee_currency_id').removeAttr('disabled');
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
              if(ui.item.id) {
                $("#employee_employee_id").val(ui.item.id);
              }
            },
            focus: function(event, ui) {
              $( "#load_employee" ).val(ui.item.label);
            },
            change: function(event, ui) {
              if(!ui.item) {
                $( "#load_employee" ).val("");
                $("#load_employee_id").val("");
              }
            }
        });
        if($("#employee_employee_id").val()) {
            var load_employee_name = $.data(document.body, 'employee_' + $("#employee_employee_id").val());
            $("#load_employee").val(load_employee_name);
        }
    });
    
    $.getJSON('/departments/search', function(data) {
      $('#load_department').autocomplete({
        source: $.map(data, function(item){
          $.data(document.body, 'department_' + item.id + "", item.name);
            return { label: item.name, id: item.id }
        }),
        
        select: function(event, ui) {
          if(ui.item.id) {
           $('#employee_department_id').val(ui.item.id);
          }
        },
        
        focus: function(event, ui) {
          $('#load_department').val(ui.item.label);  
        }
      });
      
      if($('#employee_department_id').val()) {
        var load_department_name = $.data(document.body, 'department_' + $('#employee_department_id').val());
        $('#load_department').val(load_department_name);
      }
    });
    
    $.getJSON('/positions/search', function(data) {
      $('#load_position').autocomplete({
        source: $.map(data, function(item){
          $.data(document.body, 'position_' + item.id + "", item.position);
            return { label: item.position, id: item.id }
        }),
        
        select: function(event, ui) {
          if(ui.item.id) {
           $('#employee_position_id').val(ui.item.id);
          }
        },
        
        focus: function(event, ui) {
          $('#load_position').val(ui.item.label);  
        }
      });
      
      if($('#employee_position_id').val()) {
        $('#load_position').val($.data(document.body, 'position_' + $('#employee_department_id').val()));
      }
    });
    
    $.getJSON('/occupations/search', function(data) {
      $('#load_occupation').autocomplete({
        source: $.map(data, function(item){
          $.data(document.body, 'occupation_' + item.id + "", item.name);
            return { label: item.name, id: item.id }
        }),
        
        select: function(event, ui) {
          if(ui.item.id) {
           $('#employee_occupation_id').val(ui.item.id);
          }
        },
        
        focus: function(event, ui) {
          $('#load_occupation').val(ui.item.label);
        }
      });
      
      if($('#employee_occupation_id').val()) {
        $('#load_occupation').val($.data(document.body, 'occupation_' + $('#employee_occupation_id').val()));
      }
    });
    

    $('form').submit(function(e) {
      if(!$(this).parsley().validate()) {
        e.preventDefault();
        //show notification only when tab3 is not active
        if (!$("#tab3").hasClass("active") && $("#tab3 div.form-group ul.parsley-errors-list").length >= 1) {
          new PNotify({
            title: 'Atención!',
            text: 'Por favor revisar errores en pestaña laboral.',
            type: 'error',
            icon: 'fa fa-warning',
            buttons: {
              closer: true,
              sticker: false
            }
          });
        }
      }
  });
})
