$(document).ready(function(){
	DatePicker();
  
  window.Parsley
  .addValidator("startDateValidation", {
    validateString: function (value, requirement, instance) {
      var startDate = $("#payroll_start_date").datepicker("getDate");
      var endDate = $("#payroll_end_date").datepicker("getDate");
      
      if(startDate >= endDate) {
        return false;
      }
    },
    
    messages: {
      es: "Fecha inicio no puede ser luego de fecha hasta."
    }
  });
  
  window.Parsley
    .addValidator("paymentDateValidation", {
      validateString: function (value, requirement, instance) {
        var paymentDate = $("#payroll_payment_date").datepicker("getDate");
        var endDate = $("#payroll_end_date").datepicker("getDate");
        
        if(endDate > paymentDate) {
          return false;
        }
      },
      
      messages: {
        es: "Fecha hasta no puede ser luego de fecha de pago."
      }
    });

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
