var numberPhoneFields = 1

function departmentSelected() {
  department_id = $('#employee_department_id').val();
  $('#employee_role_id').find('option').remove();
  $(roles).each(function() {
    if (this[0] == department_id) {
      $('#employee_role_id').append("<option value='" + this[2] + "'>" + this[1] + "</option>");
    } 
  });
}

function provinceSelected() {
  province_id = $('#employee_entity_attributes_addresses_attributes_0_province_id').val();
  $('#employee_entity_attributes_addresses_attributes_0_canton_id').find('option').remove();
	$('#employee_entity_attributes_addresses_attributes_0_district_id').find('option').remove();
  $(cantons).each(function() {
    if (this[0] == province_id) {
      $('#employee_entity_attributes_addresses_attributes_0_canton_id').append("<option value='" + this[2] + "'>" + this[1] + "</option>");
    } 
  });
}

function cantonSelected() {
  canton_id = $('#employee_entity_attributes_addresses_attributes_0_canton_id').val();
  $('#employee_entity_attributes_addresses_attributes_0_district_id').find('option').remove();
  $(district).each(function() {
    if (this[0] == canton_id) {
      $('#employee_entity_attributes_addresses_attributes_0_district_id').append("<option value='" + this[2] + "'>" + this[1] + "</option>");
    } 
  });
}

function addFields(e) {
	if (numberPhoneFields < 3) {
		var time = new Date().getTime();
		var regexp = new RegExp($(this).data('id'), 'g');
		$(this).before($(this).data('fields').replace(regexp, time));
		numberPhoneFields += 1;
		if (numberPhoneFields == 3) {
			$('a.add_fields').hide();
		};
	};
	e.preventDefault();
}

function removeFields(e) {
	if (numberPhoneFields > 1) {
		$(this).prev('input[type=hidden]').val(1);
		$(this).closest('.employee_telephone').hide();
		numberPhoneFields -= 1;
		if (numberPhoneFields < 3) {
			$('a.add_fields').show();
		};
	};
	e.preventDefault();
}

$(document).ready(function() {
	$('div.employee_telephone a.remove_fields').remove();
  departmentSelected();
	provinceSelected();
	cantonSelected();
  $('#employee_department_id').change(departmentSelected);
	$('#employee_entity_attributes_addresses_attributes_0_province_id').change(provinceSelected);
	$('#employee_entity_attributes_addresses_attributes_0_canton_id').change(cantonSelected);	
	$('form').on('click', '.add_fields', addFields);	
	$('form').on('click', '.remove_fields', removeFields);
})