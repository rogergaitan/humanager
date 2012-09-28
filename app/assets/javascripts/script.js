$(document).ready(function() {
  $('#sync-fb').click(function() {
    $.getJSON('/people/sync', function(element) {
      $('section.nav').append('<div class="notice">'+ element.notice +'</div>');
      $(element.people).each(function() { add_people(this, 'table#person-data')});
      $('#sync-fb').hide();
    })
  });

  function add_people(person, target_table)
  {
    var test = $(target_table + '> tbody:last').append('<tr>' + 
        '<td><a href="/people/'+ person.id +'">'+ person.id +'</a></td>' +
        '<td>' + replace_value(person.id_person) + '</td>' +
        '<td>' + replace_value(person.name) + '</td>' +
        '<td>' + replace_value(person.first_surname) + '</td>' +
        '<td>' + replace_value(person.second_surname) + '</td>' +
        '<td>' + replace_value(person.birthday) + '</td>' +
        '<td>' + replace_value(person.tipoid) + '</td>' +
        '<td>' + replace_value(person.gender) + '</td>' +
        '<td>' + replace_value(person.marital_status) + '</td>' +
        '<td><a href="/people/'+ person.id +'/edit" class="btn btn-mini">Editar</a> ' +
        '<a href="/people/'+ person.id +'" class="btn btn-mini btn-danger" ' +
        'data-confirm="¿Está seguro(a)?" data-method="delete" rel="nofollow">Eliminar</a></td>' +
      '</tr>');
    return test;
  }

  function replace_value(value)
  {
    if (value == null) value = "";
    return value;
  }
})