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

	var numberEmployees = $('#ms-deduction_employee_ids .ms-selection li.ms-selected').length;
    
	if(numberEmployees == 0) {
		general_functions.showMessage("warning", "Por favor selecione los empleados");
		return false;
	}

	// Validate Company
	if( $('#company').val() == "" ) {
		general_functions.showMessage("warning", "Por favor selecione una compañia");
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

  	$('#ms-deduction_employee_ids .ms-selection li.ms-selected').each(function() {
	    var id = $(this).attr('id').replace('-selection','');
	    employees.push(id);
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