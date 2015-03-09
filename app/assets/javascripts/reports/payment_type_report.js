payment_type_reports = {}

$(document).ready(function() {

  // Task
  $('#report_task_ids').multiSelect({
    selectableHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;'  autocomplete='off' placeholder='Filter entries...'>",
    selectionHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;' autocomplete='off' placeholder='Filter entries...'>",
    afterInit: function(ms){
      var that = this,
      $selectableSearch = that.$selectableUl.prev(),
      $selectionSearch = that.$selectionUl.prev(),
      selectableSearchString = '#'+that.$container.attr('id')+' .ms-elem-selectable:not(.ms-selected)',
      selectionSearchString = '#'+that.$container.attr('id')+' .ms-elem-selection.ms-selected';

      that.qs1 = $selectableSearch.quicksearch(selectableSearchString)
      .on('keydown', function(e){
        if(e.which === 40){
          that.$selectableUl.focus();
          return false;
        }
      });

      that.qs2 = $selectionSearch.quicksearch(selectionSearchString)
      .on('keydown', function(e){
        if (e.which == 40){
          that.$selectionUl.focus();
          return false;
        }
      });
    },
    afterSelect: function(){
      this.qs1.cache();
      this.qs2.cache();
    },
    afterDeselect: function(){
      this.qs1.cache();
      this.qs2.cache();
    }
  });
  
  // CC
  $('#report_cc_ids').multiSelect({
    selectableHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;'  autocomplete='off' placeholder='Filter entries...'>",
    selectionHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;' autocomplete='off' placeholder='Filter entries...'>",
    afterInit: function(ms){
      var that = this,
      $selectableSearch = that.$selectableUl.prev(),
      $selectionSearch = that.$selectionUl.prev(),
      selectableSearchString = '#'+that.$container.attr('id')+' .ms-elem-selectable:not(.ms-selected)',
      selectionSearchString = '#'+that.$container.attr('id')+' .ms-elem-selection.ms-selected';

      that.qs1 = $selectableSearch.quicksearch(selectableSearchString)
      .on('keydown', function(e){
        if(e.which === 40){
          that.$selectableUl.focus();
          return false;
        }
      });

      that.qs2 = $selectionSearch.quicksearch(selectionSearchString)
      .on('keydown', function(e){
        if (e.which == 40){
          that.$selectionUl.focus();
          return false;
        }
      });
    },
    afterSelect: function(){
      this.qs1.cache();
      this.qs2.cache();
    },
    afterDeselect: function(){
      this.qs1.cache();
      this.qs2.cache();
    }
  });

	// Button Create PDF
	$('#btn_create_pdf').on('click', function() {
		payment_type_reports.validate_data('pdf');
	});

	// Button Create XML
	$('#btn_create_xml').on('click', function() {
		payment_type_reports.validate_data('xml');
	});

});

payment_type_reports.create_pdf_or_exel = function(format) {

	var url = $('#show_reports_path').val();
	var type = $('#type_report').val();
	var payroll_ids = [],
	    employees = [],
	    tasks = [],
      cc = [];
  var orderBy = $('#order_by').val();
  var company = $('#company').val();

	$('#payrolls_results input:checked').each(function() {
		payroll_ids.push($(this).val());
	});

  $('#ms-deduction_employee_ids .ms-selection li.ms-selected').each(function() {
    employees.push($(this).attr('id').replace('-selection',''));
  });

  $('#ms-report_task_ids .ms-selection li.ms-selected').each(function() {
    tasks.push($(this).attr('id').replace('-selection',''));
  });
  
  $('#ms-report_cc_ids .ms-selection li.ms-selected').each(function() {
    cc.push($(this).attr('id').replace('-selection',''));
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
              + '&order=' + orderBy
              + '&tasks=' + tasks
              + '&cc=' + cc
              + '&company=' + company
            );
}

payment_type_reports.validate_data = function(format) {

	// Validation
  	if( $('#payrolls_results input:checked').length === 0 ) {
      general_functions.showMessage("warning", "Por favor selecione una planilla");
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

	payment_type_reports.create_pdf_or_exel(format);
}
