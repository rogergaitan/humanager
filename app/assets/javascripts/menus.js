$(document).ready( function() {
	$('#global_date').datepicker('setDate', new Date());

	var date = new Date();
  var d = date.getDate();
  var m = date.getMonth();
  var y = date.getFullYear();

  var calendar = $('#calendar-drag').fullCalendar({
      header: {
          left: 'title',
          right: 'prev,next month,agendaWeek,agendaDay'
      },
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
      editable: true,
      events: [
          {
              title: 'All Day Event',
              start: new Date(y, m, 8),
              backgroundColor: Utility.getBrandColor('midnightblue')
          },
          {
              title: 'Long Event',
              start: new Date(y, m, d-5),
              end: new Date(y, m, d-2),
              backgroundColor: Utility.getBrandColor('primary')
          },
          {
              id: 999,
              title: 'Repeating Event',
              start: new Date(y, m, d-3, 16, 0),
              allDay: false,
              backgroundColor: Utility.getBrandColor('success')
          },
          {
              id: 999,
              title: 'Repeating Event',
              start: new Date(y, m, d+4, 16, 0),
              allDay: false,
              backgroundColor: Utility.getBrandColor('success')
          },
          {
              title: 'Meeting',
              start: new Date(y, m, d, 10, 30),
              allDay: false,
              backgroundColor: Utility.getBrandColor('alizarin')
          },
          {
              title: 'Lunch',
              start: new Date(y, m, d, 12, 0),
              end: new Date(y, m, d, 14, 0),
              allDay: false,
              backgroundColor: Utility.getBrandColor('inverse')
          },
          {
              title: 'Birthday Party',
              start: new Date(y, m, d+1, 19, 0),
              end: new Date(y, m, d+1, 22, 30),
              allDay: false,
              backgroundColor: Utility.getBrandColor('warning')
          },
          {
              title: 'Click for Google',
              start: new Date(y, m, 28),
              end: new Date(y, m, 29),
              url: 'http://google.com/',
              backgroundColor: Utility.getBrandColor('inverse')
          }
      ],
      buttonText: {
          prev: '<i class="fa fa-angle-left"></i>',
          next: '<i class="fa fa-angle-right"></i>',
          prevYear: '<i class="fa fa-angle-double-left"></i>',  // <<
          nextYear: '<i class="fa fa-angle-double-right"></i>',  // >>
          today:    '<span class="hidden-xs">Today</span><span class="visible-xs">T</span>',
          month:    '<span class="hidden-xs">Month</span><span class="visible-xs">M</span>',
          week:     '<span class="hidden-xs">Week</span><span class="visible-xs">W</span>',
          day:      '<span class="hidden-xs">Day</span><span class="visible-xs">D</span>'
      }
  });

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