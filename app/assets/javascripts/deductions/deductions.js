$(document).ready(function() {

  $('#member_submit').click(function( event ) {
    if( $('#list-payroll-types-to-save input').length == 0 ) {
      event.preventDefault();
      if( $('#requerido').length==0 ) {
        $( "#load_filter_payroll_types_text" ).after( '<label id="requerido" for="load_filter_payroll_types_text" generated="true" class="error">Requerido</label>' );
      } else {
        $('#requerido').css('display','block');
      }
    } else {
      if( $('#requerido').length != 0 ) {
        $('#requerido').remove()
      }
    }
  });

  // Llena el filtro para los empleados
  populateEmployeesFilter('/deductions/fetch_employees', 'load_filter_employees_text', 'load_filter_employees_id');

  CContables(); // Llama la funcion para el autocomplete de cuentas contables

  // Oculpa los campos porque dependiendo del tipo de planilla que se seleccione se van a mostrar
	$('#unicPayroll').hide();
  $('#deduction_payrolls').hide();
  $('#amount_exhaust_controls').hide();

  // En caso de seleccionar una planilla unica si se quiere cambiar se limpia la anterios para que no se vayan a guardar 2 ids
  $('#unicPayroll').on({ click: clearPayrolls });

  // Carga el arbol de cuentas de credito
	treeviewhr.cc_tree(cuenta_credito, true);
  $('.expand_tree').click(treeviewhr.expand);

  // Cuando se da click en una cuenta de credito para que setee el id
  $('#list').on({
		click: set_account,
		mouseenter: function() {
			$(this).css("text-decoration", "underline");
		},
		mouseleave: function() {
			$(this).css("text-decoration", "none");
	}}, ".node_link");

  // En caso de que exista algun error al cargar las planillas si se preciona click en el enlase para volver a cargarlas
  $("#error a").click(function (e){
    e.preventDefault();
    ObtenerPlanillas();
	});
  
  // Cuando cambia el valor del select se llama la funcion TipoDeduccion
  $('#deduction_deduction_type').change(function() {
    TipoDeduccion(this);
  });

  // Al precionar click sobre una planilla se settea el id de la planilla
  $('#activas').on("click", "td.payroll-type a", set_payroll);

  // Executes different options to select the employees
  $('input[name=select_method]').change(function() {
    selectEmployeesLeft($(this));
  });

  $('div.options-right input[name=check-employees-right]').change(selectEmployeesRight);
  
  // When the employees are loaded in the page move the selected to the right
  movePayrollTypes();
  // Moves the selected employees to the list at the right
  $('#add-to-list').on('click', moveToRight);
  $('#remove-to-list').on('click', function(event) {
    event.preventDefault();
    moveToLeft();
  });

  // Moves the selected payroll types to the list at the right
  $('#add-to-list-payroll-types').click(moveToRightPayrollTypes);
  $('#remove-to-list-payroll-types').click(moveToLeftPayrollTypes);
  
  $('#departments_employees').change(function() {
    filterDepartment($(this).val());
  });
  
  $('#superiors_employees').change(function() {
    filterSuperior($(this).val());
  });
  
  $('div#marcar-desmarcar input[name=check-employees]').change(marcarDesmarcar);

  is_beneficiary( $('#deduction_is_beneficiary').is(':checked') );

  $('#deduction_is_beneficiary').change(function() { is_beneficiary($('#deduction_is_beneficiary').is(':checked')) });

  populatePayrollTypesFilter('/deductions/fetch_payroll_type', 'load_filter_payroll_types_text', 'load_filter_payroll_types_id');

  $('div#marcar-desmarcar-payroll-types input[name=check-payroll-types]').change(checkUncheck);

  $('#check-payroll-types-right').change(selectPayrollTypesRight);

  
  /************************************************************************************************************/
  /************************************************************************************************************/
  /*
   * This has all the routes to access information through AJAX
  */
  deduction = {
    search_employee_payroll_logs_path: $('#search_employee_payroll_logs_path').val(),
    search_employee_by_id_path: $('#search_employee_by_id_path').val(),
    search_employee_by_code_path: $('#search_employee_by_code_path').val(),
    search_employee_by_name_path: $('#search_employee_by_name_path').val(),
    load_em_employees_path: $('#load_em_employees_path').val()
  }
  /*
   * Call some default functions
  */
  showHideEmployees(true); // Call the function to show/hide the div about employees
  searchAll("");// Call the function to get all employee list
  /*
   * Events
  */
  $('#deduction_individual').change(function() {
    showHideEmployees(false);
  });  

  // Add new row to employee_deduction
  $('form').on('click', '.add_fields', addFields); 

  // Remove a row to employee_deduction
  $('form').on('click', '.remove_fields', function(event) {
    event.preventDefault();
    removeFields(this);
  }); 

  $('#employee_items').on('click', '#openEmployeeModal', searching);
  
  $("#search_employee_results").on("click", "table tr a", function(e) {
    
    var employeeId = $(this).parents('td').find('input:hidden').val(),
        selector = $("#employee_items input:hidden[id='in_searching'][value='1']").parents('tr');

    searchEmployeeByAttr(employeeId, 'id', selector);
    $('#employeeModal button:eq(2)').trigger('click'); // Close modal
    $("#employee_items input:hidden[id='in_searching'][value='1']").val('0'); // Change input status
    e.preventDefault();
  });

  $('#employeeModal').on('click', 'button.close', closeModal)
                    .on('click', 'button:eq(2)', closeModal);

  // Search Employee by code
  $('form').on('focusout', '.search_code_employee', function() {
    searchEmployeeByAttr($(this).val(), 'code', $(this).parents('tr'));
  });

  $('#employee_items tr.items_deductions_form').each(function() {
    searchEmployeeByAttr($(this).find( "input[id*='_employee_id']" ).val(), 'id', $(this), false );
    populateAutocompleteEmployees( $(this).find("input[id='search_name_employee']") );
  });

  // Search employee in modal
  $('#search_name_employee_modal').keyup(function() {
    return searchAll($('#search_name_employee_modal').val());
  });

  $('#deduction_custom_calculation').on('change', function() {
    var value = $(this).val();

    $('#employee_items tr').each(function() {
      if( !parseBool( $(this).find("input:hidden[id*='_destroy']").val()) ) {
        $(this).find("input:text[id*='_calculation']").val(value);
      }
    });
  });

  /************************************************************************************************************/
  /************************************************************************************************************/

});


/************************************************************************************************************/
/************************************************************************************************************/

// If the user only close the modal
function closeModal() {
  $("#employee_items input:hidden[id='in_searching'][value='1']").val('0'); // Change input status
}

// Change this value to know that row you try to edit
function searching() {
  $(this).parents('tr').find('#in_searching').val('1');
}

function searchAll(name) {
  return $.ajax({
    url: deduction.search_employee_payroll_logs_path,
    dataType: "script",
    data: {
      search_employee_name: name
    }
  });
}

// Function to fill autocompletes (Names of employees)
function populateAutocompleteEmployees(idField) {
  $.getJSON(deduction.load_em_employees_path, function(accounts) {
    $(idField).autocomplete({
      source: $.map(accounts, function(item) {
        $.data(document.body, 'e_' + item.id + "", item.nombre_cc);
        return {
          label: item.surname + ' ' + item.name,
          id: item.id
        }
      }),
      select: function( event, ui ) {
        searchEmployeeByAttr(ui.item.label, "name", $(event.target).parents('tr'));
      },
      focus: function(event, ui) {
        // console.log(ui.item.label);
      }
    });
  });
}

// Search a employee by attr (id, code, name)
function searchEmployeeByAttr(value, type, selector, check) {
  
  var url, customData;
  check = typeof check !== 'undefined' ? check : true;

  switch(type) {
    case "id":
        url = deduction.search_employee_by_id_path,
        customData = { search_id: value };
      break;
    
    case "code":
        url = deduction.search_employee_by_code_path,
        customData = { search_code: value };
      break;

    case "name":
        url = deduction.search_employee_by_name_path,
        customData = { search_name: value };
      break;
  }

  $.ajax({
    type: "GET",
    url: url,
    dataType: "json",
    data: customData,
    success: function(data) {
      populateListEmployees(data, type, selector, check);
    },
    error: function(response, textStatus, errorThrown) {
      showMessage("error", "Error al intentar borrar el registro");
    }
  });
}

function populateListEmployees(employee, type, selector, check) {

  if( !checkIfEmployeeExist(employee) || !check ) {

    if( $(selector).find("input:hidden[id*='_employee_id']").val() != "" && check ) {
      removeToList($(selector).find("input:hidden[id*='_employee_id']").val());
    }

    if( type != "id" ) {
      $(selector).find("input:hidden[id*='_employee_id']").val(employee.id);
    }
    $(selector).find("input[id='search_code_employee']").val(employee.number_employee);
    $(selector).find("input[id='search_name_employee']").val(employee.name + " " + employee.surname);
    addToList(employee.id);
  } else {
    // Clear inputs
    if( $(selector).find("input:hidden[id*='_employee_id']").val() == "" ) {
      showMessage("info", "El empleado a sido habilitado nuevamente o ya existe en la lista");
      $(selector).find("input:hidden[id*='_employee_id']").val("");
      $(selector).find("input[id='search_code_employee']").val("");
      $(selector).find("input[id='search_name_employee']").val("");
    }
  }

  if(!check) {
    hiddenEmployees(employee.id);
  }

  disableInputs();
}

// De abajo para arriba
function addToList(id) {
  $('.employees-list.left-list').find("input:checkbox[value='" + id + "']").prop('checked', true);
  $('#add-to-list').trigger('click');
}

function removeToList(id) {
  $('#list-to-save').find("input:checkbox[value='" + id + "']").prop('checked', false);
  moveToLeft();
}

// De arriba para abajo
function addToTable(id, name) {
  
  var exist = false;
  var parent = findParentByAttr(id, "id"),
      parent2 = findParentByAttr(id, "id", true);

  if(typeof parent != 'undefined') {
    exist = true;
  } else {
    if(typeof parent2 != 'undefined') {
      $(parent2).show();
      exist = true;
    }
  }

  if( !exist ) {
    $('.add_fields').trigger('click');
    var selector = $('#employee_items').find('tr:eq(1)');
    searchEmployeeByAttr(name, "name", selector[0], false);
  }
}

function removeToTable(id) {
  
  var parent = findParentByAttr(id, "id");

  if(typeof parent != 'undefined') {
    $(parent).find("input:hidden[id*='_destroy']").val(1);
    $(parent).hide();
    return false;
  }
}

// Show/Hide The differents view based in the checkbox "individual"
function showHideEmployees(isIndividual) {
  if( $('#deduction_individual').is(':checked') ) {
    $('#employee_items_one').hide()
    $('#employee_items_two').show();
    $('#custom_calculation').hide();
  } else {
    $('#employee_items_one').show();
    $('#employee_items_two').hide();
    $('#custom_calculation').show();
  }
  if(isIndividual) {
    $('#deduction_custom_calculation').val( $('#employee_items tr:eq(1)').find("input:text[id*='_calculation']").val() );
  }
}

function addFields(e) {

  var time = new Date().getTime(),
      regexp = new RegExp($(this).data('id'), 'g');
  $('.header_items').after($(this).data('fields').replace(regexp, time));

  populateAutocompleteEmployees( $('#employee_items tr:eq(1)').find("input[id='search_name_employee']") );
  e.preventDefault();
}

function removeFields(elevent) {
  var id = $(elevent).parents('tr').find("input:hidden[id*='_employee_id']").val();
  removeToList(id);
  $(elevent).prev('input[type=hidden]').val(1);
  $(elevent).parents('tr').hide();
}

// Only chech if the employee are in the list
function checkIfEmployeeExist(employee) {

  var result = false;
  var parent = findParentByAttr(employee.id, "id"),
      parent2 = findParentByAttr(employee.id, "id", true);

  if(typeof parent != 'undefined') {
    result = true;
  } else {
    if(typeof parent2 != 'undefined') {
      $(parent2).show();
      $(parent2).find("input:hidden[id*='_destroy']").val("false");
      result = true;
    }
  }

  return result;
}

function showMessage(type, message) {
  $('div#message').html('<div class="alert alert-' + type + '">' + message + '</div>');
  $('div.alert.alert-error').delay(4000).fadeOut();
}

// Solo para la tabla de abajo visual
function findParentByAttr(value, type, hidden) {
  var parent;
  hidden = typeof hidden !== 'undefined' ? hidden : false;

  $('#employee_items tr').each(function() {

    if( hidden ) {
      if( parseBool( $(this).find("input:hidden[id*='_destroy']").val()) ) {
        if(type === "id") {
          if( parseInt($(this).find("input:hidden[id*='employee_id']").val()) === parseInt(value) ) {
            parent = $(this);
            return false;
          }
        }
      }
    } else {
      if( !parseBool( $(this).find("input:hidden[id*='_destroy']").val()) ) {
        if(type === "id") {
          if( parseInt($(this).find("input:hidden[id*='employee_id']").val()) === parseInt(value) ) {
            parent = $(this);
            return false;
          }
        }
      }
    }

  });

  return parent;
}

function parseBool(str) {
  if(str==null) return false;
  if(str=="false") return false;
  if(str=="0") return false;
  if(str=="true") return true;
  if(str=="1") return true;

  return false;
}

function disableInputs() {

  // Arriba
  $(".employees-list.list-right input:checkbox").each(function() {
    if( $.inArray( parseInt($(this).val()) , detailPayments) != -1 ) {
      $(this).attr('disabled', 'disabled');
    }
  });
  // Abajo
  $('#employee_items tr').each(function() {
    if( !parseBool( $(this).find("input:hidden[id*='_destroy']").val()) ) {
      if( $.inArray( parseInt($(this).find("input:hidden[id*='employee_id']").val())   , detailPayments) != -1 ) {
        $(this).find("#search_code_employee").attr('disabled', 'disabled');
        $(this).find("#search_name_employee").attr('disabled', 'disabled');
      }        
    }
  });
}

function hiddenEmployees(id_employee) {
  if( $.inArray( parseInt(id_employee) , detailPaymentsHidden) != -1 ) {
    console.log(id_employee);
    var parent = findParentByAttr(id_employee, "id");
    removeToList(id_employee);
    $(parent).find("input[type=hidden][id*='_destroy']").val(1);
    $(parent).hide();
  }  
}

/************************************************************************************************************/
/************************************************************************************************************/

function is_beneficiary(value) {
  if( value ) {
    $('#beneficiary_id').attr('disabled', 'disabled');
    $('#deduction_beneficiary_id').val('');
    $('#deduction_beneficiary_id').attr('readonly', true);
  } else {
    $('#deduction_beneficiary_id').attr('readonly', false);
    $('#beneficiary_id').removeAttr('disabled', 'disabled');
  }
}

// Consulta las cuentas contables para hacer el autocomplete
function CContables() {
   $.getJSON('/ledger_accounts/fetch', function(category_data) {
        $( "#deduction_ledger_account" ).autocomplete({
            source: $.map(category_data, function(item){
                $.data(document.body, 'category_' + item.id+"", item.naccount);
                return{
                    label: item.naccount,                        
                    id: item.id
                }
            }),
            select: function( event, ui ) {
                $("#deduction_ledger_account_id").val(ui.item.id);
            },
            focus: function(event, ui){
                $( "#deduction_ledger_account" ).val(ui.item.label);
            }

        })
        if($("#deduction_ledger_account_id").val()){
            var deducciones_cuentas = $.data(document.body, 'category_' + $("#deduction_ledger_account_id").val()+'');
            $("#deduction_ledger_account").val(deducciones_cuentas);
        }        
    }); 
}

// Function to check and uncheck all the employees at the left.
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

// Resive el id del departamento para hacer un filtro por departamento
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

// Function to filter results by superior name 
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

// Function to move the employees to the right
function moveToRight(e) {
  e.preventDefault();
  moveEmployees();
}

// Function to move employees to the left
function moveToLeft() {
  var appendEmployees = "";
  $('div.employees-list.list-right input[type=checkbox]:not(:checked)').each(function() {

    // Remove To Table
    removeToTable( $(this).val() );

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

function moveEmployees() {
  var appendEmployees = "";
  $('div.employees-list.left-list input[type=checkbox]:checked').each(function() {

    // Add To Table
    addToTable( $(this).val(), $(this).next('label').text() );

    if (!$(this).is(':disabled')) {
      appendEmployees = "<div class='checkbox-group'>" +
                    "<div class='checkbox-margin'>" +
                      "<input type='checkbox' data-sup='"+ $(this).data('sup') +"' data-dep='"+ $(this).data('dep') +"' checked='checked' class='align-checkbox right' id='"+ $(this).data('id') +"' name='employee_ids' value='"+ $(this).val() +"' />" +
                      "<label class='checkbox-label' for='"+ $(this).data('id') +"'>"+ $(this).next().text() +"</label>" +
                    "</div>" +
                  "</div>"; 
      $('#list-to-save').append(appendEmployees);
      $(this).closest('.checkbox-group').remove();
    };
    disableInputs();
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

// Establece el campo oculto con el id d la cuenta de credito y muestra el texto en el campo cuenta credito
function set_account(e) {
    e.preventDefault();
    var accountId = $(this).closest('li').data('id');
    var accountName = $(this).text();
    $('#deduction_ledger_account_id').val(accountId);
    $('#deduction_ledger_account').val(accountName);  
}

// Resive el tipo de deducicon de un select y dependiendo el valor ejecuta diferentes opciones
function TipoDeduccion(selected) {
  switch($(selected).val()) {
    case 'Unica':
      $('#amount_exhaust_controls').hide();
      $('#payrolls-to-save').empty(); //prueba
      $('#unicPayroll').show();
      $('#deduction_payrolls').show();
      ObtenerPlanillas();
    break;
    case 'Monto_Agotar':
      $('#amount_exhaust_controls').show();
      $('#payrolls-to-save').empty(); //prueba
      $('#unicPayroll').hide();
      $('#deduction_payrolls').hide();
    break;
    case 'Constante':
    $('#amount_exhaust_controls').hide();
      $('#payrolls-to-save').empty(); //prueba
      $('#unicPayroll').hide();
      $('#deduction_payrolls').hide();
    break;
  }
}

// Obtiene todas las planillas activas
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

// Carga las planillas activas en una tabla
function add_activas(payroll, target_table) {
  var row = $(target_table + '> tbody:last').append('<tr>' + 
      '<td class="payroll-id">' + payroll.id +'</td>' +
      '<td class="payroll-type"><a data-dismiss="modal" href="#">' + payroll.payroll_type.description +'</a></td>' +
      '<td>' +  payroll.start_date + '</td>' +
      '<td>' +  payroll.end_date + '</td>' +
      '<td>' +  payroll.payment_date + '</td>' +
    '</tr>');
  return row;
}

// Establece el campo oculto de con el id de la planilla unica seleccionada
function set_payroll(e) {
    e.preventDefault();
    var payrollId = $(e.target).parent().prev().text();
    var payrollName = $(e.target).text();
    appendPayrolls = "<input type='hidden" +"' name='deduction[payroll_ids][]' value='"+ payrollId +"' />";
    $('#payrolls-to-save').append(appendPayrolls);
    $('#deduction_payroll').val(payrollName);  
}

// Limpia el id y el texto de la planilla UNICA seleccionada en caso de querer cambiar la planilla unica seleccionada
// para que no se vayan varioss ids de planillas solo se tiene que guardar un unico id
function clearPayrolls(){
  $('#payrolls-to-save').empty(); //elimina el id de la planilla que ya no se quiere guardar
  $('#deduction_payroll').val('');  
}

function populatePayrollTypesFilter(url, textField, idField) {
  $.getJSON(url, function(payrollTypes) {
      $(document.getElementById(textField)).autocomplete({
          source: $.map(payrollTypes, function(item){
              $.data(document.body, 'account_' + item.id + "", item.description );
              return{
                  label: item.description,                        
                  id: item.id,
          sup: item.id,
          dep: item.id,
          data_id: 'payroll_type_'+ item.id
              }
          }),
          select: function( event, ui ) {
        if (!$('#list-to-save input#'+ui.item.data_id).length) {
          appendPayrollTypes = "<div class='checkbox-group'>" +
                        "<div class='checkbox-margin'>" +
                          "<input type='checkbox' data-sup='"+ ui.item.sup +"' data-dep='"+ ui.item.dep +"' checked='checked' class='align-checkbox right' id='"+ ui.item.data_id +"' name='deduction[payroll_type_ids][]' value='"+ ui.item.id +"' />" +
                          "<label class='checkbox-label' for='"+ ui.item.data_id +"'>"+ ui.item.label +"</label>" +
                        "</div>" +
                      "</div>"; 
          $('#list-payroll-types-to-save').append(appendPayrollTypes);
          $('input#'+ ui.item.data_id + '_left').closest('.checkbox-group').remove();
        }
          }
      })     
  }); 
}

function movePayrollTypes() {
  var appendPayrollTypes = "";
  $('div.payroll-types-list.left-list input[type=checkbox]:checked').each(function() {
    if (!$(this).is(':disabled')) {
      appendPayrollTypes = "<div class='checkbox-group'>" +
                    "<div class='checkbox-margin'>" +
                      "<input type='checkbox' data-sup='"+ $(this).data('sup') +"' data-dep='"+ $(this).data('dep') +"' checked='checked' class='align-checkbox right' id='"+ $(this).data('id') +"' name='deduction[payroll_type_ids][]' value='"+ $(this).val() +"' />" +
                      "<label class='checkbox-label' for='"+ $(this).data('id') +"'>"+ $(this).next().text() +"</label>" +
                    "</div>" +
                  "</div>"; 
      $('#list-payroll-types-to-save').append(appendPayrollTypes);
      $(this).closest('.checkbox-group').remove();
    };
  });
  $('div#marcar-desmarcar-payroll-types input[name=check-payroll-types]').attr('checked', false);
  $('div.options-right input[name=check-payroll-types-right]').attr('checked', true);
}

// Function to move the payroll-types to the right
function moveToRightPayrollTypes(e) {
  e.preventDefault();
  movePayrollTypes();
}

// Function to move payroll-types to the left
function moveToLeftPayrollTypes(e) {
  e.preventDefault();
  var appendPayrollTypes = "";
  $('div.payroll-types-list.list-right input[type=checkbox]:not(:checked)').each(function() {
    appendPayrollTypes = "<div class='checkbox-group'>" +
                  "<div class='checkbox-margin'>" +
                    "<input type='checkbox' data-sup='"+ $(this).data('sup') +"' data-dep='"+ $(this).data('dep') +"' data-id='"+ $(this).attr('id') +"' class='align-checkbox right' id='"+ $(this).attr('id')+'_left' +"' name='left-list-payroll-types' value='"+ $(this).val() +"' />" +
                    "<label class='checkbox-label' for='"+ $(this).attr('id')+'_left' +"'>"+ $(this).next().text() +"</label>" +
                  "</div>" +
                "</div>"; 
    $('#no-save-payroll-types').append(appendPayrollTypes);
    $(this).closest('.checkbox-group').remove();
  });
  // if ($('input[name=select_method]:checked').val() == 'department') {
  //  filterDepartment($('#departments_employees').val());
  // } else if ($('input[name=select_method]:checked').val() == 'boss') {
  //  filterSuperior($('#superiors_employees').val())
  // };
}

function checkUncheck() {
  if ($(this).is(':checked')) {
    $("div.payroll-types-list.left-list input[type='checkbox']").attr('checked', true);
  } else {
    $("div.payroll-types-list.left-list input[type='checkbox']").attr('checked', false);
  };  
}

function selectPayrollTypesRight() {
  if ($(this).is(':checked')) {
    $("div.payroll-types-list.list-right input[type='checkbox']").attr('checked', true);
  } else {
    $("div.payroll-types-list.list-right input[type='checkbox']").attr('checked', false);
  };
}
