payroll_logs = {
	search_length : 3
}

$(jQuery(document).ready(function($) {

	payroll_logs.reloadSelectorsEvents = function() {

		$('.success td:eq(4) select').addClass('input-medium');

		// Task
		$("#search_task_code_").focusout(function() {
			payroll_logs.searchTaskCode( $(this).val() );
		});

		// Cost
		$('#search_cost_code_').focusout(function() {
			payroll_logs.searchCostCode( $(this).val() );
		});

		payroll_logs.searchAll( $('#search_task_name').val(), "/payroll_logs/search_task", "task" );
		payroll_logs.searchAll( $('#search_cost_name').val(), "/payroll_logs/search_cost", "cost" );
	}

	// Task
	payroll_logs.searchTaskCode = function(code) {
		
		$.each(task_code, function(index, value) {
			if( value === code ) {
				$('.success td:eq(0) input:hidden:eq(0)').val( task_id[index] );
				$('.success td:eq(0) input:hidden:eq(1)').val( task_unidad[index] );
				$('#load_task').val( task_desc[index] );
				return false;
			}

			if( task_code.length-1 == index ) {
				$('div#message').html('<div class="alert alert-error">Codigo no fue encontrado</div>');
				$('div.alert.alert-error').delay(4000).fadeOut();
				$('.success td:eq(0) input:hidden:eq(0)').val( task_id[0] );
				$('.success td:eq(0) input:hidden:eq(1)').val( task_unidad[0] );
				$('#load_task').val( task_desc[0] );
				payroll_logs.setTaskCode( task_id[0] );
			}
		});
	}

	payroll_logs.setTaskCode = function(id) {
		
		$.each(task_id, function(index, value) {
			if( value == id ) {
				$("#search_task_code_").val( task_code[index] );
				$('.success td:eq(0) input:hidden:eq(0)').val( task_id[index] );
				$('.success td:eq(0) input:hidden:eq(1)').val( task_unidad[index] );
				return false;
			}
		});
	}

	// Cost
	payroll_logs.searchCostCode = function(code) {

		$.each(cost_code, function(index, value) {
			if( value === code ) {
				$('.success td:eq(2) input:eq(1)').val(cost_id[index]);		//hidden (id)
				$('.success td:eq(2) input:eq(2)').val(cost_desc[index]);	//text (description)
				return false;
			}

			if( cost_code.length-1 === index ) {
				$('div#message').html('<div class="alert alert-error">Codigo no fue encontrado</div>');
				$('div.alert.alert-error').delay(4000).fadeOut();
				$('.success td:eq(2) input:eq(1)').val(''); //hidden (id)
				$('#search_cost_code_').val(''); 			//text (code)
				$('.success td:eq(2) input:eq(2)').val(''); //text (description)
			}
		});
	}

	payroll_logs.setCostCode = function(id) {
		$.each(cost_id, function(index, value) {
			if( value == id ) {
				$("#search_cost_code_").val(cost_code[index]);
				$('.success td:eq(2) input:eq(1)').val(cost_id[index]);
				return false;
			}
		});
	}

	// Employees add Details
	payroll_logs.addDetailsToEmployee = function(num, employee_id) {

		if ( !$('#employee_table_'+employee_id).length ) {
			payroll_logs.addNewSelection( num, employee_id );
		}
		
		payroll_logs.addNewColumn( num, employee_id );
	}

	payroll_logs.addNewColumn = function(num, employee_id) {

		var date = $('#payroll_log_payroll_date').val();
		var task = $('#payroll_log_payroll_histories_attributes_' + num + '_task_id').next().val()
		var mount = $('#payroll_log_payroll_histories_attributes_' + num + '_time_worked').val();
		var cost = $('#payroll_log_payroll_histories_attributes_' + num + '_centro_de_costo_id').next('input').val();
		var payment = $('#payroll_log_payroll_histories_attributes_' + num + '_payment_type option:selected').html();
		var totalRow = parseFloat($('#payroll_log_payroll_histories_attributes_' + num + '_total').val());
		var subTotal = parseFloat($('#total_' + employee_id + ' td:eq(1)').html());
		$('#total_' + employee_id + ' td:eq(1)').html((totalRow + subTotal));
		
		$('#employee_table_'+employee_id+' #total_'+employee_id).before('<tr id="tr_' + num + '_' + employee_id +'" class="tr_info">' +
													'<td>'+ date +'</td>' +
													'<td>'+ task +'</td>' +
													'<td>'+ mount +'</td>' +
													'<td>'+ cost +'</td>' +
													'<td>'+ payment +'</td>' +
													'<td>'+ totalRow  +'</td>' +
													'<td>' +
														'<button type="button" class="btn btn-mini btn-danger">remove</button>' +
														'<input type="hidden" value="' + num + '"  />' +
														'<input type="hidden" value="' + employee_id + '"  />' +
													'</td>' +
												'</tr>');
	}

	payroll_logs.addNewSelection = function(num, employee_id) {
		
		var total = $('#accordion div.accordion-group').length + 1;
		var name = $('#employee_'+employee_id).next().html();

		$('#accordion').append(
			'<div class="accordion-group">'+
			'<div class="accordion-heading">'+
				'<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapse'+total+'">'+name+'</a>'+
			'</div>'+
			'<div id="collapse'+total+'" class="accordion-body collapse" style="height: 0px; "><div class="accordion-inner">'+
			'<table class="table table-hover table-bordered table-striped" id="employee_table_'+employee_id+'">'+
				'<thead><tr>'+
					'<td>Fecha</td><td>Labor</td><td>Cantidad</td><td>Centro de Costos</td><td>Tipo de Pago</td><td>Total</td><td>Accion</td>'+
				'</tr></thead>'+
			'<tbody>'+
			'<tr id="total_'+employee_id+'">'+
					'<td colspan="5" class="align_right">Total:</td>'+
					'<td colspan="2">00.00</td>'+
				'</tr>'+
			'</tbody></table></div></div></div>');
	}

  	payroll_logs.search = function(name, url, type) {
		
		var d = {};

		if( name.length >= payroll_logs.search_length ) {

			if( type == 'cost' ) {
				d = { search_cost_name: name };
			} 
			if( type == 'task' ) {
				d = { search_task_name: name };
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
			d = { search_cost_name: name };
		} 
		if( type == 'task' ) {
			d = { search_task_name: name };
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

  	payroll_logs.validateEmployeeTask = function(num) {

  		var v_cost, v_date, v_task, v_payment_type, username, id;
  		var b_cost, b_date, b_task, b_payment_type, exists = false;
  		var result, data, employee_id = new Array();
  		v_cost = $('#load_centro_de_costo').val();
  		v_date = $('#payroll_log_payroll_date').val();
  		v_task = $('#load_task').val();
  		v_payment_type = $('#payroll_log_payroll_histories_attributes_' + num + '_payment_type').val();

  		data = {
			"date": v_date,
		    "task": v_task,
		    "cost": v_cost,
		    "type_payment": v_payment_type
		};

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
				if( exists ) { return false; }
  			} // End for employees id
  			if( exists ) { return false; }
		}); // End each selector ids

		if( exists ) {
			return result = { "status": true, "username": username };
		} else {
			payroll_logs.addEmployeeTaskData(data, employee_id);
			return result = { "status": false, "username": username };
		}
  	}

  	payroll_logs.addEmployeeTaskData = function(data, employees) {

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
		  		employees_info.push({
				    "id": employees[x],
				    "name": $('#employee-box .lists .list-right input[value="' + employees[x] + '"]').next().html(),
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
  			payroll_logs.removeEmployeeTaskData(num, $(this).val(), '');
  		});
  	}

  	payroll_logs.arrays_equal = function (a, b) { return !(a<b || b<a); }

  	payroll_logs.setTotal = function(num) {

  		var hours, cost, id, index, type, payment;

  		hours = parseFloat($('#payroll_log_payroll_histories_attributes_' + num + '_time_worked').val());
  		id = $('#payroll_log_payroll_histories_attributes_' + num + '_task_id').val();
  		// Search the index where the id are equals
  		index = $.inArray(id, task_id);
  		// Get the value
  		cost = parseFloat(task_cost[index]);
  		// Set task_cost (history)
  		$('#payroll_log_payroll_histories_attributes_' + num + '_task_total').val(cost);
  		// Get the type payment selected
  		type = $('#payroll_log_payroll_histories_attributes_' + num + '_payment_type').val();
  		
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
  			subtotal = parseFloat($('#tr_' + num + '_' + employee_id + ' td:eq(5)').html());
  		} else {
  			subtotal = parseFloat($('#tr_' + employee_id + '_' + payroll_history_id + ' td:eq(5)').html());
  		}

  		total = parseFloat($('#total_' + employee_id + ' td:eq(1)').html());
  		total = (total-subtotal);
  		$('#total_' + employee_id + ' td:eq(1)').html(total);
  	}

  	payroll_logs.removeAllTotalRows = function(num) {

		$('input[name="payroll_log[payroll_histories_attributes][' + num + '][employee_ids][]"]').each(function() {
			payroll_logs.removeTotalRow(num, $(this).val(), '');
  		});  		
  	}

	// Search Tasks

	$('#search_task_form input').keyup(function() {
    	return payroll_logs.search( $('#search_task_name').val(), "/payroll_logs/search_task", "task" );
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
  		payroll_logs.searchAll( $('#search_task_name').val(), "/payroll_logs/search_task", "task" );
	});

  	// Search Costs

  	$('#search_cost_form input').keyup(function() {
    	return payroll_logs.search( $('#search_cost_name').val(), "/payroll_logs/search_cost", "cost" );
  	});

  	$("#search_cost_results").on("click", ".pag a", function() {
    	$.getScript(this.href);
		return false;
  	});
  	
  	$("#search_cost_results").on("click", "table tr a", function(e) {
  		$('#load_centro_de_costo').val( $(this).html() );
    	payroll_logs.setCostCode( $(this).next().val() );
    	$('#payrollModal button:eq(2)').trigger('click');
  		e.preventDefault();
  	});

  	$('#clear_cost').click(function() {
  		$('#search_cost_name').val('');
		payroll_logs.searchAll( $('#search_cost_name').val(), "/payroll_logs/search_cost", "cost" );
  	});

  	// Delete a Row - Employee (local)

  	$('#accordion').on("click", ".tr_info button", function() {

  		var num = $(this).next().val();					// Number
  		var employee_id = $(this).next().next().val();	// Employee_id
  		
  		if( $("tr[id^='tr_" + num + "_']").length == 1 ) {
  			
  			$('#payroll_log_payroll_histories_attributes_' + num + '__destroy').val(1);
			var deletedRow = $('#payroll_log_payroll_histories_attributes_' + num + '__destroy').closest('.success');
			deletedRow.removeClass('success').addClass('deleted').hide();
  		}
  		
		payroll_logs.removeEmployeeTaskData(num, employee_id, "");
		payroll_logs.removeTotalRow(num, employee_id, "");
  		$('#tr_' + num + '_' + employee_id).remove();
  		$("input[name='payroll_log[payroll_histories_attributes][" + num + "][employee_ids][]'][value='" + employee_id + "']").remove();
  	});

  	// Delete a Row - Employee (server)

  	$('#accordion').on("click", "tr:not(.tr_info) button", function() {
  		
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
  				$('div#message').html('<div class="alert alert-info">Borrado con exito</div>');
				$('div.alert.alert-error').delay(4000).fadeOut();
	        },
			error: function(response, textStatus, errorThrown) {
				$('div#message').html('<div class="alert alert-error">Error al intentar borrar el registro</div>');
				$('div.alert.alert-error').delay(4000).fadeOut();
			}
      	});
  	});
  	
}));