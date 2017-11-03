$(jQuery(document).ready(function($) {
	 types = {
    add: 'add',
    remove: 'remove',
    show: 'show'
  };
  
  $(".add_fields").hide();
  $('form').on('click', '.add_fields', addFields);
  
	$('#work_benefit_employee_ids').multiSelect({
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
	    afterSelect: function(values){
        searchEmployeeByAttr(values[0], 'id', 'multi', types.add);
        this.qs1.cache();
	      this.qs2.cache();
	    },
	    afterDeselect: function(values){
	      searchEmployeeByAttr(values[0], 'id', 'multi', types.remove);
        this.qs1.cache();
	      this.qs2.cache();
	    }
	  });
	
	$('#work_benefit_payroll_type_ids').multiSelect({
	    
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
	
	// Update validation
  $('#work_benefit_employee_ids, #work_benefit_payroll_type_ids').change(function() {
    var modelName = $('form:eq(0)').data('modelName');
    var referenceId = $('form:eq(0)').data('referenceId');
    resources.updateValidation(modelName, referenceId);
  });
	
	// Generates the treeview with the different accounts
	$('#debit-button').click(function(){
		$('#myModalLabel').html('Seleccione la cuenta contable');
		treeviewhr.cc_tree(debit_account, true, 'load_debit_accounts', 'work_benefit_debit_account');
	});

	$('#credit-button').click(function(){
    if($("#credit-button").attr("data-toggle")) {
		  $('#myModalLabel').html('Seleccione la cuenta contable');
		  treeviewhr.cc_tree(credit_account, true, 'load_credit_account_name', 'work_benefit_credit_account');
    }
	});

	$('#cost-centrt-button').click(function(){
		$('#myModalLabel').html('Seleccione un Centro de costo');
		treeviewhr.cc_tree(costs_center, true, 'load_costs_center_name', 'work_benefit_costs_center_id');
	});
	
	// Populates the autocompletes for the accounts
  	fetchPopulateAutocomplete('/work_benefits/fetch_debit_accounts', "#load_debit_accounts", 
                                                             "#work_benefit_debit_account", "debit_account_");
    fetchPopulateAutocomplete('/work_benefits/fetch_credit_accounts', "#load_credit_account_name", 
                                                            "#work_benefit_credit_account", "credit_account_");
  	fetchCostCenterAutocomplete('/work_benefits/fetch_cost_center', "#load_costs_center_name", "#work_benefit_costs_center_id");
	// Populates the filter for employees
	populateEmployeesFilter('/work_benefits/fetch_employees', 'load_filter_employees_text', 'load_filter_employees_id');

	populatePayrollTypesFilter('/work_benefits/fetch_payroll_type', 'load_filter_payroll_types_text', 'load_filter_payroll_types_id');

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

	$('#work_benefit_is_beneficiary').next().click(function() { is_beneficiary($('#work_benefit_is_beneficiary').is(':checked')) });

	// Seach Cost Center
	searchCostCenter( $('#cost_center_name').val(), "/work_benefits/search_cost_center");

	$("#search_cost_center_results").on("click", ".pag a", function() {
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
		employeesSelectAll();
	});

	$('#emplotee_select_all').next().click(function() {
		employeesSelectAll();
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
  
  calculationType( $("#work_benefit_calculation_type"));
  
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
  
  $('#activas').on("click", "td.payroll-type a", setPayroll);
  
  enableDisableCreditAccount();
  $("#work_benefit_provisioning").next().on("click", enableDisableCreditAccount);
  $("label[for=work_benefit_provisioning]").on("click", enableDisableCreditAccount);
  
  $('#employee_items tr.items_work_benefits_form').each(function() {
    var id = $(this).find("input[id*='_employee_id']").val();
    if(id != "" ) {
      searchEmployeeByAttr( id, 'id', 'show', '');
    } else {
      $(this).remove();
    }
  });
  
  $("#work_benefit_currency_id").on("change", function () {
    changeEmployeeValueCurrencySymbol();    
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
      $('#ms-work_benefit_employee_ids').find('.ms-selection').css('margin-top', '-1px');
      filterEmployees("all");
      break;
    case 'boss':
      $('#ms-work_benefit_employee_ids').find('.ms-selection').css('margin-top', '-5.7%');
      $('#ms-work_benefit_employee_ids').find('input:eq(0)').hide();
      $('#list-departments').hide();
      filterEmployees("superior", $('#superiors_employees').val());
      $('#list-superior').show(); 
      break;
    case 'department':
      $('#ms-work_benefit_employee_ids').find('.ms-selection').css('margin-top', '-5.7%');
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

function employeesSelectAll() {
	if( $('#emplotee_select_all').is(':checked') ) {
    selectUnselectEmployees(true);
	} else {
    selectUnselectEmployees(false);
	}
}

function selectUnselectEmployees(isSelect) {
  
  var theClass = 'ms-selection';
  if(isSelect) {
    theClass = 'ms-selectable';
  }
  
  $('#ms-work_benefits_employee_ids div.'+theClass).find('li:visible').each( function() {
    var id = $(this).attr('id').replace('-selectable','');
    if(isSelect) {
      searchEmployeeByAttr(id, 'id', 'multi', types.add);
    } else {
      searchEmployeeByAttr(id, 'id', 'multi', types.remove);
    }
  });

  if(isSelect) {
    $('#work_benefit_employee_ids').multiSelect('select_all');
  } else {
    $('#work_benefit_employee_ids').multiSelect('deselect_all');
  }
}

function payrollSelectAll() {
	if( $('#payroll_type_select_all').is(':checked') ) {
		$('#work_benefit_payroll_type_ids').multiSelect('select_all');
	} else {
		$('#work_benefit_payroll_type_ids').multiSelect('deselect_all');
	}
}

function is_beneficiary(value) {
	if( value ) {
		$('#work_benefit_beneficiary_id').attr('disabled', 'disabled');
		$('#work_benefit_beneficiary_id').val('');
	} else {
		$('#work_benefit_beneficiary_id').removeAttr('disabled', 'disabled');
	}
}

function fetchPopulateAutocomplete(url, textField, idField, dataField) {
  $.getJSON(url, function(data) {
    $(textField).autocomplete({

      source: $.map(data, function(item) {
        $.data(document.body, dataField + item.id + "", item.iaccount + " - " + item.naccount);
          return { label: item.iaccount + " - " + item.naccount, id: item.id }
      }),
      
      select: function(event, ui) {
        if(ui.item.id) {
          $(idField).val(ui.item.id);
        }
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
      var account = $.data(document.body, dataField + $(idField).val() +"");
      $(textField).val(account);
    }
  })
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
																"<input type='checkbox' data-sup='"+ ui.item.sup +"' data-dep='"+ ui.item.dep +"' checked='checked' class='align-checkbox right' id='"+ ui.item.data_id +"' name='work_benefit[employee_ids][]' value='"+ ui.item.id +"' />" +
																"<label class='checkbox-label' for='"+ ui.item.data_id +"'>"+ ui.item.label +"</label>" +
															"</div>" +
														"</div>";	
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
					appendPayrollTypes = "<div class='checkbox-group'>" +
												"<div class='checkbox-margin'>" +
													"<input type='checkbox' data-sup='"+ ui.item.sup +"' data-dep='"+ ui.item.dep +"' checked='checked' class='align-checkbox right' id='"+ ui.item.data_id +"' name='work_benefit[payroll_type_ids][]' value='"+ ui.item.id +"' />" +
													"<label class='checkbox-label' for='"+ ui.item.data_id +"'>"+ ui.item.label +"</label>" +
												"</div>" +
											"</div>";	
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
              $.data(document.body, 'account_' + item.id + "", item.icost_center + " - "  + item.name_cc);
              return{
                  label: item.icost_center + " - " + item.name_cc,
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
		dataType: "script",
		data: { search_cost_center_name: name }
	});
}

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

function calculationType(selector) {
    switch($(selector).val()) {
      case "percentage":
      $("#currency").hide();
      workBenefitValuePercentValidation()
      percentMask($("#work_benefit_work_benefits_value"));
      employeeValueValidation();
      changeEmployeeValueCurrencySymbol();
      break;
      case "fixed":
      $("#currency").show();
      workBenefitValueCurrencyValidation();
      currencyMask($("#work_benefit_work_benefits_value"));
      employeeValueValidation();
      changeEmployeeValueCurrencySymbol();
      break;
    }
};

function enableWorkBenefitValueValidations () {
  if($("#work_benefit_calculation_type").val() == "percentage" ) {
    workBenefitValuePercentValidation();
  } else {
    workBenefitValueCurrencyValidation();
  }
}

function disableWorkBenefitValueValidations () {
  $("#work_benefit_work_benefits_value").removeAttr("data-parsley-range");
  $("#work_benefit_work_benefits_value").removeAttr("required");
}

function workBenefitValuePercentValidation() {
  if(!$("#work_benefit_individual").prop("checked")) {
    $("#work_benefit_work_benefits_value").attr("data-parsley-range", "[1, 100]");
    $("#work_benefit_work_benefits_value").attr("required", true);  
  }
}

function workBenefitValueCurrencyValidation () {
  if(!$("#work_benefit_individual").prop("checked")) {
    $("#work_benefit_work_benefits_value").removeAttr("data-parsley-range");
    $("#work_benefit_work_benefits_value").attr("required", true);
  }
}

function showHideEmployees() {
  if( $('#work_benefit_individual').is(':checked') ) {
    $('#work_benefit_work_benefits_value').val('');
    $("#work_benefit_work_benefits_value").prop("disabled", true);
    disableWorkBenefitValueValidations();
    $('#employee_items_two').show();
    $("#employee_items_two input").prop("disabled", false);
  } else {
    $("#work_benefit_work_benefits_value").prop('disabled', false);
    enableWorkBenefitValueValidations();
    
    $("#employee_items_two input").prop("disabled", true);
    $('#employee_items_two').hide();
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

function fromMulti(employee, type) {

  var data = findParentByAttr(employee.id, 'id');

  switch(type) {

    case types.add:
      // No existe
      if(typeof data.parent == 'undefined') {
        $('.add_fields ').trigger('click'); // Add new row
        var selector = $('#employee_items tr.items_work_benefits_form:eq(0)');
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
// Search a employee by attr (id, code, name)
function searchEmployeeByAttr(searchValue, searchType, from, typeFrom) {
  
  var url, customData;

  switch(searchType) {
    case "id":
      url = "/employees/search_employee_by_id",
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

function populateAutocompleteEmployees(idField) {
  $.getJSON("/employees/load_em", function(accounts) {
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

function changeEmployeeValueCurrencySymbol() {
  
  if($("#work_benefit_calculation_type").val() == "fixed" ) {
    var currency = $("#work_benefit_currency_id :selected").text();
    var symbol = $("input[name=" + currency + "]").val();
    
    $(".employee_calculation_currency_symbol").text(symbol);
  }  else {
    $(".employee_calculation_currency_symbol").text("%");
  }
}

function employeeValueValidation () {
  var calculation_type = $("#work_benefit_calculation_type").val()
  
  if($('#work_benefit_individual').is(':checked')) {
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
}

function parseBool(str) {
  if(str==null) return false;
  if(str=="false") return false;
  if(str=="0") return false;
  if(str=="true") return true;
  if(str=="1") return true;

  return false;
}

function payToEmployee(value) {
  if( value ) {
    $("#load_creditor").prop("disabled", true);
    $("#load_creditor").prop("required", "");
    $("#load_creditor").val('');
    $("#work_benefit_creditor_id").val("");
    $("a[href=#creditors_modal]").prop("disabled", true);
  } else {
    $("#load_creditor").prop("disabled", false);
    $("#load_creditor").prop("required", "required")
    $("a[href=#creditors_modal]").prop("disabled", false);
  }
}

function addCreditor (selector) {
  var creditor = selector;
  var load_creditor = $("#load_creditor");
  if(!load_creditor.prop("disabled")) {
    $("#load_creditor").val(creditor.text());
    $("#work_benefit_creditor_id").val(creditor.attr("id"));
  }
  $("#creditors_modal").modal("hide");
}

function getCreditors () {
  $.getJSON("/creditors", function(data) {
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
      $("#creditors_modal .modal-body").append("<p id="+ item.id + ">" + item.name + "</p>");
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

function setPayroll(e) {
  e.preventDefault();
  var payrollId = $(e.target).parent().prev().text();
  var payrollName = $(e.target).text();
  $("#work_benefit_payroll_id").val(payrollId);
  $('#work_benefits_payrolls_name').val(payrollName);
  $('#work_benefits_payroll_name').focusout();
}

function enableDisableCreditAccount() {
  if($("#work_benefit_provisioning").prop("checked")) {
    $("#credit_accounts input").prop("disabled", false).attr("required", true);
    $("#credit-button").attr("data-toggle", "modal");
  } else {
    $("#credit_accounts input").prop("disabled", true).attr("required", false);
    $("#credit-button").removeAttr("data-toggle");
  }
}

function disablePayrollTypes() {
  $("#work_benefit_payroll_type_ids").prop("disabled", true);
  $("#work_benefit_payroll_type_ids").prop("required", false);
  $("#work_benefit_payroll_type_ids").multiSelect("refresh");
  $("#payroll_select_all").iCheck("disable");
}

function enablePayrollTypes() {
  $("#work_benefit_payroll_type_ids").prop("disabled", false);
  $("#work_benefit_payroll_type_ids").prop("required", true);
  $("#work_benefit_payroll_type_ids").multiSelect("refresh");
  $("#payroll_select_all").iCheck("enable");
}

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
