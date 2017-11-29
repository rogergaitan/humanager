$(document).ready( function() {

  // ********************************************************************************************* //
  // Start
  $('#check_start').parents('label').click(function() {
    show_hidde_events($('#check_start').is(':checked'), $('#check_start').val());
  });

  $('#check_start').next().click(function() {
    show_hidde_events($('#check_start').is(':checked'), $('#check_start').val());
  });

  // ********************************************************************************************* //
  // End
  $('#check_end').parents('label').click(function() {
    show_hidde_events($('#check_end').is(':checked'), $('#check_end').val());
  });

  $('#check_end').next().click(function() {
    show_hidde_events($('#check_end').is(':checked'), $('#check_end').val());
  });

  // ********************************************************************************************* //
  // Patment
  $('#check_payment').parents('label').click(function() {
    show_hidde_events($('#check_payment').is(':checked'), $('#check_payment').val());
  });

  $('#check_payment').next().click(function() {
    show_hidde_events($('#check_payment').is(':checked'),  $('#check_payment').val());
  });

  if($('#get_main_calendar_payrolls_path').length != 0) {
    set_calendar();
  }

  // Next Button
  $('.fc-button-next').click(function() {
    $('#calendar-drag').fullCalendar('removeEvents');
  });

  // Prev Button
  $('.fc-button-prev').click(function() {
    $('#calendar-drag').fullCalendar('removeEvents');
  });

  function show_hidde_events(checked, type) {
    if(checked) {
      $.each( JSON.parse(sessionStorage.getItem('events')), function (key, value) {
        if( value['id'] === type ) {
  	  $('#calendar-drag').fullCalendar('addEventSource', [value]);
  	}
     });
     } else {
       $('#calendar-drag').fullCalendar('removeEvents', type);
     }
  }

  function set_calendar() {
    var calendar = $('#calendar-drag').fullCalendar({
      header: {
        left: 'title',
        right: 'prev,next month,agendaWeek,agendaDay'
      },
      monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
      monthNamesShort: ['ENE','FEB','MAR','ABR','MAY','JUN','JUL','AGO','SEP','OCT','NOV','DIC'],
      dayNames: ['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'],
      dayNamesShort: ['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'],
      titleFormat: {
        day: "ddd, MMM d, yy"
      },
      selectable: true,
      selectHelper: true,
      editable: false,
      events: function(start, end, callback) {
        $.ajax({
          type: "GET",
          url: $('#get_main_calendar_payrolls_path').val(),
          dataType: 'json',
          cache: true,
          data: {
            start: start,
            end: end,
          },
          success: function(doc) {
            var events = set_events(doc);
            callback(events);
          }
        });
      },
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

  function set_events(data) {
    var myEvents = [];
    var allEvents = [];

    $.each(data, function(key, d) {
      var obj;

      // Start Date
      obj = {
        id: 'start',
        url: '/payroll_logs/'+d['id']+'/edit',
        title: 'Inicio '+ d['description'],
        start: set_date(d['start_date']),
        backgroundColor: Utility.getBrandColor('success')
      }

      if( $('#check_start').is(':checked') ) {
      	myEvents.push(obj);
      }
      allEvents.push(obj);

      // End Date
      obj = {
        id: 'end',
        url: '/payroll_logs/'+d['id']+'/edit',
        title: 'Final '+ d['description'],
        start: set_date(d['end_date']),
        backgroundColor: Utility.getBrandColor('success')
      };

      if( $('#check_end').is(':checked') ) {
      	myEvents.push(obj);
      }
      allEvents.push(obj);
      
      // Payment Date
      obj = {
        id: 'payment',
        url: '/payroll_logs/'+d['id']+'/edit',
        title: 'Pago '+ d['description'],
        start: set_date(d['payment_date']),
        backgroundColor: Utility.getBrandColor('success')
      };

      if( $('#check_payment').is(':checked') ) {
        myEvents.push(obj);
      }
	allEvents.push(obj);
    });

    sessionStorage.setItem('events', JSON.stringify(allEvents));

    return myEvents;
  }

  function set_date(str_date) {
    var split = str_date.split('-'); //YYYY/MM/DD
    var date = new Date(split[0], split[1] - 1, split[2]); //Y M D
    return date;
  }

});
