$(document).ready(function(){
	DatePicker();
});

function DatePicker(){
	 $("#payroll_start_date").datepicker({
			format: 'dd/mm/yyyy'
		});
	 $("#payroll_end_date").datepicker({
			format: 'dd/mm/yyyy'
		});
	 $("#payroll_payment_date").datepicker({
			format: 'dd/mm/yyyy'
		});
}
