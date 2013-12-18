var payroll = {
  total : 0
}

$(document).ready(function() {

  payroll.index();

  $('#seleccion').click(Reactivar);

  // Event click the button to close the payroll
  $('#cerrar').click(function() {

    var id = $('#activas .ckActive:checked').val();
    payroll.closePayrollSelected(id);
  });
	
  // Enable and Disabled the checkbox
  $("#activas").on("change", ".ckActive", function() {
    
    if( $('#activas .ckActive:checked').length === 1 ) {
      $('#activas .ckActive').attr('disabled','disabled');
      $('#activas .ckActive:checked').removeAttr('disabled','disabled');
    } else {
      $('#activas .ckActive').removeAttr('disabled','disabled');
    }
  });

  $("#inactivas").on("click", "[id^='send_firebird_']", function(e) { 

    e.stopPropagation();

    if( payroll.confirm() ) {
      var payroll_id = $(this).next().val();
      payroll.send_to_firebird(payroll_id);
    }
  });
  
  $('#payrollModal').click(function() {
    if ($('#id_sent_to_firebird').val()==1){
      location.reload();
    }
  });

});


// Consulta los datos de las planillas activas y inactivas
// Get the data of active and inactive payrolls
payroll.index = function() {

  var url_get_activas = $('#get_activas_payrolls_path').val();
  var url_get_inactivas = $('#get_inactivas_payrolls_path').val();

  $.getJSON(url_get_activas, function(resultado) {
    var totalCount = resultado.activa.length;
    var count = 0;
    $('table#activas > tbody').empty();
    $(resultado.activa).each(function() { 
      count ++;
      payroll.add_activas(this, 'table#activas', count, totalCount);
    });
  });

  $.getJSON(url_get_inactivas, function(resultado) {

    $('table#inactivas > tbody').empty();
    $(resultado.inactiva).each(function() { 
      payroll.add_inactivas(this, 'table#inactivas');
    });
  });

}

// Carga las planillas activas en una tabla
// Load the active payroll in a table
payroll.add_activas = function (payrolld, target_table, count, totalCount) {
  if( payrolld.payroll_log.payroll_total != null ) {
    payroll.total += parseFloat(payrolld.payroll_log.payroll_total);
  } else {
    payroll.total += parseFloat(0);
  }

  var payroll_destroy = $('#payroll_destroy').val();
  var payroll_update = $('#payroll_update').val();

  var url = $('#tab1').data('url');
  var url_payrolls = $('#payrolls_path').val();
  var row2 = '';
  var pay_total = parseFloat(payrolld.payroll_log.payroll_total)

  var data = '<tr>' + 
      '<td><a href="/payrolls/' + payrolld.id + '">' + payrolld.payroll_type.description + '</a></td>' +
      '<td>' + (payrolld.company != null ? payrolld.company.name : '--' ) + '</td>' +
      '<td>' + date_format(payrolld.start_date) + '</td>' +
      '<td>' + date_format(payrolld.end_date) + '</td>' +
      '<td>' + date_format(payrolld.payment_date) + '</td>' +
      '<td>' + ( payrolld.payroll_log.payroll_total != null ? (pay_total).toFixed(2) : 0.00)  + '</td>' +
      '<td>' +
        '<input type="checkbox" class="ckActive" id="' + payrolld.id + '" value="' + payrolld.id + '" />' +
      '</td><td>';

  if( payroll_update == 1 ) {
    data = data + '<a href="'+ url +'/' + payrolld.payroll_log.id + '/edit" class="btn btn-mini btn-success">Digitar</a> ' + 
      '<a href="'+ url +'/' + payrolld.id +'/edit" class="btn btn-mini" data-method="get" rel="nofollow">Editar</a>';
  }

  if( payroll_destroy == 1 ) {
    data = data + '<a href="'+ url_payrolls +'/' + payrolld.id + '" class="btn btn-mini btn-danger" ' +
     'data-confirm="¿Está seguro(a) que desea eliminar la planilla?" data-method="delete" rel="nofollow">Eliminar</a>';
  }


  data = data + '</td></tr>';
  var row = $(target_table + '> tbody:last').append(data);
  console.log(payrolld);
  if(count == totalCount) {
    row2 = $(target_table + '> tbody:last').append(
      '<tr>' + 
        '<td colspan="4" style="text-align: right;">Total: </td>' +
        '<td colspan="3">' + (payroll.total).toFixed(2) + '</td>' +
      '</tr>'
    );
  }

  return row + row2;
}

// Carga las planillas inactivas en una tabla
// Load the inactive payroll in a table
payroll.add_inactivas = function (payroll, target_table) {

  var num_oper = '';
  var checked = '';
  var send_to_firebird = $('#send_to_firebird').val();

  if (payroll.num_oper != null ) {
    num_oper = payroll.num_oper + ', ' + payroll.num_oper_2;
    checked = 'disabled="disabled"';
  } else {
    if( send_to_firebird == 1 ) {
      num_oper = '<a href="#" id="send_firebird_'+payroll.id+'" class="btn btn-mini btn-danger"'+
      ' data-method="delete" rel="nofollow">Enviar a AgroWin</a>'+
      '<input type="hidden" value="'+payroll.id+'">';
    }
  }
  
  var row = $(target_table + '> tbody:last').append('<tr>' + 
      '<td>' +
        '<a href="/payrolls/' + payroll.id + '">' + payroll.payroll_type.description + '</a>' +
      '</td>' +
      '<td>' + (payroll.company != null ? payroll.company.name : '--' ) + '</td>' +
      '<td>' +  date_format(payroll.start_date) + '</td>' +
      '<td>' +  date_format(payroll.end_date) + '</td>' +
      '<td>' +  date_format(payroll.payment_date) + '</td>' +
      '<td>' + ( payroll.payroll_log.payroll_total != null ? parseFloat(payroll.payroll_log.payroll_total).toFixed(2) : 0.00)  + '</td>' +
      '<td>' +
        '<input type="checkbox" class="ck" id="' + payroll.id + '" value="' + payroll.id + '" '+checked+'/>' +
      '</td>' +
      '<td>' + num_oper +'</td>' +
    '</tr>');
  return row;
}

var date_format;

date_format = function(date) {
  var date1, date2, date_f, date_from, date_t, date_to;
  date_from = (date).split("-");
  date_f = date_from[2] + "-" + date_from[1] + "-" + date_from[0];
    
  return date_f;
};

// Process to close a payroll Selected
payroll.closePayrollSelected = function(payroll_id) {

  var url_close_payroll = $('#close_payroll_payrolls_path').val();

  if( payroll.confirm() ) {
    
    $.ajax({
      type: "POST",
      url: url_close_payroll,
      data: {
        payroll_id: payroll_id
      },
      success: function(data) {
        
        if(data['status']) {
          $('#table_results_close_payroll').hide();
          $('#results_close_payroll').html('La Planilla fue cerrada con exito');
          $('#myModalLabel').html('Mensaje');
          $("#payrollModal").modal('show');
        } else {
          payroll.show_details_erros(data['data']);
        }

      }
    });
  }
}

payroll.show_details_erros = function(data) {

  $('#table_results_close_payroll > tbody').html('');

  $.each(data, function(index, array) {

    $('#table_results_close_payroll > tbody').append(
      '<tr>' +
        '<td>' + array['employee_name'] + '</td>' +
        '<td>' + array['total_salary'] + '</td>' +
        '<td>' + array['total_deductions'] + '</td>' +
      '</tr>'
    );
  });

  $('#myModalLabel').html('Mensaje: Error salario insuficiente');
  $('#table_results_close_payroll').show();
  $("#payrollModal").modal('show');
}

// Process that sends information to firebird
payroll.send_to_firebird = function(payroll_id) {

  $.ajax({
    type: "POST",
    url: "/payrolls/send_to_firebird",
    data: {
      payroll_id: payroll_id
    },
    xhrFields: {
      withCredentials: true
    },
    success: function(data) {
      if(data['status']) {
        $('#table_results_close_payroll').hide();
        var input = '<input type="hidden" id="id_sent_to_firebird" value="1" >';
        $('#results_close_payroll').html('Informacion enviada con exito' + input);
        $('#myModalLabel').html('Mensaje');
        $("#payrollModal").modal('show');
      }
    },
    error: function(data) {
      $('#results_close_payroll').html('Ocurrio un error durante el proceso');
      $('#myModalLabel').html('Mensaje');
      $("#payrollModal").modal('show');
    }
  });
}

// Reabre planillas cerradas
function Reactivar() {

  if (Confirmar() == true ) {
    var planillas = new Array();
    $('#inactivas tbody tr td:nth-child(6) .ck').each(function () {
      if( $(this).is(":checked") ) {
        planillas.push($(this).val());
      };
    });

    $.ajax({
      type: "POST",
      url: "/payrolls/reabrir",
      data: { 
        reabrir_planilla: JSON.stringify(planillas) 
      },
      success: function() { 
        index(); 
      }
    });
  };
}

// Confirm the action to rum the user
payroll.confirm = function () {

  var resp = confirm("Realmente desea ejecutar esta acción ?");
  return resp;
}