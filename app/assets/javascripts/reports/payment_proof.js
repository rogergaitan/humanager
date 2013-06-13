reports_payment_proof = { }

$(document).ready(function() {

  $('#payrolls_results').on('click', 'input', function() {

    if( $('#payrolls_results input:checked').length === 1 ) {
      $('#payrolls_results input').attr('disabled','disabled');
      $('#payrolls_results input:checked').removeAttr('disabled','disabled');
    } else {
      $('#payrolls_results input').removeAttr('disabled','disabled');
    }
  });

  $('#btn_create').click(reports_payment_proof.validate_data);

  var input = $('#messages_to_employees'), display = $('#char-count'), count = 0, limit = 320;

  count = input.val().length
  remaining = limit - count
  update(remaining);

  input.keyup(function(e) {
    count = $(this).val().length;
    remaining = limit - count;

    update(remaining);
  });

  function update(count) {
    var txt = ( Math.abs(count) === 1 ) ? count + ' Carácteres restantes' :  count + ' Carácteres restantes'
    display.html(txt);
  }

});

reports_payment_proof.validate_data = function(e) {

  // Validation
  if( $('#payrolls_results input:checked').length === 0 ) {
    $('div#message').html('<div class="alert alert-error">Por favor selecione una planilla</div>');
    $('div.alert.alert-error').delay(4000).fadeOut();
    return false;
  }

  var numberEmployees = $('div.employees-list.list-right input').length;
  var employeesChecked = $('div.employees-list.list-right input[type=checkbox]').is(':checked');
  var rowIsDisabled = $('#products_items tr:eq(1) td:first select').is(':disabled');
    
  if( (numberEmployees == 0 || employeesChecked == false) && (rowIsDisabled == false) ) {
    $('div#message').html('<div class="alert alert-error">Por favor selecione los empleados</div>');
    $('div.alert.alert-error').delay(4000).fadeOut();
    return false;
  }

  reports_payment_proof.create_pdf();
}

reports_payment_proof.create_pdf = function() {
  
  var url = $('#show_reports_path').val();
  var payroll_id = $('#payrolls_results input:checked').val();
  var type = $('#type_report').val();
  var msg = $('#messages_to_employees').val();
  var employees = [];

  $('div.employees-list.list-right input[type=checkbox]:checked').each(function() {
    employees.push($(this).val());
  });

  window.open(url + '/' + payroll_id + '.pdf'
                + '?type=' + type
                + '&employees=' + employees
                + '&payroll_id=' + payroll_id
                + '&msg=' + msg
              );
}