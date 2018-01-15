$(document).ready(function() {

  deduction = {
    search_employee_payroll_logs_path: $('#search_employee_payroll_logs_path').val(),
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
      .on('keydown', function(e) {
        if (e.which === 40) {
          that.$selectableUl.focus();
          return false;
        }
      });

      that.qs2 = $selectionSearch.quicksearch(selectionSearchString)
      .on('keydown', function(e) {
        if (e.which == 40) {
          that.$selectionUl.focus();
          return false;
        }
      });
    },
    afterSelect: function() {
      this.qs1.cache();
      this.qs2.cache();
    },
    afterDeselect: function() {
      this.qs1.cache();
      this.qs2.cache();
    }
  });

  $('#deduction_employee_ids').multiSelect({
    selectableHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;'  autocomplete='off' placeholder='Filtrar...'>",
    selectionHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;' autocomplete='off' placeholder='Filtrar...'>",
    afterInit: function(ms) {
      var that = this,
      $selectableSearch = that.$selectableUl.prev(),
      $selectionSearch = that.$selectionUl.prev(),
      selectableSearchString = '#'+that.$container.attr('id')+' .ms-elem-selectable:not(.ms-selected)',
      selectionSearchString = '#'+that.$container.attr('id')+' .ms-elem-selection.ms-selected';

      that.qs1 = $selectableSearch.quicksearch(selectableSearchString)
      .on('keydown', function(e) {
        if (e.which === 40) {
          that.$selectableUl.focus();
          return false;
        }
      });

      that.qs2 = $selectionSearch.quicksearch(selectionSearchString)
      .on('keydown', function(e) {
        if (e.which == 40) {
          that.$selectionUl.focus();
          return false;
        }
      });
    },
    afterSelect: function(values) { // selected
      searchEmployeeByAttr(values, types.add);
      // this.qs1.cache();
      this.qs2.cache();
    },
    afterDeselect: function(values) { // deselected
      searchEmployeeByAttr(values, types.remove);
      // this.qs1.cache();
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
  $('#unicPayroll').on('click', function () { clearPayrolls });

  searchAll(''); // Call the function to get all employee list

  /* E V E N T S */
  // Update validation
  $('#deduction_employee_ids, #deduction_payroll_type_ids').change(function() {
    var modelName = $('form:eq(0)').data('modelName');
    var referenceId = $('form:eq(0)').data('referenceId');
    // resources.updateValidation(modelName, referenceId);
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
    selectAll();
  });

  $('#emplotee_select_all').next().click(function() {
    selectAll();
  });

  function selectAll() {
    HoldOn.open({theme: 'sk-rect', message: 'Cargando... Por favor espera!'});
    setTimeout(function() {
      employeesSelectAll();
    }, 2000);
  }

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
  
  $('#member_submit').click(function( event ) {
    if(!$('#member_submit').hasClass("disabled")) {
      $("form[id*='_deduction']").parsley().validate();
    }
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

  // Clear empty employees on the table
  $('#employee_items tr.items_deductions_form').each(function() {
    var id = $(this).find("input[id*='_employee_id']").val();
    if(id == "") $(this).remove();
  });

  // Creditors list
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
    var elements = '';
    
    $.each(data, function(i, item) {
      elements += '<p id=' + item.id + '>' + item.name + '</p>';
    });
    
    $('#creditors_modal .modal-body').append(elements);
  });
    
  $('#creditors_modal .modal-body').on('click', 'p', function() {
    var creditor = $(this);
    var load_creditor = $('#load_creditor');
    if(!load_creditor.prop('disabled')) {
      $('#load_creditor').val(creditor.text());
      $('#deduction_creditor_id').val(creditor.attr('id'));
    }
    $('#creditors_modal').modal('hide');
  });
  
  changeMaximumDeductionCurrencySymbol();
  changeEmployeeValueCurrencySymbol();
  
  $('#deduction_maximum_deduction_currency_id').on('change', function () {
    changeMaximumDeductionCurrencySymbol();
  });
  
  $('#deduction_deduction_currency_id').on('change', function () {
    changeEmployeeValueCurrencySymbol();
  })
  
  $('#deduction_amount_exhaust_currency_id').on('change', function () {
    $('#deduction_deduction_currency_id').val($(this).val());
    changeEmployeeValueCurrencySymbol();
  });
  
  currencyMask($('#deduction_maximum_deduction'));
  
  //employee search fields
  showHideOptions( $('#select_method_all') );
  
  $('input[name=select_method]').parents('label').click(function() {
    showHideOptions( $(this).find('input') );
  });

  $('input[name=select_method]').next().click(function() {
    showHideOptions( $(this).parents('label').find('input') );
  });
  
  $('#departments_employees').change(function() {
    filterEmployees('department', $(this).val());
  });

  $('#superiors_employees').change(function() {
    filterEmployees('superior', $(this).val());
  });
  
  $('#deduction_deduction_value').on('change', function() {
    var value = $(this).val();
    $('#employee_items tr').each(function() {
      if( !resources.parseBool( $(this).find('input:hidden[id*=_destroy]').val()) ) {
        $(this).find('input:text[id*=_calculation]').val(value);
      }
    });
  });
});

/* F U N C T I O N S */
function currencyMask(selector) {
  selector.mask('FNNNNNNNNN.NN', {
    translation: {
      'N': {pattern: /\d/, optional: true},
      'F': {pattern: /[1-9]/}
    }
  });
}

function percentMask(selector) {
  selector.mask('FNN.NN', {
    translation: {
      'N': { pattern: /\d/, optional: true },
      'F': { pattern: /[1-9]/ }
    }
  });
}

function employeesSelectAll() {
  var checked = $('#emplotee_select_all').is(':checked');
  var that = $('#deduction_employee_ids');
  
  var select = $('#ms-deduction_employee_ids div.ms-selectable li:visible').map(function() {
    return $(this).attr('id').split('-', 1)[0];
  });
  
  var deselect = $('#ms-deduction_employee_ids div.ms-selection li:visible').map(function() {
    return $(this).attr('id').split('-', 1)[0]
  });

  if(checked && select.length == 0) HoldOn.close();
  checked ? that.multiSelect('select', select) : that.multiSelect('deselect', deselect);
}

function payrollSelectAll() {
  var checked = $('#payroll_select_all').is(':checked');
  var selector = $('#deduction_payroll_type_ids');
  checked ? selector.multiSelect('select_all'):selector.multiSelect('deselect_all');
}

function typeDeduction(selected) {
  var amountExhaustControls = $('#amount_exhaust_controls');
  var unicPayroll = $('#unicPayroll');
  var deductionPayrolls = $('#deduction_payrolls');
  var deductionPayroll = $('#deduction_payroll');
  var deductionAmountExhaust = $('#deduction_amount_exhaust');
  var deductionCurrencyId = $('#deduction_deduction_currency_id');

  switch($(selected).val()) {
    case 'unique':
      amountExhaustControls.hide();
      unicPayroll.show();
      deductionPayrolls.show();
      deductionPayroll.prop('required', 'required');
      deductionAmountExhaust.prop('required', '');
      deductionAmountExhaust.val('');
      deductionCurrencyId.prop("disabled", false);
      $("#deduction_employee_ids").prop('required', '');
      disablePayrollTypes();
      getPayrolls();
    break;
    case 'amount_to_exhaust':
      amountExhaustControls.show();
      $('#payrolls-to-save').empty();
      unicPayroll.hide();
      deductionPayrolls.hide();
      deductionPayroll.val('');
      deductionPayroll.prop('required', '');
      deductionAmountExhaust.prop('required', 'required');  
      deductionCurrencyId.prop("disabled", true);
      enablePayrollTypes();
    break;
    case 'constant':
      amountExhaustControls.hide();
      $('#payrolls-to-save').empty();
      unicPayroll.hide();
      deductionPayrolls.hide();
      deductionPayroll.val('');
      deductionPayroll.prop('required', ''); 
      deductionAmountExhaust.prop('required', '');
      deductionAmountExhaust.val('');
      deductionCurrencyId.prop("disabled", false);
      enablePayrollTypes();
    break;
  }
}

function typeCalculation(selected) {
  var maximumDeduction = $('#deduction_maximum_deduction');
  var deductionValue = $('#deduction_deduction_value');

  switch($(selected).val()) {
    case 'percentage':
      $('.percentage').html('%');
      $("#deduction_currency").hide();
      $(".maximum_deduction").show();
      maximumDeduction.prop("required", true);
      changeEmployeeValueCurrencySymbol();
      percentMask(deductionValue);
      employeeValueValidation();
      deductionValuePercentValidation();
      break;
    case 'fixed':
      $('.percentage').html('');
      $('#deduction_currency').show();
      $('.maximum_deduction').hide();
      maximumDeduction.val('');
      maximumDeduction.prop('required', false);
      changeEmployeeValueCurrencySymbol();
      currencyMask(deductionValue);
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
  var children = '';
  
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
  var deductionValue = $('#deduction_deduction_value');

  if($('#deduction_individual').is(':checked') ) {
    deductionValue.val('');
    deductionValue.prop('disabled', true);
    disableDeductionValueValidations();
    employeeValueValidation();
    $('#employee_items_two').show();
  } else {
    deductionValue.prop('disabled', false);
    enableDeductionValueValidations();
    employeeValueValidation();
    $('#employee_items_two').hide();
  }
}

// Consulta las cuentas contables para hacer el autocomplete
function CContables() {
  $.getJSON('/ledger_accounts/credit_accounts', function(category_data) {
    $('#deduction_ledger_account').autocomplete({
      source: $.map(category_data, function(item) {
        $.data(document.body, 'category_' + item.id+'', item.iaccount + ' - ' + item.naccount);
        return {
          label: item.iaccount + ' - ' + item.naccount, 
          id: item.id
        }
      }),
      
      select: function(event, ui) {
        $('#deduction_ledger_account_id').val(ui.item.id);
      },
      
      change: function(event, ui) {
        if(!ui.item) {
          $('#deduction_ledger_account').val('');
          $('#deduction_ledger_account_id').val('');
        }
      },
      
      focus: function(event, ui){
        $('#deduction_ledger_account').val(ui.item.label);
      }
    })
    if($('#deduction_ledger_account_id').val()){
      var deducciones_cuentas = $.data(document.body, 'category_' + $('#deduction_ledger_account_id').val()+'');
      $('#deduction_ledger_account').val(deducciones_cuentas);
    }
  }); 
}

// Limpia el id y el texto de la planilla UNICA seleccionada en caso de querer cambiar la planilla unica seleccionada
// para que no se vayan varioss ids de planillas solo se tiene que guardar un unico id
function clearPayrolls() {
  $('#payrolls-to-save').empty(); // Elimina el id de la planilla que ya no se quiere guardar
  $('#deduction_payroll').val('');
}

function isBeneficiary(value) {
  var creditor = $('#load_creditor');

  if(value) {
    creditor.prop('disabled', true);
    creditor.prop('required', '');
    creditor.val('');
    $('#deduction_creditor_id').val('');
    $('a[href=#creditors_modal]').prop('disabled', true);
  } else {
    $('#load_creditor').prop('disabled', false);
    $('#load_creditor').prop('required', 'required')
    $('a[href=#creditors_modal]').prop('disabled', false);
  }
}

function parseBool(str) {
  if(str== null) return false;
  if(str== 'false') return false;
  if(str== '0') return false;
  if(str== 'true') return true;
  if(str== '1') return true;

  return false;
}

function searchAll(name) {
  return $.ajax({
    url: deduction.search_employee_payroll_logs_path,
    dataType: 'script',
    data: {
      search_employee_name: name
    }
  });
}

/******************************************************************************************/
// Search a employee by attr (id)
function searchEmployeeByAttr(values, type) {
  
  var symbol = currencySymbol();
  var deduction = $('#deduction_deduction_value').val();

  $.each(values, function (key, value) {
    var employee = gon.employees[value];

    if(employee == null) {
      resources.PNotify('Empleado', 'Error al buscar', 'danger');
      return false;
    }

    var selector = $('#tr_employee_id_' + employee.id);

    if(types.add == type) {
      if(selector.length) {
        selector.find('input[type=hidden][id*=_destroy]').val(0);
        selector.show();
      } else {
        $('.header_items').after(newRow(employee, symbol, deduction));
        employeeValueValidation();
      }
    }
    
    if(types.remove == type) {
      selector.find("input[type=hidden][id*='_destroy']").val(1);
      selector.hide()
    }
  });

  HoldOn.close();
}

function newRow(employee, symbol, deduction) {

  var time = new Date().getTime().toString() + employee.id;

  // TD One
  var tds = '<td class="controls_item"><div class="input-append"><div class="col-md-12">';
  tds += '<input id="deduction_deduction_employees_attributes_' + time + '_employee_id"' + 
          ' name="deduction[deduction_employees_attributes][' + time + '][employee_id]"' + 
          ' type="hidden" value="' + employee.id + '" />';
  tds += '<input class="form-control" disabled="disabled" id="search_name_employee"' + 
         ' name="search_name_employee" type="text" value="' + employee.full_name + '" >';
  tds += '</div></div></td>';

  // TD Two
  tds += '<td class="controls_item"><div class="input-append"><div class="controls">';
  tds += '<span class="employee_calculation_currency_symbol">' + symbol + '</span>';
  tds += '<input class="form-control" id="deduction_deduction_employees_attributes_' + time + '_calculation"' + 
          ' name="deduction[deduction_employees_attributes][' + time + '][calculation]"' +
          ' size="5x5" type="text" required="required" data-parsley-range="[1, 100]" value="' + deduction + '" />';
  tds += '</div></div></td>';

  // TD Tree
  tds += '<td><div class="controls_item"><div class="controls">';
  tds += '<input id="deduction_deduction_employees_attributes_' + time + '__destroy"' + 
          ' name="deduction[deduction_employees_attributes][' + time + '][_destroy]"' + 
          ' type="hidden" value="false" />';
  tds += '</div></div></td>';

  // TR
  var html = '<tr class="items_deductions_form" id="tr_employee_id_' + employee.id + '">';
  html += tds;
  html += '<input id="deduction_deduction_employees_attributes_' + time + '_completed"' + 
          ' name="deduction[deduction_employees_attributes][' + time + '][completed]"' + 
          'type="hidden" value="false" />';
  html += '</tr>';

  return html;
}

// Disable/Enable payroll types
function disablePayrollTypes() {
  var selector = $('#deduction_payroll_type_ids');

  selector.prop('disabled', true);
  selector.prop('required', false);
  selector.multiSelect("refresh");
  $("#payroll_select_all").iCheck("disable");
}

function enablePayrollTypes() {
  var selector = $('#deduction_payroll_type_ids');
  
  selector.prop("disabled", false);
  selector.prop("required", true);
  selector.multiSelect("refresh");
  $("#payroll_select_all").iCheck("enable");
}

// Add currency symbol to maximum deduction and individual employee value field
function changeMaximumDeductionCurrencySymbol() {
  var currency = $('#deduction_maximum_deduction_currency_id :selected').text();
  var symbol = $('input[name=' + currency + ']').val();
  $('#maximum_deduction_currency_symbol').text(symbol);
}

function showHideOptions(selected) {
  switch($(selected).val()) {
    case 'all':
      $('#ms-deduction_employee_ids').find('input:eq(0)').show();
      $('#list-departments').hide();
      $('#list-superior').hide(); 
      $('#ms-deduction_employee_ids').find('.ms-selection').removeClass('custom-multiselect')
                                                           .addClass('custom-multiselect-empty');
      filterEmployees("all");
      break;
    case 'boss':
      $('#ms-deduction_employee_ids').find('.ms-selection').addClass('custom-multiselect')
                                                           .removeClass('custom-multiselect-empty');
      $('#ms-deduction_employee_ids').find('input:eq(0)').hide();
      $('#list-departments').hide();
      filterEmployees("superior", $('#superiors_employees').val());
      $('#list-superior').show(); 
      break;
    case 'department':
      $('#ms-deduction_employee_ids').find('.ms-selection').addClass('custom-multiselect')
                                                           .removeClass('custom-multiselect-empty');
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
    
    if(type === 'all') {
      if(!$(this).hasClass('ms-selected')) $(this).show();
    }

    var searchType = 0;
    if(type === 'superior') searchType = $(this).data('sup') ? $(this).data('sup') : 0;
    if(type === 'department') searchType = $(this).data('dep') ? $(this).data('dep') : 0;
    
    if(id != 0) {
      if( id == searchType ) {
        if(!$(this).hasClass('ms-selected')) $(this).show();
      } else {
        $(this).hide();
      }
    } else {
      if(!$(this).hasClass('ms-selected')) $(this).show();
    }
  });
}

function changeEmployeeValueCurrencySymbol() {
  var symbol = currencySymbol();
  $('.employee_calculation_currency_symbol').text(symbol);
}

function currencySymbol() {
  var symbol = '%';
  if($('#deduction_calculation_type').val() == 'fixed') {
    var currency = $('#deduction_deduction_currency_id :selected').text();
    symbol = $('input[name=' + currency + ']').val();
  }
  return symbol;
}

function enableDeductionValueValidations() {
  if($('#deduction_calculation_type').val() == 'percentage') {
    deductionValuePercentValidation();
  } else {
    deductionValueCurrencyValidation();
  }
}

function disableDeductionValueValidations() {
  var selector = $('#deduction_deduction_value');
  selector.removeAttr('data-parsley-range required');
}

function deductionValuePercentValidation() {
  var selector = $('#deduction_deduction_value');
  if(!$('#deduction_individual').is(':checked')) {
    selector.attr({'data-parsley-range': '[1, 100]', 'required': true});
  }
}

function deductionValueCurrencyValidation() {
  var selector = $('#deduction_deduction_value');
  if(!$('#deduction_individual').is(':checked')) {
    selector.removeAttr('data-parsley-range');
    selector.attr('required', true);
  }
}

function employeeValueValidation() {
  var calculationType = $('#deduction_calculation_type').val()
  var employeesValueField = $('#employee_items input:text[id*=_calculation]');
  
  if($('#deduction_individual').is(':checked')) {
    employeesValueField.attr('required', true);
    
    if(calculationType == 'fixed') {
      currencyMask(employeesValueField);
      employeesValueField.removeAttr('data-parsley-range');
    } else {
      percentMask(employeesValueField);
      employeesValueField.attr('data-parsley-range', '[1, 100]');
    }
    
  } else {
    employeesValueField.removeAttr('required data-parsley-range');
  }
}
