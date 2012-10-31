$(document).ready(function() {
  $('#account-fb').click(function() { 
    //$('#account-fb').attr("disabled", true); //desabilito el boton
     $('#account-fb').hide();
     $('#imagen').show();
    $.getJSON('/ledger_accounts/accountfb', function(resultado) {
      $('section.nav').append('<div class="notice">'+ resultado.notice +'</div>'); 
      $(resultado.account).each(function() { add_accounts(this, 'table#account-data')});
      $('#imagen').hide();
    })
  });

  function add_accounts(account, target_table)
  {
    var row = $(target_table + '> tbody:last').append('<tr>' + 
        '<td><a href="/ledger_accounts/'+ account.id +'">'+ account.id +'</a></td>' +
        '<td>' + replace_value(account.ifather) + '</td>' +
        '<td>' + replace_value(account.iaccount) + '</td>' +
        '<td>' + replace_value(account.naccount) + '</td>' +
        '<td><a href="/ledger_accounts/'+ account.id +'" class="btn btn-mini btn-danger" ' +
        'data-confirm="¿Está seguro(a)?" data-method="delete" rel="nofollow">Eliminar</a></td>' +
      '</tr>');
    return row;
  }

  function replace_value(value)
  {
    if (value == null) value = "";
    return value;
  }
})

  $(document).ready(function() {
     $('#imagen').hide();
  });