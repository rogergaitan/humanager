$(jQuery(document).ready(function($) {
	
	//generates the treeview with the different accounts
	$('#debit-button').click(function(){
		treeviewhr.cc_tree(debit_account, true, 'load_debit_accounts', 'work_benefit_debit_account');
	});
	$('#credit-button').click(function(){
		treeviewhr.cc_tree(credit_account, true, 'load_credit_account_name', 'work_benefit_credit_account');
	});
	
	//populates the autocompletes for the accounts
  fetchPopulateAutocomplete('fetch_debit_accounts', "load_debit_accounts", "work_benefit_debit_account");
  fetchPopulateAutocomplete('fetch_credit_accounts', "load_credit_account_name", "work_benefit_credit_account");
	//populates the filter for employees
	populateEmployeesFilter('fetch_employees', 'load_filter_employees_text', 'load_filter_employees_id');

	//allows expand the treeview
	$('#list').on("click", "span.expand_tree", treeviewhr.expand);
	
	//delete the treeview after the user clicks on close
	$('button.delete-accounts').click(function() {
		$('#list').empty();
	});	
	
	//allows add the selected account to the textfield	
  $('#list').on({
		click: set_account,
		mouseenter: function() {
			$(this).css("text-decoration", "underline");
		},
		mouseleave: function() {
			$(this).css("text-decoration", "none");
		}}, ".node_link");
		
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
}));

var empSelected = [];

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

//function to filter results by department name 
function filterDepartment (dropdown) {
	var dep = dropdown ? dropdown : 0;
	$('div.employees-list.left-list input[type=checkbox]').each(function() {
		var empDep = $(this).data('dep') ? $(this).data('dep') : 0;
		if (!(dep == 0)) {
			if (!(dep == empDep)) {
				empSelected.push(Array($(this).data('id'), empDep, $(this).next().text()));
				$(this).closest('div.checkbox-group').hide();
				$(this).prop('disabled', true);
			} else {
				$(this).prop('disabled', false);
				$(this).closest('div.checkbox-group').show();
			};
		}	 else {
				$(this).closest('div.checkbox-group').show();
			};
	});
}


//function to filter results by superior name 
function filterSuperior (dropdown) {
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
		}	 else {
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
											"<input type='checkbox' data-sup='"+ $(this).data('sup') +"' data-dep='"+ $(this).data('dep') +"' checked='checked' class='align-checkbox right' id='"+ $(this).data('id') +"' name='work_benefit[employee_ids][]' value='"+ $(this).val() +"' />" +
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

function fetchPopulateAutocomplete(url, textField, idField) {
  $.getJSON(url, function(accounts) {
      $(document.getElementById(textField)).autocomplete({
          source: $.map(accounts, function(item){
              $.data(document.body, 'account_' + item.id+"", item.naccount);
              return{
                  label: item.naccount,                        
                  id: item.id
              }
          }),
          select: function( event, ui ) {
              $(document.getElementById(idField)).val(ui.item.id);
          },
          focus: function(event, ui){
              $(document.getElementById(textField)).val(ui.item.label);
          }

      })
      if($(document.getElementById(idField)).val()){
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
      })     
  });	
}

function set_account(e) {
    e.preventDefault();
    var accountId = $(this).closest('li').data('id');
    var accountName = $(this).text();
    $(document.getElementById($('#idFieldPopup').val())).val(accountId);
    $(document.getElementById($('#textFieldPopup').val())).val(accountName);
	$('#list').empty();
}