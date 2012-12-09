$(document).ready(function(){

	index();

	$('#seleccion').click(Reactivar);
  $('#cerrar').click(Cerrar);
	$('#chkTodos').click(MarcarTodosIniciadas);

});

//consulta los datos de las planillas activas y inactivas
 function index(){
    $.getJSON('payrolls/get_activas', function(resultado) {
      $('table#activas > tbody').empty();
      $(resultado.activa).each(function() { add_activas(this, 'table#activas')});
    });

    $.getJSON('payrolls/get_inactivas', function(resultado) {
      $('table#inactivas > tbody').empty();
      $(resultado.inactiva).each(function() { add_inactivas(this, 'table#inactivas')});
    });
 }

//carga las planillas activas en una tabla
 function add_activas(payroll, target_table)
  {
    var row = $(target_table + '> tbody:last').append('<tr>' + 
        '<td><a href="/payrolls/'+ payroll.id +'">'+ payroll.id +'</a></td>' +
        '<td>' + payroll.payroll_type.description + '</td>' +
        '<td>' +  payroll.start_date + '</td>' +
        '<td>' +  payroll.end_date + '</td>' +
        '<td>' +  payroll.payment_date + '</td>' +
        '<td> <input type="checkbox" class="ckActivas" id="'+payroll.id+'" value="'+payroll.id+'" /> </td>' +
        '<td><a href="/payrolls/' + payroll.id +'/edit" class="btn btn-mini" ' +
        'data-method="get" rel="nofollow">Editar</a>' +
       '<a href="/payrolls/'+payroll.id +'" class="btn btn-mini btn-danger" ' +
        'data-confirm="¿Está seguro(a) que desea eliminar la planilla?" data-method="delete" rel="nofollow">Eliminar</a></td>' +
      '</tr>');
    return row;
  }

//carga las planillas inactivas en una tabla
 function add_inactivas(payroll, target_table)
  {
    var row = $(target_table + '> tbody:last').append('<tr>' + 
    	
        '<td><a href="/payrolls/'+ payroll.id +'">'+ payroll.id +'</a></td>' +
        '<td>' + payroll.payroll_type.description + '</td>' +
        '<td>' +  payroll.start_date + '</td>' +
        '<td>' +  payroll.end_date + '</td>' +
        '<td>' +  payroll.payment_date + '</td>' +
        '<td> <input type="checkbox" class="ck" id="'+payroll.id+'" value="'+payroll.id+'" /> </td>' +
      '</tr>');
    return row;
  }

  //reabre planillas cerradas
  function Reactivar(){
    if (Confirmar() == true) {
      var planillas = new Array();
      $('#inactivas tbody tr td:nth-child(6) .ck').each(function () {
        if ($(this).is(":checked")){
          planillas.push($(this).val());
        };
      });

      $.ajax({
        type: "POST",
        url: "/payrolls/reabrir",
        data: { reabrir_planilla: JSON.stringify(planillas) },
        success: function() { index(); }
      });
    };
}

//cierra una o un conjunto de planillas
 function Cerrar(){
  if (Confirmar() == true) {
    var planillas = new Array(); //hago un each de la 6ta columna d la tabla y guardo los chequeados en un arreglo
    $('#activas tbody tr td:nth-child(6) .ckActivas').each(function () {
      if ($(this).is(":checked")){
        planillas.push($(this).val());
      };
    });

    $.ajax({
      type: "POST",
      url: "/payrolls/cerrar_planilla",
      data: { cerrar_planilla: JSON.stringify(planillas) },
      success: function() { index(); }
    });
  };
}

//marca o desmarca todos los checkbox de planillas iniciadas
function MarcarTodosIniciadas(){
    if($(this).is(":checked")) {
	 	$(".ckActivas:checkbox:not(:checked)").attr("checked", "checked");
	}else{
		$(".ckActivas:checkbox:checked").removeAttr("checked");
	}
}

//confirma una accion a ejecutar por el usuario
function Confirmar(){
  var resp = confirm("Realmente desea ejecutar esta acción ?");
  return resp;
}