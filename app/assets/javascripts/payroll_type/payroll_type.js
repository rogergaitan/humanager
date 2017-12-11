var payrollType = {};

$(document).ready(function() {
  
  // $('#payroll_type_calendar_color').colorpicker();
  $('#payroll_type_calendar_color').simplecolorpicker({ 
                                      picker: true, 
                                      theme: 'glyphicons'
                                    });
  
  payrollSupports();
  
  $('#payroll_accounting_supports_modal').on('click', 'p', function () {
    $('#load_payroll_accounting_supports').val($(this).text());
    $('#payroll_type_cod_doc_accounting_support_mov').val( $(this).attr('data-id') );
    $('#payroll_type_mask_doc_accounting_support_mov').val($(this).attr('data-smask'));
    $('#payroll_accounting_supports_modal').modal('hide');
  })
  
  $('#payroll_supports_modal').on('click', 'p', function () {
    $('#load_payroll_supports').val($(this).text());
    $('#payroll_type_cod_doc_payroll_support').val($(this).attr('data-id'));
    $('#payroll_type_mask_doc_payroll_support').val($(this).attr('data-smask'));
    $('#payroll_supports_modal').modal('hide');
  })
  
  // Load Routes
  payrollType.bank_accounts_path = $('#get_bank_account_ledger_accounts_path').val();

  // Load the tree Bank Account
  treeviewhr.cc_tree(bank_account, true);
  $('.expand_tree').click(treeviewhr.expand);

  // Event click in a Bank Account to set the id
  $('#list').on({
    click: payrollType.setAccount,
    
    mouseenter: function() {
            $(this).css("text-decoration", "underline");
    },
    mouseleave: function() {
            $(this).css("text-decoration", "none");
  }}, ".node_link");

  // Autocomplete to Bank Account
  payrollType.autocompleteBackAccounts();

  // Autocomplete Employees
  payrollType.autocompletePayerEmployee();

});

// Set the hidden field with the Id and show the text (Bank Account)
payrollType.setAccount = function(e) {
  e.preventDefault();
  var accountId = $(this).closest('li').data('id');
  var accountName = $(this).text();
  $('#payroll_type_ledger_account_id').val(accountId);
  $('#payroll_type_ledger_account').val(accountName);
}

// Autocomplete to Bank Account
payrollType.autocompleteBackAccounts = function() {
  $.getJSON(payrollType.bank_accounts_path, function(category_data) {
    
    $('#payroll_type_ledger_account').autocomplete({
      source: $.map(category_data, function(item) {
        $.data(document.body, 'category_' + item.id + '', item.iaccount + ' - ' + item.naccount);
        return {
          label: item.iaccount + ' - ' + item.naccount,
          id: item.id
        }
      }),
      select: function( event, ui ) {
        $('#payroll_type_ledger_account_id').val(ui.item.id);
      },
      focus: function(event, ui) {
        $('#payroll_type_ledger_account').val(ui.item.label);
      },
      change: function(event, ui) {
        if(!ui.item) {
          $('#payroll_type_ledger_account_id').val('');
          $('#payroll_type_ledger_account').val('');
        }
      }
    });
    
    if($("#payroll_type_ledger_account_id").val()) {
      var deducciones_cuentas = $.data(document.body, 'category_' + $('#payroll_type_ledger_account_id').val() + '');
      $("#payroll_type_ledger_account").val(deducciones_cuentas);
    }
  });
}

// Autocomplete Payer Employee
payrollType.autocompletePayerEmployee = function() {
  
  $('#payroll_type_payer_employee').autocomplete({
    source: $.map(gon.employees, function(employee) {
      $.data(document.body, 'employee_' + employee.id + ' - ', employee.full_name);
      return {
        label: employee.full_name,
        id: employee.id
      }
    }),
    select: function(event, ui) {
      $('#payroll_type_payer_employee_id').val(ui.item.id);
    },
    focus: function(event, ui) {
      $('#payroll_type_payer_employee').val(ui.item.label);
    },
    change: function(event, ui) {
      if(!ui.item) {
        $('#payroll_type_payer_employee_id').val('');
        $('#payroll_type_payer_employee').val('');
      }
    }
  });

  var employeeId = $('#payroll_type_payer_employee_id').val();
  if(employeeId) $('#payroll_type_payer_employee').val(gon.employees[employeeId].full_name);
}

payrollSupports = function () {
  $.getJSON("/supports", function(data) {
    $("#load_payroll_supports").autocomplete({
      
      source: $.map(data, function(item) {
        $.data(document.body, 'support_' + item.id + "",  item.ntdsop);
          return { label: item.ntdsop, id: item.id, smask: item.smask }
      }),
      
      select: function(event, ui) {
        if(ui.item.id) {
          $('#payroll_type_cod_doc_payroll_support').val(ui.item.id);
          $("#payroll_type_mask_doc_payroll_support").val(ui.item.smask);
        }
      },
      
      focus: function(event, ui) {
        $('#load_payroll_supports').val(ui.item.label); 
      },
      
      change: function(event, ui) {
        if(!ui.item) {
          $('#load_payroll_supports').val('');
          $('#payroll_type_cod_doc_payroll_support').val('');
          $("#payroll_type_mask_doc_payroll_support").val('');
        }
      }
    });
      
    if($('#payroll_type_cod_doc_payroll_support').val()) {
      var load_support_name = $.data(document.body, 'support_' + $('#payroll_type_cod_doc_payroll_support').val());
      $('#load_payroll_supports').val(load_support_name);
    }
  
    $("#load_payroll_accounting_supports").autocomplete({
      source: $.map(data, function(item) {
        $.data(document.body, 'support_' + item.id + "",  item.ntdsop);
        return { label: item.ntdsop, id: item.id, smask: item.smask }
      }),
      
      select: function(event, ui) {
        if(ui.item.id) {
          $('#payroll_type_cod_doc_accounting_support_mov').val(ui.item.id);
          $("#payroll_type_mask_doc_accounting_support_mov").val(ui.item.smask);
        }
      },
      
      focus: function(event, ui) {
        $('#load_payroll_accounting_supports').val(ui.item.label); 
      },
      
      change: function(event, ui) {
        if(!ui.item) {
          $('#payroll_type_cod_doc_accounting_support_mov').val('');
          $('#payroll_type_mask_doc_accounting_support_mov').val('');
          $('#load_payroll_accounting_supports').val('');
        }
      }
    })
    
    if($('#payroll_type_cod_doc_accounting_support_mov').val()) {
      var load_support_name = $.data(document.body, 'support_' + $('#payroll_type_cod_doc_accounting_support_mov').val());
      $('#load_payroll_accounting_supports').val(load_support_name);
    }
    
  }).done(function (data) {
     $.each(data, function (i, item) {
       $("#payroll_supports_modal .modal-body, #payroll_accounting_supports_modal .modal-body")
         .append("<p data-id=" + "'" + item.id +"'" +  "data-smask=" + item.smask  + ">" + item.ntdsop +  "</p>");
    }) 
  });
}
