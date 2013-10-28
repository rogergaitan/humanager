payment_type_reports = {}

$(document).ready(function() {

	// Autocomplete Tasks
	payment_type_reports.populateTasksFilter($('#tasks').data('id'), 'load_filter_tasks_text');
  
  // Autocomplete Centro de Costo
  payment_type_reports.populateCCFilter($('#centro_de_costos').data('id'), 'load_filter_cc_text');

	// Moves the selected tasks to the list at the right
	$('#add-to-list-tasks').click(payment_type_reports.moveToRightTasks);
	$('#remove-to-list-tasks').click(payment_type_reports.moveToLeftTasks);

  // Moves the selected CC to the list at the right
  $('#add-to-list-cc').click(payment_type_reports.moveToRightCC);
  $('#remove-to-list-cc').click(payment_type_reports.moveToLeftCC);

	// Checked event change - tasks
	$('div#marcar-desmarcar input[name=check-tasks]').change(payment_type_reports.marcarDesmarcar);
	$('div.options-right input[name=check-tasks-right]').change(payment_type_reports.selectTasksRight);

  // Checked event change - CC
  $('div#marcar-desmarcar input[name=check-cc]').change(payment_type_reports.marcarDesmarcarCC);
  $('div.options-right input[name=check-cc-right]').change(payment_type_reports.selectTasksRightCC);

	// Button Create PDF
	$('#btn_create_pdf').on('click', function() {
		payment_type_reports.validate_data('pdf');
	});

	// Button Create XML
	$('#btn_create_xml').on('click', function() {
		payment_type_reports.validate_data('xml');
	});

});

payment_type_reports.create_pdf_or_exel = function(format) {

	var url = $('#show_reports_path').val();
	var type = $('#type_report').val();
	var payroll_ids = [],
	    employees = [],
	    tasks = [],
      cc = [];
  var orderBy = $('#order_by').val();

	$('#payrolls_results input:checked').each(function() {
		payroll_ids.push($(this).val());
	});

	$('div.employees-list.list-right input[type=checkbox]:checked').each(function() {
	  employees.push($(this).val());
	});

	$('div.tasks-list.list-right:eq(0) input[type=checkbox]:checked').each(function() {
		tasks.push($(this).val());
	});

  $('div.tasks-list.list-right:eq(1) input[type=checkbox]:checked').each(function() {
    cc.push($(this).val());
  });

	if( format === 'pdf' ) {
		url = url + '/' + payroll_ids[0] + '.pdf'
	} else {
		url = url + '/' + payroll_ids[0] + '.xls'
	}

  window.open( url
			        + '?type=' + type
              + '&format=' + format
              + '&employees=' + employees
              + '&payroll_ids=' + payroll_ids
              + '&order=' + orderBy
              + '&tasks=' + tasks
              + '&cc=' + cc
            );
};

payment_type_reports.validate_data = function(format) {

	// Validation
  	if( $('#payrolls_results input:checked').length === 0 ) {
    	$('div#message').html('<div class="alert alert-error">Por favor selecione una planilla</div>');
    	$('div.alert.alert-error').delay(4000).fadeOut();
    	return false;
	}

	var numberEmployees = $('div.employees-list.list-right input').length;
	var employeesChecked = $('div.employees-list.list-right input[type=checkbox]').is(':checked');
	var rowIsDisabled = $('#products_items tr:eq(1) td:first select').is(':disabled');
    
	if( (numberEmployees == 0 || employeesChecked == false) && (rowIsDisabled == false) ) {
		$('div#message').html('<div class="alert alert-error">Por favor selecione los empleados</div>');
		$('div.alert.alert-error').delay(4000).fadeOut();
		return false;
	}

	payment_type_reports.create_pdf_or_exel(format);
}

payment_type_reports.populateTasksFilter = function(url, textField) {

  $.getJSON(url, function(tasks) {
      $(document.getElementById(textField)).autocomplete({
          source: $.map(tasks, function(item){
          	window.item = item;
              $.data(document.body, 'account_' + item.id + "", item.ntask );
              return{
                  label: item.ntask,
                  id: item.id,
                  data_id: 'task_'+ item.id
              }
          }),
          select: function( event, ui ) {
              if (!$('#list-tasks input#'+ui.item.data_id).length) {
                appendTasks = "<div class='checkbox-group'>" +
                              "<div class='checkbox-margin'>" +
                                "<input type='checkbox' checked='checked' class='align-checkbox right' id='"+ ui.item.data_id +"' name='deduction[employee_ids][]' value='"+ ui.item.id +"' />" +
                                "<label class='checkbox-label' for='"+ ui.item.data_id +"'>"+ ui.item.label +"</label>" +
                              "</div>" +
                            "</div>";
                $('#list-tasks').append(appendTasks);
                $('input#'+ ui.item.data_id + '_left').closest('.checkbox-group').remove();
              }
          }
      })
  });
}

payment_type_reports.populateCCFilter = function(url, textField) {
  $.getJSON(url, function(CC) {
    $(document.getElementById(textField)).autocomplete({
        source: $.map(CC, function(item){
          window.item = item;
            $.data(document.body, 'account_' + item.id + "", item.nombre_cc );
            return{
                label: item.nombre_cc,
                id: item.id,
                data_id: 'cc_'+ item.id
            }
        }),
        select: function( event, ui ) {
            if (!$('#list-cc input#'+ui.item.data_id).length) {
              appendTasks = "<div class='checkbox-group'>" +
                            "<div class='checkbox-margin'>" +
                              "<input type='checkbox' checked='checked' class='align-checkbox right' id='"+ ui.item.data_id +"' name='cc[cc_ids][]' value='"+ ui.item.id +"' />" +
                              "<label class='checkbox-label' for='"+ ui.item.data_id +"'>"+ ui.item.label +"</label>" +
                            "</div>" +
                          "</div>";
              $('#list-cc').append(appendTasks);
              $('input#'+ ui.item.data_id + '_left').closest('.checkbox-group').remove();
            }
        }
      })
  });
}

// Tasks 
payment_type_reports.moveTasks = function() {
  var tasks = "";
  $('#tasks-list input[type=checkbox]:checked').each(function() {
    if (!$(this).is(':disabled')) {
      tasks = "<div class='checkbox-group'>" +
                    "<div class='checkbox-margin'>" +
                      "<input type='checkbox' checked='checked' class='align-checkbox right' id='"+ $(this).data('id') +"' value='"+ $(this).val() +"' />" +
                      "<label class='checkbox-label' for='"+ $(this).data('id') +"'>"+ $(this).next().text() +"</label>" +
                    "</div>" +
                  "</div>"; 
      $('#list-tasks').append(tasks);
      $(this).closest('.checkbox-group').remove();
    };
  });
  $('#check-employees').prop('checked', false);
  $('#check-tasks-right').prop('checked', true);
}

payment_type_reports.moveToRightTasks = function(e) {
  e.preventDefault();
  payment_type_reports.moveTasks();
}

payment_type_reports.moveToLeftTasks = function(e) {

  e.preventDefault();
  var appendEmployees = "";
  $('div.tasks-list.list-right:eq(0) input[type=checkbox]:not(:checked)').each(function() {
    appendEmployees = "<div class='checkbox-group'>" +
                  "<div class='checkbox-margin'>" +
                    "<input type='checkbox' data-id='"+ $(this).attr('id') +"' class='align-checkbox right' id='"+ $(this).attr('id')+'_left' +"' name='left-list-employees' value='"+ $(this).val() +"' />" +
                    "<label class='checkbox-label' for='"+ $(this).attr('id')+'_left' +"'>"+ $(this).next().text() +"</label>" +
                  "</div>" +
                "</div>"; 
    $('#no-save-tasks').append(appendEmployees);
    $(this).closest('.checkbox-group').remove();
  });
}

payment_type_reports.marcarDesmarcar = function() {
  
  if ($(this).is(':checked')) {
  	$("div.tasks-list.left-list:eq(0) input[type='checkbox']").prop('checked', true);
  } else {
    $("div.tasks-list.left-list:eq(0) input[type='checkbox']").prop('checked', false);
  };
}

payment_type_reports.selectTasksRight = function() {
  if ($(this).is(':checked')) {
    $("div.tasks-list.list-right:eq(0) input[type='checkbox']").prop('checked', true);
  } else {
    $("div.tasks-list.list-right:eq(0) input[type='checkbox']").prop('checked', false);
  };
}

// Centro de Costos

payment_type_reports.moveToRightCC = function(e) {
  e.preventDefault();
  payment_type_reports.moveCC();
}

payment_type_reports.moveCC = function() {
  var centro_costo = "";
  $('#cc-list input[type=checkbox]:checked').each(function() {
    if (!$(this).is(':disabled')) {
      centro_costo = "<div class='checkbox-group'>" +
                    "<div class='checkbox-margin'>" +
                      "<input type='checkbox' checked='checked' class='align-checkbox right' id='"+ $(this).data('id') +"' value='"+ $(this).val() +"' />" +
                      "<label class='checkbox-label' for='"+ $(this).data('id') +"'>"+ $(this).next().text() +"</label>" +
                    "</div>" +
                  "</div>"; 
      $('#list-cc').append(centro_costo);
      $(this).closest('.checkbox-group').remove();
    };
  });
  $('#check-cc').prop('checked', false);
  $('#check-cc-right').prop('checked', true);
}

payment_type_reports.moveToLeftCC = function(e) {

  e.preventDefault();
  var appendCC = "";
  $('div.tasks-list.list-right:eq(1) input[type=checkbox]:not(:checked)').each(function() {
    appendCC = "<div class='checkbox-group'>" +
                  "<div class='checkbox-margin'>" +
                    "<input type='checkbox' data-id='"+ $(this).attr('id') +"' class='align-checkbox right' id='"+ $(this).attr('id')+'_left' +"' name='left-list-employees' value='"+ $(this).val() +"' />" +
                    "<label class='checkbox-label' for='"+ $(this).attr('id')+'_left' +"'>"+ $(this).next().text() +"</label>" +
                  "</div>" +
                "</div>"; 
    $('#no-save-cc').append(appendCC);
    $(this).closest('.checkbox-group').remove();
  });
}

payment_type_reports.marcarDesmarcarCC = function() {
  
  if ($(this).is(':checked')) {
    $("div.tasks-list.left-list:eq(1) input[type='checkbox']").prop('checked', true);
  } else {
    $("div.tasks-list.left-list:eq(1) input[type='checkbox']").prop('checked', false);
  };
}

payment_type_reports.selectTasksRightCC = function() {
  if ($(this).is(':checked')) {
    $("div.tasks-list.list-right:eq(1) input[type='checkbox']").prop('checked', true);
  } else {
    $("div.tasks-list.list-right:eq(1) input[type='checkbox']").prop('checked', false);
  };
}
