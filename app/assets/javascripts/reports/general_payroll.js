reports_general_payroll = { }

$(document).ready(function() {
	
	$('#btn_create_pdf').on('click', function() {
		reports_general_payroll.validate_data('pdf');
	});

	$('#btn_create_excel').on('click', function() {
		reports_general_payroll.validate_data('xml');
	});

})

reports_general_payroll.validate_data = function(format) {
	
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

	// Validate Company
	if( $('#company').val() == "" ) {
		$('div#message').html('<div class="alert alert-error">Por favor selecione una compañia </div>');
		$('div.alert.alert-error').delay(4000).fadeOut();
		return false;
	}

	reports_general_payroll.create_pdf_or_exel(format);
};

reports_general_payroll.create_pdf_or_exel = function(format) {

	var url = $('#show_reports_path').val();
  	var type = $('#type_report').val();
  	var company = $('#company').val();
  	var payroll_ids = [];
  	var employees = [];

  	$('#payrolls_results input:checked').each(function() {
  		payroll_ids.push($(this).val());
  	});

  	$('div.employees-list.list-right input[type=checkbox]:checked').each(function() {
		employees.push($(this).val());
  	});

  	if( format === 'pdf' ) {
  		url = url + '/' + payroll_ids[0] + '.pdf'
  	} else {
  		url = url + '/' + payroll_ids[0] + '.xls'
  	}

	window.open( url
				+ '?type=' + type
                + '&format=' + format
                + '&employees=' + employees
                + '&payroll_ids=' + payroll_ids
                + '&company=' + company
              );
};