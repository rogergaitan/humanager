$(document).ready(function() {

  $('#task-fb').click(function() { 
    $.getJSON('tasks/tasksfb', function(element) {
      $('section.nav').append('<div class="notice">'+ element.notice +'</div>');
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