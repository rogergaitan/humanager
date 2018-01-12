var company = {}

$(document).ready(function() {

  $('#sync_process').on('click', function() {
  	syncProcess();
  });

  function syncProcess() {
		var cc_array = [];
		var url = $('#firebird_sync_process_path').val();
	  $('#sync_process').attr("disabled", true); // Disable button

	  $.ajax(url, {
	    type: 'GET',
	    beforeSend: function() {
	      resources.showMessage(
	        'info',
	        'Sincronización en Proceso, por favor espere...', 
	        {
						'dissipate': false, 
						'icon': 'fa fa-fw fa-spinner fa-spin'
					}
	      );
	    },
	    complete: function() {
				console.log('complete');
	      setTimeout(function() {
	        resources.showMessage('info', 'Resfrescando...');
	        location.reload();
	      },2000);
	    },
	    success: function(result) {
				var msj = jQuery.map(result, function(value) {
					return value.notice[0] + '';
				});
	      resources.showMessage('info', msj);
	      $('#sync_process').hide();
	    },
	    error: function(result) {
	      resources.showMessage('danger','Imposible cargar los Datos');
	    }
	  });
	}

});
