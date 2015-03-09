$(document).ready(function() {

  deduction = {
    search_employee_payroll_logs_path: $('#search_employee_payroll_logs_path').val(),
    search_employee_by_id_path: $('#search_employee_by_id_path').val(),
    search_employee_by_code_path: $('#search_employee_by_code_path').val(),
    search_employee_by_name_path: $('#search_employee_by_name_path').val(),
    load_em_employees_path: $('#load_em_employees_path').val()
  }

  $('#deduction_payroll_type_ids').multiSelect({
    selectableHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;'  autocomplete='off' placeholder='Filter entries...'>",
    selectionHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;' autocomplete='off' placeholder='Filter entries...'>",
    afterInit: function(ms){
      var that = this,
      $selectableSearch = that.$selectableUl.prev(),
      $selectionSearch = that.$selectionUl.prev(),
      selectableSearchString = '#'+that.$container.attr('id')+' .ms-elem-selectable:not(.ms-selected)',
      selectionSearchString = '#'+that.$container.attr('id')+' .ms-elem-selection.ms-selected';

      that.qs1 = $selectableSearch.quicksearch(selectableSearchString)
      .on('keydown', function(e){
        if (e.which === 40){
          that.$selectableUl.focus();
          return false;
        }
      });

      that.qs2 = $selectionSearch.quicksearch(selectionSearchString)
      .on('keydown', function(e){
        if (e.which == 40){
          that.$selectionUl.focus();
          return false;
        }
      });
    },
    afterSelect: function(){
      this.qs1.cache();
      this.qs2.cache();
    },
    afterDeselect: function(){
      this.qs1.cache();
      this.qs2.cache();
    }
  });

  $('#deduction_employee_ids').multiSelect({
    selectableHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;'  autocomplete='off' placeholder='Filter entries...'>",
    selectionHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;' autocomplete='off' placeholder='Filter entries...'>",
    afterInit: function(ms){
      var that = this,
      $selectableSearch = that.$selectableUl.prev(),
      $selectionSearch = that.$selectionUl.prev(),
      selectableSearchString = '#'+that.$container.attr('id')+' .ms-elem-selectable:not(.ms-selected)',
      selectionSearchString = '#'+that.$container.attr('id')+' .ms-elem-selection.ms-selected';

      that.qs1 = $selectableSearch.quicksearch(selectableSearchString)
      .on('keydown', function(e){
        if (e.which === 40){
          that.$selectableUl.focus();
          return false;
        }
      });

      that.qs2 = $selectionSearch.quicksearch(selectionSearchString)
      .on('keydown', function(e){
        if (e.which == 40){
          that.$selectionUl.focus();
          return false;
        }
      });
    },
    afterSelect: function(values) { // selected
      addEmployeeTable(values[0]);
      this.qs1.cache();
      this.qs2.cache();
    },
    afterDeselect: function(values) { // deselected
      removeEmployeeTable(values[0]);
      this.qs1.cache();
      this.qs2.cache();
    }
  });
  
  typeDeduction($('#deduction_deduction_type'));

  // En caso de seleccionar una planilla unica si se quiere cambiar se limpia la anterios 
  // para que no se vayan a guardar 2 ids
  $('#unicPayroll').on({ click: clearPayrolls });

  searchAll(""); // Call the function to get all employee list

  /* E V E N T S */

  $("#search_employee_results").on("click", "table tr a", function(e) {
    
    var employeeId = $(this).parents('td').find('input:hidden').val(),
        selector = $("#employee_items input:hidden[id='in_searching'][value='1']").parents('tr');

    searchEmployeeByAttr(employeeId, 'id', selector, true);
    $('#employeeModal').modal('hide'); // Close modal
    $("#employee_items input:hidden[id='in_searching'][value='1']").val('0'); // Change input status
    e.preventDefault();
  });

  // Change this value to know that row you try to edit
  $('#employee_items').on('click', '#openEmployeeModal', function() {
    $(this).parents('tr').find('#in_searching').val('1');
  });

  // Search employee in modal
  $('#search_name_employee_modal').keyup(function() {
    return searchAll($('#search_name_employee_modal').val());
  });

  showHideEmployees(true); // Call the function to show/hide the div about employees
  isBeneficiary($('#deduction_is_beneficiary').is(':checked'));

  // Deduction Individual
  $('#deduction_individual').parents('label').click(function() {
    showHideEmployees($('#deduction_is_beneficiary').is(':checked'));
  });

  $('#deduction_individual').next().click(function() {
    showHideEmployees($('#deduction_is_beneficiary').is(':checked'));
  });

  $('#emplotee_select_all').parents('label').click(function() {
    emploteeSelectAll();
  });

  $('#emplotee_select_all').next().click(function() {
    emploteeSelectAll();
  });

  $('#payroll_select_all').parents('label').click(function() {
    payrollSelectAll();
  });

  $('#payroll_select_all').next().click(function() {
    payrollSelectAll();
  });

  // Is Beneficiary
  $('#deduction_is_beneficiary').parents('label').click(function() {
    isBeneficiary($('#deduction_is_beneficiary').is(':checked'));
  });

  $('#deduction_is_beneficiary').next().click(function() {
    isBeneficiary($('#deduction_is_beneficiary').is(':checked'));
  });

  $('#member_submit').click(function( event ) {
    $("form[id*='edit_deduction']").parsley().validate();
  });
  
  // When change the value called the function typeDeduction
  $('#deduction_deduction_type').change(function() {
    typeDeduction(this);
  });

  // Al precionar click sobre una planilla se establece el id de la planilla
  $('#activas').on("click", "td.payroll-type a", setPayroll);

  // Carga el arbol de cuentas de credito
  treeviewhr.cc_tree(cuenta_credito, true);
  $('.expand_tree').click(treeviewhr.expand);

  // Cuando se da click en una cuenta de credito para que establesca el id
  $('#list').on({
    click: setAccount,
    mouseenter: function() {
      $(this).css("text-decoration", "underline");
    },
    mouseleave: function() {
      $(this).css("text-decoration", "none");
  }}, ".node_link");

  // En caso de que exista algun error al cargar las planillas si se preciona click en el enlase para volver a cargarlas
  $("#error a").click(function (e){
    e.preventDefault();
    getPayrolls();
  });

  CContables(); // Llama la funcion para el autocomplete de cuentas contables

  $("#employee_items input:text[id*='_calculation']").keyup(resources.twoDecimals);

  $('#deduction_custom_calculation').keyup(resources.twoDecimals);

  $('#deduction_custom_calculation').on('change', function() {
    var value = $(this).val();
    $('#employee_items tr').each(function() {
      if( !parseBool( $(this).find("input:hidden[id*='_destroy']").val()) ) {
        $(this).find("input:text[id*='_calculation']").val(value);
      }
    });
  });  

  // Add new row to employee_deduction
  $('form').on('click', '.add_fields', addFields);

  // Remove a row to employee_deduction
  $('form').on('click', '.remove_fields', function(event) {
    event.preventDefault();
    removeFields(this);
  });

  $('#employee_items tr.items_deductions_form').each(function() {
    searchEmployeeByAttr($(this).find( "input[id*='_employee_id']" ).val(), 'id', $(this), false );
  });

  // Search Employee by code
  $('form').on('focusout', '.search_code_employee', function() {
    searchEmployeeByAttr($(this).val(), 'code', $(this).parents('tr'), true);
  });

});

/* F U N C T I O N S */
function selectUnselectEmployees(isSelect) {
  
  var theClass = 'ms-selection';
  if(isSelect) {
    theClass = 'ms-selectable';
  }

  $('#ms-deduction_employee_ids div.'+theClass).find('li').each( function() {
    var id = $(this).attr('id').replace('-selectable','');
    if(isSelect) {
      addEmployeeTable(id);
    } else {
      removeEmployeeTable(id);
    }
  });
}

function emploteeSelectAll() {
  if( $('#emplotee_select_all').is(':checked') ) {
    $('#deduction_employee_ids').multiSelect('select_all');
    selectUnselectEmployees(true);
  } else {
    $('#deduction_employee_ids').multiSelect('deselect_all');    
    selectUnselectEmployees(false);
  }
}

function payrollSelectAll() {
  if( $('#payroll_select_all').is(':checked') ){
    $('#deduction_payroll_type_ids').multiSelect('select_all');
  } else {
    $('#deduction_payroll_type_ids').multiSelect('deselect_all');  
  }
}

function showMessage(type, message) {
  var icon;
  if(type === "success") {
    icon = 'check';
  }
  if(type === "danger") {
    icon = 'times';
  }
  if(type === "warning") {
    icon = 'warning';
  }
  if(type === "info") {
    icon = 'info-circle';
  }

  $('#div-message').show();
  $('#div-message').find('div.alert.alert-dismissable').addClass('alert-'+type);
  $('#div-message').find('label#message').html(message);
  $('#div-message').find('i').addClass('fa-'+icon);


  $('div.alert.alert-'+type).fadeIn(4000, function() {
    setTimeout(function() {
        $(this).fadeOut("slow");
        $('#div-message').find('div.alert.alert-dismissable').removeClass('alert-' + type);
        $('#div-message').find('i').removeClass('fa-' + icon);
        $('#div-message').hide();
    },4000);
  });
}

function typeDeduction(selected) {
  switch($(selected).val()) {
    case 'unique':
      $('#amount_exhaust_controls').hide();
      $('#payrolls-to-save').empty();
      $('#unicPayroll').show();
      $('#deduction_payrolls').show();
      getPayrolls();
    break;
    case 'amount_to_exhaust':
      $('#amount_exhaust_controls').show();
      $('#payrolls-to-save').empty();
      $('#unicPayroll').hide();
      $('#deduction_payrolls').hide();
    break;
    case 'constant':
      $('#amount_exhaust_controls').hide();
      $('#payrolls-to-save').empty();
      $('#unicPayroll').hide();
      $('#deduction_payrolls').hide();
    break;
  }
}

// Obtiene todas las planillas activas
function getPayrolls() {
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
        $(result.activa).each(function() { addActives(this, 'table#activas')});
      },
    error: function(result) {
      $('#error').show();
    }
 });
}

// Carga las planillas activas en una tabla
function addActives(payroll, target_table) {
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
function setPayroll(e) {
  e.preventDefault();
  var payrollId = $(e.target).parent().prev().text();
  var payrollName = $(e.target).text();
  appendPayrolls = "<input type='hidden" +"' name='deduction[payroll_ids][]' value='"+ payrollId +"' />";
  $('#payrolls-to-save').append(appendPayrolls);
  $('#deduction_payroll').val(payrollName);  
}

// Establece el campo oculto con el id d la cuenta de credito y muestra el texto en el campo cuenta credito
function setAccount(e) {
  e.preventDefault();
  var accountId = $(this).closest('li').data('id');
  var accountName = $(this).text();
  $('#deduction_ledger_account_id').val(accountId);
  $('#deduction_ledger_account').val(accountName);  
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

// Consulta las cuentas contables para hacer el autocomplete
function CContables() {
  $.getJSON('/ledger_accounts/fetch', function(category_data) {
    $("#deduction_ledger_account").autocomplete({
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
    $("#deduction_ledger_account").removeClass('ui-autocomplete-input');
  }); 
}

// Limpia el id y el texto de la planilla UNICA seleccionada en caso de querer cambiar la planilla unica seleccionada
// para que no se vayan varioss ids de planillas solo se tiene que guardar un unico id
function clearPayrolls(){
  $('#payrolls-to-save').empty(); //elimina el id de la planilla que ya no se quiere guardar
  $('#deduction_payroll').val('');  
}

function isBeneficiary(value) {
  if( value ) {
    $('#beneficiary_id').attr('disabled', 'disabled');
    $('#deduction_beneficiary_id').val('');
    $('#deduction_beneficiary_id').attr('readonly', true);
  } else {
    $('#deduction_beneficiary_id').attr('readonly', false);
    $('#beneficiary_id').removeAttr('disabled', 'disabled');
  }
}

function addFields(e) {
  e.preventDefault();
  var time = new Date().getTime(),
      regexp = new RegExp($(this).data('id'), 'g');
  $('.header_items').after($(this).data('fields').replace(regexp, time));

  populateAutocompleteEmployees( $('#employee_items tr:eq(1)').find("input[id='search_name_employee']") );
  $('#employee_items tr:eq(1)').find("input[id='search_name_employee']").removeClass("ui-autocomplete-input");
}

function removeFields(element) {
  var id = $(element).parents('tr').find("input:hidden[id*='_employee_id']").val();
  
  if(id != "") {
    removeEmployeeMulti(id);
    $(element).prev('input[type=hidden]').val(1);
    $(element).parents('tr').hide();
    return;
  }
  $(element).parents('tr').remove();
}

// Search a employee by attr (id, code, name)
function searchEmployeeByAttr(value, type, selector, isNew) {
  
  var url, customData;
  isNew = typeof isNew !== 'undefined' ? isNew : false;

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
      if( data != null ) {
        populateListEmployees(data, type, selector, isNew);
      }
    },
    error: function(response, textStatus, errorThrown) {
      showMessage("danger", "Error al intentar borrar el registro");
    }
  });
}

function populateListEmployees(employee, type, selector, isNew) {

  if( checkIfEmployeeExist(employee) && isNew ) {
    showMessage("info", "El empleado a sido habilitado nuevamente o ya existe en la lista");
    addEmployeeMulti(employee.id)
    $(selector).remove();
  }

  if(!isNew)
    hiddenEmployees(employee.id);
}

function hiddenEmployees(id_employee) {
  if( $.inArray( parseInt(id_employee) , detailPaymentsHidden) != -1 ) {
    var data = findParentByAttr(id_employee, "id");
    // removeToList(id_employee);
    $(data.parent).find("input[type=hidden][id*='_destroy']").val(1);
    $(data.parent).hide();
  }  
}

// Only chech if the employee are in the list
function checkIfEmployeeExist(employee) {

  if(employee == null)
    return false;

  var data = findParentByAttr(employee.id, "id");

  if(data.destroy === "")
    return false;
  
  $(data.parent).show();
  $(data.parent).find("input:hidden[id*='_destroy']").val("false");
  $(data.parent).find("input:hidden[id*='_employee_id']").val(employee.id);
  $(data.parent).find("input[id='search_code_employee']").val(employee.number_employee);
  $(data.parent).find("input[id='search_name_employee']").val(employee.name + " " + employee.surname);
  $(data.parent).find("input[id='search_code_employee']").attr('disabled', 'disabled');
  $(data.parent).find("input[id='search_name_employee']").attr('disabled', 'disabled');
  $(data.parent).find("a[id='openEmployeeModal']").attr('disabled', 'disabled');

  return true;
}

// Solo para la tabla de abajo visual
function findParentByAttr(value, type) {
  var parent = "", destroy = "";

  $('#employee_items tr').each(function() {
    if(type === "id") {
      if( parseInt($(this).find("input:hidden[id*='employee_id']").val()) === parseInt(value) ) {
        parent = $(this);
        destroy = parseBool( $(this).find("input:hidden[id*='_destroy']").val());
        return false;
      }
    }
  });

  return {
    parent: parent,
    destroy: destroy
  };
}

function parseBool(str) {
  if(str==null) return false;
  if(str=="false") return false;
  if(str=="0") return false;
  if(str=="true") return true;
  if(str=="1") return true;

  return false;
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
        searchEmployeeByAttr(ui.item.label, "name", $(event.target).parents('tr'), true);
      },
      focus: function(event, ui) {
      }
    });
    $(idField).removeClass('ui-autocomplete-input');
    });  
}

// Desde el multiselect a la tabla
function addEmployeeTable(id) {
  var data = findParentByAttr(id, 'id');
  
  if(typeof data.destroy != 'undefined') {
    $(data.parent).show();
    $(data.parent).find("input:hidden[id*='_destroy']").val("false");
    return false;
  } else {
    searchEmployeeByAttr(id, 'id', data.parent);
  }
}

function removeEmployeeTable(id) {
  var data = findParentByAttr(id, 'id');

  if(data.destroy === "")
    return false;
  
  $(data.parent).hide();
}

// Desde el tabla a la multiselect
function addEmployeeMulti(id_employee) {
  $('#employee_items_one .ms-selectable').find("li[id^='"+id_employee+"']").trigger('click');
}

function removeEmployeeMulti(id_employee) {
  $('#employee_items_one .ms-selection').find("li[id^='"+id_employee+"']").trigger('click');
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