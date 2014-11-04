var otherPayment = {};

$(document).ready(function() {

	// List of the routes
	otherPayment.fetch_ledger_accounts_path = $('#fetch_ledger_accounts_path').val();
	otherPayment.fetch_cc_centro_de_costos_path = $('#fetch_cc_centro_de_costos_path').val();
	otherPayment.search_cost_center_work_benefits_path = $('#search_cost_center_work_benefits_path').val();
	otherPayment.fetch_employees_deductions_path = $('#fetch_employees_deductions_path').val();
	otherPayment.search_employee_by_id_path = $('#search_employee_by_id_path').val();
	otherPayment.search_employee_by_code_path = $('#search_employee_by_code_path').val();
	otherPayment.search_employee_by_name_path = $('#search_employee_by_name_path').val();
	otherPayment.load_em_employees_path = $('#load_em_employees_path').val();
	otherPayment.search_employee_payroll_logs_path = $('#search_employee_payroll_logs_path').val();
	otherPayment.fetch_payroll_type_deductions_path = $('#fetch_payroll_type_deductions_path').val();
	otherPayment.get_activas_payrolls_path = $('#get_activas_payrolls_path').val();

	// Click to add a new employee
	$('form').on('click', '.add_fields', otherPayment.addFields);

	// Search Ledger Account
	treeviewhr.cc_tree(debit_account, true, 'load_debit_accounts', 'work_benefit_debit_account');

	// Populate filter for the employee
  	otherPayment.populateEmployeesFilter(otherPayment.fetch_employees_deductions_path, 
  		'load_filter_employees_text', 'load_filter_employees_id');

	// Allows expand the treeview
	$('#list').on('click', 'span.expand_tree', treeviewhr.expand);

	$('#list').on({
		click: otherPayment.setAccount,
		mouseenter: function() {
			$(this).css('text-decoration', 'underline');
		},
		mouseleave: function() {
			$(this).css('text-decoration', 'none');
		}}, '.node_link');

	// Search Centro de Costo
	$('#centroCostoButton').click(function() {
		$('#cost_center_name').val('');
		otherPayment.searchDataScript('', otherPayment.search_cost_center_work_benefits_path);
	});
	
	$('#cost_center_name').keyup(function() {
		otherPayment.searchDataScript( $(this).val(), otherPayment.search_cost_center_work_benefits_path);
	});

	// Centro de Costo | Click to pagination page
	$('#search_cost_center_results').on('click', '.pag a', function() {
    	$.getScript(this.href);
		return false;
  	});

	// Centro de Costo | Click to specific value
	$('#search_cost_center_results').on('click', 'table tr a', function(e) {
  		e.preventDefault();
  		$('#other_payment_centro_de_costo_id').val( $(this).next().val() );
  		$('#other_payment_centro_de_costo_name').val( $(this).html() );
    	$('#centroCostoModal button:eq(0)').trigger('click');
  	});

	// Add the auto complete to Leadger Account
	otherPayment.fetchPopulateAutocomplete(otherPayment.fetch_ledger_accounts_path, 
		$('#other_payment_ledger_account_name'), $('#other_payment_ledger_account_id'));
	
	// Add the auto complete to Centro de Costro
	otherPayment.fetchPopulateAutocomplete(otherPayment.fetch_cc_centro_de_costos_path, 
		$('#other_payment_centro_de_costo_name'), $('#other_payment_centro_de_costo_id'));

	// Add the auto complete to Employee field
	$("#employee_items input:text[id*='search_name_employee']").each(function() {
		otherPayment.fetchPopulateAutocomplete(otherPayment.load_em_employees_path, $(this), 'custom_employee');
	});

	// Employees

	// Executes different options to select the employees
	$('input[name=select_method]').change(function() {
		otherPayment.selectEmployeesOptionsFilter($(this));
	});

	$('div.options-right input[name=check-employees-right]').change(otherPayment.selectEmployeesRight);
	$('#marcar-desmarcar input[name=check-employees]').change(otherPayment.selectEmployeesLeft)

	// Add Employee to the list
	$('#add-to-list').click(function(event) {
		event.preventDefault();
		otherPayment.moveEmployeesToRight();
	});

	// Remove Employee to the list
	$('#remove-to-list').click(function(event) {
		event.preventDefault();
		otherPayment.moveEmployeesToLeft();
	});

	$('#superiors_employees').change(function() {
		otherPayment.filterSuperior( $(this).val() );
  	});

	$('#departments_employees').change(function() {
		otherPayment.filterDepartment( $(this).val() );
	});

	otherPayment.moveEmployeesToRight();
	otherPayment.disableInputs();

	// Search Employee by code
	$('form').on('focusout', '.search_code_employee', function() {
		otherPayment.searchEmployeeByAttr($(this).val(), 'code', $(this).parents('tr'), true);
	});

	// Remove a row to employee_deduction
	$('form').on('click', '.remove_fields', function(event) {
		event.preventDefault();
		otherPayment.removeFields(this);
	}); 

	// Event open modal to search Employee
	$('#employee_items').on('click', '#openEmployeeModal', function() {
		// Change this value to know that row you try to edit
		$(this).parents('tr').find('#in_searching').val('1');
	});

	// Search employee in modal
	$('#search_name_employee_modal').keyup(function() {
		return otherPayment.searchAll( $(this).val() );
	});

	// Click in a specific employee in the modal
	$('#search_employee_results').on('click', 'table tr a', function(e) {
		var employeeId = $(this).parents('td').find('input:hidden').val(),
			selector = $("#employee_items input:hidden[id='in_searching'][value='1']").parents('tr');

		otherPayment.searchEmployeeByAttr(employeeId, 'id', selector, true);
		$('#employeeModal button:eq(2)').trigger('click'); // Close modal
		$("#employee_items input:hidden[id='in_searching'][value='1']").val('0'); // Change input status
		e.preventDefault();
	});

	otherPayment.searchAll("");
	otherPayment.showHideEmployees(true); // Call the function to show/hide the div about employees

	// Individual
	$('#other_payment_individual').change(function() {
		otherPayment.showHideEmployees(false);
	});

	$('#other_payment_custom_calculation').on('change', function() {
		var value = $(this).val();
		$('#employee_items tr').each(function() {
			if( !parseBool( $(this).find("input:hidden[id*='_destroy']").val()) ) {
				$(this).find("input:text[id*='_calculation']").val(value);
			}
		});
	});

	// When change the value in the select option
	$('#other_payment_deduction_type').change(function() {
		otherPayment.typeDeduction(this);
	});

	otherPayment.typeDeduction( $('#other_payment_deduction_type') );

	// Payroll Types
	$('#add-to-list-payroll-types').click(function(event) {
		event.preventDefault();
		otherPayment.moveToRightPayrollTypes();
	});

	$('#remove-to-list-payroll-types').click(function(event) {
		event.preventDefault();
		otherPayment.moveToLeftPayrollTypes();
	});

	$('#check-payroll-types').change( function() {
		otherPayment.checkUncheckLeft(this);
	});

	$('#check-payroll-types-right').change( function() {
		otherPayment.checkUncheckRight(this);
	});

	otherPayment.moveToRightPayrollTypes();

	// Add the auto complete to Payroll Types
	otherPayment.fetchPopulateAutocomplete(otherPayment.fetch_payroll_type_deductions_path, 
		$('#load_filter_payroll_types_text'), 'other_payment_centro_de_costo_id' );

	$('#activas').on("click", "td.payroll-type a", otherPayment.setPayroll );

	$('#unicPayroll').on({ click: otherPayment.clearPayrolls });

});

// Show messages
otherPayment.showMessage = function(type, message) {
  $('div#message').html('<div class="alert alert-' + type + '">' + message + '</div>');
  $('div.alert.alert-error').delay(4000).fadeOut();
}

// Set Ledger Account information on the inputs from the modal
otherPayment.setAccount = function(e) {
    e.preventDefault();
	$('#other_payment_ledger_account_id').val( $(this).closest('li').data('id') );
    $('#other_payment_ledger_account_name').val( $(this).text() );
    $('#ledgerAccountModal button:eq(0)').trigger('click');
}

// Get data to specific url and return the result (type=script)
otherPayment.searchDataScript = function(name, url) {
	return $.ajax({
		url: url,
		dataType: "script",
		data: { search_cost_center_name: name }
	});
}

// Add new row to add an employee
otherPayment.addFields = function(event) {
	var time = new Date().getTime(),
      regexp = new RegExp($(this).data('id'), 'g');
  	$('.header_items').after($(this).data('fields').replace(regexp, time));

  	otherPayment.fetchPopulateAutocomplete(otherPayment.load_em_employees_path, $('#employee_items tr:eq(1)').find("input[id='search_name_employee']"), 'custom_employee');
  	event.preventDefault();
}

// Auto complete function to the different fields
otherPayment.fetchPopulateAutocomplete = function(url, textField, idField) {
	var name = "";
	$.getJSON(url, function(accounts) {
		$(textField).autocomplete({
			source: $.map(accounts, function(item) {

				if(item.naccount) {
					name = item.naccount;
				}
				if(item.nombre_cc) {
					name = item.nombre_cc;
				}
				if(item.name) {
					name = item.surname + ' ' + item.name;
				}
				if(item.description) {
					name = item.description;
				}

				$.data(document.body, 'account_' + item.id + "", name);
				return {
					label: name,
					id: item.id
				}
			}),
			select: function(event, ui) {
				if( idField == "custom_employee" ) {
					otherPayment.searchEmployeeByAttr(ui.item.label, "name", $(event.target).parents('tr'), true);
				} else if( idField == "other_payment_centro_de_costo_id") {
					$('.payroll-types-list.left-list input:checkbox').each(function() {
					  if(ui.item.id === parseInt($(this).val()) ) {
					  	$(this).prop('checked', true);
					  	return false;
					  }
					});
					otherPayment.moveToRightPayrollTypes();
				} else {
					$(idField).val(ui.item.id);
				}				
			},
			focus: function(event, ui) {
				if( idField != "custom_employee" && idField != "other_payment_centro_de_costo_id" ) {
					$(textField).val(ui.item.label);
				}
			}
		});
		if( $(idField).val() ) {
			$(textField).val( $.data(document.body, 'account_' + $(idField).val() + '') );
		}
	});
}

// Filter results by superior name
otherPayment.filterSuperior = function(dropdown) {
	var sup = dropdown ? dropdown : 0;
	$('div.employees-list.left-list input[type=checkbox]').each(function() {
		var empSup = $(this).data('sup') ? $(this).data('sup') : 0;
		if(!(sup == 0)) {
			if(!(sup == empSup)) {
				$(this).closest('div.checkbox-group').hide();
				$(this).prop('disabled', true);
			} else {
				$(this).prop('disabled', false);
				$(this).closest('div.checkbox-group').show();
			}
		} else {
			$(this).closest('div.checkbox-group').show();
		}
	});
}

// Filter results by department name
otherPayment.filterDepartment = function(dropdown) {
	var empSelected = [];
	var dep = dropdown ? dropdown : 0;
	$('div.employees-list.left-list input[type=checkbox]').each(function() {
		var empDep = $(this).data('dep') ? $(this).data('dep') : 0;
		if(!(dep == 0)) {
			if(!(dep == empDep)) {
				empSelected.push(Array($(this).data('id'), empDep, $(this).next().text()));
				$(this).closest('div.checkbox-group').hide();
				$(this).prop('disabled', true);
			} else {
				$(this).prop('disabled', false);
				$(this).closest('div.checkbox-group').show();
			}
		} else {
			$(this).closest('div.checkbox-group').show();
		}
	});
}

// Select the Employees in the right
otherPayment.selectEmployeesRight = function() {
	if( $(this).is(':checked') ) {
		$("#list-to-save input[type='checkbox']:not(:disabled)").prop('checked', true);
	} else {
		$("#list-to-save input[type='checkbox']:not(:disabled)").prop('checked', false);
	}
}

// Select the Employee in the left
otherPayment.selectEmployeesLeft = function() {
	if( $(this).is(':checked') ) {
		$("div.left-list input[type='checkbox']").prop('checked', true);
	} else {
		$("div.left-list input[type='checkbox']").prop('checked', false);
	}
}

// Select the Employees options filter
otherPayment.selectEmployeesOptionsFilter = function(selected) {
	switch($(selected).val()) {
		case 'all':
			$('#employee-filter').show();
			$('#list-departments').hide();
			$('#list-superior').hide();	
			$('div.employees-list.left-list input[type=checkbox]').prop('disabled', false);
			$('.checkbox-group').show();
			break;
		case 'boss':
			$('#employee-filter').hide();
			$('#list-departments').hide();
			otherPayment.filterSuperior($('#superiors_employees').val());
			$('#list-superior').show();	
			break;
		case 'department':
			$('#employee-filter').hide();
			$('#list-superior').hide();	
			otherPayment.filterDepartment($('#departments_employees').val());
			$('#list-departments').show();			
			break;
	}
}

// Move the employees to right
otherPayment.moveEmployeesToRight = function() {
	var appendEmployees = "";
	$('div.employees-list.left-list input[type=checkbox]:checked').each(function() {

		// Add To Table
		otherPayment.addToTable( $(this).val(), $(this).next('label').text() );

		if (!$(this).is(':disabled')) {
			appendEmployees = "<div class='checkbox-group'>" +
					"<div class='checkbox-margin'>" +
					"<input type='checkbox' data-sup='"+ $(this).data('sup') +"' data-dep='"+ $(this).data('dep') +"' checked='checked' class='align-checkbox right' id='"+ $(this).data('id') +"' name='employee_ids' value='"+ $(this).val() +"' />" +
					"<label class='checkbox-label' for='"+ $(this).data('id') +"'>"+ $(this).next().text() +"</label>" +
					"</div>" +
					"</div>"; 
			$('#list-to-save').append(appendEmployees);
			$(this).closest('.checkbox-group').remove();
		};
		// disableInputs();
	});
	$('div#marcar-desmarcar input[name=check-employees]').attr('checked', false);
	$('div.options-right input[name=check-employees-right]').attr('checked', true);
}

// Move the employees to left
otherPayment.moveEmployeesToLeft = function() {
	var appendEmployees = "";
	$('div.employees-list.list-right input[type=checkbox]:not(:checked)').each(function() {

		// Remove To Table
		otherPayment.removeToTable( $(this).val() );

		appendEmployees = "<div class='checkbox-group'>" +
				"<div class='checkbox-margin'>" +
				"<input type='checkbox' data-sup='"+ $(this).data('sup') +"' data-dep='"+ $(this).data('dep') +"' data-id='"+ $(this).attr('id') +"' class='align-checkbox right' id='"+ $(this).attr('id')+'_left' +"' name='left-list-employees' value='"+ $(this).val() +"' />" +
				"<label class='checkbox-label' for='"+ $(this).attr('id')+'_left' +"'>"+ $(this).next().text() +"</label>" +
				"</div>" +
				"</div>";
		$('#no-save').append(appendEmployees);
		$(this).closest('.checkbox-group').remove();
	});

	if($('input[name=select_method]:checked').val() == 'department') {
		otherPayment.filterDepartment( $('#departments_employees').val() );
	} else if ($('input[name=select_method]:checked').val() == 'boss') {
		otherPayment.filterSuperior( $('#superiors_employees').val() );
	}
}

// Populate the input with employee list
otherPayment.populateEmployeesFilter = function(url, textField, idField) {
	$.getJSON(url, function(employees) {
		$(document.getElementById(textField)).autocomplete({
			source: $.map(employees, function(item) {
				$.data(document.body, 'account_' + item.id+"", item.entity.name + ' ' + item.entity.surname);
				return {
					label: item.entity.surname + ' ' + item.entity.name,
					id: item.id,
					sup: item.employee_id,
					dep: item.department_id,
					data_id: 'employee_'+ item.id
				}
			}),
			select: function( event, ui ) {
				if (!$('#list-to-save input#'+ui.item.data_id).length) {
					appendEmployees = "<div class='checkbox-group'>" +
						"<div class='checkbox-margin'>" +
						"<input type='checkbox' data-sup='"+ ui.item.sup +"' data-dep='"+ ui.item.dep +"' checked='checked' class='align-checkbox right' id='"+ ui.item.data_id +"' name='deduction[employee_ids][]' value='"+ ui.item.id +"' />" +
						"<label class='checkbox-label' for='"+ ui.item.data_id +"'>"+ ui.item.label +"</label>" +
						"</div>" +
						"</div>";
					$('#list-to-save').append(appendEmployees);
					$('input#'+ ui.item.data_id + '_left').closest('.checkbox-group').remove();
				}
			}
		})     
	});
}

otherPayment.disableInputs = function() {
	/* detailPayments => LISTA DE EMPLEADOS Q NO SE PUEDEN ELIMINAR
	 * detailPaymentsHidden => LISTA DE EMPLEADOS Q ESTAN OCULTOS
	*/
	var id;
	// Disable the checkbox because you can not delete
	$(".employees-list.list-right input:checkbox").each(function() {
		if( $.inArray( parseInt($(this).val()) , detailPayments) != -1 ) {
      		$(this).attr('disabled', 'disabled');
    	}
	});

	// Disables the inputs because you can not modify
	$('#employee_items tr').each(function() {
		if( !otherPayment.parseBool( $(this).find("input:hidden[id*='_destroy']").val()) ) {
      		if( $.inArray( parseInt($(this).find("input:hidden[id*='employee_id']").val()) , detailPayments) != -1 ) {
        		$(this).find("#search_code_employee").attr('disabled', 'disabled');
        		$(this).find("#search_name_employee").attr('disabled', 'disabled');
      		}
		}

		id = $(this).find("input:hidden[id*='employee_id']").val();

		if( typeof id !== 'undefined' ) {
			otherPayment.searchEmployeeByAttr(id, "id", $(this), false );
		}


	});
}

otherPayment.parseBool = function(str) {
  if(str==null) return false;
  if(str=="false" || str=="0") return false;
  if(str=="true" || str=="1") return true;

  return false;
}

// Show/Hide The differents view based in the checkbox "individual"
otherPayment.showHideEmployees = function(isIndividual) {
	if( $('#other_payment_individual').is(':checked') ) {
		$('#employee_items_one').hide();
		$('#employee_items_two').show();
		$('#custom_calculation').hide();
	} else {
		$('#employee_items_one').show();
		$('#employee_items_two').hide();
		$('#custom_calculation').show();
	}
	if(isIndividual) {
		$('#other_payment_custom_calculation').val( $('#employee_items tr:eq(1)').find("input:text[id*='_calculation']").val() );
	}
}

// Check the type deduction and based in the value, run the differents options
otherPayment.typeDeduction = function(selected) {
	switch($(selected).val()) {
		case 'Unica':
			$('#amount_exhaust_controls').hide();
			$('#payrolls-to-save').empty();
			$('#unicPayroll').show();
			$('#other_payment_payroll').show();
			otherPayment.getPayrolls();
		break;
		case 'Monto_Agotar':
			$('#amount_exhaust_controls').show();
			$('#payrolls-to-save').empty(); //prueba
			$('#unicPayroll').hide();
			$('#other_payment_payroll').hide();
		break;
		case 'Constante':
			$('#amount_exhaust_controls').hide();
			$('#payrolls-to-save').empty(); //prueba
			$('#unicPayroll').hide();
			$('#other_payment_payroll').hide();
		break;
	}
}

// Get all  active Payrolls
otherPayment.getPayrolls = function() {
	$.ajax( otherPayment.get_activas_payrolls_path, {
		type: 'GET',
		timeout: 8000,
		beforeSend: function() {
			$('#error').hide();
			$('#loading').show();
		},
		complete: function() {
			$('#loading').hide();
		},
		success: function(result) {
			$('table#activas > tbody').empty();
			$(result.activa).each(function() { otherPayment.addActivas(this, 'table#activas')});
		},
		error: function(result) {
			$('#error').show();
		}
	});
}

// Load the active payrolls in the table
otherPayment.addActivas = function(payroll, target_table) {
	var row = $(target_table + '> tbody:last').append('<tr>' +
		'<td class="payroll-id">' + payroll.id +'</td>' +
		'<td class="payroll-type"><a data-dismiss="modal" href="#">' + payroll.payroll_type.description +'</a></td>' +
		'<td>' +  payroll.start_date + '</td>' +
		'<td>' +  payroll.end_date + '</td>' +
		'<td>' +  payroll.payment_date + '</td>' +
		'</tr>');
	return row;
}

// Sets the hidden field with the id of the selected template only
otherPayment.setPayroll = function(e) {
	e.preventDefault();
	var payrollId = $(e.target).parent().prev().text(),
		payrollName = $(e.target).text();

	$('#payrolls-to-save').append( "<input type='hidden" +"' name='other_payment[payroll_ids][]' value='"+ payrollId +"' />" );
	$('#other_payment_payroll').val(payrollName);  
}

// Clear the id and text in the payroll(unique)
// to prevent send 2 or more ids because is Just one
otherPayment.clearPayrolls = function() {
  $('#payrolls-to-save').empty();
  $('#deduction_payroll').val('');  
}

// Search a employee by attr (id, code, name)
otherPayment.searchEmployeeByAttr = function(value, type, selector, isNew) {
  
	var url, customData, result;
	isNew = typeof isNew !== 'undefined' ? isNew : true;

	switch(type) {
		case "id":
			url = otherPayment.search_employee_by_id_path,
			customData = { search_id: value };
		break;

		case "code":
			url = otherPayment.search_employee_by_code_path,
			customData = { search_code: value };
		break;

		case "name":
			url = otherPayment.search_employee_by_name_path,
			customData = { search_name: value };
		break;
	}

	$.ajax({
		type: "GET",
		url: url,
		dataType: "json",
		data: customData,
		success: function(data) {
			otherPayment.populateListEmployees(data, selector, isNew);
		},
		error: function(response, textStatus, errorThrown) {
			otherPayment.showMessage("error", "Error al intentar borrar el registro");
		}
	});
}

otherPayment.populateListEmployees = function(employee, parent, isNew) {

	var clear = false;
	if(!employee) {
		clear = true;
		otherPayment.showMessage("error", "El empleado no existe");
	} else {
		if( otherPayment.checkIfEmployeeExist(employee) && isNew ) {
			clear = true;
			otherPayment.showMessage("info", "El empleado a sido habilitado nuevamente o ya existe en la lista");
		} else {
			$(parent).find("input:hidden[id*='_employee_id']").val(employee.id);
			$(parent).find("input[id='search_code_employee']").val(employee.number_employee);
			$(parent).find("input[id='search_name_employee']").val(employee.name + " " + employee.surname);
			otherPayment.addToList(employee.id);
		}
	}

	if(!isNew) {
		otherPayment.hiddenEmployees(employee.id);
	}
	
	if( clear && !$(parent).find("input[id='search_code_employee']").prop('disabled') && $(parent).find("input:hidden[id*='_employee_id']").val() == "" ) {
		$(parent).find("input:hidden[id*='_employee_id']").val("");
		$(parent).find("input[id='search_code_employee']").val("");
		$(parent).find("input[id='search_name_employee']").val("");
	}
}

// Find a employee, return true if exist and false if not
otherPayment.checkIfEmployeeExist = function(employee) {
	var result = false,
	 	parent = otherPayment.findParentByAttr(employee.id, "id", false),
		parent2 = otherPayment.findParentByAttr(employee.id, "id", true);

	if(typeof parent != 'undefined') {
		result = true;
	} else {
		if(typeof parent2 != 'undefined') {
			$(parent2).show();
			$(parent2).find("input:hidden[id*='_destroy']").val("false");
			result = true;
		}
	}

	return result;
}

// Only for the table employee details
otherPayment.findParentByAttr = function(value, type, hidden) {
	var parent;
	hidden = typeof hidden !== 'undefined' ? hidden : false;

	$('#employee_items tr').each(function() {
		if( hidden ) {
			if( otherPayment.parseBool( $(this).find("input:hidden[id*='_destroy']").val()) ) {
				if(type === "id") {
					if( parseInt($(this).find("input:hidden[id*='employee_id']").val()) === parseInt(value) ) {
						parent = $(this);
						return false;
					}
				}
			}
		} else {
			if( !otherPayment.parseBool( $(this).find("input:hidden[id*='_destroy']").val()) ) {
				if(type === "id") {
					if( parseInt($(this).find("input:hidden[id*='employee_id']").val()) === parseInt(value) ) {
						parent = $(this);
						return false;
					}
				}
			}
		}
	});

	return parent;
}

otherPayment.removeFields = function(elevent) {
  var id = $(elevent).parents('tr').find("input:hidden[id*='_employee_id']").val();
  otherPayment.removeToList(id);
  $(elevent).prev('input[type=hidden]').val(1);
  $(elevent).parents('tr').hide();
}

otherPayment.searchAll = function(name) {
	return $.ajax({
		url: otherPayment.search_employee_payroll_logs_path,
		dataType: "script",
		data: {
			search_employee_name: name
		}
	});
}

// From top to bottom
otherPayment.addToTable = function(id, name) {
  
	var exist = false;
	var parent = otherPayment.findParentByAttr(id, "id"),
		parent2 = otherPayment.findParentByAttr(id, "id", true);

	if(typeof parent != 'undefined') {
		exist = true;
	} else {
		if(typeof parent2 != 'undefined') {
			$(parent2).show();
			$(parent2).find("input:hidden[id*='_destroy']").val("false");
			exist = true;
		}
	}

	if( !exist ) {
		$('.add_fields').trigger('click');
		var selector = $('#employee_items').find('tr:eq(1)');
		otherPayment.searchEmployeeByAttr(name, "name", selector[0], true);
	}
}

otherPayment.removeToTable = function(id) {
  
	var parent = otherPayment.findParentByAttr(id, "id");

	if(typeof parent != 'undefined') {
		$(parent).find("input:hidden[id*='_destroy']").val(1);
		$(parent).hide();
		return false;
	}
}

// From bottom to top
otherPayment.addToList = function(id) {
	$('.employees-list.left-list').find("input:checkbox[value='" + id + "']").prop('checked', true);
	$('#add-to-list').trigger('click');
}

otherPayment.removeToList = function(id) {
	$('#list-to-save').find("input:checkbox[value='" + id + "']").prop('checked', false);
	otherPayment.moveEmployeesToLeft();
}

otherPayment.hiddenEmployees = function(idEmployee) {
	if( $.inArray( parseInt(idEmployee) , detailPaymentsHidden) != -1 ) {
		var parent = otherPayment.findParentByAttr(idEmployee, "id");
		otherPayment.removeToList(idEmployee);
		$(parent).find("input[type=hidden][id*='_destroy']").val(1);
		$(parent).hide();
	}
}

/* Payrolls Types */
// Function to move payroll-types to the right
otherPayment.moveToRightPayrollTypes = function() {
	var appendPayrollTypes = "";
	$('div.payroll-types-list.left-list input[type=checkbox]:checked').each(function() {
		if (!$(this).is(':disabled')) {
			appendPayrollTypes = "<div class='checkbox-group'>" +
				"<div class='checkbox-margin'>" +
				"<input type='checkbox' data-sup='"+ $(this).data('sup') +"' data-dep='"+ $(this).data('dep') +"' checked='checked' class='align-checkbox right' id='"+ $(this).data('id') +"' name='other_payment[payroll_type_ids][]' value='"+ $(this).val() +"' />" +
				"<label class='checkbox-label' for='"+ $(this).data('id') +"'>"+ $(this).next().text() +"</label>" +
				"</div>" +
				"</div>"; 
			$('#list-payroll-types-to-save').append(appendPayrollTypes);
			$(this).closest('.checkbox-group').remove();
		}
	});
	$('div#marcar-desmarcar-payroll-types input[name=check-payroll-types]').attr('checked', false);
	$('div.options-right input[name=check-payroll-types-right]').attr('checked', true);
}

// Function to move payroll-types to the left
otherPayment.moveToLeftPayrollTypes = function() {
	var appendPayrollTypes = "";
	$('div.payroll-types-list.list-right input[type=checkbox]:not(:checked)').each(function() {
		appendPayrollTypes = "<div class='checkbox-group'>" +
			"<div class='checkbox-margin'>" +
			"<input type='checkbox' data-sup='"+ $(this).data('sup') +"' data-dep='"+ $(this).data('dep') +"' data-id='"+ $(this).attr('id') +"' class='align-checkbox right' id='"+ $(this).attr('id')+'_left' +"' name='left-list-payroll-types' value='"+ $(this).val() +"' />" +
			"<label class='checkbox-label' for='"+ $(this).attr('id')+'_left' +"'>"+ $(this).next().text() +"</label>" +
			"</div>" +
			"</div>"; 
		$('#no-save-payroll-types').append(appendPayrollTypes);
		$(this).closest('.checkbox-group').remove();
	});
}

// Check/Uncheck Left
otherPayment.checkUncheckLeft = function(elevent) {
	if ($(elevent).is(':checked')) {
		$("div.payroll-types-list.left-list input[type='checkbox']").prop('checked', true);
	} else {
		$("div.payroll-types-list.left-list input[type='checkbox']").prop('checked', false);
	}
}

// Check/Uncheck Right
otherPayment.checkUncheckRight = function(elevent) {
	if ($(elevent).is(':checked')) {
		$("div.payroll-types-list.list-right input[type='checkbox']").prop('checked', true);
	} else {
		$("div.payroll-types-list.list-right input[type='checkbox']").prop('checked', false);
	}
}
