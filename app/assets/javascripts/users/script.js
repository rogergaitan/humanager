var users = {}

$(document).ready(function() {

  $('#users-fb').click(function() {
    users_fb();
  });
});

function users_fb() {

  $.ajax($('#usersfb_users_path').val(), {
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
      $('#users-fb').hide();
    },
    error: function(result) {
      resources.showMessage('danger','Imposible cargar las cuentas contables');
    }
  });
}
