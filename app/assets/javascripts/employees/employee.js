$(document).ready(function($) {
  
  $('.telephone-field').mask('0000-0000');
  
  $('#employee_wage_payment').mask("FNNNNNNNNN.NN", {
    translation: {
      'N': {pattern: /\d/, optional: true},
      "F": {pattern: /[1-9]/}
    }
  });
  
  $("#employee_social_insurance").mask("00000000000000000000");
  $("#employee_account_bncr").mask("00000000000000000000");
  
  window.Parsley
    .addValidator("joinDate", {
      validateString: function () {
       var currentDate = new Date();
       var selectedDate = $("#employee_join_date").datepicker("getDate");
  
       if(selectedDate > currentDate) {
         return false;                  
       } else {
         return true;
       }
      },
      messages: {
        es: "Fecha de ingreso no puede ser despues de la fecha actual."
      }
    });
    
  

});
