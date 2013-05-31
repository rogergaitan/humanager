reports_payment_proof = { }

$(document).ready(function() {
	
	reports_payment_proof.datePicker();

	reports_payment_proof.searchInfoPayrolls();

	$('#search_payrolls').click(function() {
		reports_payment_proof.searchInfoPayrolls();
	});

	$("#payrolls_results").on("click", ".pag a", function() {
    	$.getScript(this.href);
		return false;
  	});

	reports_payment_proof.populateEmployeesFilter($('#fetch_employees_deductions_path').val(), 'load_filter_employees_text', 'load_filter_employees_id');

	$('input[name=select_method]').change(function() {
    	reports_payment_proof.selectEmployeesLeft($(this));
  	});

  	$('div.options-right input[name=check-employees-right]').change(reports_payment_proof.selectEmployeesRight);

  	// Moves the selected employees to the list at the right
  	$('#add-to-list').click(reports_payment_proof.moveToRight);
  	$('#remove-to-list').click(reports_payment_proof.moveToLeft);

  	$('#departments_employees').change(function() {
    	reports_payment_proof.filterDepartment($(this).val());
  	});

  	$('#superiors_employees').change(function() {
    	reports_payment_proof.filterSuperior($(this).val());
  	});

  	$('div#marcar-desmarcar input[name=check-employees]').change(reports_payment_proof.marcarDesmarcar);
  	
 	$('#employee-data').on('change', 'input', function() {
		alert('d');
	});

});
	
// Establishing the datepicker
reports_payment_proof.datePicker = function() {
	$("#start_date").datepicker({ //'dd/mm/yyyy'
		format: 'yyyy-mm-dd'
	});
	$("#end_date").datepicker({
		format: 'yyyy-mm-dd'
	});
}

// Search the payrolls
reports_payment_proof.searchPayrolls = function(start_date, end_date, url) {

	return $.ajax({
		url: url,
		dataType: "script",
		data: {
			start_date: start_date,
			end_date: end_date
		}
	});	
}

// Find the information and calls the search function
reports_payment_proof.searchInfoPayrolls = function() {

	var start_date = $('#start_date').val();
	var end_date = $('#end_date').val();
	var url = $("form[id=search_payrolls_form]").attr('action');

	reports_payment_proof.searchPayrolls(start_date, end_date, url);
}

reports_payment_proof.populateEmployeesFilter = function(url, textField, idField) {
  $.getJSON(url, function(employees) {
      $(document.getElementById(textField)).autocomplete({
          source: $.map(employees, function(item){
              $.data(document.body, 'account_' + item.id+"", item.entity.name + ' ' + item.entity.surname);
              return{
                  label: item.entity.surname + ' ' + item.entity.name,                        
                  id: item.id,
                  sup: item.employee_id,
                  dep: item.department_id,
                  data_id: 'employee_'+ item.id
              }
          }),
          select: function( event, ui ) {
              if (!$('#list-to-save input#'+ui.item.data_id).length) {
                appendEmployees = "<div class='checkbox-group'>" +
                              "<div class='checkbox-margin'>" +
                                "<input type='checkbox' data-sup='"+ ui.item.sup +"' data-dep='"+ ui.item.dep +"' checked='checked' class='align-checkbox right' id='"+ ui.item.data_id +"' name='deduction[employee_ids][]' value='"+ ui.item.id +"' />" +
                                "<label class='checkbox-label' for='"+ ui.item.data_id +"'>"+ ui.item.label +"</label>" +
                              "</div>" +
                            "</div>"; 
                $('#list-to-save').append(appendEmployees);
                $('input#'+ ui.item.data_id + '_left').closest('.checkbox-group').remove();
              }
          }
      })     
  }); 
}

reports_payment_proof.selectEmployeesLeft = function(selected) {
  switch($(selected).val()) {
    case 'all':
      $('#employee-filter').show();
      $('#list-departments').hide();
      $('#list-superior').hide(); 
      $('div.employees-list.left-list input[type=checkbox]').prop('disabled', false);
      $('.checkbox-group').show();
      break;
    case 'boss':
      $('#employee-filter').hide();
      $('#list-departments').hide();
      reports_payment_proof.filterSuperior($('#superiors_employees').val());
      $('#list-superior').show(); 
      break;
    case 'department':
      $('#employee-filter').hide();
      $('#list-superior').hide(); 
      reports_payment_proof.filterDepartment($('#departments_employees').val());
      $('#list-departments').show();      
      break;
  }
}

reports_payment_proof.selectEmployeesRight = function() {
  if ($(this).is(':checked')) {
    $("div.list-right input[type='checkbox']").attr('checked', true);
  } else {
    $("div.list-right input[type='checkbox']").attr('checked', false);
  };
}

reports_payment_proof.moveEmployees = function() {
  var appendEmployees = "";
  $('div.employees-list.left-list input[type=checkbox]:checked').each(function() {
    if (!$(this).is(':disabled')) {
      appendEmployees = "<div class='checkbox-group'>" +
                    "<div class='checkbox-margin'>" +
                      "<input type='checkbox' data-sup='"+ $(this).data('sup') +"' data-dep='"+ $(this).data('dep') +"' checked='checked' class='align-checkbox right' id='"+ $(this).data('id') +"' name='deduction[employee_ids][]' value='"+ $(this).val() +"' />" +
                      "<label class='checkbox-label' for='"+ $(this).data('id') +"'>"+ $(this).next().text() +"</label>" +
                    "</div>" +
                  "</div>"; 
      $('#list-to-save').append(appendEmployees);
      $(this).closest('.checkbox-group').remove();
    };
  });
  $('div#marcar-desmarcar input[name=check-employees]').attr('checked', false);
  $('div.options-right input[name=check-employees-right]').attr('checked', true);
}

reports_payment_proof.moveToRight = function(e) {
  e.preventDefault();
  reports_payment_proof.moveEmployees();
}

reports_payment_proof.moveToLeft = function(e) {
  e.preventDefault();
  var appendEmployees = "";
  $('div.employees-list.list-right input[type=checkbox]:not(:checked)').each(function() {
    appendEmployees = "<div class='checkbox-group'>" +
                  "<div class='checkbox-margin'>" +
                    "<input type='checkbox' data-sup='"+ $(this).data('sup') +"' data-dep='"+ $(this).data('dep') +"' data-id='"+ $(this).attr('id') +"' class='align-checkbox right' id='"+ $(this).attr('id')+'_left' +"' name='left-list-employees' value='"+ $(this).val() +"' />" +
                    "<label class='checkbox-label' for='"+ $(this).attr('id')+'_left' +"'>"+ $(this).next().text() +"</label>" +
                  "</div>" +
                "</div>"; 
    $('#no-save').append(appendEmployees);
    $(this).closest('.checkbox-group').remove();
  });
  if ($('input[name=select_method]:checked').val() == 'department') {
    reports_payment_proof.filterDepartment($('#departments_employees').val());
  } else if ($('input[name=select_method]:checked').val() == 'boss') {
    reports_payment_proof.filterSuperior($('#superiors_employees').val())
  };
}

reports_payment_proof.filterDepartment = function(dropdown) { 
  var empSelected = [];
  var dep = dropdown ? dropdown : 0; //si se manda un id de departamento se almacena en dep de lo contrario se almacena 0
  $('div.employees-list.left-list input[type=checkbox]').each(function() { //recorre cada checkbox
    //en la sig linea si el empleado tiene un id de departamento es porque esta asigando a uno de lo 
    //y se almacenaria en empDep de lo contrario si no tiene es porque el empleado no a sido asignado a ninguno
    var empDep = $(this).data('dep') ? $(this).data('dep') : 0; 
    if (!(dep == 0)) { //si el id del departamento es diferente de 0
      if (!(dep == empDep)) { //si dep no es igual a empDep quiere decir que el empleado NO pertenece al departamento seleccionado
        //En la siguiente linea se procede a guardar en un arreglo 
        //otro arreglo con el id del empledo luego el id del departamento y despues el nombre del empleado
        empSelected.push(Array($(this).data('id'), empDep, $(this).next().text()));
        $(this).closest('div.checkbox-group').hide(); //oculte el checkbox grup correspondiente a ese empleado
        $(this).prop('disabled', true);
      } else { //quiere decir que dep es igual a empDep ese empleado pertenece al departamente seleccionado
        $(this).prop('disabled', false); //habilito el check
        $(this).closest('div.checkbox-group').show(); //y muestro al empleado
      };
    }  else {
        $(this).closest('div.checkbox-group').show(); //que los muestre todos
      };
  });
}

reports_payment_proof.filterSuperior = function(dropdown) {
  var empSelected = [];
  var sup = dropdown ? dropdown : 0;
  $('div.employees-list.left-list input[type=checkbox]').each(function() {
    var empSup = $(this).data('sup') ? $(this).data('sup') : 0;
    if (!(sup == 0)) {
      if (!(sup == empSup)) {
        $(this).closest('div.checkbox-group').hide();
        $(this).prop('disabled', true);
      } else {
        $(this).prop('disabled', false);
        $(this).closest('div.checkbox-group').show();
      };
    }  else {
        $(this).closest('div.checkbox-group').show();
      };
  });
}

reports_payment_proof.marcarDesmarcar = function() {
  if ($(this).is(':checked')) {
    $("div.left-list input[type='checkbox']").attr('checked', true);
  } else {
    $("div.left-list input[type='checkbox']").attr('checked', false);
  };
}