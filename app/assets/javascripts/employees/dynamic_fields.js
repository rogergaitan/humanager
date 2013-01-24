var dynamic_fields = new function() {
	this.provinceSelected = function() {
	  province_id = $('#employee_entity_attributes_addresses_attributes_0_province_id').val();
	  $('#employee_entity_attributes_addresses_attributes_0_canton_id').find('option').remove();
		$('#employee_entity_attributes_addresses_attributes_0_district_id').find('option').remove();
	  $(cantons).each(function() {
	    if (this[0] == province_id) {
	      $('#employee_entity_attributes_addresses_attributes_0_canton_id').append("<option value='" + this[2] + "'>" + this[1] + "</option>");
	    } 
	  });
		dynamic_fields.cantonSelected();
	}

	this.cantonSelected = function() {
	  canton_id = $('#employee_entity_attributes_addresses_attributes_0_canton_id').val();
	  $('#employee_entity_attributes_addresses_attributes_0_district_id').find('option').remove();
	  $(district).each(function() {
	    if (this[0] == canton_id) {
	      $('#employee_entity_attributes_addresses_attributes_0_district_id').append("<option value='" + this[2] + "'>" + this[1] + "</option>");
	    } 
	  });
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
	dynamic_fields.countFields();
	$('div.employee_contact_fields a.telephone-remove.remove_fields:eq(0)').remove();
	$('div.employee_contact_fields a.email-remove.remove_fields:eq(0)').remove();
	dynamic_fields.provinceSelected();
	dynamic_fields.cantonSelected();
	$('#employee_entity_attributes_addresses_attributes_0_province_id').change(dynamic_fields.provinceSelected);
	$('#employee_entity_attributes_addresses_attributes_0_canton_id').change(dynamic_fields.cantonSelected);	
	$('form').on('click', '.add_fields', dynamic_fields.addFields);	
	$('form').on('click', '.remove_fields', dynamic_fields.removeFields);
})