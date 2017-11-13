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
	}).on("select2-close", function (e) {
		if( pl.validationTabs() ) {
			if( $(pl.current_employee).find('#employee_code').val() == '') {
				$(pl.current_employee).find('#search_name_employee').select2('open');
				var thatName = $(pl.current_employee).find('a:eq(1)');
		 		$(thatName).find('span:eq(0)').html("Nombre");
			} else {
				$(pl.current_cc).find('#search_code_cc').select2('open');
			}
		}
	}).on("select2-highlight", function (e) {
		var thatName = $(pl.current_employee).find('a:eq(1)');
	 	$(thatName).find('span:eq(0)').html(e.choice.name + ' ' + e.choice.surname);
  });
}

pl.employeeCodeFormatResult = function(employee) {
	var markup = "<table><tr>";
	markup += "<td><div>" + employee.number_employee + "</div>";
	markup += "</td></tr></table>";
	return markup;
}

pl.employeeCodeFormatSelection = function(employee) {
	pl.setValuesFromSearch(pl.search_types.employees, employee);
	return employee.number_employee;xit
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
		escapeMarkup: function (m) { return m; } // we do not want to escape markup since we are displaying html in results
	}).on("select2-close", function (e) {
		if( pl.validationTabs() ) {
			if( $(pl.current_employee).find('#employee_code').val() == '') {
				$(pl.current_employee).find('#search_code_employee').select2('open');
				var thatCode = $(pl.current_employee).find('a:eq(0)');
		 		$(thatCode).find('span:eq(0)').html("#");
			} else {
				$(pl.current_cc).find('#search_code_cc').select2('open');
			}
		}
	}).on("select2-highlight", function (e) {
		var thatCode = $(pl.current_employee).find('a:eq(0)');
	 	$(thatCode).find('span:eq(0)').html(e.choice.number_employee);
  });
}

pl.employeeNameFormatResult = function(employee) {
	var markup = "<table><tr>";
	markup += "<td><div>" + employee.name + " " + employee.surname + "</div>";
	markup += "</td></tr></table>";
	return markup;
}

pl.employeeNameFormatSelection = function(employee) {
	return pl.setValuesFromSearch(pl.search_types.employees, employee);
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
	}).on("select2-close", function (e) {
		if( pl.validationTabs() ) {
			if( $(pl.current_cc).find('input:hidden[id*=_costs_center_id]').val() == '' ) {
				$(pl.current_cc).find('#search_name_cc').select2('open');
		 		var thatName = $(pl.current_cc).find('a:eq(1)');
				$(thatName).find('span:eq(0)').html("Nombre");
			} else {
				$(pl.current_task).find('#search_code_task').select2('open');
			}
		}
	}).on("select2-highlight", function (e) {
		var thatName = $(pl.current_cc).find('a:eq(1)');
		$(thatName).find('span:eq(0)').html(e.choice.name_cc);
  });
}

pl.ccCodeFormatResult = function(cc) {
	var markup = "<table><tr>";
	markup += "<td><div>" + cc.icost_center + "</div>";
	markup += "</td></tr></table>";
	return markup;
}

pl.ccCodeFormatSelection = function(cc) {
	return pl.setValuesFromSearch(pl.search_types.cc, cc);
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
	}).on("select2-close", function (e) {
		if( pl.validationTabs() ) {
			if( $(pl.current_cc).find('input:hidden[id*=_costs_center_id]').val() == '' ) {
				$(pl.current_cc).find('#search_code_cc').select2('open');
				var thatCode =  $(pl.current_cc).find('a:eq(0)');
				$(thatCode).find('span:eq(0)').html("#");
			} else {
				$(pl.current_task).find('#search_code_task').select2('open');
			}
		}
	}).on("select2-highlight", function (e) {
		var thatCode =  $(pl.current_cc).find('a:eq(0)');
		$(thatCode).find('span:eq(0)').html(e.choice.icost_center);
  });
}

pl.ccNameFormatResult = function(cc) {
	var markup = "<table><tr>";
	markup += "<td><div>" + cc.name_cc + "</div>";
	markup += "</td></tr></table>";
	return markup;
}

pl.ccNameFormatSelection = function(cc) {
	return pl.setValuesFromSearch(pl.search_types.cc, cc);
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
					task_iactivity: $(pl.current_cc).find('#iactivity_cc').val(),
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
	}).on("select2-close", function (e) {
		if( pl.validationTabs() ) {
			if( $(pl.current_task).find('input:hidden[id*=_task_id]').val() == '' ) {
				$(pl.current_task).find('#search_name_task').select2('open');
				var thatName = $(pl.current_task).find('a:eq(1)');
				$(thatName).find('span:eq(0)').html("Nombre");
			} else {
				setTimeout(function() {
					$(pl.current_cant_working).find('input[id*=_time_worked]').focus();
    		}, 1);
			}
		}
	}).on("select2-highlight", function (e) {
		var thatName = $(pl.current_task).find('a:eq(1)');
		$(thatName).find('span:eq(0)').html(e.choice.ntask);
  });
}

pl.taskCodeFormatResult = function(task) {
	var markup = "<table><tr>";
	markup += "<td><div>" + task.itask + "</div>";
	markup += "</td></tr></table>";
	return markup;
}

pl.taskCodeFormatSelection = function(task) {
	return pl.setValuesFromSearch(pl.search_types.tasks, task);
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
					task_iactivity: $(pl.current_cc).find('#iactivity_cc').val(),
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
	}).on("select2-close", function (e) {
		if( pl.validationTabs() ) {
			if( $(pl.current_task).find('input:hidden[id*=_task_id]').val() == '' ) {
				$(pl.current_task).find('#search_code_task').select2('open');
				var thatCode = $(pl.current_task).find('a:eq(0)');
				$(thatCode).find('span:eq(0)').html("#");
			} else {
				setTimeout(function() {
					$(pl.current_cant_working).find('input[id*=_time_worked]').focus();
    		}, 1);
			}
		}
	}).on("select2-highlight", function (e) {
		var thatCode = $(pl.current_task).find('a:eq(0)');
		$(thatCode).find('span:eq(0)').html(e.choice.itask);
  });
}

pl.taskNameFormatResult = function(task) {
	var markup = "<table><tr>";
	markup += "<td><div>" + task.ntask + "</div>";
	markup += "</td></tr></table>";
	return markup;
}

pl.taskNameFormatSelection = function(task) {
	return pl.setValuesFromSearch(pl.search_types.tasks, task);
}
/**************************************************************************************/
/* Set Values From the Seach result */
/**************************************************************************************/
pl.setValuesFromSearch = function(type, object) {

	pl.tabs_function = true;
	pl.saveSearchSessionStorage(type, object);

	switch(type) {

		case pl.search_types.employees:
			// Set Code
			var that = $(pl.current_employee).find('a:eq(0)');
			$(that).find('span:eq(0)').html(object.number_employee);
	 		$(that).removeClass('select2-default');
	 		// Set Name
	 		that = $(pl.current_employee).find('a:eq(1)');
	 		$(that).find('span:eq(0)').html(object.name + ' ' + object.surname);
			$(that).removeClass('select2-default');
			// Set ID
			$(pl.current_employee).find('#employee_code').val(object.id);
		break;

		case pl.search_types.cc:
			// Set Code
			var that =  $(pl.current_cc).find('a:eq(0)');
			$(that).find('span:eq(0)').html(object.icost_center);
			$(that).removeClass('select2-default');
			// Set Name
			that = $(pl.current_cc).find('a:eq(1)');
			$(that).find('span:eq(0)').html(object.name_cc);
			$(that).removeClass('select2-default');
			// Set ID
			$(pl.current_cc).find('input:hidden[id*=_costs_center_id]').val(object.id);
			// Set Activity
			$(pl.current_cc).find('#iactivity_cc').val(object.iactivity);
			// Enable Tasks inputs
			$(pl.current_task).find('#s2id_search_code_task').removeClass('a-not-active');
			$(pl.current_task).find('#s2id_search_name_task').removeClass('a-not-active');
		break;

		case pl.search_types.tasks:
			// Set Code
			var that = $(pl.current_task).find('a:eq(0)');
			$(that).find('span:eq(0)').html(object.itask);
			$(that).removeClass('select2-default');
			// Set Name
			that = $(pl.current_task).find('a:eq(1)');
			$(that).find('span:eq(0)').html(object.ntask);
			$(that).removeClass('select2-default');
			// Set ID, Costs, Unidad, Unit performance
			$(pl.current_task).find('input:hidden[id*=_task_id]').val(object.id);
			$(pl.current_task).find('input:hidden[id*=_task_total]').val(object.cost);
			$(pl.current_task).find('input:hidden[id*=_task_unidad]').val(object.nunidad);
		break;
	}
}
/**************************************************************************************/
/* Validation Tabs */
/**************************************************************************************/
pl.validationTabs = function() {
	var result = (pl.tabs_function) ? true : false;
	pl.tabs_function = false;
	return result;
}
/**************************************************************************************/
/* Save in Session Storage the objects selected by search */
/**************************************************************************************/
pl.saveSearchSessionStorage = function(key, object) {
	var sessionArray = JSON.parse(sessionStorage.getItem(key));

	if(sessionArray != null) {
		var add = true;
		$.each( sessionArray, function( arrayKey, sessionObj ) {
  		if(sessionObj.id == object.id) {
  			add = false;
  		}
		});

		if(add) {
			sessionArray.push(object);
			pl.setSessionStorage(key, sessionArray);
		}
	} else {
		var array = Array();
		array.push(object);
		pl.setSessionStorage(key, array);
	}
}
/**************************************************************************************/
/* Custom performance functionality | Search Task By Code */
/**************************************************************************************/
pl.customSearchTaskByCode = function() {
	$('#group_search_code_task').select2({
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
		formatResult: pl.customTaskCodeFormatResult,
		formatSelection: pl.customTaskCodeFormatSelection,
		dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
		escapeMarkup: function (m) { return m; } // we do not want to escape markup since we are displaying html in results
	}).on("select2-close", function (e) {
		if( $('#group_id_task').val() == '' ) {
			$('#group_search_name_task').select2('open');
			$('#s2id_group_search_name_task').find('span:eq(0)').html("Nombre");
		}
	}).on("select2-highlight", function (e) {
	 	$('#s2id_group_search_name_task').find('span:eq(0)').html(e.choice.ntask);
  });
}

pl.customTaskCodeFormatResult = function(task) {
	var markup = "<table><tr>";
	markup += "<td><div>" + task.itask + "</div>";
	markup += "</td></tr></table>";
	return markup;
}

pl.customTaskCodeFormatSelection = function(task) {
	// Set Name
	$('#s2id_group_search_name_task').find('span:eq(0)').html(task.ntask);
	$('#group_id_task').val(task.id);
	return task.itask;
}
/**************************************************************************************/
/* Custom performance functionality | Search Task By Name */
/**************************************************************************************/
pl.customSearchTaskByName = function() {
	$('#group_search_name_task').select2({
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
		formatResult: pl.customTaskNameFormatResult,
		formatSelection: pl.customTaskNameFormatSelection,
		dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
		escapeMarkup: function (m) { return m; } // we do not want to escape markup since we are displaying html in results
	}).on("select2-close", function (e) {
		if( $('#group_id_task').val() == '' ) {
			// $('#group_search_code_task').select2('open');
			$('#s2id_group_search_code_task').find('span:eq(0)').html("#");
		}
	}).on("select2-highlight", function (e) {
	 	$('#s2id_group_search_code_task').find('span:eq(0)').html(e.choice.itask);
  });
}

pl.customTaskNameFormatResult = function(task) {
	var markup = "<table><tr>";
	markup += "<td><div>" + task.ntask + "</div>";
	markup += "</td></tr></table>";
	return markup;
}

pl.customTaskNameFormatSelection = function(task) {
	// Set Code
	$('#s2id_group_search_code_task').find('span:eq(0)').html(task.itask);
	$('#group_id_task').val(task.id);
	return task.ntask;
}
