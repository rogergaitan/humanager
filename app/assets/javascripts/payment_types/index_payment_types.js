$(document).ready(function() {
	
	$('input.bootstrap-switch').bootstrapSwitch();

	$('table input[name="state_payment_type"]').on('switchChange.bootstrapSwitch', function(event, state) {

		var id = $(this).data("id");
		change_status(id, state);
	});

	$('input[id="show_closed"]').on('switchChange.bootstrapSwitch', function(event, state) {
		show_state(state);
	});

	$('a[data-method="delete"]').click(function(e) {
		e.stopPropagation();
		e.preventDefault();
		
		var url = $(this).attr('href');
		var that = $(this);

		bootbox.confirm("¿Está seguro(a)?", function(result) {
    	if(result) {

	    	$.ajax({
		      type: "DELETE",
		      url: url,
		      statusCode: {
		      	200: function(e, xhr, settings) {
		      		resources.PNotify('Tipo de Pago', e.notice, 'success');
		      		$(that).parents('tr').remove();
		      	},
		      	409: function(e, xhr, settings) {
		      		var message = e.responseJSON.notice;
		      		bootbox.confirm(message, function(result) {
		      			if(result) {
		      				$(that).parents('tr').find('input:checkbox').trigger('click');
		      			}
		      		});
		      	},
		      	422: function(e, xhr, settings) {
		      		resources.PNotify('Tipo de Pago', e.notice, 'success');
		      	}
		      }
		    });
    	}
    });
	});

	function show_state(state) {
		$('table input[name="state_payment_type"]').each(function () {
			if(state) {
				$(this).prop('checked') ? $(this).parents('tr').show() : $(this).parents('tr').hide();
			} else {
				$(this).prop('checked') ? $(this).parents('tr').hide() : $(this).parents('tr').show();
			}
		});
	}

	function change_status(id, state) {

		var url = $('#change_status_payment_types_path').val();

		$.ajax({
      type: "POST",
      url: url,
      data: {
        id: id,
        state: state
      },
      success: function(data) {
      	show_state($('input[id="show_closed"]').prop('checked'));
      	resources.PNotify('Estado', 'Actualizado', 'success');
      },
      error: function(response, textStatus, errorThrown) {
      	resources.PNotify('Error', 'Error al Actualizar estado', 'warning');
      }
    });
	}
	
	$('table input[name="state_payment_type"]').each(function () {
		$(this).prop('checked') ? $(this).parents('tr').show() : $(this).parents('tr').hide();
	});

});
