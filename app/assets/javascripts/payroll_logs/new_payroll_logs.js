var pl = {};

$(jQuery(document).ready(function($) {
  /**************************************************************************************/
  /* Load Selectors */
  /**************************************************************************************/
  pl.current_employee       = '#products_items tbody tr:eq(0) td#td_employees';
  pl.current_cc             = '#products_items tbody tr:eq(0) td#td_cc';
  pl.current_task           = '#products_items tbody tr:eq(0) td#td_task';
  pl.current_cant_working   = '#products_items tbody tr:eq(0) td#td_time_worked';
  pl.current_performance    = '#products_items tbody tr:eq(0) td#td_performance';
  pl.current_payments_type  = '#products_items tbody tr:eq(0) td#td_payment_type';
  pl.key_code_tab = 9;
  pl.per_page = 5;

	/**************************************************************************************/
	/* Multi-Select */
	/**************************************************************************************/
	// Multi-Select: Employees list
	$('#payroll_logs_employee_ids').multiSelect({
    selectableHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;'  autocomplete='off' placeholder='Empleado...'>",
    selectionHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;' autocomplete='off' placeholder='Empleado...'>",
    afterInit: function(ms) {
      var that = this,
      $selectableSearch = that.$selectableUl.prev(),
      $selectionSearch = that.$selectionUl.prev(),
      selectableSearchString = '#'+that.$container.attr('id')+' .ms-elem-selectable:not(.ms-selected)',
      selectionSearchString = '#'+that.$container.attr('id')+' .ms-elem-selection.ms-selected';

      that.qs1 = $selectableSearch.quicksearch(selectableSearchString)
      .on('keydown', function(e) {
        if(e.which === 40) {
          that.$selectableUl.focus();
          return false;
        }
      });

      that.qs2 = $selectionSearch.quicksearch(selectionSearchString)
      .on('keydown', function(e) {
        if(e.which == 40) {
          that.$selectionUl.focus();
          return false;
        }
      });
    },
    afterSelect: function() {
      // this.qs1.cache();
      this.qs2.cache();
    },
    afterDeselect: function() {
      // this.qs1.cache();
      this.qs2.cache();
    }
	});
	
	// Multi-Select: Select All
	$('#emplotee_select_all').parents('label').click(function() {
		pl.employeeSelectAll();
	});

	$('#emplotee_select_all').next().click(function() {
		pl.employeeSelectAll();
	});

	// Multi-Select: Options
	$('input[name=select_method]').parents('label').click(function() {
		pl.showHideOptions($(this).find('input'));
  });

  $('input[name=select_method]').next().click(function() {
		pl.showHideOptions($(this).parent().find('input'));
  });

  // Multi-Select: Options Initial
  pl.showHideOptions($('#select_method_all'));

  // // Multi-Select: Change Department
  $('#departments_employees').change(function() {
		pl.filterEmployees("department", $(this).val());
	});

  // Multi-Select: Change Superiors
	$('#superiors_employees').change(function() {
		pl.filterEmployees("superior", $(this).val());
	});

	/**************************************************************************************/
	/* Multi-Select */
	/**************************************************************************************/

	// Date
	$('#payroll_log_payroll_date').datepicker({
    format: 'dd/mm/yyyy',
    autoclose: true,
    language: "es"
	});

  // Add new Row
  $('form').on('click', '.add_fields', pl.addFields);

}));