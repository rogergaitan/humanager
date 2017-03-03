$(jQuery(document).ready(function($) {
	
	$('#work_benefit_employee_ids').multiSelect({
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
	      // this.qs1.cache();
	      this.qs2.cache();
	    },
	    afterDeselect: function(){
	      this.qs1.cache();
	      this.qs2.cache();
	    }
	  });
	
	$('#work_benefit_payroll_type_ids').multiSelect({
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
	
	// Update validation
  $('#work_benefit_employee_ids, #work_benefit_payroll_type_ids').change(function() {
    var modelName = $('form:eq(0)').data('modelName');
    var referenceId = $('form:eq(0)').data('referenceId');
    resources.updateValidation(modelName, referenceId);
  });
	
	// Generates the treeview with the different accounts
	$('#debit-button').click(function(){
		treeviewhr.cc_tree(debit_account, true, 'load_debit_accounts', 'work_benefit_debit_account');
	});

	$('#credit-button').click(function(){
		treeviewhr.cc_tree(credit_account, true, 'load_credit_account_name', 'work_benefit_credit_account');
	});
	
	// Populates the autocompletes for the accounts
  	fetchPopulateAutocomplete('/work_benefits/fetch_debit_accounts', "load_debit_accounts", "work_benefit_debit_account");
  	fetchPopulateAutocomplete('/work_benefits/fetch_credit_accounts', "load_credit_account_name", "work_benefit_credit_account");
  	fetchCostCenterAutocomplete('/work_benefits/fetch_cost_center', "load_costs_center_name", "work_benefit_costs_center_id");
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

	$('#work_benefit_is_beneficiary').change(function() { is_beneficiary($('#work_benefit_is_beneficiary').is(':checked')) });

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

function fetchPopulateAutocomplete(url, textField, idField) {
  $.getJSON(url, function(accounts) {
      $(document.getElementById(textField)).autocomplete({
          source: $.map(accounts, function(item) {
              $.data(document.body, 'account_' + item.id+"", item.naccount);
              return{
                  label: item.naccount,                        
                  id: item.id
              }
          }),
          select: function( event, ui ) {
              $(document.getElementById(idField)).val(ui.item.id);
          },
          focus: function(event, ui) {
              $(document.getElementById(textField)).val(ui.item.label);
          }
      });

      if($(document.getElementById(idField)).val()) {
          var account = $.data(document.body, 'account_' + $('#'+idField).val()+'');
          $(document.getElementById(textField)).val(account);
      }        
  }); 
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
      $(document.getElementById(textField)).autocomplete({
          source: $.map(accounts, function(item) {
              $.data(document.body, 'account_' + item.id + "", item.name_cc);
              return{
                  label: item.name_cc,                        
                  id: item.id
              }
          }),
          select: function( event, ui ) {
              $(document.getElementById(idField)).val(ui.item.id);
          },
          focus: function(event, ui) {
              $(document.getElementById(textField)).val(ui.item.name_cc);
          }
      });
      if($(document.getElementById(idField)).val()) {
          var account = $.data(document.body, 'account_' + $('#'+idField).val()+'');
          $(document.getElementById(textField)).val(account);
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