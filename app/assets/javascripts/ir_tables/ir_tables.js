$('form').submit(function(e) {
  if(!$(this).parsley().validate()) {
    e.preventDefault();
  }
});

$("#ir_table_start_date, #ir_table_end_date").datepicker({
    format: 'dd/mm/yyyy',
    autoclose: true,
    language: "es"
});

$(".mark_for_destruction").hide();

currencyMask();

$("#add_stratus").on("click", function (e) {
  var timestamp = new Date().getTime();
  
  $("tbody").append("<tr>" + 
    "<td><input id=ir_table_ir_table_values_attributes_"+ timestamp +"_from name=ir_table[ir_table_values_attributes]["+ timestamp+"][from]" +
    "data-parsley-from-until-validation required type=text></td>" +
    "<td><input id=ir_table_ir_table_values_attributes_"+timestamp+"_until name=ir_table[ir_table_values_attributes]["+timestamp+"][until] required  type=text></td>" +
    "<td><input id=ir_table_ir_table_values_attributes_"+timestamp+"_base name=ir_table[ir_table_values_attributes]["+timestamp+"][base]  required type=text></td>" +
    "<td><input id=ir_table_ir_table_values_attributes_"+timestamp+"_percent name=ir_table[ir_table_values_attributes]["+timestamp+"][percent] required  type=text></td>" +
    "<td><input id=ir_table_ir_table_values_attributes_"+timestamp+"_excess name=ir_table[ir_table_values_attributes]["+timestamp+"][excess] required  type=text></td>" +
    "<td><a class='btn btn-xs btn-danger-alt delete_stratus'><i class='fa fa-trash-o'></i></a></td>" +
    "</tr>"
  );
});

$("tbody").on("click", ".delete_stratus", function () {
  $(this).parent().parent().remove();
  $(this).next().val(1);
});

$("#is_last").on("click", function () {
  $("input[name$='[until]']").filter(":last").val(9999999999.99);
});

function currencyMask() {
   $("tbody input").mask("FNNNNNNNNN.NN", {
      translation: {
       'N': {pattern: /\d/, optional: true},
       'F': {pattern: /\d/}
      }
  });    
}

window.Parsley
  .addValidator("fromUntilValidation", {
    validateNumber: function (value, requirement, instance) {    
      
      var fromValue = value;
      var untilValue =instance.$element.parent().next().children().val();
      
      if(fromValue >  untilValue) {
        return false;
      }
    },
    
    messages: {
      en: "valor de este campo no puede ser mayor al del campo Hasta."
    }
  });
 
window.Parsley
  .addValidator("startDateValidation", {
    validateString: function (value, requirement, instance) {
      
      var startDate = $("#ir_table_start_date").datepicker("getDate");
      var endDate = $("#ir_table_end_date").datepicker("getDate");
      
      if(startDate > endDate) {
        return false;
      }
    },
    
    messages: {
      en: "Fecha desde no puede ser luego de Fecha hasta."
    }
  });
  
