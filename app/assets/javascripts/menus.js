$(document).ready( function() {

  $('#global_date').datepicker({
    format: 'dd/mm/yyyy',
    autoclose: true,
    language: "es"
  }).datepicker('setDate', new Date());

  $('form[data-company="true"]').submit(function(event) {
    if($('#user_company_id option:selected').val() == '' ) {
      event.preventDefault();
      var message = 'Seleccione una Compañia';
      resources.PNotify('Compañia', message, 'warning');
    }
  });

  $('#user_company_id').on('change', function() {
    $.ajax({
      type: 'POST',
      url: $(this).data('url'),
      data: {
        company_id: $(this).val()
      },
      statusCode: {
        200: function(e, xhr, settings) {
          sessionStorage.setItem('company_updated', true);
          resources.PNotify('Compañia', 'Actualizando...', 'success');
           
          if($('form').attr('data-company')) { 
            setTimeout(function() { location.assign($('a:contains(Cancelar)').attr('href')); }, 3000);
          } else {
            setTimeout(function() { location.reload(); }, 3000);
	        }
        },
        409: function(e, xhr, settings) {
          var message = e.responseJSON.notice;
          resources.PNotify('Compañia', message, 'warning');
        },
        422: function(e, xhr, settings) {
          resources.PNotify('Compañia', e.notice, 'success');
        }
      }
    });
  });

  if(sessionStorage.getItem('company_updated')) {
    sessionStorage.removeItem('company_updated');
    resources.PNotify('Compañia', 'Actualizada con exito', 'success');
  }
});
