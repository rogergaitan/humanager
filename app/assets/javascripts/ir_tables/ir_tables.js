$("#ir_table_start_date, #ir_table_end_date").datepicker({
    format: 'dd/mm/yyyy',
    autoclose: true,
    language: "es"
});

$(".mark_for_destruction").hide();

$("#add_stratus").on("click", function (e) {
  timestamp = new Date().getTime();
  
  $("tbody").append("<tr>" + 
    "<td><input id=ir_table_ir_table_values_attributes_"+ timestamp +"_from name=ir_table[ir_table_values_attributes]["+ timestamp+"][from]  type=text></td>" +
    "<td><input id=ir_table_ir_table_values_attributes_"+timestamp+"_until name=ir_table[ir_table_values_attributes]["+timestamp+"][until]  type=text></td>" +
    "<td><input id=ir_table_ir_table_values_attributes_"+timestamp+"_base name=ir_table[ir_table_values_attributes]["+timestamp+"][base]  type=text></td>" +
    "<td><input id=ir_table_ir_table_values_attributes_"+timestamp+"_percent name=ir_table[ir_table_values_attributes]["+timestamp+"][percent]  type=text></td>" +
    "<td><input id=ir_table_ir_table_values_attributes_"+timestamp+"_excess name=ir_table[ir_table_values_attributes]["+timestamp+"][excess]  type=text></td>" +
    "<td><a class='btn btn-xs btn-danger-alt delete_stratus'><i class='fa fa-trash-o'></i></a></td>" +
    "</tr>"
  );
});

$("tbody").on("click", ".delete_stratus", function () {
  $(this).parent().parent().hide();
  $(this).next().val(1);
});
