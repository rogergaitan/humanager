$(document).ready(function(){

  //llena el filtro para los empleados
  populateEmployeesFilter('/deductions/fetch_employees', 'load_filter_employees_text', 'load_filter_employees_id');

	$('#planilla').hide();
	treeviewhr.cc_tree(cuenta_credito, true);
  $('.expand_tree').click(treeviewhr.expand);

  	  $('#list').on({
		click: set_account,
		mouseenter: function() {
			$(this).css("text-decoration", "underline");
		},
		mouseleave: function() {
			$(this).css("text-decoration", "none");
		}}, ".node_link");

  	 //en caso de que exista algun error al cargar las planillas si se preciona click en el enlase para volver a cargarlas
  	$("#error a").click(function (e){
	e.preventDefault();
	ObtenerPlanillas();
	});
  
	TipoDeduccion();
  	//$('#deduction_deduction_type').change(TipoDeduccion);

  	//$('#activas').on("click", "td.payroll-type a", set_payroll);

  //executes different options to select the employees
  $('input[name=select_method]').change(function() {
    selectEmployeesLeft($(this));
  });

  $('div.options-right input[name=check-employees-right]').change(selectEmployeesRight);
  
  //when the employees are loaded in the page move the selected to the right
  moveEmployees();

  //moves the selected employees to the list at the right
  $('#add-to-list').click(moveToRight);
  $('#remove-to-list').click(moveToLeft);
  
  $('#departments_employees').change(function() {
    filterDepartment($(this).val());
    });
  
  $('#superiors_employees').change(function() {
    filterSuperior($(this).val());
  });
  
  $('div#marcar-desmarcar input[name=check-employees]').change(marcarDesmarcar);

});


//function to check and uncheck all the employees at the left.
function marcarDesmarcar () {
  if ($(this).is(':checked')) {
    $("div.left-list input[type='checkbox']").attr('checked', true);
  } else {
    $("div.left-list input[type='checkbox']").attr('checked', false);
  };
}

function selectEmployeesRight() {
  if ($(this).is(':checked')) {
    $("div.list-right input[type='checkbox']").attr('checked', true);
  } else {
    $("div.list-right input[type='checkbox']").attr('checked', false);
  };
}

//resive el id del departamento 
function filterDepartment (dropdown) { 
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


//function to filter results by superior name 
function filterSuperior (dropdown) {
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

//function to move the employees to the right
function moveToRight(e) {
  e.preventDefault();
  moveEmployees();
}

//Function to move employees to the left
function moveToLeft (e) {
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
    filterDepartment($('#departments_employees').val());
  } else if ($('input[name=select_method]:checked').val() == 'boss') {
    filterSuperior($('#superiors_employees').val())
  };
}

function moveEmployees () {
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

function selectEmployeesLeft(selected) {
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
      filterSuperior($('#superiors_employees').val());
      $('#list-superior').show(); 
      break;
    case 'department':
      $('#employee-filter').hide();
      $('#list-superior').hide(); 
      filterDepartment($('#departments_employees').val());
      $('#list-departments').show();      
      break;
  }
}

function populateEmployeesFilter(url, textField, idField) {
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

//
//settea el campo oculto con el id d la cuenta de credito y muestra el texto en el campo cuenta credito

function set_account(e) {
    e.preventDefault();
    var accountId = $(this).closest('li').data('id');
    var accountName = $(this).text();
    $('#deduction_ledger_account_id').val(accountId);
    $('#deduction_ledger_account').val(accountName);  
}

function TipoDeduccion(e) {
	if ($('#deduction_deduction_type').val() == 'unica'){
	 //CODIGO QUE VALIDA LAS PLANILLAS EN LAS QUE ESTA EL USUARIO
	}
	else{
		AllPlanillas();
	}
}

//Agrega todas las planillas activas esta funcion se ejecuta cuando se selecciona constante
function AllPlanillas(){
    var planillas = new Array();
    $.getJSON('/deductions/get_activas', function(result) {
      $(result.activa).each(function() { 
        appendPayrolls = "<input type='hidden" +"' name='deduction[payroll_ids][]' value='"+ this.id +"' />";
      $('#payrolls-to-save').append(appendPayrolls);
      }); //fin del each
    });
 }

//EL CODIGO DE AQUI PARA ABAJO NO LO ESTOY NECESITANDO
//Obtiene todas las planillas activas
function ObtenerPlanillas(){
    $.ajax('/payrolls/get_activas', {
    	type: 'GET',
    	timeout: 8000,

    	beforeSend: function() {
		$('#error').hide();
		$('#loading').show();
		},

		complete: function() {
		$('#loading').hide();
		},

    	success: function(result) {
    	$('table#activas > tbody').empty();
      	$(result.activa).each(function() { add_activas(this, 'table#activas')});
    	},

    	error: function(result) {
		$('#error').show();
		}
	});
}

//carga las planillas activas en una tabla
 function add_activas(payroll, target_table)
  {
    var row = $(target_table + '> tbody:last').append('<tr>' + 
        '<td class="payroll-id">' + payroll.id +'</td>' +
        '<td class="payroll-type"><a data-dismiss="modal" href="#">' + payroll.payroll_type.description +'</a></td>' +
        '<td>' +  payroll.star_date + '</td>' +
        '<td>' +  payroll.end_date + '</td>' +
        '<td>' +  payroll.payment_date + '</td>' +
      '</tr>');
    return row;
  }

function set_payroll(e) {
    e.preventDefault();
    var payrollId = $(this).parent().prev().text();
    var payrollName = $(this).text();
    $('#deduction_payroll_ids_').val(payrollId);
    $('#deduction_payroll').val(payrollName);  
}