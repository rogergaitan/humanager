$(document).ready(function(){

	$('#planilla').hide();
	treeviewhr.cc_tree(cuenta_credito, true);
  	$('.expand_tree').click(treeviewhr.expand);

  	  $('#list').on({
		click: set_account,
		mouseenter: function() {
			$(this).css("text-decoration", "underline");
		},
		mouseleave: function() {
			$(this).css("text-decoration", "none");
		}}, ".node_link");

  	 //en caso de que exista algun error al cargar las planillas si se preciona click en el enlase para volver a cargarlas
  	$("#error a").click(function (e){
	e.preventDefault();
	ObtenerPlanillas();
	});

	TipoDeduccion();
  	$('#deduction_deduction_type').change(TipoDeduccion);

  	$('#activas tbody tr td a').click(function(e) {
  		set_payroll();
  	});

});

//settea el campo oculto con el id d la cuenta de credito y muestra el texto en el campo cuenta credito
function set_account(e) {
    e.preventDefault();
    var accountId = $(this).closest('li').data('id');
    var accountName = $(this).text();
    $('#deduction_ledger_account_id').val(accountId);
    $('#deduction_ledger_account').val(accountName);  
}

function TipoDeduccion(e) {
	if ($('#deduction_deduction_type').val() == 'unica'){
		$('#btnModalPayroll').show();
		$('#planilla').show();
		ObtenerPlanillas();
	}
	else{
		$('#btnModalPayroll').hide();
		$('#planilla').hide();
	}
}

//Obtiene las planillas activas
function ObtenerPlanillas(){
    $.ajax('/payrolls/get_activas', {
    	type: 'GET',
    	timeout: 8000,

    	beforeSend: function() {
		$('#error').hide();
		$('#loading').show();
		},

		complete: function() {
		$('#loading').hide();
		},

    	success: function(result) {
    	$('table#activas > tbody').empty();
      	$(result.activa).each(function() { add_activas(this, 'table#activas')});
    	},

    	error: function(result) {
		$('#error').show();
		}
	});
}

//carga las planillas activas en una tabla
 function add_activas(payroll, target_table)
  {
    var row = $(target_table + '> tbody:last').append('<tr>' + 
        '<td>' + payroll.id +'</td>' +
        '<td><a href="#">' + payroll.payroll_type.description +'</a></td>' +
        '<td>' +  payroll.star_date + '</td>' +
        '<td>' +  payroll.end_date + '</td>' +
        '<td>' +  payroll.payment_date + '</td>' +
      '</tr>');
    return row;
  }

function set_payroll(e) {
    e.preventDefault();
    var payrollId = $('#activas tbody tr td:nth-child(1)').data('id');// $(this).closest('li').data('id');
    var payrollName = $('#activas tbody tr:eq(3) a').text();
    $('#deduction_payroll_ids_').val(payrollId);
    $('#deduction_payroll').text(payrollName);  
}