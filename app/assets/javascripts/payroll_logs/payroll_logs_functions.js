payroll_logs = {
	search_length : 3,
	employee_td_eq: 0,
	task_td_eq: 1,
	time_worked_td_eq: 2,
	centro_de_costo_td_eq: 3,
	payment_type_td_eq: 5,
}

$(jQuery(document).ready(function($) {

	payroll_logs.reloadSelectorsEvents = function() {

		$('.success td:eq(4) select').addClass('input-medium');

		// Employee
		$('#search_code_employee').focusout( function() {
			if( $(this).val() != "") {
				payroll_logs.searhEmployeeCode( $(this).val() );
			}
		});

		// Task
		$("#search_task_code_").focusout(function() {
			var code = $(this).val();
			if( code != "" ) {
				payroll_logs.searchTaskCode( code );
			}
		});

		$("#search_task_code_").focus(function() {
			var employeeId = $('.success td:eq('+payroll_logs.employee_td_eq+') input:hidden:eq(0)').val();
			if( employeeId == '' ) {
				resources.PNotify('Empleado', 'Seleciona un empleado', 'warning');
			}
		});

		// Time Worked
		$('.success td:eq('+payroll_logs.time_worked_td_eq+') input').focus(function() {
			var taskId = $('.success td:eq('+payroll_logs.task_td_eq+') input:hidden:eq(0)').val();
			if(taskId == "") {
				resources.PNotify('Labor', 'Seleciona una Labor', 'warning');
			}
		});

		// Cost Center
		$('#search_cost_code_').focusout(function() {
			if($(this).val()!="") {
				payroll_logs.searchCostCode( $(this).val().toUpperCase() );
			}
		});

		// Payment Type
		$('.success td:eq('+payroll_logs.payment_type_td_eq+') select').focus(function() {
			var costCenterId = $('.success td:eq('+payroll_logs.centro_de_costo_td_eq+') input:hidden').val();
			if( costCenterId == "" ) {
				resources.PNotify('Centro de Costo', 'Seleciona un Centro de Costo', 'warning');
			}
		});

		// Add Fields last tap
		$('.paymentType').focusout(function() {
			$('.addFields').trigger('click');
		});

		$('#load_centro_de_costo').focusout(function() {
			$('.paymentType').trigger('focus');
		});

		$('#name_employee').focusout(function() {
			$('#search_task_code_').trigger('focus');
		});			

		payroll_logs.searchAll( $('#search_task_name').val(), $('#search_task_payroll_logs_path').val(), "task" );
		payroll_logs.searchAll( $('#search_cost_name').val(), $('#search_cost_payroll_logs_path').val(), "cost" );
		payroll_logs.searchAll( $('#search_name_employee').val(), $('#search_employee_payroll_logs_path').val(), "employees" );
	}

	// Task
	payroll_logs.searchTaskCode = function(code) {
		
		$.each(task_code, function(index, value) {
			if( value === code ) {
				$('.success td:eq('+payroll_logs.task_td_eq+') input:hidden:eq(0)').val( task_id[index] );
				$('.success td:eq('+payroll_logs.task_td_eq+') input:hidden:eq(1)').val( task_cost[index] );
				$('.success td:eq('+payroll_logs.task_td_eq+') input:hidden:eq(2)').val( task_unidad[index] );
				$('#load_task').val( task_desc[index] );
				$('#task_cost_').val(parseFloat(task_cost[index]).toFixed(2));
				$("#task_unit_").val( task_unidad[index] );
				return false;
			}

			if( task_code.length-1 == index ) {
				resources.PNotify('Labor', "Codigo no fue encontrado", 'info');
				$('.success td:eq('+payroll_logs.task_td_eq+') input:hidden:eq(0)').val('');
				$('.success td:eq('+payroll_logs.task_td_eq+') input:hidden:eq(1)').val('');
				$('.success td:eq('+payroll_logs.task_td_eq+') input:hidden:eq(2)').val('');
				$('#load_task').val('');
				$('#search_task_code_').val('');
				$('#task_cost_').val('');
				$('#task_unit_').val('');
			}
		});
	}

	payroll_logs.setTaskCode = function(id) {
		
		$.each(task_id, function(index, value) {
			if( value == id ) {
				$("#search_task_code_").val( task_code[index] );
				$("#task_cost_").val( parseFloat(task_cost[index]).toFixed(2) );
				$("#task_unit_").val( task_unidad[index] );
				$('.success td:eq('+payroll_logs.task_td_eq+') input:hidden:eq(0)').val( task_id[index] );
				$('.success td:eq('+payroll_logs.task_td_eq+') input:hidden:eq(1)').val( task_cost[index] );
				$('.success td:eq('+payroll_logs.task_td_eq+') input:hidden:eq(2)').val( task_unidad[index] );
				return false;
			}
		});
	}

	// Cost
	payroll_logs.searchCostCode = function(code) {

		$.each(cost_code, function(index, value) {
			if( value === code ) {
				$('.success td:eq('+payroll_logs.centro_de_costo_td_eq+') input:eq(1)').val(cost_id[index]);		// hidden (id)
				$('.success td:eq('+payroll_logs.centro_de_costo_td_eq+') input:eq(2)').val(cost_desc[index]);	// text (description)
				return false;
			}

			if( cost_code.length-1 === index ) {
				resources.PNotify('Centro de Costo', "Codigo no fue encontrado", 'info');
				$('.success td:eq('+payroll_logs.centro_de_costo_td_eq+') input:eq(1)').val(''); // hidden (id)
				$('#search_cost_code_').val(''); 			// text (code)
				$('.success td:eq('+payroll_logs.centro_de_costo_td_eq+') input:eq(2)').val(''); // text (description)
			}
		});
	}

	payroll_logs.setCostCode = function(id) {
		$.each(cost_id, function(index, value) {
			if( value == id ) {
				$("#search_cost_code_").val(cost_code[index]);
				$('.success td:eq('+payroll_logs.centro_de_costo_td_eq+') input:eq(1)').val(cost_id[index]);
				return false;
			}
		});
	}

	// Employee

	payroll_logs.searhEmployeeCode = function(code) {
		$.each(employee_code, function(index, value) {
			if( value == code ) {
				$('#employee_code').val( employee_id[index] ); 		// Hidden id empleyee (id)
				$('#name_employee').val( employee_name[index] );	// Name employee
				return false;
			}

			if( employee_code.length-1 === index ) {
				resources.PNotify('Empleado', "El numero de Identificacion no fue encontrado", 'info');
				$('#employee_code').val('');		// Hidden id empleyee (id)
				$('#name_employee').val('');		// Name employee
				$('#search_code_employee').val('');	// Code employee
			}
		});
	}

	payroll_logs.setEmployeeId = function(id) {
  		$.each(employee_id, function(index, value) {
  			if( value == id ) {
  				$('#search_code_employee').val( employee_code[index] ); // Code employee
  				$('#employee_code').val( employee_id[index] ); // Hidden id empleyee (id)
  				return false;
  			}
  		});
  	}

	// Employees add Details
	payroll_logs.addDetailsToEmployee = function(num, employee_id, is_select_methol_all) {

		if ( !$('#employee_table_'+employee_id).length ) {
			payroll_logs.addNewSelection( num, employee_id, is_select_methol_all );
		}
		
		payroll_logs.addNewColumn( num, employee_id );
	}

	payroll_logs.addNewColumn = function(num, employee_id) {

		var base = '#payroll_log_payroll_histories_attributes_' + num;

		var date 		= $('#payroll_log_payroll_date').val(),
			task 		= $(base + '_task_id').parents('div.row').find('input[id*=load_task]').val(),
			task_id 	= $(base + '_task_id').parents('div.row').find('input[id*=search_task_code_]').val(),
			task_cost 	= $(base + '_task_id').parents('div.row').find('input[id*=task_cost_]').val(),
			unit 		= $(base + '_task_id').parents('div.row').find('input[id*=task_unit_]').val(),
			mount 		= $(base + '_time_worked').val(),
			cost 		= $(base + '_costs_center_id').parents('div.row').find('input[id*=load_centro_de_costo]').val(),
			payment 	= $(base + '_payment_type_id option:selected').text(),
			totalRow 	= parseFloat($(base + '_total').val().replace(',', '')),
			subTotal 	= parseFloat($('#total_' + employee_id + ' td:eq(1)').html().replace(',', ''));

		$('#total_' + employee_id + ' td:eq(1)').html( resources.prettyNumber(totalRow + subTotal) );
		
		$('#employee_table_'+employee_id+' #total_'+employee_id).before('<tr id="tr_' + num + '_' + employee_id +'" class="alert alert-dismissable alert-info">' +
													'<td>'+ date +'</td>' +
													'<td>'+ task_id +' | '+ task +'</td>' +
													'<td>'+ task_cost +'</td>'+
													'<td>'+ unit + '</td>' +
													'<td>'+ mount +'</td>' +
													'<td>'+ cost +'</td>' +
													'<td>'+ payment +'</td>' +
													'<td>'+ resources.prettyNumber(totalRow) +'</td>' +
													'<td>' +
														'<button type="button" class="btn btn-xs btn-danger-alt"><i class="fa fa-trash-o"></i></button>' +
														'<input type="hidden" value="' + num + '"  />' +
														'<input type="hidden" value="' + employee_id + '"  />' +
													'</td>' +
												'</tr>');
		payroll_logs.addToPayrollTotal(totalRow);
		payroll_logs.addEmployeeCounter();
	}

	payroll_logs.addNewSelection = function(num, employee_id, is_select_methol_all) {
		
		var total = $('#accordion div.panel.accordion-item').length + 1,
			name = "";

		if( is_select_methol_all ) {
			name = $('#products_items tr:eq(2) td:eq('+payroll_logs.employee_td_eq+') input:eq(2)').val();
		} else {
			name = $('#employee_'+employee_id).next().html();			
		}
		
		var theadList = ["Fecha", "Labor", "Costo", "Unidad", "Cantidad", "Centro de Costos", "Tipo de Pago", "Total"];
		var thead = '';

		$.each(theadList, function( index, data ) {
			thead += '<td>'+data+'</td>';
		});

		var data = '<div class="panel accordion-item">' +
			'<a class="accordion-title collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapsea'+total+'" aria-expanded="false">' +
				'<h2>'+name+'</h2></a>' +
			'<div id="collapsea'+total+'" class="collapse" aria-expanded="false" style="height: 0px;">' +
				'<div class="accordion-body">' +
					'<table class="table table-hover table-bordered table-striped" id="employee_table_'+employee_id+'">' +
						thead +
						'<tbody>' +
							'<tr class="employee_count" id="total_'+employee_id+'">' +
								'<td colspan="6" class="align_right">Total:</td>' +
								'<td colspan="3">00.00</td>' +
			'</tr></tbody></table></div></div></div>';

		$('#accordion').append(data);
	}

  	payroll_logs.search = function(name, url, type) {
		
		var d = {};

		if( name.length >= payroll_logs.search_length ) {

			if( type == 'cost' ) {
				d = { 
					search_cost_name: name,
					company_id: $('#the_company_id').val()
				};
			} 
			if( type == 'task' ) {
				d = { search_task_name: name };
			}
			if( type == 'employees' ) {
				d = { search_employee_name: name };
			}

			return $.ajax({
				url: url,
				dataType: "script",
				data: d
			});
		}
  	}

  	payroll_logs.searchAll = function(name, url, type) {
		
		var d = {};

		if( type == 'cost' ) {
			d = { 
				search_cost_name: name ,
				company_id: $('#the_company_id').val()
			};
		} 
		if( type == 'task' ) {
			d = { search_task_name: name };
		}
		if( type == 'employees' ) {
			d = { search_employee_name: name };
		}

		return $.ajax({
			url: url,
			dataType: "script",
			data: d
		});
  	}

  	payroll_logs.deleteAllEmployeesView = function(num) {

  		$("tr[id^='tr_" + num + "_']").each(function( index ) {
  			$(this).remove();
		});
  	}

  	// Validation data employees

  	payroll_logs.validateEmployeeTask = function(num, is_select_methol_all) {

  		var v_cost = $('#load_centro_de_costo').val();
  		var v_date = $('#payroll_log_payroll_date').val();
  		var v_task = $('#load_task').val();
  		var v_payment_type = $('#payroll_log_payroll_histories_attributes_' + num + '_payment_type_id option:selected').text();
  		var username;
  		var id;
  		var b_cost;
  		var b_date;
  		var b_task;
  		var b_payment_type;
  		var exists = false;
  		var result;
  		var data;
  		var employee_id = new Array();

  		data = {
			"date": v_date,
		    "task": v_task,
		    "cost": v_cost,
		    "type_payment": v_payment_type
		};

		if( is_select_methol_all ) {
			id = $('#products_items tr:eq(1) td:eq('+payroll_logs.employee_td_eq+') input:hidden').val();
			employee_id.push(id);

	  		for( var i=0; i<=employees_info.length-1; i++ ) {

	  			if( employees_info[i]['id'] == id ) {

	  				$.each(employees_info[i]['data'], function(obj,index) {

	  					( v_cost == index.cost ) ? b_cost = true : b_cost = false;

	  					( v_date == index.date ) ? b_date = true : b_date = false;

	  					( v_task == index.task ) ? b_task = true : b_task = false;

	  					( v_payment_type == index.type_payment ) ? b_payment_type = true : b_payment_type = false;

	  					if( b_cost && b_date && b_task && b_payment_type ) {
	  						exists = true;
	  						username = employees_info[i]['name'];
	  						return false;
	  					}
					}); // End each employees data
	  			} // End if
	  		} // End for employees id

		} else {
	  		$('#employee-box .lists .list-right input').each(function() {
			  
			  id = $(this).val();
			  employee_id.push(id);

	  			for( var i=0; i<=employees_info.length-1; i++ ) {

	  				if( employees_info[i]['id'] == id ) {

	  					$.each(employees_info[i]['data'], function(obj,index) {

	  						( v_cost == index.cost ) ? b_cost = true : b_cost = false;

	  						( v_date == index.date ) ? b_date = true : b_date = false;

	  						( v_task == index.task ) ? b_task = true : b_task = false;

	  						( v_payment_type == index.type_payment ) ? b_payment_type = true : b_payment_type = false;

	  						if( b_cost && b_date && b_task && b_payment_type ) {
	  							exists = true;
	  							username = employees_info[i]['name'];
	  							return false;
	  						}
						}); // End each employees data
	  				} // End if
	  			} // End for employees id
			}); // End each selector ids
  		}

		if( exists ) {
			return result = { "status": true, "username": username };
		} else {
			payroll_logs.addEmployeeTaskData(data, employee_id, is_select_methol_all);
			return result = { "status": false, "username": username };
		}
  	}

  	payroll_logs.addEmployeeTaskData = function(data, employees, is_select_methol_all) {

  		var exists = false;

  		for( var x=0; x<=employees.length-1; x++ ) {

  			for( var i=0; i<=employees_info.length-1; i++ ) {

	  			if( employees_info[i]['id'] == employees[x] ) {
	  				employees_info[i]['data'].push(data);
	  				exists = true;
	  				i = employees_info.length-1;
				}
	  		}
		  	if( !exists ) {
		  		var name = "";

		  		if( is_select_methol_all ) {
		  			name = $('#name_employee').val();
		  		} else {
		  			name = $('#employee-box .lists .list-right input[value="' + employees[x] + '"]').next().html()
		  		}

		  		employees_info.push({
				    "id": employees[x],
				    "name": name,
				    "data": [data]
				});

		  		exists = false;
		  	}
	  	}
  	}

  	payroll_logs.removeEmployeeTaskData = function(num, employee_id, payroll_history_id) {

  		var array, deleted = false;

  		if( num != "" ) {
  			array = {
			    "date": $('#tr_' + num + '_' + employee_id + ' td:eq(0)').html(),
			    "task": $('#tr_' + num + '_' + employee_id + ' td:eq(1)').html(),
			    "cost": $('#tr_' + num + '_' + employee_id + ' td:eq(3)').html(),
			    "type_payment": $('#tr_' + num + '_' + employee_id + ' td:eq(4)').html() 
			}
  		} else {
  			array = {
			    "date": $('#tr_' + employee_id + '_' + payroll_history_id + ' td:eq(0)').html(),
			    "task": $('#tr_' + employee_id + '_' + payroll_history_id + ' td:eq(1)').html(),
			    "cost": $('#tr_' + employee_id + '_' + payroll_history_id + ' td:eq(3)').html(),
			    "type_payment": $('#tr_' + employee_id + '_' + payroll_history_id + ' td:eq(4)').html()
			}
  		}

  		for( var i=0; i<=employees_info.length-1; i++ ) {
  			if( employees_info[i]['id'] == employee_id ) {
	  			for( var x=0; x<=employees_info[i]['data'].length-1; x++ ) {
	  				if( payroll_logs.arrays_equal(employees_info[i]['data'][x], array) ) {
	  					employees_info[i]['data'].splice($.inArray(array, employees_info[i]['data'][x]),1);
	  					deleted = true;
  						return false;
	  				}
	  			}
	  			if( deleted ) { return false; }
			}
  		}
  	}

  	payroll_logs.removeAllEmployeeTaskData = function(num) {

  		$('input[name="payroll_log[payroll_histories_attributes][' + num + '][employee_ids][]"]').each(function() {
  			var table_id = $('#tr_' + num + '_' + $(this).val() ).parents('table').attr('id');
  			payroll_logs.removeEmployeeTaskData(num, $(this).val(), '');
  			if ($('#' + table_id + ' >tbody >tr').length == 2){
  				$('#tr_' + num + '_' + $(this).val() ).parents('.accordion-group').remove();
  			}
  			payroll_logs.addEmployeeCounter();
  		});
  	}

  	payroll_logs.arrays_equal = function (a, b) { return !(a<b || b<a); }

  	payroll_logs.setTotal = function(num) {

  		var payment;
  		var hours = parseFloat($('#payroll_log_payroll_histories_attributes_' + num + '_time_worked').val());
  		var id = $('#payroll_log_payroll_histories_attributes_' + num + '_task_id').val();
  		// Search the index where the id are equals
  		var index = $.inArray(id, task_id);
  		// Get the value
  		var cost = parseFloat(task_cost[index]);
  		// Set task_cost (history)
  		$('#payroll_log_payroll_histories_attributes_' + num + '_task_total').val(cost);
  		// Get the type payment selected
  		var type = $('#payroll_log_payroll_histories_attributes_' + num + '_payment_type_id option:selected').text();
  		
  		// Search the type payment and get the value (%)
  		for( var x=0; x<=type_payment.length-1; x++ ) {
  			if( type_payment[x].name === type ) {
		  		payment = parseFloat(type_payment[x].value);
		  		x = type_payment.length-1;
  			}
  		}
  		
  		$('#payroll_log_payroll_histories_attributes_' + num + '_total').val(cost*hours*payment);
  	}

  	payroll_logs.removeTotalRow = function(num, employee_id, payroll_history_id) {

  		var subtotal, total;

  		if( num != "" ) {
  			subtotal = parseFloat($('#tr_' + num + '_' + employee_id + ' td:eq(7)').html().replace(',', ''));
  		} else {
  			subtotal = parseFloat($('#tr_' + employee_id + '_' + payroll_history_id + ' td:eq(7)').html().replace(',', ''));
  		}

  		total = parseFloat($('#total_' + employee_id + ' td:eq(1)').html().replace(',', ''));
  		total = (total-subtotal);
  		$('#total_' + employee_id + ' td:eq(1)').html(resources.prettyNumber(total));
  		payroll_logs.deductToPayrollTotal(subtotal);
  	}

  	payroll_logs.removeAllTotalRows = function(num) {
		$('input[name="payroll_log[payroll_histories_attributes][' + num + '][employee_ids][]"]').each(function() {
			payroll_logs.removeTotalRow(num, $(this).val(), '');
  		});
  	}

  	payroll_logs.cleanEmployeeAlone = function() {
  		
  		if( !$('#select_method_all').is(':checked') ) {
			$('#products_items tr:eq(1) td:eq(' + payroll_logs.employee_td_eq + ') a').hide();
			$('#products_items tr:eq(1) td:eq(' + payroll_logs.employee_td_eq + ') input').each(function() {
				$(this).val('');
				$(this).attr( "disabled", "disabled" );
			});
			$('#employee-box').css("display", "block");
			$('#filter-controls input:checkbox').css("display", "");
			$('#filter-controls input:checkbox').next().css("display", "");
  		} else {
  			$('#products_items tr:eq(1) td:eq(' + payroll_logs.employee_td_eq + ') a').show();
			$('#products_items tr:eq(1) td:eq(' + payroll_logs.employee_td_eq + ') input').each(function() {
				$(this).removeAttr( "disabled", "disabled" );
			});
			$('#employee-filter').css("display", "none");
			$('#employee-box').css("display", "none");
			$('#filter-controls input:checkbox').css("display", "none");
			$('#filter-controls input:checkbox').next().css("display", "none");
  		}
	}

	payroll_logs.addToPayrollTotal = function(num) {
		var total = parseFloat($('#payroll_total').html().replace(',', ''));
		$('#payroll_total').html(resources.prettyNumber(total + num));
	}

	payroll_logs.deductToPayrollTotal = function(num) {
		var total = parseFloat($('#payroll_total').html().replace(',', ''));
		$('#payroll_total').html(resources.prettyNumber(total - num));
	}

	payroll_logs.addEmployeeCounter = function() {
		var oldCount = $('#accordion .accordion-group').length;
		$('#employee_counter').html(oldCount);
	}

	payroll_logs.cleanEmployeeAlone();

  	// Search Employee

  	$('#search_name_employee').keyup(function() {
  		return payroll_logs.searchAll( $('#search_name_employee').val(), $('#search_employee_payroll_logs_path').val(), "employees" );
  	});

  	$("#search_employee_results").on("click", ".pag a", function() {
    	$.getScript(this.href);
		return false;
  	});
  	
  	$("#search_employee_results").on("click", "table tr a", function(e) {
  		$('#name_employee').val( $(this).html() );
  		payroll_logs.setEmployeeId( $(this).next().val() ); // Id Employee
  		$('#employeeModal button:eq(2)').trigger('click');
  		e.preventDefault();
  	});

	$('#clear_employee').click(function() {
  		$('#search_name_employee').val('');
		payroll_logs.searchAll( $('#search_name_employee').val(), $('#search_employee_payroll_logs_path').val(), "employees" );
	});  	
	
	// Search Tasks

	$('#search_task_form input').keyup(function() {
    	return payroll_logs.search( $('#search_task_name').val(), $('#search_task_payroll_logs_path').val(), "task" );
  	});

  	$("#search_task_results").on("click", ".pag a", function() {
    	$.getScript(this.href);
		return false;
  	});

  	$("#search_task_results").on("click", "table tr a", function(e) {
  		$('#load_task').val( $(this).html() );
    	payroll_logs.setTaskCode( $(this).next().val() );
    	$('#taskModal button:eq(2)').trigger('click');
  		e.preventDefault();
  	});

  	$('#clear_task').click(function() {
  		$('#search_task_name').val('');
  		payroll_logs.searchAll( $('#search_task_name').val(), $('#search_task_payroll_logs_path').val(), "task" );
	});

  	// Search Costs

  	$('#search_cost_form input').keyup(function() {
    	return payroll_logs.search( $('#search_cost_name').val(), $('#search_cost_payroll_logs_path').val(), "cost" );
  	});

  	$("#search_cost_results").on("click", ".pag a", function() {
    	$.getScript(this.href);
		return false;
  	});
  	
  	$("#search_cost_results").on("click", "table tr a", function(e) {
  		$('#load_centro_de_costo').val( $(this).html() );
    	payroll_logs.setCostCode( $(this).next().val() );
    	$('#payrollModal button:eq(2)').trigger('click');
  		$('#products_items tr.items_purchase_orders_form:eq(0)').find('#search_cost_code_').focus();
  		e.preventDefault();
  	});

  	$('#clear_cost').click(function() {
  		$('#search_cost_name').val('');
		payroll_logs.searchAll( $('#search_cost_name').val(), $('#search_cost_payroll_logs_path').val(), "cost" );
  	});

  	// Delete a Row - Employee (local)

  	$('#accordion').on("click", ".alert-info button", function() {

  		var num = $(this).next().val();					// Number
  		var employee_id = $(this).next().next().val();	// Employee_id
  		var table_id = $(this).parents('table').attr('id'); //Table id
  		
  		if( $("tr[id^='tr_" + num + "_']").length == 1 ) {
  			
  			$('#payroll_log_payroll_histories_attributes_' + num + '__destroy').val(1);
			var deletedRow = $('#payroll_log_payroll_histories_attributes_' + num + '__destroy').closest('.success');
			deletedRow.removeClass('success').addClass('deleted').hide();
			if ($('#' + table_id + ' >tbody >tr').length == 2){
				$(this).parents('.accordion-group').remove();
  			}
  			payroll_logs.addEmployeeCounter();
  		}
  		
		payroll_logs.removeEmployeeTaskData(num, employee_id, "");
		payroll_logs.removeTotalRow(num, employee_id, "");
  		$('#tr_' + num + '_' + employee_id).remove();
  		$("input[name='payroll_log[payroll_histories_attributes][" + num + "][employee_ids][]'][value='" + employee_id + "']").remove();
  		payroll_logs.addEmployeeCounter();
  	});

  	// Delete a Row - Employee (server)

  	$('#accordion').on("click", "tr:not(.alert-info) button", function() {
  		
  		var employee_id = $(this).next().val();					// employee_id
  		var payroll_history_id = $(this).next().next().val();	// payroll_history_id
  		
  		$.ajax({
			type: "GET",
			url: "/payroll_logs/delete_employee_to_payment",
			dataType: "json",
	        data: {
	        	employee_id : employee_id,
	        	payroll_history_id : payroll_history_id
	        },
	        success: function(msg) {
	        	// Remove the row from the table
	        	payroll_logs.removeEmployeeTaskData("", employee_id, payroll_history_id);
	        	payroll_logs.removeTotalRow("", employee_id, payroll_history_id);
  				$('#tr_' + employee_id + '_' + payroll_history_id).remove();
  				resources.PNotify('Planilla', "Borrado con exito", 'success');
	        },
			error: function(response, textStatus, errorThrown) {
				resources.PNotify('Planilla', "Error al intentar borrar el registro", 'danger');
			}
      	});
  	});
  	
}));