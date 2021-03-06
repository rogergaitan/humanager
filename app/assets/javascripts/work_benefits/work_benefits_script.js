$(jQuery(document).ready(function($) {
   
  types = {
    add: 'add',
    remove: 'remove',
    show: 'show'
  };
  
  $('#work_benefit_employee_ids').multiSelect({
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
    afterSelect: function(values) {
      searchEmployeeByAttr(values, types.add);
      // this.qs1.cache();
      this.qs2.cache();
    },
    afterDeselect: function(values) {
      searchEmployeeByAttr(values, types.remove);
      // this.qs1.cache();
      this.qs2.cache();
    }
  });
	
  $('#work_benefit_payroll_type_ids').multiSelect({
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
        if (e.which == 40){
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
	
  // Update validation
  $('#work_benefit_employee_ids, #work_benefit_payroll_type_ids').change(function() {
    var modelName = $('form:eq(0)').data('modelName');
    var referenceId = $('form:eq(0)').data('referenceId');
    resources.updateValidation(modelName, referenceId);
  });
	
  // Generates the treeview with the different accounts
  $('#debit-button').click(function() {
    $('#myModalLabel').html('Seleccione la cuenta contable');
    treeviewhr.cc_tree(debit_account, true, 'load_debit_accounts', 'work_benefit_debit_account');
  });

  $('#credit-button').click(function() {
    if($("#credit-button").attr("data-toggle")) {
      $('#myModalLabel').html('Seleccione la cuenta contable');
      treeviewhr.cc_tree(credit_account, true, 'load_credit_account_name', 'work_benefit_credit_account');
    }
  });

  $('#cost-centrt-button').click(function() {
    $('#myModalLabel').html('Seleccione un Centro de costo');
    treeviewhr.cc_tree(costs_center, true, 'load_costs_center_name', 'work_benefit_costs_center_id');
  });
	
  // Populates the autocompletes for the accounts
  fetchPopulateAutocomplete('/work_benefits/fetch_debit_accounts', '#load_debit_accounts', 
                            '#work_benefit_debit_account', 'debit_account_');

  fetchPopulateAutocomplete('/work_benefits/fetch_credit_accounts', '#load_credit_account_name', 
                            '#work_benefit_credit_account', 'credit_account_');

  fetchCostCenterAutocomplete('/work_benefits/fetch_cost_center', '#load_costs_center_name', 
                              '#work_benefit_costs_center_id');
  
  // Populates the filter for employees
  populateEmployeesFilter('/work_benefits/fetch_employees', 'load_filter_employees_text', 
                          'load_filter_employees_id');

  populatePayrollTypesFilter('/work_benefits/fetch_payroll_type', 'load_filter_payroll_types_text', 
                              'load_filter_payroll_types_id');

  // Allows expand the treeview
  $('#list').on("click", "span.expand_tree", treeviewhr.expand);
	
  // Delete the treeview after the user clicks on close
  $('button.delete-accounts').click(function() {
    $('#list').empty();
  });	
	
	// Allows add the selected account to the textfield	
  $('#list').on({
    click: set_account,
    mouseenter: function() {
      $(this).css("text-decoration", "underline");
    },
    mouseleave: function() {
      $(this).css("text-decoration", "none");
  }}, ".node_link");

  is_beneficiary( $('#work_benefit_is_beneficiary').is(':checked') );

  $('#work_benefit_is_beneficiary').next().click(function() { 
    is_beneficiary($('#work_benefit_is_beneficiary').is(':checked'));
  });

  // Seach Cost Center
  searchCostCenter( $('#cost_center_name').val(), "/work_benefits/search_cost_center");

  $('#search_cost_center_results').on('click', '.pag a', function() {
    $.getScript(this.href);
    return false;
  });

  $('#search_cost_center_form input').keyup(function() {
    return searchCostCenter( $('#cost_center_name').val(), "/work_benefits/search_cost_center" );
  });

  $('#clear_task').click(function() {
    $('#cost_center_name').val('');
    searchCostCenter( $('#cost_center_name').val(), "/work_benefits/search_cost_center" );
  });

  // Seach Cost center
  $("#search_cost_center_results").on("click", "table tr a", function(e) {
    $('#load_costs_center_name').val( $(this).html() );
    $('#work_benefit_costs_center_id').val( $(this).next().val() );
    $('#costCenterModal button:eq(2)').trigger('click');
    e.preventDefault();
  });
  	
  $('#work_benefit_percentage').keyup(resources.twoDecimals);

  // Empleados
  $('#emplotee_select_all').parents('label').click(function() {
    selectAll();
	});

	$('#emplotee_select_all').next().click(function() {
    selectAll();
	});

  // Tipos de Planillas
  $('#payroll_type_select_all').parents('label').click(function() {
    payrollSelectAll();
  });

  $('#payroll_type_select_all').next().click(function() {
    payrollSelectAll();
  });

  // Employees
  showHideOptions( $('#select_method_all') ); // Set default

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
  
  calculationType($("#work_benefit_calculation_type"));
  
  $("#work_benefit_calculation_type").on("change", function () { 
    calculationType(this);
  });
  
  showHideEmployees(); 
  
  $("label[for=work_benefit_individual]").click(function() {
    showHideEmployees();
  });

  $('#work_benefit_individual').next().click(function() {
    showHideEmployees();
  });
  
  getCreditors();
  
  $("#creditors_modal .modal-body").on("click", "p", function() {
    addCreditor($(this));
  });
  
  payToEmployee($("#work_benefit_pay_to_employee").prop("checked"));
  
  $('label[for=work_benefit_pay_to_employee]').click(function() {
    payToEmployee($('#work_benefit_pay_to_employee').is(':checked'));
  });

  $('#work_benefit_pay_to_employee').next().click(function() {
    payToEmployee($('#work_benefit_pay_to_employee').is(':checked'));
  });
  
  $('#activas').on('click', 'td.payroll-type a', setPayroll);
  
  enableDisableCreditAccount();
  $('#work_benefit_provisioning').next().on('click', enableDisableCreditAccount);
  $('label[for=work_benefit_provisioning]').on('click', enableDisableCreditAccount);
  
  // Clear empty employees on the table
  $('#employee_items tr.items_work_benefits_form').each(function() {
    var id = $(this).find("input[id*='_employee_id']").val();
    if(id == "") $(this).remove();
  });
  
  $('#work_benefit_currency_id').on('change', function () {
    changeEmployeeValueCurrencySymbol();    
  });

  $('#work_benefit_work_benefits_value').on('change', function() {
    var value = $(this).val();
    $('#employee_items tr').each(function() {
      if( !resources.parseBool( $(this).find('input:hidden[id*=_destroy]').val()) ) {
        $(this).find('input:text[id*=_calculation]').val(value);
      }
    });
  });
  
  getPayrolls();
  
}));

var empSelected = [];

function showHideOptions(selected) {
  switch($(selected).val()) {
    case 'all':
      $('#ms-work_benefit_employee_ids').find('input:eq(0)').show();
      $('#list-departments').hide();
      $('#list-superior').hide(); 
      $('#ms-work_benefit_employee_ids').find('.ms-selection').removeClass('custom-multiselect')
                                                              .addClass('custom-multiselect-empty');
      filterEmployees("all");
      break;
    case 'boss':
      $('#ms-work_benefit_employee_ids').find('.ms-selection').addClass('custom-multiselect')
                                                              .removeClass('custom-multiselect-empty');
      $('#ms-work_benefit_employee_ids').find('input:eq(0)').hide();
      $('#list-departments').hide();
      filterEmployees("superior", $('#superiors_employees').val());
      $('#list-superior').show(); 
      break;
    case 'department':
      $('#ms-work_benefit_employee_ids').find('.ms-selection').addClass('custom-multiselect')
                                                              .removeClass('custom-multiselect-empty');
      $('#ms-work_benefit_employee_ids').find('input:eq(0)').hide();
      $('#list-superior').hide(); 
      filterEmployees("department", $('#departments_employees').val());
      $('#list-departments').show();
      break;
  }
}

function filterEmployees(type, id) {
  
  id = id ? id : 0;

  $('#ms-work_benefit_employee_ids .ms-selectable').find('li').each(function() {
    
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

function selectAll() {
  HoldOn.open({theme: 'sk-rect', message: 'Cargando... Por favor espera!'});
  setTimeout(function() {
    employeesSelectAll();
  }, 2000);
}

function employeesSelectAll() {
  var checked = $('#emplotee_select_all').is(':checked');
  var that = $('#work_benefit_employee_ids');
  
  var select = $('#ms-work_benefit_employee_ids div.ms-selectable li:visible').map(function() {
    return $(this).attr('id').split('-', 1)[0];
  });

  var deselect = $('#ms-work_benefit_employee_ids div.ms-selection li:visible').map(function() {
    return $(this).attr('id').split('-', 1)[0];
  });
  
  if(checked && select.length == 0) HoldOn.close();
  checked ? that.multiSelect('select', select) : that.multiSelect('deselect', deselect);
}

function payrollSelectAll() {
  var select = ($('#payroll_type_select_all').is(':checked')) ? 'select_all':'deselect_all';
  $('#work_benefit_payroll_type_ids').multiSelect(select);
}

function is_beneficiary(value) {
  var selector = $('#work_benefit_beneficiary_id');
  value ? selector.attr('disabled', 'disabled').val('') : selector.removeAttr('disabled', 'disabled');
}

function fetchPopulateAutocomplete(url, textField, idField, dataField) {

  $.getJSON(url, function(data) {

    $(textField).autocomplete({
      source: $.map(data, function(item) {
        $.data(document.body, dataField + item.id + '', item.iaccount + ' - ' + item.naccount);
        return {
          label: item.iaccount + " - " + item.naccount,
          id: item.id
        }
      }),
      
      select: function(event, ui) {
        if(ui.item.id) $(idField).val(ui.item.id);
      },
      
      change: function(event, ui) {
        if(!ui.item) {
          $(idField).val('');
          $(textField).val('');
        }
      },
      
      focus: function(event, ui) {
        $(textField).val(ui.item.label);  
      }
    }); 
    
    if($(idField).val()) {
      var account = $.data(document.body, dataField + $(idField).val() +'');
      $(textField).val(account);
    }
  })
}

function populateEmployeesFilter(url, textField, idField) {
  $.getJSON(url, function(employees) {
    $(document.getElementById(textField)).autocomplete({
      source: $.map(employees, function(item) {
        $.data(document.body, 'account_' + item.id + '', item.entity.name + ' ' + item.entity.surname);
        return {
          label: item.entity.surname + ' ' + item.entity.name,                        
          id: item.id,
          sup: item.employee_id,
          dep: item.department_id,
          data_id: 'employee_' + item.id
        }
      }),
      select: function( event, ui ) {
        if (!$('#list-to-save input#'+ui.item.data_id).length) {
          appendEmployees = "<div class='checkbox-group'>" + "<div class='checkbox-margin'>" + "<input type='checkbox' data-sup='"+ ui.item.sup +"' data-dep='"+ ui.item.dep +
                            "' checked='checked' class='align-checkbox right' id='"+ ui.item.data_id +"' name='work_benefit[employee_ids][]' value='"+ ui.item.id +"' />" +
                            "<label class='checkbox-label' for='"+ ui.item.data_id +"'>"+ ui.item.label +"</label>" + "</div>" + "</div>";
          $('#list-to-save').append(appendEmployees);
          $('input#'+ ui.item.data_id + '_left').closest('.checkbox-group').remove();
        }
      }
    });
  });

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
 	  appendPayrollTypes = "<div class='checkbox-group'>" + "<div class='checkbox-margin'>" + "<input type='checkbox' data-sup='"+
	    ui.item.sup +"' data-dep='"+ ui.item.dep + "' checked='checked' class='align-checkbox right' id='"+ ui.item.data_id +
	    "' name='work_benefit[payroll_type_ids][]' value='"+ ui.item.id +"' />" +
	    "<label class='checkbox-label' for='"+ ui.item.data_id +"'>"+ ui.item.label +"</label>" + "</div>" + "</div>";
   	    $('#list-payroll-types-to-save').append(appendPayrollTypes);
    	    $('input#'+ ui.item.data_id + '_left').closest('.checkbox-group').remove();
    	    }
          }
      });
  });	
}

function set_account(e) {
  e.preventDefault();
  var accountId = $(this).closest('li').data('id');
  var accountName = $(this).text();
  $(document.getElementById($('#idFieldPopup').val())).val(accountId);
  $(document.getElementById($('#textFieldPopup').val())).val(accountName);
  $('#list').empty();
  $('#accountsModal .modal-content button:eq(1)').trigger('click');
}

function fetchCostCenterAutocomplete(url, textField, idField) {
  $.getJSON(url, function(accounts) {
    $(textField).autocomplete({
      source: $.map(accounts, function(item) {
        $.data(document.body, 'account_' + item.id + '', item.icost_center + ' - '  + item.name_cc);
        return {
          label: item.icost_center + ' - ' + item.name_cc,
          id: item.id
        }
      }),
      select: function( event, ui ) {
        $(idField).val(ui.item.id);
      },
      focus: function(event, ui) {
        $(textField).val(ui.item.name_cc);
      },
      change: function(event, ui) {
        if(!ui.item) {
          $(idField).val('');
          $(textField).val('');
        }
      }
    });
    if($(idField).val()) {
      var account = $.data(document.body, 'account_' + $(idField).val()+'');
      $(textField).val(account);
    }
  });
}

function searchCostCenter(name, url, type) {
  return $.ajax({
    url: url,
    dataType: 'script',
    data: { search_cost_center_name: name }
  });
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

function calculationType(selector) {
  var currency = $('#currency');
  var workBenefitsValue = $('#work_benefit_work_benefits_value');

  switch($(selector).val()) {
    case 'percentage':
      currency.hide();
      workBenefitValuePercentValidation()
      percentMask(workBenefitsValue);
      changeEmployeeValueCurrencySymbol();
      employeeValueValidation();
    break;
    case 'fixed':
      currency.show();
      workBenefitValueCurrencyValidation();
      currencyMask(workBenefitsValue);
      changeEmployeeValueCurrencySymbol();
      employeeValueValidation();
    break;
  }
};

function enableWorkBenefitValueValidations() {
  if($('#work_benefit_calculation_type').val() == 'percentage' ) {
    workBenefitValuePercentValidation();
  } else {
    workBenefitValueCurrencyValidation();
  }
}

function disableWorkBenefitValueValidations() {
  $("#work_benefit_work_benefits_value").removeAttr('data-parsley-range required');
}

function workBenefitValuePercentValidation() {
  if(!$('#work_benefit_individual').prop('checked')) {
    $('#work_benefit_work_benefits_value').attr({'data-parsley-range': '[1, 100]', 'required': true });
  }
}

function workBenefitValueCurrencyValidation() {
  var workBenefitsValue = $('#work_benefit_work_benefits_value');

  if(!$('#work_benefit_individual').prop('checked')) {
    workBenefitsValue.removeAttr('data-parsley-range');
    workBenefitsValue.attr('required', true);
  }
}

function showHideEmployees() {
  var workBenefitsValue = $('#work_benefit_work_benefits_value');
  var employeeItems = $('#employee_items_two');

  if( $('#work_benefit_individual').is(':checked') ) {
    workBenefitsValue.val('');
    workBenefitsValue.prop('disabled', true);
    disableWorkBenefitValueValidations();
    employeeValueValidation();
    employeeItems.show();
  } else {
    workBenefitsValue.prop('disabled', false);
    enableWorkBenefitValueValidations();
    employeeValueValidation();
    employeeItems.hide();
  }
}

// Search a employee by attr (id)
function searchEmployeeByAttr(values, type) {
  var symbol = currencySymbol();
  var deduction = $('#work_benefit_work_benefits_value').val();

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
      selector.find('input[type=hidden][id*=_destroy]').val(1);
      selector.hide();
    }
  });
  
  HoldOn.close();
}

function newRow(employee, symbol, deduction) {
  
  var time = new Date().getTime().toString() + employee.id;

  // TD One
  var tds = '<td class="controls_item"><div class="input-append"><div class="col-md-12">';
  tds += '<input id="work_benefit_employee_benefits_attributes_' + time + '_employee_id"' + 
          ' name="work_benefit[employee_benefits_attributes][' + time + '][employee_id]"' + 
          ' type="hidden" value="' + employee.id + '" />';
  tds += '<input class="form-control" disabled="disabled" id="search_name_employee"' + 
          ' name="search_name_employee" type="text" value="' + employee.full_name + '" >';
  tds += '</div></div></td>';

  // TD Two
  tds += '<td class="controls_item"><div class="input-append"><div class="controls">';
  tds += '<span class="employee_calculation_currency_symbol">' + symbol + '</span>';
  tds += '<input class="form-control" id="work_benefit_employee_benefits_attributes_' + time + '_calculation"' + 
          ' name="work_benefit[employee_benefits_attributes][' + time + '][calculation]"' +
          ' size="5x5" type="text" required="required" data-parsley-range="[1, 100]" value="' + deduction + '" />';
  tds += '</div></div></td>';

  // TD Tree
  tds += '<td><div class="controls_item"><div class="controls">';
  tds += '<input id="work_benefit_employee_benefits_attributes_' + time + '__destroy"' + 
          ' name="work_benefit[employee_benefits_attributes][' + time + '][_destroy]"' + 
          ' type="hidden" value="false" />';
  tds += '</div></div></td>';

  // TR
  var html = '<tr class="items_work_benefits_form" id="tr_employee_id_' + employee.id + '">';
  html += tds;
  html += '<input id="work_benefit_employee_benefits_attributes_' + time + '_completed"' + 
          ' name="work_benefit[employee_benefits_attributes][' + time + '][completed]"' + 
          'type="hidden" value="false" />';
  html += '</tr>';

  return html;
}

function changeEmployeeValueCurrencySymbol() {
  var symbol = currencySymbol();
  $('.employee_calculation_currency_symbol').text(symbol);
}

function currencySymbol() {
  var symbol = '%';
  if($('#work_benefit_calculation_type').val() == 'fixed' ) {
    var currency = $('#work_benefit_currency_id :selected').text();
    symbol = $('input[name=' + currency + ']').val();
  }
  return symbol;
}

function parseBool(str) {
  if(str==null) return false;
  if(str=='false') return false;
  if(str=='0') return false;
  if(str=='true') return true;
  if(str=='1') return true;

  return false;
}

function payToEmployee(value) {
  if( value ) {
    $('#load_creditor').prop('disabled', true).prop('required', '').val('');
    $('#work_benefit_creditor_id').val('');
    $('a[href=#creditors_modal]').attr('disabled', true);
  } else {
    $('#load_creditor').prop('disabled', false).prop('required', 'required');
    $('a[href=#creditors_modal]').attr('disabled', false);
  }
}

function addCreditor(selector) {
  var creditor = selector;
  var load_creditor = $('#load_creditor');
  if(!load_creditor.prop('disabled')) {
    $('#load_creditor').val(creditor.text());
    $('#work_benefit_creditor_id').val(creditor.attr('id'));
  }
  $('#creditors_modal').modal('hide');
}

function getCreditors() {
  $.getJSON('/creditors', function(data) {
    $('#load_creditor').autocomplete({
      minLength: 3,
      
      source: $.map(data, function(item) {
        $.data(document.body, 'creditor_' + item.id + "", item.name);
          return { label: item.name, id: item.id }
      }),
      
      select: function(event, ui) {
        if(ui.item.id) {
          $('#work_benefit_creditor_id').val(ui.item.id);
        }
      },
      
      focus: function(event, ui) {
        $('#load_creditor').val(ui.item.label);  
      }, 
      
      change: function(event, ui) {
        if(!ui.item) {
          $('#work_benefit_creditor_id').val('');
          $('#load_creditor').val('');
        }
      }
    });
    
    if($('#work_benefit_creditor_id').val()) {
      var load_creditor_name = $.data(document.body, 'creditor_' + $('#work_benefit_creditor_id').val());
      $('#load_creditor').val(load_creditor_name);
    }
    
  }).done(function(data) {
    $.each(data, function(i, item) {
      $('#creditors_modal .modal-body').append('<p id='+ item.id + '>' + item.name + '</p>');
    });
  });
}

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
        $(result.activa).each(function() { 
          addActives(this, 'table#activas')
        });
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

function setPayroll(e) {
  e.preventDefault();
  var payrollId = $(e.target).parent().prev().text();
  var payrollName = $(e.target).text();
  $("#work_benefit_payroll_id").val(payrollId);
  $('#work_benefits_payrolls_name').val(payrollName);
  $('#work_benefits_payroll_name').focusout();
}

function enableDisableCreditAccount() {
  var checked = $('#work_benefit_provisioning').prop('checked');
  $('#credit_accounts input').prop('disabled', !checked).attr('required', checked);
  $('#credit-button').attr('data-toggle', 'modal').attr('disabled', !checked);
}

function employeeValueValidation() {
  var calculationType = $('#work_benefit_calculation_type').val();
  var employeesValueField = $('#employee_items input:text[id*=_calculation]'); 

  if($('#work_benefit_individual').is(':checked')) {
    employeesValueField.attr('required', true); 
    
    if(calculationType == 'fixed') {
      currencyMask(employeesValueField);
      employeesValueField.removeAttr('data-parsley-range');
    } else {
      percentMask($('#employee_items input:text[id*=_calculation]'));
      employeesValueField.attr('data-parsley-range', '[1, 100]');
    }
  } else {
    employeesValueField.removeAttr('required data-parsley-range');
  }
}
