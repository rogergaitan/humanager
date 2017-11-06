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

  var input = $('#messages_to_employees');
  var display = $('#char-count');
  var count = input.val().length
  var limit = 230;

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
    resources.PNotify('Atención!', 'Por favor selecione una planilla.', 'error');
    return false;
  }

  var numberEmployees = $('#ms-deduction_employee_ids .ms-selection li.ms-selected').length;

  if( numberEmployees == 0) {
    resources.PNotify('Atención!', 'Por favor selecione los empleados.', 'error');
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

  $('#ms-deduction_employee_ids .ms-selection li.ms-selected').each(function() {
    var id = $(this).attr('id').replace('-selection','');
    employees.push(id);
  });

  window.open(url + '/' + payroll_id + '.pdf'
                + '?type=' + type
                + '&employees=' + employees
                + '&payroll_id=' + payroll_id
                + '&msg=' + msg
              );
}
