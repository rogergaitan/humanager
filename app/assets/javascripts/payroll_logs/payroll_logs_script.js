$(jQuery(document).ready(function($) {

	$('#payroll_logs_employee_ids').multiSelect({
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

	$('#payroll_log_payroll_date').datepicker();

	$('input[name=select_method]').parents('label').click(function() {
		$('input[name=select_method]').prop('checked', false);
		$(this).find('input').prop('checked', true);
		showHideOptions($(this).find('input'));
  	});

  	$('input[name=select_method]').next().click(function() {
		$('input[name=select_method]').prop('checked', false);
		$(this).parent().find('input').prop('checked', true);
		showHideOptions($(this).parent().find('input'));
  	});

  	// Select All
  	$('#emplotee_select_all').parents('label').click(function() {
  		emploteeSelectAll();
  	});

  	$('#emplotee_select_all').next().click(function() {
  		emploteeSelectAll();
  	});

  	showHideOptions($('#select_method_all'));

  	$('#departments_employees').change(function() {
		filterEmployees("department", $(this).val());
	});

	$('#superiors_employees').change(function() {
		filterEmployees("superior", $(this).val());
	});
	
	$('#products_items').on('click', '.remove_fields', removeFields);
	
	$('.items_purchase_orders_form .cc-filter-id:eq(0)').each(function() {
		populateTasks($('#load_cc_tasks_path').val(), $(this).attr('id'));
	});

	$('.items_purchase_orders_form .cc-filter-id:eq(2)').each(function() {
		populateCentroCostos($('#load_cc_centro_de_costos_path').val(), $(this).attr('id'), $(this).attr('id'));
	});

	$('#employee_code').each( function() {
		populateEmployees($('#load_em_employees_path').val(), $(this).attr('id'));
	});

	$('form').submit(function(e) {
		var timeWorked = $.trim($('#products_items tr:eq(1) input.time-worked').val()).length
		var rowIsDisabled = $('#products_items tr:eq(1) td:first select').is(':disabled');
		if((timeWorked != 0) && rowIsDisabled == false) { 
			resources.showMessage('info','Por favor guarde esta línea antes de guardar');
			e.preventDefault();
		} else {
			$('#products_items input, select').attr('disabled', false);
		}
	});

	// Add logs to table
	$('form').on('click', '.add_fields', addFields);
	
	if( $('.controls_item:eq(1) input').val() != "" ) {
		$('#products_items input').attr('disabled', true);
		$('#products_items select').attr('disabled', true);
	}

	$('#last_fingering').click(function(){
		getLastFingering();
	});

}));

function showHideOptions(selected) {
  switch($(selected).val()) {

    case 'all':
	    	// Hiden the boxes and checkbox filters
	    	$('#ms-payroll_logs_employee_ids').hide();
	    	$('#list-departments').hide();
	    	$('#list-superior').hide();
	    	$('#emplotee_select_all').parents('label').hide();
	    	// Filters set by default the "boss" and "department"
	    	$('#superiors_employees option:eq(0)').attr('selected','selected');
				$('#departments_employees option:eq(0)').attr('selected','selected');
				payroll_logs.cleanEmployeeAlone();
      break;

    case 'boss':
	    	$('#ms-payroll_logs_employee_ids').show();
	    	$('#emplotee_select_all').parents('label').show();
      	$('.ms-selection').css('margin-top', '-5.5%');
      	$('#ms-payroll_logs_employee_ids').find('input:eq(0)').hide();
      	$('#list-departments').hide();
      	$('#list-superior').show();
      	filterEmployees("superior", $('#superiors_employees').val());
    		payroll_logs.cleanEmployeeAlone();
    		$('#superiors_employees').removeAttr('disabled');
      break;

    case 'department':
	    	$('#ms-payroll_logs_employee_ids').show();
	    	$('#emplotee_select_all').parents('label').show();
	    	$('.ms-selection').css('margin-top', '-5.5%');
	    	$('#ms-payroll_logs_employee_ids').find('input:eq(0)').hide();
				$('#list-departments').show();
	      $('#list-superior').hide();
	      filterEmployees("department", $('#departments_employees').val());
	      $('#departments_employees').removeAttr('disabled');
	    	payroll_logs.cleanEmployeeAlone();
      break;
  }
}

function filterEmployees(type, id) {
  
	id = id ? id : 0;

  	$('#ms-payroll_logs_employee_ids .ms-selectable').find('li').each(function() {
    
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

function emploteeSelectAll() {
	if( $('#emplotee_select_all').is(':checked') ) {
		$('#payroll_logs_employee_ids').multiSelect('select_all');
	} else {
	    $('#payroll_logs_employee_ids').multiSelect('deselect_all');
	}
}

function removeFields(e) {

	e.preventDefault();
	// $(this).prev('input[type=hidden]').val(1);
	$(this).parents('div.row').find('input[id*=_destroy]').val(1);
	var deletedRow = $(this).closest('.success');

	if( deletedRow.find('#search_code_employee').is(':enabled') ) {
		deletedRow.remove();
	} else {
		deletedRow.removeClass('success').addClass('deleted').hide();
		var name = $(this).prev().attr('name');
		var num = name.match(/\d/g);
		num = num.join('');
		payroll_logs.removeAllEmployeeTaskData(num);
		payroll_logs.removeAllTotalRows(num);
		payroll_logs.deleteAllEmployeesView(num);
	}
}

// Function to fill autocompletes
function populateTasks(url, idField) {

  var textField = $(document.getElementById(idField)).next().find('input');

  $.getJSON(url, function(accounts) {
      $(textField).autocomplete({
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
              $(textField).val(ui.item.label);
          }
      });
      if($(document.getElementById(idField)).val()){
        var account = $.data(document.body, 'cc_' + $('#'+idField).val()+'');
        $(textField).val(account);
      }
      $(textField).removeClass('ui-autocomplete-input');
  }); 
}

// Function to fill autocompletes kalfaro
function populateCentroCostos(url, textField, idField) {
  $.getJSON(url, {
        company_id: $('#the_company_id').val()
    }, function(accounts) {
      $("#"+textField).autocomplete({
          source: $.map(accounts, function(item){
              $.data(document.body, 'cc_' + item.id+"", item.name_cc);
              return{
                  label: item.name_cc,
                  id: item.id
              }
          }),
          select: function( event, ui ){
              $("#"+idField).val(ui.item.id);
              payroll_logs.setCostCode(ui.item.id);
          },
          focus: function(event, ui){
              $("#"+textField).val(ui.item.label);
          }
      });
      if($("#"+idField).val()){
          var account = $.data(document.body, 'cc_' + $('#'+idField).val()+'');
          $("#"+textField).next().val(account);
      }
      $("#"+textField).removeClass('ui-autocomplete-input');
  }); 
}

// Function to fill autocompletes (Employee)
function populateEmployees(url, idField) {
  $.getJSON(url, function(accounts) {
      $(document.getElementById(idField)).next().autocomplete({
          source: $.map(accounts, function(item){
              $.data(document.body, 'e_' + item.id + "", item.nombre_cc);
              return{
                  label: item.surname + ' ' + item.name,
                  id: item.id
              }
          }),
          select: function( event, ui ) {
              payroll_logs.setEmployeeId(ui.item.id);
          },
          focus: function(event, ui){
              $(document.getElementById(idField)).next().val(ui.item.label);
          }
      });
      if($(document.getElementById(idField)).val()){
        var account = $.data(document.body, 'e_' + $('#'+idField).val()+'');
        $(document.getElementById(idField)).next().val(account);
      }
      $(document.getElementById(idField)).next().removeClass('ui-autocomplete-input');
  });
}

function addFields(e) {
	// Valida si hay campos en blanco
	var timeWorked = $.trim($('#products_items tr:eq(1) input.time-worked').val()).length
	var numberRows = $('#products_items tr').length;
	var is_select_methol_all = false;

	if((timeWorked == 0 ) && numberRows > 1) {
		resources.showMessage('info','Por favor complete los espacios en blanco');
		e.preventDefault();
	} else {
		var numberEmployees = $('div.employees-list.list-right input').length;
		var employeesChecked = $('div.employees-list.list-right input[type=checkbox]').is(':checked');
		var rowIsDisabled = $('#products_items tr:eq(1) td:first select').is(':disabled');
		if (numberRows == 1) { rowIsDisabled = true; };

		// Valida si agrego Labor
		var task = $('#products_items tr:eq(1)').find("input[id*='task_id']").val();
		if( task == "" ) {
			resources.showMessage('info','Por favor agrege una Tarea');
			return false;
		}
		
		// Valida si agrego CC
		var cc = $('#products_items tr:eq(1)').find("input[id*='_costs_center_id']").val();
		if( cc == "" ) {
			resources.showMessage('info','Por favor agrege un Centro de Costo');
			return false;
		}

		// Valida si "Todos" esta seleccionado
		if( $('#select_method_all').is(':checked') ) {
			numberEmployees = 1;
			employeesChecked = true;
			is_select_methol_all = true;
			// Validar Empleado
			if( $('#products_items tr:eq(1) td:eq('+payroll_logs.employee_td_eq+') input:eq(1)').val() === "" ) {
				resources.showMessage('info','Debe añadir al menos un empleado');
				return false;	
			}
		}

		// Valida si se ha seleccionado al menos un empleado antes de agregar una línea nueva
		if ((numberEmployees == 0 || employeesChecked == false) && (rowIsDisabled == false) && (numberRows > 1)) {
			resources.showMessage('info','Debe añadir al menos un empleado');
			return false;
		} else {
			// Validate Duplicate Records
			if( !rowIsDisabled ) {
				var name = $('#products_items tr:eq(1) td:eq('+payroll_logs.task_td_eq+') input:hidden').attr('name');
				var num = name.match(/\d/g);
				num = num.join('');

				// Set Date
				$('#payroll_log_payroll_histories_attributes_' + num + '_payroll_date').val($('#payroll_log_payroll_date').val());
				payroll_logs.setTotal(num);
				result = payroll_logs.validateEmployeeTask(num,is_select_methol_all);
				if( result.status ) {
					var message = 'Existe al menos un empleado con datos duplicados ['+result.username+']';
					resources.showMessage('info',message);
					return false;
				}
			}
		}

		$('#products_items tr input, select').attr('disabled', true);
		var time = new Date().getTime();
		var regexp = new RegExp($(this).data('id'), 'g');
		$('.header_items').after($(this).data('fields').replace(regexp, time));
		populateTasks(
			$('#load_cc_tasks_path').val(), 
			$('#products_items .items_purchase_orders_form').first().find('input.cc-filter-id:eq(0)').attr('id')
		);
		populateCentroCostos(
			$('#load_cc_centro_de_costos_path').val(), 
			$('#products_items .items_purchase_orders_form').first().find('input.cc-filter:eq(1)').attr('id'), 
			$('#products_items .items_purchase_orders_form').first().find('input.cc-filter-id:eq(2)').attr('id')
		);
		populateEmployees(
			$('#load_em_employees_path').val(), 
			$('#employee_code').attr('id')
		);
		$('#products_items').find('label').remove();
		saveEmployees(rowIsDisabled, is_select_methol_all);
		payroll_logs.reloadSelectorsEvents();
		payroll_logs.cleanEmployeeAlone();
		$('#search_code_employee').focus();
		e.preventDefault();
	}
}

function saveEmployees(isDisabled, is_select_methol_all) {
	if( !isDisabled ) {
		var name = $('#products_items tr:eq(2) td:eq(' + payroll_logs.task_td_eq + ') input:hidden').attr('name');
		var num = name.match(/\d/g);
		num = num.join('');

		if( is_select_methol_all ) {
			var idEmployee = $('#products_items tr:eq(2) td:eq('+payroll_logs.employee_td_eq+') input:hidden').val();
			$('#products_items tr:eq(2) .save-employees').append('<input type="hidden" name="payroll_log[payroll_histories_attributes]['+ num +'][employee_ids][]" value="'+ idEmployee +'" >');
			payroll_logs.addDetailsToEmployee( num, idEmployee, is_select_methol_all );
		} else {
			$('div.employees-list.list-right input[type=checkbox]:checked').each(function() {
				$('#products_items tr:eq(2) .save-employees').append('<input type="hidden" name="payroll_log[payroll_histories_attributes]['+ num +'][employee_ids][]" value="'+ $(this).val() +'" >');
				payroll_logs.addDetailsToEmployee( num, $(this).val(), is_select_methol_all );
			});
		}
	};
}

function getLastFingering() {
	var str, id;
	$("[id^='employee_table_'] tr[id^='tr_']").each(function() {
		if(typeof str == 'undefined') {
			str = this.id.split(['_'])[2];
			id = this.id;
		} else {
			if( parseInt( this.id.split(['_'])[2] ) > parseInt(str) ) {
				str = this.id.split(['_'])[2];
				id = this.id;
			}
		}
	});
	$('#'+id).addClass("tr_info");
}
