$(document).ready(function() {

	$('#sync-cc').on("click", function() {
    sync_cc();
  });

	treeviewhr.cc_tree(costs_center);
	$('.expand_tree').on('click', treeviewhr.expand);
	$('a[rel=tooltip]').tooltip();
});

function sync_cc() {
  $.ajax('costs_centers/sync_cc', {
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
      $('#sync-cc').hide();
    },
    error: function(result) {
      resources.showMessage('danger','Imposible cargar las Centro de Costos');
    }
  });
}
