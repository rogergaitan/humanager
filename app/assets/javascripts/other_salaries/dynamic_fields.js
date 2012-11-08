function ledger_account_Selected() {
  var iaccount = $('#other_salary_ledger_account_id').val(); // OBTENGO EL VALOR SELECCIONADO DEL DROPDOWN
 // $('#other_salary_ledger_account_id').find('option').remove(); // SE ELIMINAN LOS VALORES
  alert(iaccount);
  $(cuentas).each(function() {
    if (this[1] == iaccount) { //el this[1] es el id d la cuenta en este caso iaccount y this[2] es el naccount q es lo q va a mostrar
      $('#other_salary_ledger_account_id').append("<option value='" + this[1] + "'>" + this[2] + "</option>");
      alert(this[1]);
      options[options.length] = new Option(state[1], state[2]);
    } 
  });
}

$(document).ready(function() {
  ledger_account_Selected();
  $('#other_salary_ledger_account_id').change(ledger_account_Selected);
})