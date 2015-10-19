Employee = {
  search_length : 3,
  per_page : 15
}

$(document).ready(function() {

  $('#sync-fb').click(function() {
    syn_fb();
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

function syn_fb() {
  $.ajax('employees/sync', {
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
      $('#account-fb').hide();
    },
    error: function(result) {
      resources.showMessage('danger','Imposible cargar los Empleados');
    }
  });
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
