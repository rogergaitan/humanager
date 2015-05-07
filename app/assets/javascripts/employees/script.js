Employee = {
  search_length : 3
}

$(document).ready(function() {
  $('#sync-fb').click(function() {
    $('section.nav').append('<div class="notice">Sincronización en Proceso</div>');
    $.getJSON('employees/sync', function(element) {
      $(element.notice).each(function() { $('section.nav').append('<div class="notice">'+ this +'</div>').delay(5000).fadeOut(function(){location.reload();}); });
      $(element.employee).each(function() { add_employees(this, 'table#employee-data') });
      $('#sync-fb').hide();
    })
  });

  $('#search_form input').keyup(function() {
    return Employee.search();
  });

  $('#search_form select').change(function() {
    return Employee.search();
  });

  $('#clear').click(function(e){
    Employee.search_all();
    $('#search_id').val('');
    $('#search_name').val('');
    $('#search_surname').val('');
    $('#search_department option:eq(0)').attr('selected', 'selected');
    $('#search_entities option:eq(0)').attr('selected', 'selected');
  });
});

function add_employees(employee, target_table) {
  var row = $(target_table + '> tbody:last').append('<tr>' + 
    '<td><a href="/employees/'+ employee.id +'">'+ employee.id +'</a></td>' +
    '<td>' + replace_value(employee.entity.entityid) + '</td>' +
    '<td>' + replace_value(employee.entity.name) + '</td>' +
    '<td>' + replace_value(employee.entity.surname) + '</td>' +
    '<td>' + replace_value(employee.department_id) + '</td>' +
    '<td>' + replace_value(employee.wage_payment) + '</td>' +
    '<td><a href="/employees/'+ employee.id +'/edit" class="btn btn-mini">Editar</a> ' +
    '<a href="/employees/'+ employee.id +'" class="btn btn-mini btn-danger" ' +
    'data-confirm="¿Está seguro(a)?" data-method="delete" rel="nofollow">Eliminar</a></td>' +
  '</tr>');
  return row;
}

function replace_value(value) {
  if (value == null) value = "";
  return value;
}

Employee.search = function() {
  var id, name, surname, department, entities;
  id = $('#search_id').val();
  name = $('#search_name').val();
  surname = $('#search_surname').val();
  department = $('#search_department').val();
  entities = $('#search_entities').val();

  if( id.length >= Employee.search_length || name.length >= Employee.search_length || 
    surname.length >= Employee.search_length || department != "" || entities != "") {
    return $.ajax({
      url: "/employees/search",
      dataType: "script",
      data: {
        search_id: id,
        search_name: name,
        search_surname: surname,
        search_department: department,
        search_entities: entities
      }
    });
  }
}

Employee.search_all = function() {
  return $.ajax({
    url: "/employees/search_all",
    dataType: "script",
    complete: function(data) {
      return ''
    }
  });
}
