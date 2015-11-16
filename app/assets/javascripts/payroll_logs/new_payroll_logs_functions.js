
// Multi-Select: Select or deselect all Employees
pl.employeeSelectAll = function (argument) {
	var that = $('#payroll_logs_employee_ids');
	var array = Array('3-selectable');
	$('#emplotee_select_all').is(':checked') ? $(that).multiSelect('select_all', array) : $(that).multiSelect('deselect_all', array);
}

// Multi-Select: Show or Hide Options
pl.showHideOptions = function(selected) {
	
	switch($(selected).val()) {

		case 'all':
			// Hiden the boxes and checkbox filters
			$('#ms-payroll_logs_employee_ids').hide();
			$('#list_departments').hide();
			$('#list_superior').hide();
			$('#emplotee_select_all').parents('label').hide();
			// Filters set by default the "boss" and "department"
			$('#superiors_employees option:eq(0)').attr('selected','selected');
			$('#departments_employees option:eq(0)').attr('selected','selected');
			// pl.cleanEmployeeAlone();
		break;

		case 'boss':
			$('#ms-payroll_logs_employee_ids').show();
			$('#emplotee_select_all').parents('label').show();
			$('.ms-selection').css('margin-top', '-5.5%');
			$('#ms-payroll_logs_employee_ids').find('input:eq(0)').hide();
			$('#list_departments').hide();
			$('#list_superior').show();
			pl.filterEmployees("superior", $('#superiors_employees').val());
			$('#superiors_employees').removeAttr('disabled');
			// pl.cleanEmployeeAlone();
		break;

		case 'department':
			$('#ms-payroll_logs_employee_ids').show();
			$('#emplotee_select_all').parents('label').show();
			$('.ms-selection').css('margin-top', '-5.5%');
			$('#ms-payroll_logs_employee_ids').find('input:eq(0)').hide();
			$('#list_departments').show();
			$('#list_superior').hide();
			pl.filterEmployees("department", $('#departments_employees').val());
			$('#departments_employees').removeAttr('disabled');
			// pl.cleanEmployeeAlone();
		break;
	}
}

// Multi-Select: Filter the employees by superior or department
pl.filterEmployees = function(type, id) {
  
	id = id ? id : 0;

  $('#ms-payroll_logs_employee_ids .ms-selectable').find('li').each(function() {
    
    if(type === "all") {
      if(!$(this).hasClass('ms-selected')) {
        $(this).show();
      }
    }

    var searchType = 0;
    if(type === "superior") {
      searchType = $(this).data('sup') ? $(this).data('sup') : 0;
    }
	    
    if(type === "department") {
      searchType = $(this).data('dep') ? $(this).data('dep') : 0;
    }

    if(id != 0) {
      if( id == searchType ) {
        if(!$(this).hasClass('ms-selected')) {
          $(this).show();
        }
      } else {
        $(this).hide();
      }
    } else {
      if(!$(this).hasClass('ms-selected')) {
        $(this).show();
      }
    }

	});
}

pl.cleanEmployeeAlone = function() {
  		
	if( !$('#select_method_all').is(':checked') ) {
		$('#products_items tr:eq(1) td:eq(0) a').hide();
		$('#products_items tr:eq(1) td:eq(0) input').each(function() {
			$(this).val('');
			$(this).attr( "disabled", "disabled" );
		});
		$('#employee-box').css("display", "block");
		$('#filter-controls input:checkbox').css("display", "");
		$('#filter-controls input:checkbox').next().css("display", "");
	} else {
		$('#products_items tr:eq(1) td:eq(0) a').show();
		$('#products_items tr:eq(1) td:eq(0) input').each(function() {
			$(this).removeAttr( "disabled", "disabled" );
		});
		$('#employee-filter').css("display", "none");
		$('#employee-box').css("display", "none");
		$('#filter-controls input:checkbox').css("display", "none");
		$('#filter-controls input:checkbox').next().css("display", "none");
	}
}

// Add new Row
pl.addFields = function(e) {
	e.preventDefault();



	/**************************************************************************************/
	/* TEST */
	/**************************************************************************************/
	var time = new Date().getTime();
	var regexp = new RegExp($(this).data('id'), 'g');
	$('#products_items > tbody').prepend($(this).data('fields').replace(regexp, time));
	// Seach Employees
	pl.searchEmployeeByName();
	pl.searchEmployeeByCode();
	// Seach Costs Centers
	pl.searchCcByCode();
	pl.searchCcByName();
	// Seach Tasks
	pl.searchTaskByCode();
	pl.searchTaskByName();

	// pl.searchEmployeeByCode(); // Seach Employee by Code
	$(pl.current_employee).find('#search_code_employee').select2("open");



	// Time Validation
	// validation();

	// Valida si hay campos en blanco
	var timeWorked = $.trim($('#products_items tr:eq(1) input.time-worked').val()).length
	var numberRows = $('#products_items tr').length;
	var is_select_methol_all = false;

	if((timeWorked == 0 ) && numberRows > 1) {
		resources.PNotify('Planilla', 'Por favor complete los espacios en blanco', 'info');
		// e.preventDefault();
	} else {
		var numberEmployees = $('div.employees-list.list-right input').length;
		var employeesChecked = $('div.employees-list.list-right input[type=checkbox]').is(':checked');
		var rowIsDisabled = $('#products_items tr:eq(1) td:first select').is(':disabled');
		if (numberRows == 1) { rowIsDisabled = true; };

		// Valida si agrego Labor
		// var task = $('#products_items tr:eq(1)').find("input[id*='task_id']").val();
		// if( task == "" ) {
		// 	resources.PNotify('Labor', 'Por favor agrege una Labor', 'info');
		// 	return false;
		// }
		
		// Valida si agrego CC
		// var cc = $('#products_items tr:eq(1)').find("input[id*='_costs_center_id']").val();
		// if( cc == "" ) {
		// 	resources.PNotify('Centro de Costo', 'Por favor agrege un Centro de Costo', 'info');
		// 	return false;
		// }

		// Valida si "Todos" esta seleccionado
		// if( $('#select_method_all').is(':checked') ) {
		// 	numberEmployees = 1;
		// 	employeesChecked = true;
		// 	is_select_methol_all = true;
		// 	// Validar Empleado
		// 	if( $('#products_items tr:eq(1) td:eq('+payroll_logs.employee_td_eq+') input:eq(1)').val() === "" ) {
		// 		resources.PNotify('Empleado', 'Debe añadir al menos un empleado', 'info');
		// 		return false;	
		// 	}
		// }

		// Valida si se ha seleccionado al menos un empleado antes de agregar una línea nueva
		if ((numberEmployees == 0 || employeesChecked == false) && (rowIsDisabled == false) && (numberRows > 1)) {
			resources.PNotify('Empleado', 'Debe añadir al menos un empleado', 'info');
			return false;
		} else {
			// Validate Duplicate Records
			if( !rowIsDisabled ) {
				var name = $('#products_items tr:eq(1) td:eq('+payroll_logs.task_td_eq+') input:hidden').attr('name');
				var num = name.match(/\d/g);
				num = num.join('');

				

				// Set Date
				$('#payroll_log_payroll_histories_attributes_' + num + '_payroll_date').val($('#payroll_log_payroll_date').val());
				payroll_logs.setTotal(num);
				result = payroll_logs.validateEmployeeTask(num,is_select_methol_all);
				if( result.status ) {
					var message = 'Existe al menos un empleado con datos duplicados ['+result.username+']';
					resources.PNotify('Planilla', message, 'info');
					return false;
				}
			}
		}

		// $('#products_items tr input, select').attr('disabled', true);
		// Add new Row
		var time = new Date().getTime();
		var regexp = new RegExp($(this).data('id'), 'g');
		$('#products_items > tbody').prepend($(this).data('fields').replace(regexp, time));

		populateTasks(
			$('#load_cc_tasks_path').val(), 
			$('#products_items .items_purchase_orders_form').first().find('input.cc-filter-id:eq(0)').attr('id')
		);
		populateCentroCostos(
			$('#load_cc_centro_de_costos_path').val(), 
			$('#products_items <div class="items_pur"></div>chase_orders_form').first().find('input.cc-filter:eq(1)').attr('id'), 
			$('#products_items .items_purchase_orders_form').first().find('input.cc-filter-id:eq(2)').attr('id')
		);
		populateEmployees(
			$('#load_em_employees_path').val(), 
			$('#employee_code').attr('id')
		);
		$('#products_items').find('label').remove();
		saveEmployees(rowIsDisabled, is_select_methol_all);
		payroll_logs.reloadSelectorsEvents();
		payroll_logs.cleanEmployeeAlone();
		// $('#search_code_employee').focus();
		e.preventDefault();
	}

}

/**************************************************************************************/
/* Seach Employee By Code */
/**************************************************************************************/
pl.searchEmployeeByCode = function() {
	$(pl.current_employee).find('#search_code_employee').select2({
		placeholder: "#",
		minimumInputLength: 1,
		width: '100%',
		ajax: {
			url: $('#search_employee_payroll_logs_path').val(),
			dataType: 'json',
			quietMillis: 100,
			// Page is the one-based page number tracked by Select2
			data: function (term, page) { 
				return {
					employee_code: term, // Search Term
					per_page: pl.per_page, // Page Size
					page: page // Page Number
				};
			},
			results: function (data, page) {
				// Whether or not there are more results available
				var more = (page * pl.per_page) < data.total;
				// Notice we return the value of more so Select2 knows if more results can be loaded
				return {results: data.entries, more: more};
			}
		},
		formatResult: pl.employeeCodeFormatResult,
		formatSelection: pl.employeeCodeFormatSelection,
		dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
		escapeMarkup: function (m) { return m; } // we do not want to escape markup since we are displaying html in results
	});
}

pl.employeeCodeFormatResult = function(employee) {
	var markup = "<table><tr>";
	markup += "<td><div>" + employee.number_employee + " - " + employee.name + " " + employee.surname + "</div>";
	markup += "</td></tr></table>";
	return markup;
}

pl.employeeCodeFormatSelection = function(employee) {
	// console.log(employee.id);
	return employee.number_employee;
}
/**************************************************************************************/
/* Seach Employee By Name */
/**************************************************************************************/
pl.searchEmployeeByName = function() {
	$(pl.current_employee).find('#search_name_employee').select2({
		placeholder: "Nombre",
		minimumInputLength: 1,
		width: '100%',
		cache: true,
		ajax: {
			url: $('#search_employee_payroll_logs_path').val(),
			dataType: 'json',
			quietMillis: 100,
			// Page is the one-based page number tracked by Select2
			data: function (term, page) { 
				return {
					employee_name: term, // Search Term
					per_page: pl.per_page, // Page Size
					page: page // Page Number
				};
			},
			results: function (data, page) {
				// Whether or not there are more results available
				var more = (page * pl.per_page) < data.total;
				// Notice we return the value of more so Select2 knows if more results can be loaded
				return {results: data.entries, more: more};
			}
		},
		formatResult: pl.employeeNameFormatResult,
		formatSelection: pl.employeeNameFormatSelection,
		dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
		escapeMarkup: function (m) { return m; } // we do not want to escape markup since we are displaying html in results
	});
}

pl.employeeNameFormatResult = function(employee) {
	var markup = "<table><tr>";
	markup += "<td><div>" + employee.name + " " + employee.surname + "</div>";
	markup += "</td></tr></table>";
	return markup;
}

pl.employeeNameFormatSelection = function(employee) {
	// console.log(employee.id);
	return employee.name + " " + employee.surname;
}

/**************************************************************************************/
/* Seach Costs Center By Code */
/**************************************************************************************/
pl.searchCcByCode = function() {
	$(pl.current_cc).find('#search_code_cc').select2({
		placeholder: "#",
		minimumInputLength: 1,
		width: '100%',
		ajax: {
			url: $('#search_cost_payroll_logs_path').val(),
			dataType: 'json',
			quietMillis: 100,
			// Page is the one-based page number tracked by Select2
			data: function (term, page) { 
				return {
					cc_code: term, // Search Term
					per_page: pl.per_page, // Page Size
					page: page // Page Number
				};
			},
			results: function (data, page) {
				// Whether or not there are more results available
				var more = (page * pl.per_page) < data.total;
				// Notice we return the value of more so Select2 knows if more results can be loaded
				return {results: data.entries, more: more};
			}
		},
		formatResult: pl.ccCodeFormatResult,
		formatSelection: pl.ccCodeFormatSelection,
		dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
		escapeMarkup: function (m) { return m; } // we do not want to escape markup since we are displaying html in results
	});
}

pl.ccCodeFormatResult = function(cc) {
	var markup = "<table><tr>";
	markup += "<td><div>" + cc.icost_center + " - " + cc.name_cc + "</div>";
	markup += "</td></tr></table>";
	return markup;
}

pl.ccCodeFormatSelection = function(cc) {
	// console.log(employee.id);
	return cc.icost_center;
}

/**************************************************************************************/
/* Seach Costs Center By Name */
/**************************************************************************************/
pl.searchCcByName = function() {
	$(pl.current_cc).find('#search_name_cc').select2({
		placeholder: "Nombre",
		minimumInputLength: 1,
		width: '100%',
		ajax: {
			url: $('#search_cost_payroll_logs_path').val(),
			dataType: 'json',
			quietMillis: 100,
			// Page is the one-based page number tracked by Select2
			data: function (term, page) { 
				return {
					cc_name: term, // Search Term
					per_page: pl.per_page, // Page Size
					page: page // Page Number
				};
			},
			results: function (data, page) {
				// Whether or not there are more results available
				var more = (page * pl.per_page) < data.total;
				// Notice we return the value of more so Select2 knows if more results can be loaded
				return {results: data.entries, more: more};
			}
		},
		formatResult: pl.ccNameFormatResult,
		formatSelection: pl.ccNameFormatSelection,
		dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
		escapeMarkup: function (m) { return m; } // we do not want to escape markup since we are displaying html in results
	});
}

pl.ccNameFormatResult = function(cc) {
	var markup = "<table><tr>";
	markup += "<td><div>" + cc.name_cc + "</div>";
	markup += "</td></tr></table>";
	return markup;
}

pl.ccNameFormatSelection = function(cc) {
	// console.log(employee.id);
	return cc.name_cc;
}

/**************************************************************************************/
/* Seach Task By Code */
/**************************************************************************************/
pl.searchTaskByCode = function() {
	$(pl.current_task).find('#search_code_task').select2({
		placeholder: "#",
		minimumInputLength: 1,
		width: '100%',
		ajax: {
			url: $('#search_task_payroll_logs_path').val(),
			cache: "true",
			dataType: 'json',
			quietMillis: 100,
			// Page is the one-based page number tracked by Select2
			data: function (term, page) { 
				return {
					task_code: term, // Search Term
					per_page: pl.per_page, // Page Size
					page: page // Page Number
				};
			},
			results: function (data, page) {
				// Whether or not there are more results available
				var more = (page * pl.per_page) < data.total;
				// Notice we return the value of more so Select2 knows if more results can be loaded
				return {results: data.entries, more: more};
			}
		},
		formatResult: pl.taskCodeFormatResult,
		formatSelection: pl.taskCodeFormatSelection,
		dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
		escapeMarkup: function (m) { return m; } // we do not want to escape markup since we are displaying html in results
	});
}

pl.taskCodeFormatResult = function(task) {
	var markup = "<table><tr>";
	markup += "<td><div>" + task.itask + " - " + task.ntask + "</div>";
	markup += "</td></tr></table>";
	return markup;
}

pl.taskCodeFormatSelection = function(task) {
	// console.log(employee.id);
	return task.itask;
}

/**************************************************************************************/
/* Seach Task By name */
/**************************************************************************************/
pl.searchTaskByName = function() {
	$(pl.current_task).find('#search_name_task').select2({
		placeholder: "Nombre",
		minimumInputLength: 1,
		width: '100%',
		ajax: {
			url: $('#search_task_payroll_logs_path').val(),
			cache: "true",
			dataType: 'json',
			quietMillis: 100,
			// Page is the one-based page number tracked by Select2
			data: function (term, page) { 
				return {
					task_name: term, // Search Term
					per_page: pl.per_page, // Page Size
					page: page // Page Number
				};
			},
			results: function (data, page) {
				// Whether or not there are more results available
				var more = (page * pl.per_page) < data.total;
				// Notice we return the value of more so Select2 knows if more results can be loaded
				return {results: data.entries, more: more};
			}
		},
		formatResult: pl.taskNameFormatResult,
		formatSelection: pl.taskNameFormatSelection,
		dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
		escapeMarkup: function (m) { return m; } // we do not want to escape markup since we are displaying html in results
	});
}

pl.taskNameFormatResult = function(task) {
	var markup = "<table><tr>";
	markup += "<td><div>" + task.ntask + "</div>";
	markup += "</td></tr></table>";
	return markup;
}

pl.taskNameFormatSelection = function(task) {
	// console.log(employee.id);
	return task.ntask;
}
