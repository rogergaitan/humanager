$(document).ready(function() {

  var task = {
    search_length : 3
  }

  $('#task-fb').click(function() { 
    task_fb();
  });

  $('#task-data a').click( function(e) {
    e.preventDefault();
  });

  $('#task-data a').dblclick( function(e) {
    var url = $(this).next().val();
    document.location.href = url;
  });

  $('#search_form input').keyup(function() {
    return search_task();
  });

  $('#clear').click(function(e){
    search_all();
    $('#search_code').val('');
    $('#search_desc').val('');
  });

  function search_task() {
    var code = $('#search_code').val(),
        description = $('#search_desc').val();

    if( code.length >= 1 || description.length >= task.search_length || code != "" || description != "") {

      return $.ajax({
        url: $('#search_form').attr('action'),
        dataType: "script",
        data: {
          search_code: code,
          search_desc: description
        }
      });
    }
  }

  function search_all() {
    return $.ajax({
      url: $('#search_form').attr('action'),
      dataType: "script",
      data: {
          search_code: "",
          search_desc: ""
        }
    });
  }

  function task_fb() {
    $.ajax('tasks/tasksfb', {
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
        $('#task-fb').hide();
      },
      error: function(result) {
        resources.showMessage('danger','Imposible cargar las Labores');
      }
    });
  }

})