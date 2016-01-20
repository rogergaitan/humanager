// Multi-Select: Select or deselect all Employees
pl.employeeSelectAll = function() {
	var that = $('#payroll_logs_employee_ids');
	var select = Array();
	var deselect = Array();

	$('#ms-payroll_logs_employee_ids div.ms-selectable li:visible').each(function () {
		select.push( $(this).attr("id").split('-', 1)[0] );
	});

	$('#ms-payroll_logs_employee_ids div.ms-selection li:visible').each(function () {
		deselect.push( $(this).attr("id").split('-', 1)[0] );
	});

	$('#emplotee_select_all').is(':checked') ? $(that).multiSelect('select', select) : $(that).multiSelect('deselect', deselect);
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
			pl.cleanEmployeeAlone();
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
			pl.cleanEmployeeAlone();
		break;

		case 'department':
			$('#ms-payroll_logs_employee_ids').show();
			$('#emplotee_select_all').parents('label').show();
			$('.ms-selection').css('margin-top', '-5.5%');
			$('#ms-payroll_logs_employee_ids').find('input:eq(0)').hide();
			$('#list_departments').show();
			$('#list_superior').hide();
			pl.filterEmployees('department', $('#departments_employees').val());
			$('#departments_employees').removeAttr('disabled');
			pl.cleanEmployeeAlone();
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
  		
	if( $('#select_method_all').is(':checked') ) {
		// Deselect all employees
		$('#payroll_logs_employee_ids').multiSelect('deselect_all');
		// Show simple employee in the line Code/Name
		$(pl.current_employee).find('#s2id_search_code_employee').removeClass('a-not-active');
		$(pl.current_employee).find('#s2id_search_name_employee').removeClass('a-not-active');
	} else {
		// Clear and Hide simple employee in the line
		// Set Code
		var that = $(pl.current_employee).find('a:eq(0)');
		$(that).find('span:eq(0)').html('#');
 		$(that).addClass('select2-default');
 		$(pl.current_employee).find('#s2id_search_code_employee').addClass('a-not-active');
 		// Set Name
 		that = $(pl.current_employee).find('a:eq(1)');
 		$(that).find('span:eq(0)').html('Nombre');
		$(that).addClass('select2-default');
		$(pl.current_employee).find('#s2id_search_name_employee').addClass('a-not-active');
		// Code (ID)
		$(pl.current_employee).find('#employee_code').val('');
	}
}

// Add new Row
pl.addFields = function(e) {
	e.preventDefault();
	// Check Time Session
	pl.UpdateTime();
	var numberRows = $('#products_items tbody tr').length;
	var rowIsDisabled = $(pl.current_payments_type).find('select[id*=_payment_type_id]').is(':disabled');
	var dRecords = Object();
	var newRow = true;
	var currentEmployees = $(pl.current_save_employees).find('input').length;

	if( numberRows > 0 && rowIsDisabled == false && currentEmployees == 0 ) {
		// Validate Employee
		if( $('#select_method_all').is(':checked') ) {
			var oneEmployee = $(pl.current_employee).find('#employee_code').val();
			if( oneEmployee == '' ) {
				resources.PNotify('Planilla', pl.messages.employee_not_found , 'info');
				return false;
			}
		} else {
			var listEmployees = $('#payroll_logs_employee_ids').val(); // Array[] or Null
			if( listEmployees == null ) {
				resources.PNotify('Planilla', pl.messages.employees_not_found , 'info');
				return false;
			}	
		}

		// Validate CC
		var cc = $(pl.current_cc).find('input:hidden[id*=_costs_center_id]').val();
		if( cc == "" ) {
			resources.PNotify('Planilla', pl.messages.cc_not_found , 'info');
			return false;
		}

		// Validate Tasks
		var task = $(pl.current_task).find('input:hidden[id*=_task_id]').val();
		if( task == "" ) {
			resources.PNotify('Planilla', pl.messages.task_not_found , 'info');
			return false;
		}

		// Validate Cant. Working
		var timeWorked = $(pl.current_cant_working).find('input[id*=_time_worked]').val();
		if( timeWorked == "" ) {
			resources.PNotify('Planilla', pl.messages.cant_working_not_found , 'info');
			return false;
		}

		timeWorked = parseInt(timeWorked);
		if( timeWorked <= 0 ) {
			resources.PNotify('Planilla', pl.messages.cant_working_greater_zero , 'info');
			return false;
		}

		// Validate Performance
		var performance = $(pl.current_performance).find('input[id*=_performance]').val();
		if( performance != "" && typeof performance != 'undefined' ) {
			performance = parseInt(performance);
			if( isNaN(performance) ) {
				resources.PNotify('Planilla', pl.messages.performance_wrong_format , 'info');
				return false;
			}
			
			if( !(performance > 0 || performance <= 99.99) ) {
				resources.PNotify('Planilla', pl.messages.performance_range , 'info');
				return false;
			}
		}

		// Validate Date
		var date = $('#payroll_log_payroll_date').val();
		if( date == "" ) {
			resources.PNotify('Planilla', pl.messages.date_not_found , 'info');
			return false;
		}

		// Set Date
		$(pl.current_payments_type).find('input[id*=_payroll_date]').val(date);

		// Validate Duplicate Records
		dRecords = pl.validateDuplicateRecords();
	}

	if( dRecords.hasOwnProperty('employeesAdded') ) {

		if( dRecords.employeesAdded.length == 0 ) {
			newRow = false;
		} else {
			// Disabled Current Row
			pl.disableRow();
			// Add Hidden Employee to Current Row
			pl.addHiddenEmployees(dRecords.employeesAdded);
			// Detail list
			pl.addDetailsList();
		}

		if(dRecords.employeesRemoved.length > 0) {
			var mjs = pl.messages.employees_duplicated;
			$.each(dRecords.employeesRemoved, function(key, obj) {
				mjs += obj.name + " " + obj.surname + " ";
			});
			resources.PNotify('Planilla', mjs , 'info');
			return false;
		}
	}

	if(newRow) {
		// Add new Row
		var time = new Date().getTime();
		var regexp = new RegExp($(this).data('id'), 'g');
		$('#products_items > tbody').prepend($(this).data('fields').replace(regexp, time));
		// Seach Employees
		pl.searchEmployeeByCode();
		pl.searchEmployeeByName();
		// Seach Costs Centers
		pl.searchCcByCode();
		pl.searchCcByName();
		// Seach Tasks
		pl.searchTaskByCode();
		pl.searchTaskByName();
		$(pl.current_employee).find('#search_code_employee').select2("open");
		pl.checkPerformance();
	}
}

// Disable the Current Row
pl.disableRow = function() {
	// Employees
	$(pl.current_employee).find('#s2id_search_code_employee').addClass('a-not-active');
	$(pl.current_employee).find('#s2id_search_name_employee').addClass('a-not-active');
	// CC
	$(pl.current_cc).find('#s2id_search_code_cc').addClass('a-not-active');
	$(pl.current_cc).find('#s2id_search_name_cc').addClass('a-not-active');
	// Tasks
	$(pl.current_task).find('#s2id_search_code_task').addClass('a-not-active');
	$(pl.current_task).find('#s2id_search_name_task').addClass('a-not-active');
	// Cant Working
	$(pl.current_cant_working).find('input[id*=_time_worked]').prop('readonly', true);
	$(pl.current_cant_working).find('input[id*=_time_worked]').prop('tabindex', -1);
	// Performance
	$(pl.current_performance).find('input[id*=_performance]').prop('readonly', true);
	$(pl.current_performance).find('input[id*=_performance]').prop('tabindex', -1);
	// Payments Type
	$(pl.current_payments_type).find('select[id*=_payment_type_id]').parent('div').addClass('a-not-active');
	$(pl.current_payments_type).find('select[id*=_payment_type_id]').prop('tabindex', -1);
}

// Hidden Employees
pl.addHiddenEmployees = function(employeesAdded) {
	var identificador = pl.getIdentificador();
	$.each(employeesAdded, function(key, id) {
		var name = 'payroll_log[payroll_histories_attributes]['+ identificador +'][employee_ids][]';
		$(pl.current_save_employees).append('<input type="hidden" name="'+ name +'" value="'+ id +'" >');
	});
}

pl.UpdateTime = function() {
	var modelName = $('form:eq(0)').data('modelName');
  var referenceId = $('form:eq(0)').data('referenceId');
  resources.updateValidation(modelName, referenceId);
}

// Check Validate Records
pl.validateDuplicateRecords = function() {
	// Get History Information
	var history = pl.getSessionStorage(pl.search_types.history);
	// Temporal Data
	var tmpData = pl.getTemporalData();
	// Employees Removed
	var er = Array();

	if(history != null) {
		$.each( history.employees, function( key, clsEmployee ) {

			var index = $.inArray( clsEmployee.id.toString(), tmpData.employees);

			if (index > -1) { // (-1) cuando no lo encuentra o retorna el [index]
				$.each(clsEmployee.data, function(k, dataStructure) {
					// Check Task, Payment Type and Date
					var tIdCC = tmpData.data.cc.id == dataStructure.cc.id;
					var tIdTaks = tmpData.data.type_payment == dataStructure.type_payment;
					var tDate = tmpData.data.date == dataStructure.date;

					if(tIdCC && tIdTaks && tDate) {
						er.push(pl.findEmployeeById(clsEmployee.id));
						tmpData.employees.splice([index], 1);
						return false;
					}
				});
			}
		});
	}

	if( tmpData.employees.length > 0 ) {
		// Set Total
		$(pl.current_payments_type).find('input:hidden[id*=_total]').val(tmpData.data.subtotal);
		pl.addEmployees(tmpData);
	}

	return {
		employeesRemoved: er,
		employeesAdded: tmpData.employees
	}
}

pl.addEmployees = function(tmpData) {
	
	var history = pl.getSessionStorage(pl.search_types.history);
	if(history == null) {
		history = new pl.PayrollHistories();
	}
		
	$.each(tmpData.employees, function (key, id) {
		var add = true;
		$.each(history.employees, function (k, clsEmployee) {
			if(id == clsEmployee.id) {
				clsEmployee.data.push(tmpData.data);
				clsEmployee.add.push(tmpData.data.identification);
				add = false;
				return false;
			}
		});

		if(add) {
			var employee = new pl.Employee();
			var e = pl.findEmployeeById(id);
			employee.id = e.id;
			employee.name = e.name + " " + e.surname;
			employee.data.push(tmpData.data);
			employee.add.push(tmpData.data.identification);
			history.employees.push(employee);
		}
	});

	pl.setSessionStorage(pl.search_types.history, history);
}

pl.removeEmployee = function(employee_id, identificador) {
	var objHistory = pl.getSessionStorage(pl.search_types.history);

	$.each(objHistory.employees, function (key, clsEmployee) {

		if(clsEmployee.id == employee_id) {

			var index = null;
			$.each(clsEmployee.data, function(k, dta) {
				if(dta.identification == identificador) {
					index = k;
					return false;
				}
			});

			if(index != null) {
				// Set Total all Row
				var that = $('#total_' + employee_id + ' td:eq(1)');
				var prv = $(that).html().replace(',', '');
				var total = parseFloat(prv) -	parseFloat(clsEmployee.data[index].subtotal);
				$(that).html(resources.prettyNumber(total));
				pl.changeAccumulated(pl.employee_options.remove, clsEmployee.data[index].subtotal);

				// Remove obj
				clsEmployee.data.splice([index], 1); // Remove
				return false;
			}
		}
	});
	pl.setSessionStorage(pl.search_types.history, objHistory);
}

// Get Temporal Data
pl.getTemporalData = function() {
	var tmpData = new pl.DataStructure();
	tmpData.identification = pl.getIdentificador();
	tmpData.type_payment = $(pl.current_payments_type).find('select[id*=_payment_type_id] option:selected').text();
	tmpData.type_payment_factor = $(pl.current_payments_type).find('select[id*=_payment_type_id] option:selected').data('factor');
	tmpData.time_worked = $(pl.current_cant_working).find('input[id*=_time_worked]').val();
	tmpData.performance = $(pl.current_performance).find('input[id*=_performance]').val();
	tmpData.date = $('#payroll_log_payroll_date').val();
	// CC
	tmpData.cc = pl.findCcById($(pl.current_cc).find('input:hidden[id*=_costs_center_id]').val());
	// Taks
	tmpData.task = pl.findTaskById($(pl.current_task).find('input:hidden[id*=_task_id]').val());

	// List Employees
	var arrayEmployees = Array();
	if( $('#select_method_all').is(':checked') ) {
		arrayEmployees.push($(pl.current_employee).find('#employee_code').val());
	} else {
		arrayEmployees = $('#payroll_logs_employee_ids').val(); // Array[] or Null
	}

	tmpData.subtotal = pl.setSubTotalByRow(tmpData);

	return {
		employees: arrayEmployees,
		data: tmpData
	}
}

pl.setSubTotalByRow = function(tmpData) {
	var cost = parseFloat(tmpData.task.mlaborcost);
	var hours = parseFloat(tmpData.time_worked);
	var payment = parseFloat(tmpData.type_payment_factor);
	return cost*hours*payment;
}

// Get Identificador for the current row
pl.getIdentificador = function() {
	return $(pl.current_task).find('input:hidden[id*=_task_id]').attr('name').match(/\d/g).join('');
}

// Set session Storage
pl.setSessionStorage = function(key, object) {
	sessionStorage.setItem(key, JSON.stringify(object));
}

// Get session Storage
pl.getSessionStorage = function(key) {
	return JSON.parse(sessionStorage.getItem(key));
}

// Clear session Storage
pl.clearSessionStorage = function() {
	sessionStorage.clear();
}

// Find CC by ID
pl.findCcById = function(id) {
	var cc = pl.getSessionStorage(pl.search_types.cc);
	return pl.seach(id, cc);
}

// Find Taks by ID
pl.findTaskById = function(id) {
	var tasks = pl.getSessionStorage(pl.search_types.tasks);
	return pl.seach(id, tasks);
}

// Find Employee by ID
pl.findEmployeeById = function(id) {
	var employee = pl.getSessionStorage(pl.search_types.employees);
	return pl.seach(id, employee);
}

// Seach Function
pl.seach = function(id, array) {
	var result = null;
	$.each( array, function( key, obj ) {
		if(obj.id == id) {
			result = obj;
			return false;
		}
	});
	return result;
}

pl.addDetailsList = function() {
	var objHistory = pl.getSessionStorage(pl.search_types.history);

	$.each(objHistory.employees, function(k, clsEmployee) {
		if(clsEmployee.add.length > 0) {

			$.each(clsEmployee.data, function(key, dta) {

				var index = $.inArray( dta.identification, clsEmployee.add);
				if(index > -1) { // (-1) cuando no lo encuentra o retorna el [index]
					
					if(!$('#employee_table_' + clsEmployee.id).length) {
						pl.addNewSection(clsEmployee.id, clsEmployee.name);
					}
					pl.addNewColumn(clsEmployee.id, dta);
					// return false;
					clsEmployee.add.splice([index], 1); // Remove
				}
			});
		}
	});

	pl.setSessionStorage(pl.search_types.history, objHistory);
}

pl.addNewSection = function(employee_id, name) {
	var total = $('#accordion div.panel.accordion-item').length + 1;
	var thead = '';

	var colspan = pl.theadList.length - 2;
	$.each(pl.theadList, function( index, data ) { thead += '<td>' + data + '</td>'; });

	var data = '<div class="panel accordion-item">' +
		'<a class="accordion-title collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapsea' + total + '" aria-expanded="false">' +
			'<h2>' + name + '</h2></a>' +
		'<div id="collapsea' + total + '" class="collapse" aria-expanded="false" style="height: 0px;">' +
			'<div class="accordion-body">' +
				'<table class="table table-hover table-bordered table-striped" id="employee_table_' + employee_id + '">' +
					thead + '<tbody>' +
						'<tr class="employee_count" id="total_' + employee_id + '">' +
							'<td colspan="' + colspan + '" class="align_right">Total:</td>' +
							'<td colspan="2">00.00</td>' +
		'</tr></tbody></table></div></div></div>';

	$('#accordion').append(data);
}

pl.addNewColumn = function(employee_id, data) {
	var filterData = Array();
	filterData.push(data.date); // Date
	filterData.push(data.task.itask); // Task - Code
	filterData.push(data.task.ntask); // Task
	filterData.push(data.task.mlaborcost); // Task - Cost
	filterData.push(data.task.nunidad); // Task - Unit
	filterData.push(data.time_worked); // Quantity
	filterData.push(data.cc.icost_center); // CC - Code
	filterData.push(data.cc.name_cc); // CC
	filterData.push(data.performance); // Performance
	filterData.push(data.task.unit_performance); // Performance - Unit
	filterData.push(data.type_payment); // Payment Type
	filterData.push(resources.prettyNumber(data.subtotal)); // Total per row

	pl.changeAccumulated(pl.employee_options.add, data.subtotal);

	var tds = '';
	$.each(filterData, function(key, value) { tds += '<td>' + value + '</td>'; });

	// Set Total all rows
	var that = $('#total_' + employee_id + ' td:eq(1)');
	var prv = $(that).html().replace(',', '');
	var total = parseFloat(prv) +	parseFloat(data.subtotal);

	$(that).html(resources.prettyNumber(total));
	
	var tr = '<tr id="tr_' + data.identification + '_' + employee_id +
		'" class="alert alert-dismissable alert-info">' + tds + '<td>' +
			'<button type="button" class="btn btn-xs btn-danger-alt"><i class="fa fa-trash-o"></i></button>' +
			'<input type="hidden" name="identificador" id="payroll_history_id" value="' + data.identification + '"/>' +
			'<input type="hidden" id="employee_id" value="' + employee_id + '"/>' +
			'<input type="hidden" id="new" value="true"/></td></tr>';

	$('#employee_table_' + employee_id + ' #total_' + employee_id).before(tr);
}

pl.multiSelectGetEmployees = function(ids) {
	if(ids.length > 0) {
		$.ajax({
	    type: "GET",
	    url: $(get_employees_payroll_logs_path).val(),
	    dataType: "json",
	    data: {
	    	employee_ids: JSON.stringify(ids)
	    },
	    success: function(employees) {
	    	$.each(employees, function(key, employee) {
	    		pl.saveSearchSessionStorage(pl.search_types.employees, employee);
	    	});
	    }
	  });
	}
}

pl.changeAccumulated = function(option, total) {
	var tmpHistory =  pl.getSessionStorage(pl.search_types.history);
	var ac = $('#payroll_total').html().replace(',', '');
 	ac = parseFloat(ac);
 	var newTotal = 0;

 	if(option == pl.employee_options.remove) {
 		newTotal = ac - total;
 	}

 	if(option == pl.employee_options.add) {
 		newTotal = ac + total;
 	}

 	$('#payroll_total').html(resources.prettyNumber(newTotal));
 	$('#employee_counter').html(tmpHistory.employees.length);
}

pl.checkPerformance = function () {

	var checked = $('#perf_is_simple').is(':checked');

	if( $(pl.current_performance).length === 1 ) {
		var value = parseInt($('#products_items input[id*=_time_worked]').val());
		var currentPerformance = $(pl.current_performance).find('input[id*=_performance]');

	  if(value == 0 || value < 0 || isNaN(value) || !checked) {
	    $(currentPerformance).prop("readonly", true);
	    $(currentPerformance).val('');
	  } else {
	    $(currentPerformance).prop("readonly", false);
	  }
	}
	pl.showHideCustomSearch(checked);
}

pl.showHideCustomSearch = function(checked) {
	if( checked ) {
		$('#custom_performance_search').hide();
    // remove data inputs
    $('#group_id_task').val('');
    $('#group_performance').val('');
    $('#s2id_group_search_code_task').find('span:eq(0)').html('#');
    $('#s2id_group_search_name_task').find('span:eq(0)').html('Nombre');
	} else {
		$('#custom_performance_search').show();
	}
}

pl.applyGroupPerformance = function (newPerformance, idTask, date) {
	
	var history = pl.getSessionStorage(pl.search_types.history);
	var serverEmployeeIds = Array();
	var localEmployee = Array();
	var count = 0;
	var split = date.split('/'); //DD/MM/YYYY
	var tDate = new Date(split[2], split[1] - 1, split[0]); //Y M D 
	var timestamp = tDate.getTime();

	if(history != null) {
		$.each( history.employees, function( key, clsEmployee ) {
			$.each(clsEmployee.data, function(k, dataStructure) {

				split = dataStructure.date.split('/'); //DD/MM/YYYY
				var tDate2 = new Date(split[2], split[1] - 1, split[0]); //Y M D 
				var timestamp2 = tDate2.getTime();

				if( timestamp == timestamp2 ) {
					if( parseInt(dataStructure.task.id) === parseInt(idTask) ) {
						count++;
						
						if(dataStructure.old) {
							serverEmployeeIds.push(dataStructure.identification);
						}

						var obj = Array();
						obj['identification'] = dataStructure.identification;
						obj['employee_id'] = clsEmployee.id;
						obj['old'] = dataStructure.old;
						localEmployee.push(obj);
					}
				}
			});
		});
	}

	if(count == 0) {
		resources.PNotify('Planilla', pl.messages.perf_not_found, 'info');
		return false;
	}

	newPerformance = newPerformance / count;

	if(serverEmployeeIds.length > 0) {
		pl.saveCustomPerformance(serverEmployeeIds, newPerformance);
	}

	if(localEmployee.length > 0) {
		pl.changeHtmlPerformance(localEmployee, newPerformance);
	}

	// Changes Applied and Clear inputs
	resources.PNotify('Planilla', pl.messages.changes_applied + count + ' empleados.', 'info');
	// newPerformance
	$('#group_performance').val('');
  // idTask
  $('#group_id_task').val('');
  // Name
  $('#s2id_group_search_name_task').find('span:eq(0)').html('Nombre');
  // Code
	$('#s2id_group_search_code_task').find('span:eq(0)').html('#');
	


}

pl.saveCustomPerformance = function(ids, performance) {
	var custom = pl.getSessionStorage(pl.search_types.custom);
	if(custom == null) { custom = {}; }
	
	$.each(ids, function(key, id) {
		var included = false;

		$.each(custom, function(key, array) {
			if( key === id ) {
				array = {'performance' : performance};
				included = true;
				return false;
			}
		});

		if(!included) {
			custom[id] = {'performance' : performance};
		}
	});

	pl.setSessionStorage(pl.search_types.custom, custom);
}

pl.ajaxUpdatePerformance = function() {
	var dta = pl.getSessionStorage(pl.search_types.custom);

	if(dta != null) {
		$.ajax({
			type: "POST",
			url: '/payroll_logs/set_custom_update',
			dataType: "json",
			data: {
				"data": dta
			},
			success: function(response) {
				$("form").trigger( "submit" );
			},
			error: function() {
				resources.PNotify('Planilla', 'ERROR al Actualizar' , 'info');
			}
		});
	} else {
		$("form").trigger( "submit" );
	}	
}

pl.changeHtmlPerformance = function(localEmployee, newPerformance) {

	$.each(localEmployee, function(k, d) {
		if(d['old']) {
			// Only change HTML in the datail table
			$('#performance_' + d['identification']).html(newPerformance);
		} else {
			// Only change HTML in the datail table
			$('#payroll_log_payroll_histories_attributes_' + d['identification'] + '_performance').val(newPerformance);
			$('#tr_' + d['identification'] + '_' + d['employee_id']).find('td:eq(8)').html(newPerformance);
		}
	});
}
