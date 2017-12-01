$(document).ready(function() {
	DatePicker();
  
  window.Parsley.addValidator("startDateValidation", {
    validateString: function (value, requirement, instance) {
      var startDate = $("#payroll_start_date").datepicker("getDate");
      var endDate = $("#payroll_end_date").datepicker("getDate");
      if(startDate >= endDate) return false;
    },
    messages: {
      es: "Fecha inicio no puede ser luego de fecha hasta."
    }
  });
  
  window.Parsley.addValidator("paymentDateValidation", {
    validateString: function (value, requirement, instance) {
      var paymentDate = $("#payroll_payment_date").datepicker("getDate");
      var endDate = $("#payroll_end_date").datepicker("getDate");
      if(endDate > paymentDate) return false;
    },
    messages: {
      es: "Fecha hasta no puede ser luego de fecha de pago."
    }
  });

  window.Parsley.addValidator("endDateStartDateValidation", {
    validateString: function (value, requirement, instance) {
      var startDate = $("#payroll_start_date").datepicker("getDate");
      var endDate = $("#payroll_end_date").datepicker("getDate");
      if(endDate < startDate) return false;
    },
    messages: {
      es: "Fecha 'hasta' no puede ser antes de fecha 'desde'."
    }
  });

  window.Parsley.addValidator("paymentDateStartDateValidation", {
    validateString: function (value, requirement, instance) {
      var startDate = $("#payroll_start_date").datepicker("getDate");
      var endDate = $("#payroll_end_date").datepicker("getDate");
      if(endDate < startDate) return false;
    },
    messages: {
      es: "La 'fecha de pago' no puede ser antes de fecha 'desde'."
    }
  });

});

var invalidDate = 'Invalid Date';

function DatePicker() {

  $("#payroll_start_date").datepicker({
    format: 'dd/mm/yyyy',
    autoclose: true,
    language: "es",
    startDate: "-1m",
    endDate: "+1m"
  }).on('changeDate', function(e) {
    var date = e.date;
    var endDateSelector = $('#payroll_end_date');
    var paymentDateSelector = $("#payroll_payment_date");

    if(date) {
      date.setDate(date.getDate()+1);
      
      var endDate = endDateSelector.datepicker("getDate");

      endDateSelector.datepicker('setStartDate', date)
                     .prop('disabled', false);

      if(endDate != invalidDate) {
        if(endDate < date) endDateSelector.datepicker('setDates', null);
      }
      
      var paymentDate = paymentDateSelector.datepicker("getDate");

      paymentDateSelector.datepicker('setStartDate', date)
                         .prop('disabled', false);

      if(paymentDate != invalidDate) {
        if(paymentDate < date) paymentDateSelector.datepicker('setDates', null);
      }
    } else {
      endDateSelector.datepicker('setDates', null)
                     .prop('disabled', true);
      paymentDateSelector.datepicker('setDates', null)
                         .prop('disabled', true);
    }
  });

  $("#payroll_end_date").datepicker({
    format: 'dd/mm/yyyy',
    autoclose: true,
    language: "es",
    enableOnReadonly: false
  }).prop('disabled', true);

  $("#payroll_payment_date").datepicker({
    format: 'dd/mm/yyyy',
    autoclose: true,
    language: "es"
  }).prop('disabled', true);
}
