$(document).ready(function(){
	DatePicker();
});

function DatePicker(){
	 $("#payroll_start_date").datepicker({
			format: 'dd/mm/yyyy',
    	autoclose: true,
    	language: "es"
		});
	 $("#payroll_end_date").datepicker({
			format: 'dd/mm/yyyy',
	    autoclose: true,
	    language: "es"
		});
	 $("#payroll_payment_date").datepicker({
			format: 'dd/mm/yyyy',
	    autoclose: true,
	    language: "es"
		});
}
