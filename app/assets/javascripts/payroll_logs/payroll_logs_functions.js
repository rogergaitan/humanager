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
				$('.success td:eq(0) input:hidden').val( task_id[index] );
				$('#load_task').val( task_desc[index] );
				return false;
			}

			if( task_code.length-1 == index ) {
				$('div#message').html('<div class="alert alert-error">Codigo no fue encontrado</div>');
				$('div.alert.alert-error').delay(4000).fadeOut();
				$('.success td:eq(0) input:hidden').val( task_id[0] );
				$('#load_task').val( task_desc[0] );
				payroll_logs.setTaskCode( task_id[0] );
			}
		});
	}

	payroll_logs.setTaskCode = function(id) {
		
		$.each(task_id, function(index, value) {
			if( value == id ) {
				$("#search_task_code_").val( task_code[index] );
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
		
		$('#employee_table_'+employee_id).append('<tr id="tr_' + num + '_' + employee_id +'" class="tr_info">' +
													'<td>'+ date +'</td>' +
													'<td>'+ task +'</td>' +
													'<td>'+ mount +'</td>' +
													'<td>'+ cost +'</td>' +
													'<td>'+ payment +'</td>' +
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
					'<td>Fecha</td><td>Labor</td><td>Cantidad</td><td>Centro de Costos</td><td>Tipo de Pago</td><td>Accion</td>'+
				'</tr></thead>'+
			'<tbody></tbody></table></div></div></div>');
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
  			
  			$('#payroll_log_payroll_histories_attributes_' + num + '__destroy').val(1)
			var deletedRow = $('#payroll_log_payroll_histories_attributes_' + num + '__destroy').closest('.success');
			deletedRow.removeClass('success').addClass('deleted').hide();
  		}

  		$('#tr_' + num + '_' + employee_id).remove();
  		$("input[name='payroll_log[payroll_histories_attributes][" + num + "][employee_ids][]'][value='" + employee_id + "']").remove();
  	});

  	// Delete a Row - Employee (server)

  	$('#accordion').on("click", "tr:not(.tr_info) button", function() {
  		alert('hola');
  	});
  	

}));