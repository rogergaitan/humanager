reports_general_payroll = { }

$(document).ready(function() {
	
	$('#btn_create_pdf').on('click', function() {
		alert('pdf');
		reports_general_payroll.validate_data();
	});

	$('#btn_create_excel').on('click', function() {
		alert('exel');
		reports_general_payroll.validate_data();
	});

})

reports_general_payroll.validate_data = function() {
	
	// Validation
  	if( $('#payrolls_results input:checked').length === 0 ) {
    	$('div#message').html('<div class="alert alert-error">Por favor selecione una planilla</div>');
    	$('div.alert.alert-error').delay(4000).fadeOut();
    	return false;
	}

	var numberEmployees = $('div.employees-list.list-right input').length;
	var employeesChecked = $('div.employees-list.list-right input[type=checkbox]').is(':checked');
	var rowIsDisabled = $('#products_items tr:eq(1) td:first select').is(':disabled');
    
	if( (numberEmployees == 0 || employeesChecked == false) && (rowIsDisabled == false) ) {
		$('div#message').html('<div class="alert alert-error">Por favor selecione los empleados</div>');
		$('div.alert.alert-error').delay(4000).fadeOut();
		return false;
	}
};

reports_general_payroll.create_pdf = function() {

};

reports_general_payroll.create_exel = function() {

};