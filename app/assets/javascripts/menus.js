$(document).ready( function() {
  
  $('#global_date').datepicker({
    format: 'dd/mm/yyyy',
    autoclose: true,
    language: "es"
  }).datepicker('setDate', new Date());

  if($('#get_main_calendar_payrolls_path').length != 0) {
    $.ajax({
      type: "GET",
      url: $('#get_main_calendar_payrolls_path').val(),
      dataType: "json",
      success: function(data) {
        set_events(data);
      }
    });
  }

  function set_events(data) {
    var myEvents = [];

    $.each(data, function(key, d) {
      var split = d['payment_date'].split('-'); //YYYY/MM/DD
      var date = new Date(split[0], split[1] - 1, split[2]); //Y M D 
      myEvents.push({
        url: '/payroll_logs/'+d['id']+'/edit',
        title: 'Pago '+ d['description'],
        start: date,
        backgroundColor: Utility.getBrandColor('success')
      });
    });

    set_calendar(myEvents);
  }

  function set_calendar(myEvents) {
    var calendar = $('#calendar-drag').fullCalendar({
      header: {
          left: 'title',
          right: 'prev,next month,agendaWeek,agendaDay'
      },
      monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
      monthNamesShort: ['ENE','FEB','MAR','ABR','MAY','JUN','JUL','AGO','SEP','OCT','NOV','DIC'],
      dayNames: ['Sábado','Lunes','Martes','Miércoles','Jueves','Viernes','Domingo'],
      dayNamesShort: ['Sábado','Lunes','Martes','Miércoles','Jueves','Viernes','Domingo'],
      titleFormat: {
          day: "ddd, MMM d, yy"
      },
      selectable: true,
      selectHelper: true,
      select: function(start, end, allDay) {
          var title = prompt('Event Title:');
          if (title) {
              calendar.fullCalendar('renderEvent',
                  {
                      title: title,
                      start: start,
                      end: end,
                      allDay: allDay
                  },
                  true // make the event "stick"
              );
          }
          calendar.fullCalendar('unselect');
      },
      editable: false,
      events: myEvents,
      buttonText: {
          prev: '<i class="fa fa-angle-left"></i>',
          next: '<i class="fa fa-angle-right"></i>',
          prevYear: '<i class="fa fa-angle-double-left"></i>',  // <<
          nextYear: '<i class="fa fa-angle-double-right"></i>',  // >>
          today:    '<span class="hidden-xs">Hoy</span><span class="visible-xs">T</span>',
          month:    '<span class="hidden-xs">Mes</span><span class="visible-xs">M</span>',
          week:     '<span class="hidden-xs">Semana</span><span class="visible-xs">W</span>',
          day:      '<span class="hidden-xs">Día</span><span class="visible-xs">D</span>'
      }
    });
  }

  $('form').submit(function(event) {
    if($('#user_company_id option:selected').val() == "" ){
      event.preventDefault();
      var message = 'Seleccione una Compañia';
      resources.PNotify('Compañia', message, 'warning');
    }
  });

  $('#user_company_id').on('change', function() {
    $.ajax({
      type: "POST",
      url: $(this).data('url'),
      data: {
          company_id: $(this).val()
      },
      statusCode: {
        200: function(e, xhr, settings) {
            resources.PNotify('Compañia', 'Actualizada con exito', 'success');
            setTimeout(function() { location.reload(); }, 3000);
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

});
