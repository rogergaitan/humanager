$(document).ready(function($) {
  //Gets all data from employees
  $('.telephone-field').mask('0000-0000');
  
  $('#employee_wage_payment').mask("FNNNNNNNNN.NN", {
    translation: {
      'N': {pattern: /\d/, optional: true},
      "F": {pattern: /[1-9]/}
    }
  });
  
  $.getJSON('/employees/load_employees', function(employee_data) {
    $('#load_employee').autocomplete({
      source: $.map(employee_data, function(item) {
        $.data(document.body, 'employee_' + item.id + "", item.entity.name + ' ' + item.entity.surname);
        return {
          label: item.entity.name + ' ' + item.entity.surname,
          id: item.id
        }
      }),
      select: function( event, ui ) {
        if(ui.item.id) {
            $('#department_employee_id').val(ui.item.id);
        }
      },
      focus: function(event, ui) {
        $('#load_employee').val(ui.item.label);
      },
      change: function(event, ui) {
        if(!ui.item){
          alert('Ningún resultado contiene ' + $('#load_employee').val());
          $('#load_employee').val("");
          $('#load_employee_id').val("");
        }
      }
    });
    if($('#department_employee_id').val()) {
        var load_employee_name = $.data(document.body, 'employee_' + $('#department_employee_id').val() + '');
        $('#load_employee').val(load_employee_name);
    }
  });
})
