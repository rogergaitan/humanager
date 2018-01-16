var op = {};

$(document).ready(function() {
  /*********************************************************************************************************************************************************/
  /* E V E N T S */
  /*********************************************************************************************************************************************************/
  // List of the routes
  op.fetch_ledger_accounts_path = $('#fetch_ledger_accounts_path').val();
  op.fetch_cc_costs_centers_path = $('#fetch_cc_costs_centers_path').val();
  op.search_cost_center_work_benefits_path = $('#search_cost_center_work_benefits_path').val();
  op.fetch_employees_deductions_path = $('#fetch_employees_deductions_path').val();
  op.search_employee_payroll_logs_path = $('#search_employee_payroll_logs_path').val();
  op.fetch_payroll_type_deductions_path = $('#fetch_payroll_type_deductions_path').val();
  op.get_activas_payrolls_path = $('#get_activas_payrolls_path').val();

  op.types = {
    add: 'add',
    remove: 'remove',
    show: 'show'
  };
  
  // Payroll types
  $('#other_payment_payroll_type_ids').multiSelect({
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
    afterSelect: function() {
      this.qs1.cache();
      this.qs2.cache();
    },
    afterDeselect: function() {
      this.qs1.cache();
      this.qs2.cache();
    }
  });
  
  // Employees	
  $('#other_payment_employee_ids').multiSelect({
    selectableHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;'  autocomplete='off' placeholder='Filtrar...'>",
    selectionHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;' autocomplete='off' placeholder='Filtrar...'>",
    afterInit: function(ms) {
      var that = this,
      $selectableSearch = that.$selectableUl.prev(),
      $selectionSearch = that.$selectionUl.prev(),
      selectableSearchString = '#' + that.$container.attr('id') + ' .ms-elem-selectable:not(.ms-selected)',
      selectionSearchString = '#' + that.$container.attr('id') + ' .ms-elem-selection.ms-selected';

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
      op.searchEmployeeByAttr(values, op.types.add);
      // this.qs1.cache();
      this.qs2.cache();
    },
    afterDeselect: function(values) { // deselected
      op.searchEmployeeByAttr(values, op.types.remove);
      // this.qs1.cache();
      this.qs2.cache();
    }
  });

  // Update validation
  $('#other_payment_payroll_type_ids, #other_payment_employee_ids').change(function() {
    // op.updateValidation();
  });
	
  op.typeDeduction($('#other_payment_other_payment_type'));

  // When change the value called the function typeDeduction
  $('#other_payment_other_payment_type').change(function() {
    op.typeDeduction(this);
  });

  // En caso de seleccionar una planilla unica si se quiere cambiar se limpia la anterios 
  // para que no se vayan a guardar 2 ids
  $('#unicPayroll').on({ click: op.clearPayrolls });

  op.showHideEmployees(true); // Call the function to show/hide the div about employees

  // Deduction Individual
  $("label[for=other_payment_individual]").click(function() {
    op.showHideEmployees($('#other_payment_individual').is(':checked'));
  });

  $('#other_payment_individual').next().click(function() {
    op.showHideEmployees($('#other_payment_individual').is(':checked'));
  });

  // Payrolls Types
  $('#payroll_select_all').parents('label').click(function() {
    op.payrollSelectAll();
  });

  $('#payroll_select_all').next().click(function() {
    op.payrollSelectAll();
  });

  // Employees
  $('#emplotee_select_all').parents('label').click(function() {
    selectAll();
  });
  
  $('#emplotee_select_all').next().click(function() {
    selectAll();
  });

  function selectAll() {
    HoldOn.open({theme: 'sk-rect', message: 'Cargando... Por favor espera!'});
    setTimeout(function() {
      op.employeeSelectAll();
    }, 2000);
  }

  // Al precionar click sobre una planilla se establece el id de la planilla
  $('#activas').on("click", "td.payroll-type a", op.setPayroll);

  // Carga el arbol de cuentas de credito
  treeviewhr.cc_tree(debit_account, true);
  $('.expand_tree').click(treeviewhr.expand);

  $('#list').on({
    click: op.setAccount,
    mouseenter: function() {
      $(this).css('text-decoration', 'underline');
    },
    mouseleave: function() {
      $(this).css('text-decoration', 'none');
  }}, '.node_link');

  op.getPayrolls();
  
  $("#error a").click(function (e) {
    e.preventDefault();
    op.getPayrolls();
  });

  // Add the auto complete to Leadger Account
  op.fetchPopulateAutocomplete(op.fetch_ledger_accounts_path, 
    $('#other_payment_ledger_account_name'), $('#other_payment_ledger_account_id'));
  
  // Add the auto complete to Centro de Costro
  op.fetchPopulateAutocomplete(op.fetch_cc_costs_centers_path, 
    $('#other_payment_costs_center_name'), $('#other_payment_costs_center_id'));

  $('#other_payment_amount').on('change', function() {
    var value = $(this).val();
    $('#employee_items tr').each(function() {
      if( !resources.parseBool( $(this).find('input:hidden[id*=_destroy]').val()) ) {
        $(this).find('input:text[id*=_calculation]').val(value);
      }
    })
  });

  op.showHideOptions($('#select_method_all')); // Set default

  $('input[name=select_method]').parents('label').click(function() {
    op.showHideOptions($(this).find('input'));
  });

  $('input[name=select_method]').next().click(function() {
    op.showHideOptions($(this).parent().find('input'));
  });

  $('#departments_employees').change(function() {
    op.filterEmployees('department', $(this).val());
  });

  $('#superiors_employees').change(function() {
    op.filterEmployees('superior', $(this).val());
  });

  // Clear empty employees on the table
  $('#employee_items tr.items_other_payment_form').each(function() {
    var id = $(this).find('input[id*=_employee_id]').val();
    if(id == "") $(this).remove();
  });

  // Search Centro de Costo
  $('#centroCostoButton').click(function() {
    $('#cost_center_name').val('');
    op.searchDataScript('', op.search_cost_center_work_benefits_path);
  });

  $('#cost_center_name').keyup(function() {
    op.searchDataScript( $(this).val(), op.search_cost_center_work_benefits_path);
  });

  // Centro de Costo | Click to pagination page
  $('#search_cost_center_results').on('click', '.pag a', function() {
    $.getScript(this.href);
    return false;
  });

  // Centro de Costo | Click to specific value
  $('#search_cost_center_results').on('click', 'table tr a', function(e) {
    e.preventDefault();
    $('#other_payment_costs_center_id').val($(this).next().val());
    $('#other_payment_costs_center_name').val($(this).html());
    $('#centroCostoModal button:eq(0)').trigger('click');
  });
  
  calculationType($('#other_payment_calculation_type'));

  $('#other_payment_calculation_type').on('change', function () { 
    calculationType($(this));
  });
  
  $('#other_payment_currency_id').on('change', function () {
    changeEmployeeValueCurrencySymbol();
  });

});

/*********************************************************************************************************************************************************/
/* F U N C T I O N S */
/*********************************************************************************************************************************************************/
op.updateValidation = function() {
  var modelName = $('form:eq(0)').data('modelName');
  var referenceId = $('form:eq(0)').data('referenceId');
  resources.updateValidation(modelName, referenceId);
}

op.searchEmployeeByAttr = function(values, type) {
  
  var symbol = currencySymbol();
  var deduction = $('#other_payment_amount').val();

  $.each(values, function (key, value) {
    var employee = gon.employees[value];

    if(employee == null) {
      resources.PNotify('Empleado', 'Error al buscar', 'danger');
      return false;
    }

    var selector = $('#tr_employee_id_' + employee.id);

    if(op.types.add == type) {
      if(selector.length) {
        selector.find('input[type=hidden][id*=_destroy]').val(0);
        selector.show();
      } else {
        $('.header_items').after( op.newRow(employee, symbol, deduction) );
        employeeValueValidation();
      }
    }

    if(op.types.remove == type) {
      selector.find('input[type=hidden][id*=_destroy]').val(1);
      selector.hide();
    }
  });
  
  HoldOn.close();
}

op.newRow = function(employee, symbol, deduction) {
  
  var time = new Date().getTime().toString() + employee.id;

  // TD One
  var tds = '<td class="controls_item"><div class="input-append"><div class="col-md-12">';
  tds += '<input id="other_payment_other_payment_employees_attributes_' + time + '_employee_id"' + 
          ' name="other_payment[other_payment_employees_attributes][' + time + '][employee_id]"' + 
          ' type="hidden" value="' + employee.id + '" />';
  tds += '<input class="form-control" disabled="disabled" id="search_name_employee"' + 
          ' name="search_name_employee" type="text" value="' + employee.full_name + '" >';
  tds += '</div></div></td>';

  // TD Two
  tds += '<td class="controls_item"><div class="input-append"><div class="controls">';
  tds += '<span class="employee_calculation_currency_symbol">' + symbol + '</span>';
  tds += '<input class="form-control" id="other_payment_other_payment_employees_attributes_' + time + '_calculation"' + 
          ' name="other_payment[other_payment_employees_attributes][' + time + '][calculation]"' +
          ' size="5x5" type="text" required="required" data-parsley-range="[1, 100]" value="' + deduction + '" />';
  tds += '</div></div></td>';

  // TD Tree
  tds += '<td><div class="controls_item"><div class="controls">';
  tds += '<input id="other_payment_other_payment_employees_attributes_' + time + '__destroy"' + 
          ' name="other_payment[other_payment_employees_attributes][' + time + '][_destroy]"' + 
          ' type="hidden" value="false" />';
  tds += '</div></div></td>';

  // TR
  var html = '<tr class="items_deductions_form" id="tr_employee_id_' + employee.id + '">';
  html += tds;
  html += '<input id="other_payment_other_payment_employees_attributes_' + time + '_completed"' + 
          ' name="other_payment[other_payment_employees_attributes][' + time + '][completed]"' + 
          'type="hidden" value="false" />';
  html += '</tr>';

  return html;
}

op.typeDeduction = function(selected) {
  var unicPayroll = $('#unicPayroll');
  var otherPaymentsPayroll = $('#other_payments_payroll');
  var otherPaymentPayroll = $('#other_payment_payroll');
  var payrollsToSave = $('#payrolls-to-save');

  switch($(selected).val()) {
    case 'unique':
      payrollsToSave.empty();
      unicPayroll.show();
      otherPaymentsPayroll.show();
      otherPaymentPayroll.attr('required', true);
      op.getPayrolls();
      disablePayrollTypes();
    break;
    case 'constant':
      payrollsToSave.empty();
      otherPaymentPayroll.removeAttr('required');
      otherPaymentsPayroll.hide();
      unicPayroll.hide();
      enablePayrollTypes();
    break;
  }
}

// Obtiene todas las planillas activas
op.getPayrolls = function() {
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
        $(result.activa).each(function() { op.addActives(this, 'table#activas')});
      },
    error: function(result) {
      $('#error').show();
    }
 });
}

// Carga las planillas activas en una tabla
op.addActives = function(payroll, target_table) {
  var row = $(target_table + '> tbody:last').append('<tr>' +
      '<td class="payroll-id">' + payroll.id +'</td>' +
      '<td class="payroll-type"><a data-dismiss="modal" href="#">' + payroll.payroll_type.description +'</a></td>' +
      '<td>' +  payroll.start_date + '</td>' +
      '<td>' +  payroll.end_date + '</td>' +
      '<td>' +  payroll.payment_date + '</td>' +
    '</tr>');
  return row;
}

// Limpia el id y el texto de la planilla UNICA seleccionada en caso de querer cambiar la planilla unica seleccionada
// para que no se vayan varioss ids de planillas solo se tiene que guardar un unico id
op.clearPayrolls = function() {
  $('#payrolls-to-save').empty(); // Elimina el id de la planilla que ya no se quiere guardar
  $('#deduction_payroll').val('');
}

// Show/Hide The differents view based in the checkbox "individual"
op.showHideEmployees = function(isIndividual) {
  var employeesItems = $('#employee_items_two');
  var otherPaymentAmount = $('#other_payment_amount');

  if( $('#other_payment_individual').is(':checked') ) {
    employeesItems.show();
    otherPaymentAmount.prop('disabled', true);
    otherPaymentAmount.val('');
    disableValueValidations();
    employeeValueValidation();
  } else {
    employeesItems.hide();
    otherPaymentAmount.prop("disabled", false);
    enableValueValidations();
    employeeValueValidation();
  }
}

op.payrollSelectAll = function() {
  var that = $('#other_payment_payroll_type_ids');
  $('#payroll_select_all').is(':checked') ? $(that).multiSelect('select_all') : $(that).multiSelect('deselect_all');
}

op.employeeSelectAll = function() {
  var checked = $('#emplotee_select_all').is(':checked');
  var that = $('#other_payment_employee_ids');

  var select = $('#ms-other_payment_employee_ids div.ms-selectable li:visible').map(function() {
    return $(this).attr('id').split('-', 1)[0];
  });

  var deselect = $('#ms-other_payment_employee_ids div.ms-selection li:visible').map(function() {
    return $(this).attr('id').split('-', 1)[0];
  });
  
  if(checked && select.length == 0) HoldOn.close();
  checked ? $(that).multiSelect('select', select) : $(that).multiSelect('deselect', deselect);
}

// Establece el campo oculto de con el id de la planilla unica seleccionada
op.setPayroll = function(e) {
  e.preventDefault();
  var payrollId = $(e.target).parent().prev().text();
  var payrollName = $(e.target).text();
  appendPayrolls = "<input type='hidden" +"' name='other_payment[payroll_ids][]' value='"+ payrollId +"' />";
  $('#payrolls-to-save').append(appendPayrolls);
  $('#other_payment_payroll').val(payrollName);
}

// Establece el campo oculto con el id d la cuenta de credito y muestra el texto en el campo cuenta credito
op.setAccount = function(e) {
  e.preventDefault();
  var accountId = $(this).closest('li').data('id');
  var accountName = $(this).text();
  $('#other_payment_ledger_account_id').val(accountId);
  $('#other_payment_ledger_account_name').val(accountName);
}

// Auto complete function to the different fields
op.fetchPopulateAutocomplete = function(url, textField, idField) {
  var name = '';
  var codeLabel = '';

  $.getJSON(url, function(accounts) {
    $(textField).autocomplete({
      source: $.map(accounts, function(item) {

        if(item.naccount) name = item.naccount;
        
        if(item.name_cc) name = item.name_cc;
        
        if(item.name) name = item.surname + ' ' + item.name;

        if(item.description) name = item.description;

        if(item.icost_center) codeLabel = item.icost_center;

        if(item.iaccount) codeLabel = item.iaccount;
 
        $.data(document.body, 'account_' + item.id + '', codeLabel + ' - ' + name);

        return {
          label: codeLabel + ' - ' + name,
          id: item.id
        }
      }),

      select: function(event, ui) {
        if( idField == 'other_payment_costs_center_id') {
          $('.payroll-types-list.left-list input:checkbox').each(function() {
            if(ui.item.id === parseInt($(this).val()) ) {
              $(this).prop('checked', true);
              return false;
            }
          });
          otherPayment.moveToRightPayrollTypes();
        } else {
          $(idField).val(ui.item.id);
        }       
      },
      
      focus: function(event, ui) {
        if( idField != 'custom_employee' && idField != 'other_payment_costs_center_id' ) {
          $(textField).val(ui.item.label);
        }
      },
      
      change: function(event, ui) {
        if(!ui.item) {
          $(idField).val('');
          $(textField).val('');
        }
      }
    });
    if( $(idField).val() ) {
      $(textField).val( $.data(document.body, 'account_' + $(idField).val() + '') );
    }
  });

}

op.showHideOptions = function(selected) {
  var main_selector = $('#employee_items_one');
  switch($(selected).val()) {
    case 'all':
      $('#ms-other_payment_employee_ids').find('input:eq(0)').show();
      $('#list-departments').hide();
      $('#list-superior').hide(); 
      $(main_selector).find('.ms-selection').removeClass('custom-multiselect')
                                            .addClass('custom-multiselect-empty');
      op.filterEmployees("all");
      break;
    case 'boss':
      $(main_selector).find('.ms-selection').addClass('custom-multiselect')
                                            .removeClass('custom-multiselect-empty');
      $('#ms-other_payment_employee_ids').find('input:eq(0)').hide();
      $('#list-departments').hide();
      op.filterEmployees("superior", $('#superiors_employees').val());
      $('#list-superior').show(); 
      break;
    case 'department':
      $(main_selector).find('.ms-selection').addClass('custom-multiselect')
                                            .removeClass('custom-multiselect-empty');
      $('#ms-other_payment_employee_ids').find('input:eq(0)').hide();
      $('#list-superior').hide(); 
      op.filterEmployees('department', $('#departments_employees').val());
      $('#list-departments').show();
      break;
  }
}

op.filterEmployees = function(type, id) {
  
  id = id ? id : 0;

  $('#ms-other_payment_employee_ids .ms-selectable').find('li').each(function() {
    
    if(type === 'all') {
      if(!$(this).hasClass('ms-selected')) {
        $(this).show();
      }
    }

    var searchType = 0;
    if(type === 'superior') {
      searchType = $(this).data('sup') ? $(this).data('sup') : 0;
    }
    
    if(type === 'department') {
      searchType = $(this).data('dep') ? $(this).data('dep') : 0;
    }
    
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

// Get data to specific url and return the result (type=script)
op.searchDataScript = function(name, url) {
  return $.ajax({
    url: url,
    dataType: 'script',
    data: { search_cost_center_name: name }
  });
}

function calculationType(selector) {
  var otherPaymentAmount = $('#other_payment_amount');
  var currency = $('#currency');

  switch($(selector).val()) {
    case 'percentage':
      currency.hide()
      amountPercentValidation()
      percentMask(otherPaymentAmount);
      changeEmployeeValueCurrencySymbol();
      enableValueValidations();
      employeeValueValidation();
      break;
    case 'fixed':
      currency.show();
      amountCurrencyValidation();
      currencyMask(otherPaymentAmount);
      changeEmployeeValueCurrencySymbol();
      enableValueValidations();
      employeeValueValidation();
      break;
  }
}

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
     'N': {pattern: /\d/, optional: true},
     'F': {pattern: /[1-9]/}
    }
  });    
}

function amountPercentValidation() {
  if(!$('#work_benefit_individual').prop('checked')) {
    $('#work_benefit_work_benefits_value').attr({'data-parsley-range': '[1, 100]', 'required': true });
  }
}

function amountCurrencyValidation() {
  var workBenefitValue = $('#work_benefit_work_benefits_value');

  if(!$('#work_benefit_individual').prop('checked')) {
    workBenefitValue.removeAttr('data-parsley-range');
    workBenefitValue.attr('required', true);
  }
}

function changeEmployeeValueCurrencySymbol() {
  var symbol = currencySymbol();
  $('.employee_calculation_currency_symbol').text(symbol);
}

function currencySymbol() {
  var symbol = '%';
  if($('#other_payment_calculation_type').val() == 'fixed') {
    var currency = $('#other_payment_currency_id :selected').text();
    symbol = $('input[name=' + currency + ']').val();
  }
  return symbol;
}

function disablePayrollTypes() {
  var payrollTypeIds = $('#other_payment_payroll_type_ids');

  payrollTypeIds.prop('disabled', true);
  payrollTypeIds.prop('required', false);
  payrollTypeIds.multiSelect('refresh');
  $('#payroll_select_all').iCheck('disable');
}

function enablePayrollTypes() {
  var payrollTypeIds = $('#other_payment_payroll_type_ids');

  payrollTypeIds.prop('disabled', false);
  payrollTypeIds.prop('required', true);
  payrollTypeIds.multiSelect('refresh');
  $('#payroll_select_all').iCheck('enable');
}

function enableValueValidations() {
  if($('#other_payment_calculation_type').val() == 'percentage') {
    otherPaymentValuePercentValidation();
  } else {
    otherPaymentValueCurrencyValidation();
  }
}    

function disableValueValidations() {
  $('#other_payment_amount').removeAttr('data-parsley-range required');
}

function otherPaymentValuePercentValidation() {
  if(!$('#other_payment_individual').prop('checked')) {
    $('#other_payment_amount').attr({'data-parsley-range': '[1, 100]', 'required': true});
  }
}

function otherPaymentValueCurrencyValidation() {
  if(!$('#other_payment_individual').prop('checked')) {
    $('#other_payment_amount').removeAttr('data-parsley-range').attr('required', true);
  }
}

function employeeValueValidation() {
  var calculationType = $('#other_payment_calculation_type').val();
  var employeesValueField = $('#employee_items input:text[id*=_calculation]');
  
  if($('#other_payment_individual').is(':checked')) {
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
