$(document).ready(function() {

  task = {
    search_length : 3
  }

  $('#task-fb').click(function() { 
    $('section.nav').append('<div class="notice">Sincronización en Proceso</div>');
    $.getJSON('tasks/tasksfb', function(element) {
      $(element.notice).each(function() { $('section.nav').append('<div class="notice">'+ this +'</div>').delay(5000).fadeOut(function(){location.reload();}); });
      $(element.task).each(function() { add_tasks(this, 'table#task-data')});
      $('#task-fb').hide();
    })
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

  function add_tasks(task, target_table) {
    var row = $(target_table + '> tbody:last').append('<tr>' + 
        '<td><a href="/tasks/'+ task.id +'">'+ task.id +'</a></td>' +
        '<td>' + replace_value(task.iactivity) + '</td>' +
        '<td>' + replace_value(task.itask) + '</td>' +
        '<td>' + replace_value(task.ntask) + '</td>' +
        '<td>' + replace_value(task.iaccount) + '</td>' +
        '<td>' + replace_value(task.mlaborcost) + '</td>' +
        '<td><a href="/tasks/'+ task.id +'" class="btn btn-mini btn-danger" ' +
        'data-confirm="¿Está seguro(a)?" data-method="delete" rel="nofollow">Eliminar</a></td>' +
      '</tr>');
    return row;
  }

  function replace_value(value) {
    if (value == null) value = "";
    return value;
  }
})