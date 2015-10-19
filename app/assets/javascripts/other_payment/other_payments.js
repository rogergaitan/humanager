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
	op.search_employee_by_id_path = $('#search_employee_by_id_path').val();
	op.search_employee_by_code_path = $('#search_employee_by_code_path').val();
	op.search_employee_by_name_path = $('#search_employee_by_name_path').val();
	op.load_em_employees_path = $('#load_em_employees_path').val();
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
		selectableHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;'  autocomplete='off' placeholder='Filter entries...'>",
  	selectionHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;' autocomplete='off' placeholder='Filter entries...'>",
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
    selectableHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;'  autocomplete='off' placeholder='Filter entries...'>",
    selectionHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;' autocomplete='off' placeholder='Filter entries...'>",
    afterInit: function(ms) {
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
      op.searchEmployeeByAttr(values[0], 'id', 'multi', op.types.add);
      this.qs1.cache();
      this.qs2.cache();
    },
    afterDeselect: function(values) { // deselected
      op.searchEmployeeByAttr(values[0], 'id', 'multi', op.types.remove);
      this.qs1.cache();
      this.qs2.cache();
    }
  });

  // Update validation
  $('#other_payment_payroll_type_ids, #other_payment_employee_ids').change(function() {
    op.updateValidation();
  });
	
	op.typeDeduction($('#other_payment_deduction_type'));

  // When change the value called the function typeDeduction
  $('#other_payment_deduction_type').change(function() {
    op.typeDeduction(this);
  });

  // En caso de seleccionar una planilla unica si se quiere cambiar se limpia la anterios 
  // para que no se vayan a guardar 2 ids
  $('#unicPayroll').on({ click: op.clearPayrolls });

  op.searchAll(""); // Call the function to get all employee list

  $("#search_employee_results").on("click", "table tr a", function(e) {

    var employeeId = $(this).parents('td').find('input:hidden').val();
    var selector = $("#employee_items input:hidden[id='in_searching'][value='1']").parents('tr'); // kalfaro no hace nada esta linea

    op.searchEmployeeByAttr(employeeId, 'id', 'table', op.types.add);
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
    return op.searchAll($('#search_name_employee_modal').val());
  });

  op.showHideEmployees(true); // Call the function to show/hide the div about employees

  // Deduction Individual
  $('#other_payment_individual').parents('label').click(function() {
    op.showHideEmployees($('#other_payment_individual').is(':checked'));
  });

  $('#other_payment_individual').next().click(function() {
    op.showHideEmployees($('#other_payment_individual').is(':checked'));
  });

  $('#payroll_select_all').parents('label').click(function() {
    op.payrollSelectAll();
  });

  $('#payroll_select_all').next().click(function() {
    op.payrollSelectAll();
  });

  $('#emplotee_select_all').parents('label').click(function() {
    op.payrollSelectAll();
  });
  
  $('#emplotee_select_all').next().click(function() {
    op.payrollSelectAll();
  });

  // Al precionar click sobre una planilla se establece el id de la planilla
  $('#activas').on("click", "td.payroll-type a", op.setPayroll);

  // Carga el arbol de cuentas de credito
  treeviewhr.cc_tree(debit_account, true);
  $('.expand_tree').click(treeviewhr.expand);

  $('#list').on({
    click: op.setAccount,
    mouseenter: function() {
      $(this).css("text-decoration", "underline");
    },
    mouseleave: function() {
      $(this).css("text-decoration", "none");
  }}, ".node_link");

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

  // Add new row to employee_deduction
  $('form').on('click', '.add_fields', op.addFields);

  // Remove a row to employee_deduction
  $('form').on('click', '.remove_fields', function(event) {
    event.preventDefault();
    var id = $(this).parents('tr').find("input:hidden[id*='_employee_id']").val();
    if(id != "") {
      op.searchEmployeeByAttr( id, 'id', 'table', op.types.remove);
      return; 
    }
    $(element).parents('tr').remove();
  });

  $('#other_payment_custom_calculation').on('change', function() {
    var value = $(this).val();
    $('#employee_items tr').each(function() {
      if( !resources.parseBool( $(this).find("input:hidden[id*='_destroy']").val()) ) {
        $(this).find("input:text[id*='_calculation']").val(value);
      }
    });
  });

  // Search Employee by code
  $('form').on('focusout', '.search_code_employee', function() {
    op.searchEmployeeByAttr($(this).val(), 'code', 'table', op.types.add);
  });

  op.showHideOptions($('#select_method_all')); // Set default

  $('input[name=select_method]').parents('label').click(function() {
    op.showHideOptions($(this).find('input'));
  });

  $('input[name=select_method]').next().click(function() {
    op.showHideOptions($(this).parent().find('input'));
  });

  $('#departments_employees').change(function() {
    op.filterEmployees("department", $(this).val());
  });

  $('#superiors_employees').change(function() {
    op.filterEmployees("superior", $(this).val());
  });

  $('#employee_items tr.items_other_payment_form').each(function() {
    var id = $(this).find("input[id*='_employee_id']").val();
    if(id != "" ) {
      op.searchEmployeeByAttr( id, 'id', 'show', '');
    } else {
      $(this).remove();
    }
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

});

/*********************************************************************************************************************************************************/
/* F U N C T I O N S */
/*********************************************************************************************************************************************************/
op.updateValidation = function(){
  var modelName = $('form:eq(0)').data('modelName');
  var referenceId = $('form:eq(0)').data('referenceId');
  resources.updateValidation(modelName, referenceId);
}

op.searchEmployeeByAttr = function(searchValue, searchType, from, typeFrom) {
  
	var url;
  var customData;

	switch(searchType) {
		case "id":
			url = op.search_employee_by_id_path,
			customData = { search_id: searchValue };
		break;

		case "code":
			url = op.search_employee_by_code_path,
			customData = { search_code: searchValue };
		break;

		case "name":
			url = op.search_employee_by_name_path,
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
          op.fromTable(data, typeFrom);
        }
        if( from == "multi" ) {
          op.fromMulti(data, typeFrom);
        }
        if( from == "show" ) {
          op.showEmployees(data);
        }
      }
		},
		error: function(response, textStatus, errorThrown) {
			resources.PNotify('Empleado', 'Error al buscar', 'danger');
		}
	});
}

// TABLA - MULTISELECT
op.fromTable = function(employee, type) {

  var data = op.findParentByAttr(employee.id, 'id');

  switch(type) {

    case op.types.add:
      // No existe
      if(typeof data.parent == 'undefined') {
        var selector = $('#employee_items tr.items_other_payment_form:eq(0)');
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
        $('#employee_items tr.items_other_payment_form:eq(0)').remove();
      }
      // resources.PNotify('Empleado', 'Agregado con exito', 'success');
      op.addEmployeeMulti(employee.id);
    break;
    
    case op.types.remove: // Ocutar
      $(data.parent).find("input[type=hidden][id*='_destroy']").val(1);
      $(data.parent).hide();
      resources.PNotify('Empleado', 'Eliminado con exito', 'success');
      op.removeEmployeeMulti(employee.id);
    break;
  }
}

// MULTISELECT - TABLA
op.fromMulti = function(employee, type) {

  var data = op.findParentByAttr(employee.id, 'id');

  switch(type) {

    case op.types.add:
      // No existe
      if(typeof data.parent == 'undefined') {
        $('.add_fields ').trigger('click'); // Add new row
        var selector = $('#employee_items tr.items_other_payment_form:eq(0)');
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
      resources.PNotify('Empleado', 'Agregado con exito', 'success');
    break;
    
    case op.types.remove: // Ocutar
      $(data.parent).find("input[type=hidden][id*='_destroy']").val(1);
      $(data.parent).hide();
      resources.PNotify('Empleado', 'Eliminado con exito', 'success');
    break;
  }
}

// SHOW IN TABLA LOAD
op.showEmployees = function(employee) {
  var data = op.findParentByAttr(employee.id, 'id');
  $(data.parent).find("input:hidden[id*='_destroy']").val("false");
  $(data.parent).find("input:hidden[id*='_employee_id']").val(employee.id);
  $(data.parent).find("input[id='search_code_employee']").val(employee.number_employee);
  $(data.parent).find("input[id='search_name_employee']").val(employee.name + " " + employee.surname);
  $(data.parent).find("input[id='search_code_employee']").attr('disabled', 'disabled');
  $(data.parent).find("input[id='search_name_employee']").attr('disabled', 'disabled');
  $(data.parent).find("a[id='openEmployeeModal']").attr('disabled', 'disabled');
}

// Solo para la tabla de abajo visual
op.findParentByAttr = function(value, type) {
	var parent;
  var destroy;

	$('#employee_items tr').each(function() {
    if(type === "id") {
      if( parseInt($(this).find("input:hidden[id*='employee_id']").val()) === parseInt(value) ) {
        parent = $(this);
        destroy = resources.parseBool( $(this).find("input:hidden[id*='_destroy']").val());
        return false;
      }
    }
  });

  return {
    parent: parent,
    destroy: destroy
  };
}

// TABLA - MULTISELECT
op.addEmployeeMulti = function(id_employee) {
	$('#employee_items_one .ms-selectable').find("li[id^='"+id_employee+"']").trigger('click');
}

op.removeEmployeeMulti = function(id_employee) {
	$('#employee_items_one .ms-selection').find("li[id^='"+id_employee+"']").trigger('click');
}

op.typeDeduction = function(selected) {
  switch($(selected).val()) {
    case 'unique':
      $('#amount_exhaust_controls').hide();
      $('#payrolls-to-save').empty();
      $('#unicPayroll').show();
      $('#other_payment_payrolls').show();
      op.getPayrolls();
    break;
    case 'amount_to_exhaust':
      $('#amount_exhaust_controls').show();
      $('#payrolls-to-save').empty();
      $('#unicPayroll').hide();
      $('#other_payment_payrolls').hide();
    break;
    case 'constant':
      $('#amount_exhaust_controls').hide();
      $('#payrolls-to-save').empty();
      $('#unicPayroll').hide();
      $('#other_payment_payrolls').hide();
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

op.searchAll = function(name) {
  return $.ajax({
    url: op.search_employee_payroll_logs_path,
    dataType: "script",
    data: {
      search_employee_name: name
    }
  });
}

// Show/Hide The differents view based in the checkbox "individual"
op.showHideEmployees = function(isIndividual) {
  if( $('#other_payment_individual').is(':checked') ) {
    $('#employee_items_one').hide()
    $('#employee_items_two').show();
    $('#custom_calculation').hide();
  } else {
    $('#employee_items_one').show();
    $('#employee_items_two').hide();
    $('#custom_calculation').show();
  }
  if(isIndividual) {
    $('#other_payment_custom_calculation').val( $('#employee_items tr:eq(1)').find("input:text[id*='_calculation']").val() );
  }
}

op.payrollSelectAll = function() {
  if( $('#payroll_select_all').is(':checked') ) {
    $('#other_payment_payroll_type_ids').multiSelect('select_all');
  } else {
    $('#other_payment_payroll_type_ids').multiSelect('deselect_all');  
  }
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
  var name = "";
  $.getJSON(url, function(accounts) {
    $(textField).autocomplete({
      source: $.map(accounts, function(item) {

        if(item.naccount) {
          name = item.naccount;
        }
        if(item.name_cc) {
          name = item.name_cc;
        }
        if(item.name) {
          name = item.surname + ' ' + item.name;
        }
        if(item.description) {
          name = item.description;
        }

        $.data(document.body, 'account_' + item.id + "", name);
        return {
          label: name,
          id: item.id
        }
      }),
      select: function(event, ui) {
        if( idField == "custom_employee" ) {
          op.searchEmployeeByAttr(ui.item.label, "name", $(event.target).parents('tr'), true);
        } else if( idField == "other_payment_costs_center_id") {
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
        if( idField != "custom_employee" && idField != "other_payment_costs_center_id" ) {
          $(textField).val(ui.item.label);
        }
      }
    });
    if( $(idField).val() ) {
      $(textField).val( $.data(document.body, 'account_' + $(idField).val() + '') );
    }
  });
}

op.addFields = function(e) {
  op.updateValidation();
  e.preventDefault();
  var time = new Date().getTime();
  var regexp = new RegExp($(this).data('id'), 'g');
  $('.header_items').after($(this).data('fields').replace(regexp, time));

  // populateAutocompleteEmployees( $('#employee_items tr:eq(1)').find("input[id='search_name_employee']") );
  op.fetchPopulateAutocomplete(op.load_em_employees_path, $('#employee_items tr:eq(1)').find("input[id='search_name_employee']"), 'custom_employee');
  // $('#employee_items tr:eq(1)').find("input[id='search_name_employee']").removeClass("ui-autocomplete-input");
}

op.showHideOptions = function(selected) {
  switch($(selected).val()) {
    case 'all':
      $('#ms-other_payment_employee_ids').find('input:eq(0)').show();
      $('#list-departments').hide();
      $('#list-superior').hide(); 
      $('.ms-selection').css('margin-top', '0px');
      op.filterEmployees("all");
      break;
    case 'boss':
      $('.ms-selection').css('margin-top', '-3.7%');
      $('#ms-other_payment_employee_ids').find('input:eq(0)').hide();
      $('#list-departments').hide();
      op.filterEmployees("superior", $('#superiors_employees').val());
      $('#list-superior').show(); 
      break;
    case 'department':
      $('.ms-selection').css('margin-top', '-3.7%');
      $('#ms-other_payment_employee_ids').find('input:eq(0)').hide();
      $('#list-superior').hide(); 
      op.filterEmployees("department", $('#departments_employees').val());
      $('#list-departments').show();
      break;
  }
}

op.filterEmployees = function(type, id) {
  
  id = id ? id : 0;

  $('#ms-other_payment_employee_ids .ms-selectable').find('li').each(function() {
    
    if(type === "all") {
      if(!$(this).hasClass('ms-selected')){
        $(this).show();
      }
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

// Get data to specific url and return the result (type=script)
op.searchDataScript = function(name, url) {
  return $.ajax({
    url: url,
    dataType: "script",
    data: { search_cost_center_name: name }
  });
}
