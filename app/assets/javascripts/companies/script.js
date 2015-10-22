var company = {}

$(document).ready(function() {

  $('#companies-fb').on('click', function() {
  	AllCompanies();
  });

  function AllCompanies() {
	  var cc_array = [];
	  $('#companies-fb').attr("disabled", true); // Disable button

	  $.ajax($('#companies_fb_companies_path').val(), {
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
	      $('#companies-fb').hide();
	    },
	    error: function(result) {
	      resources.showMessage('danger','Imposible cargar las Compañias');
	    }
	  });
	}

});
