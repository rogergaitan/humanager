$(document).ready(function() {

  $(".add_fields").hide(); //hide add employee button  as required
  
  deduction = {
    search_employee_payroll_logs_path: $('#search_employee_payroll_logs_path').val(),
    search_employee_by_id_path: $('#search_employee_by_id_path').val(),
    search_employee_by_code_path: $('#search_employee_by_code_path').val(),
    search_employee_by_name_path: $('#search_employee_by_name_path').val(),
    load_em_employees_path: $('#load_em_employees_path').val()
  };

  types = {
    add: 'add',
    remove: 'remove',
    show: 'show'
  };

  $('#deduction_payroll_type_ids').multiSelect({
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
    selectableHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;'  autocomplete='off' placeholder='Filtrar...'>",
    selectionHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;' autocomplete='off' placeholder='Filtrar...'>",
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
      searchEmployeeByAttr(values[0], 'id', 'multi', types.add);
//       this.qs1.cache();
      this.qs2.cache();
    },
    afterDeselect: function(values) { // deselected
      searchEmployeeByAttr(values[0], 'id', 'multi', types.remove);
      this.qs1.cache();
      this.qs2.cache();
    }
  });
  
  typeDeduction($('#deduction_deduction_type'));

  // When change the value called the function typeDeduction
  $('#deduction_deduction_type').change(function() {
    typeDeduction(this);
  });

  typeCalculation($('#deduction_calculation_type'));

  $('#deduction_calculation_type').change(function() {
    typeCalculation(this);
  });

  // En caso de seleccionar una planilla unica si se quiere cambiar se limpia la anterios 
  // para que no se vayan a guardar 2 ids
  $('#unicPayroll').on("click", function () { clearPayrolls });

  searchAll(""); // Call the function to get all employee list

  /* E V E N T S */
  // Update validation
  $('#deduction_employee_ids, #deduction_payroll_type_ids').change(function() {
    var modelName = $('form:eq(0)').data('modelName');
    var referenceId = $('form:eq(0)').data('referenceId');
    resources.updateValidation(modelName, referenceId);
  });

  $("#search_employee_results").on("click", "table tr a", function(e) {
    
    var employeeId = $(this).parents('td').find('input:hidden').val(),
        selector = $("#employee_items input:hidden[id='in_searching'][value='1']").parents('tr');

    searchEmployeeByAttr(employeeId, 'id', 'table', types.add);
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

  showHideEmployees(); // Call the function to show/hide the div about employees
  isBeneficiary($("#deduction_pay_to_employee").prop("checked"));

  $("label[for=deduction_individual]").click(function() {
    showHideEmployees();
  });

  $('#deduction_individual').next().click(function() {
    showHideEmployees();
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
  $('label[for=deduction_pay_to_employee]').click(function() {
    isBeneficiary($('#deduction_pay_to_employee').is(':checked'));
  });

  $('#deduction_pay_to_employee').next().click(function() {
    isBeneficiary($('#deduction_pay_to_employee').is(':checked'));
  });
  
  /* N O */
  $('#member_submit').click(function( event ) {
    if(!$('#member_submit').hasClass("disabled")) {
      $("form[id*='_deduction']").parsley().validate();
    }
  });
  /* N O */
  
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

  // Add new row to employee_deduction
  $('form').on('click', '.add_fields', addFields);

  // Remove a row to employee_deduction
  $('form').on('click', '.remove_fields', function(event) {
    event.preventDefault();
    
    var id = $(this).parents('tr').find("input:hidden[id*='_employee_id']").val();
    if(id != "") {
      searchEmployeeByAttr( id, 'id', 'table', types.remove);
      return; 
    }
    $(element).parents('tr').remove();
  });

  $('#employee_items tr.items_deductions_form').each(function() {
    var id = $(this).find("input[id*='_employee_id']").val();
    if(id != "" ) {
      searchEmployeeByAttr( id, 'id', 'show', '');
    } else {
      $(this).remove();
    }
  });

  // Search Employee by code
  $('form').on('focusout', '.search_code_employee', function() {
    searchEmployeeByAttr($(this).val(), 'code', 'table', types.add);
  });
  
   //creditors list
  $.getJSON("/creditors", function(data) {
    $('#load_creditor').autocomplete({
      minLength: 3,
      
      source: $.map(data, function(item) {
        $.data(document.body, 'creditor_' + item.id + "", item.name);
          return { label: item.name, id: item.id }
      }),
      
      select: function(event, ui) {
        if(ui.item.id) {
          $('#deduction_creditor_id').val(ui.item.id);
        }
      },
      
      change: function(event, ui) {
        if(!ui.item) {
          $('#load_creditor').val('');
          $('#deduction_creditor_id').val('');
        }
      },
      
      focus: function(event, ui) {
        $('#load_creditor').val(ui.item.label);  
      }
    });
    
    if($('#deduction_creditor_id').val()) {
      var load_creditor_name = $.data(document.body, 'creditor_' + $('#deduction_creditor_id').val());
      $('#load_creditor').val(load_creditor_name);
    }
   
  }).done(function(data) {
    var elements = "";
    
    $.each(data, function(i, item) {
      elements += "<p id="+ item.id + ">" + item.name + "</p>";
    });
    
    $("#creditors_modal .modal-body").append(elements);
  });
    
  $("#creditors_modal .modal-body").on("click", "p", function() {
    var creditor = $(this);
    var load_creditor = $("#load_creditor");
    if(!load_creditor.prop("disabled")) {
      $("#load_creditor").val(creditor.text());
      $("#deduction_creditor_id").val(creditor.attr("id"));
    }
    $("#creditors_modal").modal("hide");
  });
  
  changeMaximumDeductionCurrencySymbol();
  changeEmployeeValueCurrencySymbol();
  
  $("#deduction_maximum_deduction_currency_id").on("change", function () {
    changeMaximumDeductionCurrencySymbol();
  });
  
  $("#deduction_deduction_currency_id").on("change", function () {
    changeEmployeeValueCurrencySymbol();
  })
  
  $("#deduction_amount_exhaust_currency_id").on("change", function () {
     $("#deduction_deduction_currency_id") .val($(this).val());
     changeEmployeeValueCurrencySymbol();
  });
  
  currencyMask("#deduction_maximum_deduction");
  
  //employee search fields
  showHideOptions( $('#select_method_all') );
  
  $('input[name=select_method]').parents('label').click(function() {
		showHideOptions( $(this).find('input') );
	});

	$('input[name=select_method]').next().click(function() {
		showHideOptions( $(this).parents('label').find('input') );
	});
  
  $('#departments_employees').change(function() {
		filterEmployees("department", $(this).val());
	});

	$('#superiors_employees').change(function() {
    	filterEmployees("superior", $(this).val());
  });
    
});

/* F U N C T I O N S */
function currencyMask(selector) {
   $(selector).mask("FNNNNNNNNN.NN", {
      translation: {
       'N': {pattern: /\d/, optional: true},
       "F": {pattern: /[1-9]/}
      }
  });    
}

function percentMask(selector) {
   $(selector).mask("FNN.NN", {
      translation: {
       'N': {pattern: /\d/, optional: true},
       "F": {pattern: /[1-9]/}
      }
  });    
}

function selectUnselectEmployees(isSelect) {
  
  var theClass = 'ms-selection';
  if(isSelect) {
    theClass = 'ms-selectable';
  }
  
  $('#ms-deduction_employee_ids div.'+theClass).find('li:visible').each( function() {
    var id = $(this).attr('id').replace('-selectable','');
    if(isSelect) {
      searchEmployeeByAttr(id, 'id', 'multi', types.add);
    } else {
      searchEmployeeByAttr(id, 'id', 'multi', types.remove);
    }
  });

  if(isSelect) {
    $('#deduction_employee_ids').multiSelect('select_all');
  } else {
    $('#deduction_employee_ids').multiSelect('deselect_all');
  }
}

function emploteeSelectAll() {
  if( $('#emplotee_select_all').is(':checked') ) {
    selectUnselectEmployees(true);
  } else {
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

function typeDeduction(selected) {
  switch($(selected).val()) {
    case 'unique':
      $('#amount_exhaust_controls').hide();
      $('#unicPayroll').show();
      $('#deduction_payrolls').show();
      $('#deduction_payroll').prop('required', 'required');
      $('#deduction_amount_exhaust').prop('required', '');
      $('#deduction_amount_exhaust').val('');
      $("#deduction_deduction_currency_id").prop("disabled", false);
      $("#deduction_employee_ids").prop('required', '');
      disablePayrollTypes();
      getPayrolls();
    break;
    case 'amount_to_exhaust':
      $('#amount_exhaust_controls').show();
      $('#payrolls-to-save').empty();
      $('#unicPayroll').hide();
      $('#deduction_payrolls').hide();
      $('#deduction_payroll').val('');
      $('#deduction_payroll').prop('required', '');
      $('#deduction_amount_exhaust').prop('required', 'required');  
      $("#deduction_deduction_currency_id").prop("disabled", true);
      enablePayrollTypes();
    break;
    case 'constant':
      $('#amount_exhaust_controls').hide();
      $('#payrolls-to-save').empty();
      $('#unicPayroll').hide();
      $('#deduction_payrolls').hide();
      $('#deduction_payroll').val('');
      $('#deduction_payroll').prop('required', ''); 
      $('#deduction_amount_exhaust').prop('required', '');
      $('#deduction_amount_exhaust').val('');
      $("#deduction_deduction_currency_id").prop("disabled", false);
      enablePayrollTypes();
    break;
  }
}

function typeCalculation(selected) {
  switch($(selected).val()) {
    case 'percentage':
      $('.percentage').html('%');
      $("#deduction_currency").hide();
      $(".maximum_deduction").show();
      $("#deduction_maximum_deduction").prop("required", true);
      changeEmployeeValueCurrencySymbol();
      percentMask("#deduction_deduction_value");
      employeeValueValidation();
      deductionValuePercentValidation();
      break;
    case 'fixed':
      $('.percentage').html('');
      $("#deduction_currency").show();
      $(".maximum_deduction").hide();
      $("#deduction_maximum_deduction").val("");
      $("#deduction_maximum_deduction").prop("required", false);
      changeEmployeeValueCurrencySymbol();
      currencyMask("#deduction_deduction_value");
      employeeValueValidation();
      deductionValueCurrencyValidation();
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
        addActives(result.activa, 'table#activas');
      },
    error: function(result) {
      $('#error').show();
    }
  });
}

// Carga las planillas activas en una tabla
function addActives(payroll, target_table) {
  var children = "";
  
  payroll.forEach(function (item, index) {
    children +=  '<tr>' + 
      '<td class="payroll-id">' + item.id +'</td>' +
      '<td class="payroll-type"><a data-dismiss="modal" href="#">' + item.payroll_type.description +'</a></td>' +
      '<td>' +  item.start_date + '</td>' +
      '<td>' +  item.end_date + '</td>' +
      '<td>' +  item.payment_date + '</td>' +
    '</tr>';  
  }); 
  
  $(target_table + '> tbody:last').append(children);
}

// Establece el campo oculto de con el id de la planilla unica seleccionada
function setPayroll(e) {
  e.preventDefault();
  var payrollId = $(e.target).parent().prev().text();
  var payrollName = $(e.target).text();
  appendPayrolls = "<input type='hidden" +"' name='deduction[payroll_ids][]' value='"+ payrollId +"' />";
  $('#payrolls-to-save').empty();
  $('#payrolls-to-save').append(appendPayrolls);
  $('#deduction_payroll').val(payrollName);
  $('#deduction_payroll').focusout();  
}

// Establece el campo oculto con el id d la cuenta de credito y muestra el texto en el campo cuenta credito
function setAccount(e) {
  e.preventDefault();
  var accountId = $(this).closest('li').data('id');
  var accountName = $(this).text();
  $('#deduction_ledger_account_id').val(accountId);
  $('#deduction_ledger_account').val(accountName);
  $('#deduction_ledger_account').focusout();  
}

// Show/Hide The differents view based in the checkbox "individual"
function showHideEmployees() {
  if( $('#deduction_individual').is(':checked') ) {
    $('#deduction_deduction_value').val('');
    $('#deduction_deduction_value').prop("disabled", true);
    disableDeductionValueValidations();
    employeeValueValidation();
    $('#employee_items_two').show();
    /*$('#employee_items_one').hide()
    $('.custom_calculation').hide();*/
  } else {
    $('#deduction_deduction_value').prop('disabled', false);
    enableDeductionValueValidations();
    employeeValueValidation();
    $('#employee_items_two').hide();
    /*$('#employee_items_one').show();
    $('.custom_calculation').show();*/
  }
}

// Consulta las cuentas contables para hacer el autocomplete
function CContables() {
  $.getJSON('/ledger_accounts/credit_accounts', function(category_data) {
    $("#deduction_ledger_account").autocomplete({
      source: $.map(category_data, function(item) {
        $.data(document.body, 'category_' + item.id+"", item.iaccount + " - " + item.naccount);
        return{
            label:  item.iaccount + " - " + item.naccount, 
            id: item.id
        }
      }),
      
      select: function( event, ui ) {
        $('#deduction_ledger_account_id').val(ui.item.id);
      },
      
      change: function(event, ui) {
        if(!ui.item) {
          $('#deduction_ledger_account').val('');
          $('#deduction_ledger_account_id').val('');
        }
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

// Limpia el id y el texto de la planilla UNICA seleccionada en caso de querer cambiar la planilla unica seleccionada
// para que no se vayan varioss ids de planillas solo se tiene que guardar un unico id
function clearPayrolls(){
  $('#payrolls-to-save').empty(); //elimina el id de la planilla que ya no se quiere guardar
  $('#deduction_payroll').val('');  
}

function isBeneficiary(value) {
  if( value ) {
    $("#load_creditor").prop("disabled", true);
    $("#load_creditor").prop("required", "");
    $("#load_creditor").val('');
    $("#deduction_creditor_id").val("");
    $("a[href=#creditors_modal]").prop("disabled", true);
  } else {
    $("#load_creditor").prop("disabled", false);
    $("#load_creditor").prop("required", "required")
    $("a[href=#creditors_modal]").prop("disabled", false);
  }
}

function addFields(e) {
  e.preventDefault();
  var time = new Date().getTime(),
      regexp = new RegExp($(this).data('id'), 'g');
  $('.header_items').after($(this).data('fields').replace(regexp, time));

  populateAutocompleteEmployees( $('#employee_items tr:eq(1)').find("input[id='search_name_employee']") );
  $('#employee_items tr:eq(1)').find("input[id='search_name_employee']").removeClass("ui-autocomplete-input");
  
  changeEmployeeValueCurrencySymbol();
  employeeValueValidation();
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

  if(typeof data.destroy == 'undefined') {
    return false;
  }
  
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
        searchEmployeeByAttr(ui.item.label, "name", 'table', types.add);
      },
      focus: function(event, ui) {
      }
    });
  });  
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

/******************************************************************************************/
/* MULTISELECT - TABLA */
function fromMulti(employee, type) {

  var data = findParentByAttr(employee.id, 'id');

  switch(type) {

    case types.add:
      // No existe
      if(typeof data.parent == 'undefined') {
        $('.add_fields ').trigger('click'); // Add new row
          var selector = $('#employee_items tr.items_deductions_form:eq(0)');
          $(selector).find("input:hidden[id*='_destroy']").val("false");
          $(selector).find("input:hidden[id*='_employee_id']").val(employee.id);
          $(selector).find("input[id='search_code_employee']").val(employee.number_employee);
          $(selector).find("input[id='search_name_employee']").val(employee.name + " " + employee.surname);
          $(selector).find("input[id='search_code_employee']").attr('disabled', 'disabled');
          $(selector).find("input[id='search_name_employee']").attr('disabled', 'disabled');
          $(selector).find("a[id='openEmployeeModal']").attr('disabled', 'disabled');
        } else { // Existe
          $(data.parent).find("input[type=hidden][id*='_destroy']").val(0);
          $(data.parent).show();
        }
      // resources.PNotify('Empleado', 'Agregado con exito', 'success');
    break;
    
    case types.remove: // Ocutar
      $(data.parent).find("input[type=hidden][id*='_destroy']").val(1);
      $(data.parent).hide();
      // resources.PNotify('Empleado', 'Eliminado con exito', 'success');
    break;
  }
}

/******************************************************************************************/
/* TABLA - MULTISELECT */
function fromTable(employee, type) {

  var data = findParentByAttr(employee.id, 'id');

  switch(type) {

    case types.add:
      // No existe
      if(typeof data.parent == 'undefined') {
        var selector = $('#employee_items tr.items_deductions_form:eq(0)');
        $(selector).find("input:hidden[id*='_destroy']").val("false");
        $(selector).find("input:hidden[id*='_employee_id']").val(employee.id);
        $(selector).find("input[id='search_code_employee']").val(employee.number_employee);
        $(selector).find("input[id='search_name_employee']").val(employee.name + " " + employee.surname);
        $(selector).find("input[id='search_code_employee']").attr('disabled', 'disabled');
        $(selector).find("input[id='search_name_employee']").attr('disabled', 'disabled');
        $(selector).find("a[id='openEmployeeModal']").attr('disabled', 'disabled');
      } else { // Existe
        // Lo muestra
        $(data.parent).find("input[type=hidden][id*='_destroy']").val(0);
        $(data.parent).show();
        $('#employee_items tr.items_deductions_form:eq(0)').remove();
      }
      // resources.PNotify('Empleado', 'Agregado con exito', 'success');
      addEmployeeMulti(employee.id);
    break;
    
    case types.remove: // Ocutar
      $(data.parent).find("input[type=hidden][id*='_destroy']").val(1);
      $(data.parent).hide();
      resources.PNotify('Empleado', 'Eliminado con exito', 'success');
      removeEmployeeMulti(employee.id);
    break;
  }
}

/******************************************************************************************/
/* SHOW IN TABLA LOAD */
function showEmployees(employee) {
  var data = findParentByAttr(employee.id, 'id');
  // $(data.parent).find("input:hidden[id*='_destroy']").val("false");
  $(data.parent).find("input:hidden[id*='_employee_id']").val(employee.id);
  $(data.parent).find("input[id='search_code_employee']").val(employee.number_employee);
  $(data.parent).find("input[id='search_name_employee']").val(employee.name + " " + employee.surname);
  $(data.parent).find("input[id='search_code_employee']").attr('disabled', 'disabled');
  $(data.parent).find("input[id='search_name_employee']").attr('disabled', 'disabled');
  $(data.parent).find("a[id='openEmployeeModal']").attr('disabled', 'disabled');
}

/******************************************************************************************/
/* TABLA - MULTISELECT */
function addEmployeeMulti(id_employee) {
  $('#employee_items_one .ms-selectable').find("li[id^='"+id_employee+"']").trigger('click');
}

function removeEmployeeMulti(id_employee) {
  $('#employee_items_one .ms-selection').find("li[id^='"+id_employee+"']").trigger('click');
}

/******************************************************************************************/
// Search a employee by attr (id, code, name)
function searchEmployeeByAttr(searchValue, searchType, from, typeFrom) {
  
  var url, customData;

  switch(searchType) {
    case "id":
      url = deduction.search_employee_by_id_path,
      customData = { search_id: searchValue };
    break;
    
    case "code":
      url = deduction.search_employee_by_code_path,
      customData = { search_code: searchValue };
    break;

    case "name":
      url = deduction.search_employee_by_name_path,
      customData = { search_name: searchValue };
    break;
  }

  $.ajax({
    type: "GET",
    url: url,
    dataType: "json",
    data: customData,
    success: function(data) {
      if( data != null ) {
        if( from == "table" ) {
          fromTable(data, typeFrom);
        }
        if( from == "multi" ) {
          fromMulti(data, typeFrom);
        }
        if( from == "show" ) {
          showEmployees(data);
        }
        // populateListEmployees(data, type, exist);
      }
    },
    error: function(response, textStatus, errorThrown) {
      resources.PNotify('Empleado', 'Error al buscar', 'danger');
    }
  });
}

// Solo para la tabla de abajo visual
function findParentByAttr(value, type) {
  var parent, destroy;

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

// Disable/Enable payroll types
function disablePayrollTypes() {
  $("#deduction_payroll_type_ids").prop("disabled", true);
  $("#deduction_payroll_type_ids").prop("required", false);
  $("#deduction_payroll_type_ids").multiSelect("refresh");
  $("#payroll_select_all").iCheck("disable");
}

function enablePayrollTypes() {
    $("#deduction_payroll_type_ids").prop("disabled", false);
    $("#deduction_payroll_type_ids").prop("required", true);
    $("#deduction_payroll_type_ids").multiSelect("refresh");
    $("#payroll_select_all").iCheck("enable");
}

// Disable/Enable Deduction Employee ids
function disableDeductionEmployeeIds() {
  $("#deduction_employee_ids").prop("disabled", true);
  $("#deduction_employee_ids").multiSelect("refresh");
  $("#emplotee_select_all").iCheck("disable");
  $(".items_deductions_form").prop("disabled", true);
  $("#employee_items_two").hide();
}

function enableDeductionEmployeeIds() {
  $("#deduction_employee_ids").prop("disabled", false);
  $("#emplotee_select_all").iCheck("enable");
  $("#deduction_employee_ids").multiSelect("refresh");
  $("#employee_items_two").show();
  $(".items_deductions_form").prop("disabled", false);
}

//add currency symbol to maximum deduction and individual employee value field
function changeMaximumDeductionCurrencySymbol() {
  var currency = $("#deduction_maximum_deduction_currency_id :selected").text();
      
  var symbol = $("input[name=" + currency + "]").val();
  
  $("#maximum_deduction_currency_symbol").text(symbol);
}


function showHideOptions(selected) {
  switch($(selected).val()) {
    case 'all':
      $('#ms-deduction_employee_ids').find('input:eq(0)').show();
      $('#list-departments').hide();
      $('#list-superior').hide(); 
      $('#ms-deduction_employee_ids').find('.ms-selection').css('margin-top', '-1px');
      filterEmployees("all");
      break;
    case 'boss':
      $('#ms-deduction_employee_ids').find('.ms-selection').css('margin-top', '-5.7%');
      $('#ms-deduction_employee_ids').find('input:eq(0)').hide();
      $('#list-departments').hide();
      filterEmployees("superior", $('#superiors_employees').val());
      $('#list-superior').show(); 
      break;
    case 'department':
      $('#ms-deduction_employee_ids').find('.ms-selection').css('margin-top', '-5.7%');
      $('#ms-deduction_employee_ids').find('input:eq(0)').hide();
      $('#list-superior').hide(); 
      filterEmployees("department", $('#departments_employees').val());
      $('#list-departments').show();
      break;
  }
}

function filterEmployees(type, id) {
  
  id = id ? id : 0;

  $('#ms-deduction_employee_ids .ms-selectable').find('li').each(function() {
    
    if(type === "all") {
      if(!$(this).hasClass('ms-selected'))
        $(this).show();
    }

    var searchType = 0;
    if(type === "superior") {
      searchType = $(this).data('sup') ? $(this).data('sup') : 0;
    }
    
    if(type === "department") {
      searchType = $(this).data('dep') ? $(this).data('dep') : 0;
    }
    
    if(id != 0) {
      if( id == searchType ) {
        if(!$(this).hasClass('ms-selected'))
          $(this).show();
      } else {
        $(this).hide();
      }
    } else {
      if(!$(this).hasClass('ms-selected'))
        $(this).show();
    }
  });
}

function changeEmployeeValueCurrencySymbol() {
  if($("#deduction_calculation_type").val() == "fixed" ) {
    var currency = $("#deduction_deduction_currency_id :selected").text();
        
    var symbol = $("input[name=" + currency + "]").val();
    
    $(".employee_calculation_currency_symbol").text(symbol);
  }  else {
    $(".employee_calculation_currency_symbol").text("%");
  }
}

function employeeValueValidation () {
  var calculation_type = $("#deduction_calculation_type").val()
  
  if($('#deduction_individual').is(':checked')) {
    $("#employee_items input:text[id*='_calculation']").attr("required", true); 
    
    if(calculation_type == "fixed") {
      currencyMask($("#employee_items input:text[id*='_calculation']"));
      $("#employee_items input:text[id*='_calculation']").removeAttr("data-parsley-range");
    } else {
      percentMask($("#employee_items input:text[id*='_calculation']"));
      $("#employee_items input:text[id*='_calculation']").attr("data-parsley-range", "[1, 100]");
    }
    
  } else {
    $("#employee_items input:text[id*='_calculation']").removeAttr("required");
    $("#employee_items input:text[id*='_calculation']").removeAttr("data-parsley-range");
  }
  
  $("form[id*='_deduction']").parsley().destroy();
}

function enableDeductionValueValidations () {
  if($("#deduction_calculation_type").val() == "percentage" ) {
    deductionValuePercentValidation();
  } else {
    deductionValueCurrencyValidation();
  }
}

function disableDeductionValueValidations () {
  $("#deduction_deduction_value").removeAttr("data-parsley-range");
  $("#deduction_deduction_value").removeAttr("required");
}

function deductionValuePercentValidation() {
  if(!$("#deduction_individual").is(":checked")) {
    $("#deduction_deduction_value").attr("data-parsley-range", "[1, 100]");
    $("#deduction_deduction_value").attr("required", true);  
  }
}

function deductionValueCurrencyValidation () {
  if(!$("#deduction_individual").is(":checked")) {
    $("#deduction_deduction_value").removeAttr("data-parsley-range");
    $("#deduction_deduction_value").attr("required", true);
  }
}
