$(document).ready(function() {

  $('#account-fb').on("click", AllLedgerAccounts );

  $('#error').hide();
  $('#loading').hide();

  treeviewhr.cc_tree(cuenta_contable);
  $('.expand_tree').on('click', treeviewhr.expand);
  $('a[rel=tooltip]').tooltip();

  $("#error a").click(function (e){
    e.preventDefault();
    AllLedgerAccounts();
  });

});

function AllLedgerAccounts() {

  var cc_array = [];
  $('#account-fb').attr("disabled", true); // Disable button

  $.ajax('/ledger_accounts/accountfb', {
    type: 'GET',
    beforeSend: function() {
      resources.showMessage(
        'info',
        'Sincronización en Proceso, por favor espere...', 
        {'dissipate': false, 'icon': 'fa fa-fw fa-spinner fa-spin'}
      );
    },
    complete: function() {
      setTimeout(function() {
        resources.showMessage('info', 'Resfrescando...');
        location.reload();
      },2000);
    },
    success: function(result) {
      var msj = jQuery.map( result.notice, function( value, index ) {
        return value + '';
      });
      resources.showMessage('info', msj);
      $('#account-fb').hide();
    },
    error: function(result) {
      resources.showMessage('danger','Imposible cargar las Cuentas Contables');
    }
  });
}