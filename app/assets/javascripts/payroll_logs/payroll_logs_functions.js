payroll_logs = {}

$(jQuery(document).ready(function($) {

	payroll_logs.reloadSelectorsEvents = function(){

		$('.success td:eq(4) select').addClass('input-medium');

		// Task
		$("#search_task_code_").focusout(function(){
			payroll_logs.searchTaskCode( $(this).val() );
		});

		$('.success td:eq(0) select').change(function(){
			payroll_logs.setTaskCode( $(this).val() );
		});

		// Cost
		$('#search_cost_code_').focusout(function(){
			payroll_logs.searchCostCode( $(this).val() );
		});
	}

	//Task
	payroll_logs.searchTaskCode = function(code){
		
		$.each(task_code, function(index, value){
			if( value === code ){
				$('.success td:eq(0) select option[value="'+task_id[index]+'"]').attr('selected', 'selected');
				return false;
			}

			if(task_code.length-1 == index) {
				alert('Codigo no fue encontrado');
				$('.success td:eq(0) select option:eq(0)').attr('selected','selected');
				payroll_logs.setTaskCode( $('.success td:eq(0) select').val() );
			}
		});
	}

	payroll_logs.setTaskCode = function(id){

		$.each(task_id, function(index, value){
			if( value === id ){
				$("#search_task_code_").val(task_code[index]);
				return false;
			}
		});
	}

	//Cost
	payroll_logs.searchCostCode = function(code){

		$.each(cost_code, function(index, value){
			if( value === code) {
				$('.success td:eq(2) input:eq(1)').val(cost_id[index]);		//hidden (id)
				$('.success td:eq(2) input:eq(2)').val(cost_desc[index]);	//text (description)
				return false;
			}

			if(cost_code.length-1 === index){
				alert('Codigo no fue encontrado');
				$('.success td:eq(2) input:eq(1)').val(''); //hidden (id)
				$('#search_cost_code_').val(''); 			//text (code)
				$('.success td:eq(2) input:eq(2)').val(''); //text (description)
			}
		});
	}

	payroll_logs.setCostCode = function(id){

		$.each(cost_id, function(index, value){
			if( value == id ){
				$("#search_cost_code_").val(cost_code[index]);
				return false;
			}
		});
	}

	//Employees add Details
	payroll_logs.addDetailsToEmployee = function(num, employee_id){
		
	}

}));