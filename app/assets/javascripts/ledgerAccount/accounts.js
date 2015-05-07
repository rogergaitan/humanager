$(document).ready(function() {

  $('#account-fb').on("click", AllLedgerAccounts );

  $('#error').hide();
  $('#loading').hide();

  treeviewhr.cc_tree(cuenta_contable);
  $('.expand_tree').on('click', treeviewhr.expand);
  $('a[rel=tooltip]').tooltip();
  
  // $('.tree-hover').on({
  //   mouseenter: function() {
  //     $(this).children('.tree-actions').show();
  //   },
  //   mouseleave: function() {
  //     $('.tree-actions').hide();
  // }}) 

  $("#error a").click(function (e){
    e.preventDefault();
    AllLedgerAccounts();
  });

});

function replace_value(value) {
  if (value == null) value = "";
  return value;
}

//Sincroniza y muestra todas las cuentas contables
function AllLedgerAccounts() {
  var cc_array = [];
  $('section.nav').append('<div class="notice">Sincronización en Proceso</div>');
  $('#account-fb').attr("disabled", true); //desabilito el boton
  $.ajax('/ledger_accounts/accountfb', {
    type: 'GET',
    //timeout: 15000,

    beforeSend: function() {
      $('#error').hide();
      $('#loading').show();
    },
    complete: function() {
      $('#loading').hide();
    },
    success: function(result) {
      $(result.notice).each(function() { 
        $('section.nav').append('<div class="notice">'+ this +'</div>').delay(5000).fadeOut(function(){
          location.reload();
        }); 
      });
      $(result.account).each(function() { 
        cc_array.push(new Array(this.iaccount ? this.iaccount : 0, this.naccount, this.ifather ? this.ifather : 0, this.id));
      });
      treeviewhr.cc_tree(cc_array);
      $('#account-fb').hide();
    },
    error: function(result) {
      $('#error').show();
    }
  });
}