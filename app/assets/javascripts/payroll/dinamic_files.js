$(document).ready(function(){
	DateEs();
	DatePicker();
  loadPayrollTypes(tipo_planilla);

  $('#admin').click(expanAdmin);
  $('#campo').click(expanCampo);
  $('#planta').click(expanPlanta);

});

function DatePicker(){
	 $("#payroll_star_date").datepicker();
	 $("#payroll_end_date").datepicker();
	 $("#payroll_payment_date").datepicker();
}

function DateEs(){
      $.datepicker.regional['es'] = {
      closeText: 'Cerrar',
      prevText: '<Ant',
      nextText: 'Sig>',
      currentText: 'Hoy',
      monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
      monthNamesShort: ['Ene','Feb','Mar','Abr', 'May','Jun','Jul','Ago','Sep', 'Oct','Nov','Dic'],
      dayNames: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
      dayNamesShort: ['Dom','Lun','Mar','Mié','Juv','Vie','Sáb'],
      dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','Sá'],
      weekHeader: 'Sm',
      dateFormat: 'dd/mm/yy',
      firstDay: 1,
      isRTL: false,
      showMonthAfterYear: false,
      yearSuffix: ''};
   $.datepicker.setDefaults($.datepicker.regional['es']);
}

function loadPayrollTypes(tree_array, isPopup){
      $(tree_array).each(function(){
           if (this[2] == 'Administrativa') {
            $('#list').append("<li style='list-style:none' id='" + this[0] +"><span  class='node_link'><p><i class='icon-minus'></i>" + 
                 "<a>" + this[1] + "</a>" + "</p></span></li>");
            }

            if (this[2] == 'Campo') {
            $('#listCamp').append("<li style='list-style:none' id='" + this[0] +"> <span class='node_link'><i class='icon-minus'></i>" + 
                 "<a>" + this[1] + "</a>" + "</span></li>");
            }

            if (this[2] == 'Planta') {
            $('#listPlanta').append("<li style='list-style:none' id='" + this[0] +"><span class='node_link'><i class='icon-minus'></i>" + 
                 "<a>" + this[1] + "</a>" + "</span> </li>");
            }
      })
}

function expanAdmin(){
   // $('#admin').children('i').toggleClass('icon-chevron-right icon-chevron-down');
    $("#list").slideToggle("slow");
}
function expanCampo(){
    $("#listCamp").slideToggle("slow");
}
function expanPlanta(){
    $("#listPlanta").slideToggle("slow");
}