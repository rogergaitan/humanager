$(jQuery(document).ready(function($) {

	hideEmployess();

	$('#select_method_all').click(function() {
		$('#superiors_employees option:eq(0)').attr('selected','selected');
		$('#departments_employees option:eq(0)').attr('selected','selected');
		hideEmployess();
	});

	$('#select_method_boss').click(function() {
		hide($('#superiors_employees').val());
		$('#superiors_employees').removeAttr('disabled');
	});

	$('#select_method_department').click(function() {
		hide($('#departments_employees').val());
		$('#departments_employees').removeAttr('disabled');
	});

	$('#superiors_employees').click(function() {
		hide($(this).val());
	});
	$('#departments_employees').click(function() {
		hide($(this).val());
	});

	$('#dp3').datepicker();
	
	$('.showTooltip').tooltip();
	$('#remove-controls').tooltip();
	
	$('#add-more').click(addMoreEmployees);

	$('#products_items').on('click', '.remove_fields', removeFields);
	
	//populates the filter for employees
	populateEmployeesFilter('/payroll_logs/fetch_employees', 'load_filter_employees_text', 'load_filter_employees_id');
	
	$('.items_purchase_orders_form .cc-filter-id:eq(0)').each(function() {
		populateTasks('/tasks/load_cc', $(this).attr('id'));
	});

	$('.items_purchase_orders_form .cc-filter-id:eq(1)').each(function() {
		populateCentroCostos('/centro_de_costos/load_cc', $(this).next().attr('id'), $(this).attr('id'));
	});
	
	//delete the treeview after the user clicks on close
	$('button.delete-accounts').click(function() {
		$('#list').empty();
	});
	
	//executes different options to select the employees
	$('input[name=select_method]').change(function() {
		selectEmployeesLeft($(this));
	});
	
	$('form').submit(function(e) {
		var timeWorked = $.trim($('#products_items tr:eq(1) input.time-worked').val()).length
		var rowIsDisabled = $('#products_items tr:eq(1) td:first select').is(':disabled');
		if((timeWorked != 0) && rowIsDisabled == false) { 
			$('div#message').html('<div class="alert alert-error">Por favor guarde esta línea antes de guardar</div>');
			$('#products_items tr:eq(1)').effect('highlight', {color: '#F2DEDE', duration: 5000});
			$('div.alert.alert-error').delay(4000).fadeOut();
			e.preventDefault();
		} else {
			$('#products_items input, select').attr('disabled', false);
		}
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
	
	//Add logs to table
	$('form').on('click', '.add_fields', addFields);
	$('#products_items').find('label').remove();

	checkNumberEmployees();
	
	if( $('.controls_item:eq(1) input').val() != "" ) {
		$('#products_items input').attr('disabled', true);
		$('#products_items select').attr('disabled', true);
	}
}));


function hideEmployess() {
	$('.employees-list:eq(0) div:eq(0)').hide();
	$('.employees-list:eq(0)').css('min-height', '218px');
	$('.employees-list:eq(0)').css('min-width', '218px');
	$('.employees-list:eq(0)').css('float', 'left');
	$('.employees-list:eq(0)').removeClass('employees-list');
}

function hide(element) {
	$('.left-list').removeAttr('style');
	$('.left-list').addClass('employees-list');

	if( element === "" ) {
		$('.employees-list:eq(0) div:eq(0)').hide();
	} else {
		$('.employees-list:eq(0) div:eq(0)').show();
	}
}

function removeFields(e) {

	$(this).prev('input[type=hidden]').val(1);
	var deletedRow = $(this).closest('.success');
	deletedRow.removeClass('success').addClass('deleted').hide();

	var name = $(this).prev().attr('name');
	var num = name.match(/\d/g);
	num = num.join('');
	payroll_logs.removeAllEmployeeTaskData(num);
	payroll_logs.removeAllTotalRows(num);
	payroll_logs.deleteAllEmployeesView(num);
	e.preventDefault();
}

function addFields(e) {
	//valida si hay campos en blanco
	var timeWorked = $.trim($('#products_items tr:eq(1) input.time-worked').val()).length
	var numberRows = $('#products_items tr').length;
	if((timeWorked == 0 ) && numberRows > 1) { 
		$('div#message').html('<div class="alert alert-error">Por favor complete los espacios en blanco</div>');
		$('#products_items tr:eq(1)').effect('highlight', {color: '#F2DEDE', duration: 5000});
		$('div.alert.alert-error').delay(4000).fadeOut();
		e.preventDefault();
	} else {
		var numberEmployees = $('div.employees-list.list-right input').length;
		var employeesChecked = $('div.employees-list.list-right input[type=checkbox]').is(':checked');
		var rowIsDisabled = $('#products_items tr:eq(1) td:first select').is(':disabled');
		if (numberRows == 1) { rowIsDisabled = true; };
		//valida si se ha seleccionado al menos un empleado antes de agregar una línea nueva
		if ((numberEmployees == 0 || employeesChecked == false) && (rowIsDisabled == false) && (numberRows > 1)) {
			$('div#message').html('<div class="alert alert-error">Debe añadir al menos un empleado</div>');
			$('div.employees-list.list-right').effect('highlight', {color: '#F2DEDE', duration: 5000});
			$('div.alert.alert-error').delay(4000).fadeOut();
			return false;
		} else {
			// Validate Duplicate Records
			if( !rowIsDisabled ) {
				var name = $('#products_items tr:eq(1) td:first input:hidden').attr('name');
				var num = name.match(/\d/g);
				num = num.join('');
				payroll_logs.setTotal(num);
				result = payroll_logs.validateEmployeeTask(num);
				if( result.status ) {
					$('div#message').html('<div class="alert alert-error">Existe al menos un empleado con datos duplicados ['+result.username+']</div>');
					$('div.employees-list.list-right').effect('highlight', {color: '#F2DEDE', duration: 5000});
					$('div.alert.alert-error').delay(4000).fadeOut();
					return false;
				}
			}
		}
		$('#products_items tr input, select').attr('disabled', true);
		var time = new Date().getTime();
		var regexp = new RegExp($(this).data('id'), 'g');
		$('.header_items').after($(this).data('fields').replace(regexp, time));
		populateTasks('/tasks/load_cc', $('#products_items .items_purchase_orders_form').first().find('input.cc-filter-id:eq(0)').attr('id'));
		populateCentroCostos('/centro_de_costos/load_cc', $('#products_items .items_purchase_orders_form').first().find('input.cc-filter:eq(1)').attr('id'), $('#products_items .items_purchase_orders_form').first().find('input.cc-filter-id:eq(1)').attr('id'));
		$('#products_items').find('label').remove();
		saveEmployees(rowIsDisabled);
		payroll_logs.reloadSelectorsEvents();
		e.preventDefault();
	}
}

function saveEmployees(isDisabled) {
	if (!isDisabled) {
		var name = $('#products_items tr:eq(2) td:first input:hidden').attr('name');
		var num = name.match(/\d/g);
		num = num.join('');
		$('div.employees-list.list-right input[type=checkbox]:checked').each(function() {
			$('#products_items tr:eq(2) .save-employees').append('<input type="hidden" name="payroll_log[payroll_histories_attributes]['+ num +'][employee_ids][]" value="'+ $(this).val() +'" >');
			payroll_logs.addDetailsToEmployee(num,$(this).val());
		});
	};
}

//FUNCTIONS FOR THE FILTER AND SELECTION OF EMPLOYEES


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
									"<input type='checkbox' data-sup='"+ $(this).data('sup') +"' data-dep='"+ $(this).data('dep') +"' checked='checked' class='align-checkbox right' id='"+ $(this).data('id') +"' name='payroll_log_employees' value='"+ $(this).val() +"' />" +
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
														"<input type='checkbox' data-sup='"+ ui.item.sup +"' data-dep='"+ ui.item.dep +"' checked='checked' class='align-checkbox right' id='"+ ui.item.data_id +"' name='payroll_log_employees' value='"+ ui.item.id +"' />" +
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
//END FILTERS

//function to fill autocompletes
function populateCentroCostos(url, textField, idField) {
  $.getJSON(url, function(accounts) {
      $(document.getElementById(idField)).next().autocomplete({
          source: $.map(accounts, function(item){
              $.data(document.body, 'cc_' + item.id+"", item.nombre_cc);
              return{
                  label: item.nombre_cc,
                  id: item.id
              }
          }),
          select: function( event, ui ){
              $(document.getElementById(idField)).val(ui.item.id);
              payroll_logs.setCostCode(ui.item.id);
          },
          focus: function(event, ui){
              $(document.getElementById(idField)).next().val(ui.item.label);
          }
      });
      if($(document.getElementById(idField)).val()){
          var account = $.data(document.body, 'cc_' + $('#'+idField).val()+'');
          $(document.getElementById(idField)).next().val(account);
      }        
  }); 
}

//function to fill autocompletes
function populateTasks(url, idField) {
  $.getJSON(url, function(accounts) {
      $(document.getElementById(idField)).next().autocomplete({
          source: $.map(accounts, function(item){
              $.data(document.body, 'cc_' + item.id+"", item.ntask);
              return{
                  label: item.ntask,
                  id: item.id
              }
          }),
          select: function( event, ui ){
              $(document.getElementById(idField)).val(ui.item.id);
              payroll_logs.setTaskCode(ui.item.id);
          },
          focus: function(event, ui){
              $(document.getElementById(idField)).next().val(ui.item.label);
          }
      });
      if($(document.getElementById(idField)).val()){
          var account = $.data(document.body, 'cc_' + $('#'+idField).val()+'');
          $(document.getElementById(idField)).next().val(account);
      }        
  }); 
}

//function to show the controls for adding more employees
function addMoreEmployees (e) {
	e.preventDefault();
	$('#add-more').hide();
	$('#filter-controls').slideDown();
	$('#employee-box').slideDown();
	$('#add-more i').removeClass('icon-plus').addClass('icon-minus');
	$('#employee-filter').animate({marginLeft: "160px"});
	$('#employee-header').text('Empleados');
}

//function to remove the controls for adding more employees
function removeControls (e) {
	e.preventDefault();
	$('#filter-controls').slideUp();
	$('#employee-box').slideUp();
	$('#add-more i').addClass('icon-plus').removeClass('icon-minus');
	$('#add-more').show();
	$('#employee-filter').animate({marginLeft: "0px"});
	$('#employee-header').text('Empleado');
	selectEmployeesRight();
	moveToLeft(e);
	$('#load_filter_employees_text').val("");
}

function checkNumberEmployees() {
	$('#add-more').trigger('click');
}