accrued_wages_dates = { }

$(document).ready(function() {

	accrued_wages_dates.message = $('div#message');
	accrued_wages_dates.start_date = $('#start_date');
	accrued_wages_dates.end_date = $('#end_date');

	
	$('#btn_create_pdf').on('click', function() {
		accrued_wages_dates.validate_data('pdf');
	});

	$('#btn_create_excel').on('click', function() {
		accrued_wages_dates.validate_data('xml');
	});

});

accrued_wages_dates.validate_data = function(format) {
	
	// Dates
	if( accrued_wages_dates.start_date.val() == "" || accrued_wages_dates.end_date.val() == "") {
		accrued_wages_dates.message.html('<div class="alert alert-error">Por favor selecione las fechas</div>');
		$('div.alert.alert-error').delay(4000).fadeOut();
		return false;
	}

	// Employees 
	var numberEmployees = $('div.employees-list.list-right input').length,
		employeesChecked = $('div.employees-list.list-right input[type=checkbox]').is(':checked'),
		rowIsDisabled = $('#products_items tr:eq(1) td:first select').is(':disabled');
    
	if( (numberEmployees == 0 || employeesChecked == false) && (rowIsDisabled == false) ) {
		accrued_wages_dates.message.html('<div class="alert alert-error">Por favor selecione los empleados</div>');
		$('div.alert.alert-error').delay(4000).fadeOut();
		return false;
	}

	// Company
	if( $('#company').val() == "" ) {
		accrued_wages_dates.message.html('<div class="alert alert-error">Por favor selecione una compañia </div>');
		$('div.alert.alert-error').delay(4000).fadeOut();
		return false;
	}

	accrued_wages_dates.create_pdf_or_exel(format);

}

accrued_wages_dates.create_pdf_or_exel = function(format) {

	var url = $('#show_reports_path').val(),
  		type = $('#type_report').val(),
  		company_id = $('#company').val(),
  		start_date = $('#start_date').val(),
  		end_date = $('#end_date').val(),
  		employee_ids = [];

  	$('div.employees-list.list-right input[type=checkbox]:checked').each(function() {
		employee_ids.push($(this).val());
  	});

  	if( format === 'pdf' ) {
  		url = url + '/accrued_wages_dates' + '.pdf'
  	} else {
  		url = url + '/accrued_wages_dates' + '.xls'
  	}

	window.open( url
				+ '?type=' + type
                + '&format=' + format
                + '&employee_ids=' + employee_ids
                + '&start_date=' + start_date
                + '&end_date=' + end_date                
                + '&company_id=' + company_id
              );
};