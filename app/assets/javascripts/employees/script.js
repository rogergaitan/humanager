$(document).ready(function() {
  $('#sync-fb').click(function() {
    $.getJSON('employees/sync', function(element) {
      $(element.notice).each(function() { $('section.nav').append('<div class="notice">'+ this +'</div>').delay(5000).fadeOut(); });
      $(element.employee).each(function() { add_employees(this, 'table#employee-data')});
      $('#sync-fb').hide();
    })
  });
})

function add_employees(employee, target_table)
{
  var row = $(target_table + '> tbody:last').append('<tr>' + 
      '<td><a href="/employees/'+ employee.id +'">'+ employee.id +'</a></td>' +
      '<td>' + replace_value(employee.entity.entityid) + '</td>' +
      '<td>' + replace_value(employee.entity.name) + '</td>' +
      '<td>' + replace_value(employee.entity.surname) + '</td>' +
      '<td>' + replace_value(employee.department_id) + '</td>' +
      '<td>' + replace_value(employee.role_id) + '</td>' +
      '<td>' + replace_value(employee.wage_payment) + '</td>' +
      '<td><a href="/employees/'+ employee.id +'/edit" class="btn btn-mini">Editar</a> ' +
      '<a href="/employees/'+ employee.id +'" class="btn btn-mini btn-danger" ' +
      'data-confirm="¿Está seguro(a)?" data-method="delete" rel="nofollow">Eliminar</a></td>' +
    '</tr>');
  return row;
}

function replace_value(value)
{
  if (value == null) value = "";
  return value;
}