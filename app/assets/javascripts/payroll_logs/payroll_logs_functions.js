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
				alert('Codigo no fue encontrado');
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
				alert('Codigo no fue encontrado');
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
			payroll_logs.addNewSelection(num, employee_id);
		}
		
		payroll_logs.addNewColumn(num, employee_id);
	}

	payroll_logs.addNewColumn = function(num, employee_id) {

		var date = $('#payroll_log_payroll_date').val();
		var task = $('#payroll_log_payroll_histories_attributes_'+num+'_task_id').next().val()
		var mount = $('#payroll_log_payroll_histories_attributes_'+num+'_time_worked').val();
		var cost = $('#payroll_log_payroll_histories_attributes_'+num+'_centro_de_costo_id').next('input').val();
		var payment = $('#payroll_log_payroll_histories_attributes_'+num+'_payment_type option:selected').html();
		
		$('#employee_table_'+employee_id).append('<tr class="tr_info">' +
													'<td>'+date+'</td>' +
													'<td>'+task+'</td>' +
													'<td>'+mount+'</td>' +
													'<td>'+cost+'</td>' +
													'<td>'+payment+'</td>' +
													'<td>delete</td>' +
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

	// Search Tasks

	$('#search_task_form input').keyup(function() {
    	return payroll_logs.search_task();
  	});

  	payroll_logs.search_task = function() {
		
		var name;
		name = $('#search_task_name').val();

		if( name.length >= payroll_logs.search_length ) {
			return $.ajax({
				url: "/payroll_logs/search_task",
				dataType: "script",
				data: {
					search_task_name: name,
				}
			});
		}
  	}

  	$("#search_task_results").on("click", ".pag a", function() {
    	$.getScript(this.href);
		return false;
  	});

  	// Search Costs

}));