$(jQuery(document).ready(function($) {
  // Clear the session storage
  pl.clearSessionStorage();
  /**************************************************************************************/
  /* Load Selectors */
  /**************************************************************************************/
  pl.employee_options       = { add: 'add', remove: 'remove' };
  pl.search_types           = { employees: 'employees', cc: 'cc', tasks: 'tasks', history: 'history', custom: 'custom' };
  pl.theadList              = ["Fecha", "Código", "Labor", "Costo", "Unidad", "Cant. Trabajada", 
                              "Código", "Centro de Costos", "Rendimiento", "Unidad", 
                              "Tipo de Pago", "Total", "Acción"];
  pl.current_employee       = '#products_items tbody tr:eq(0) td#td_employees';
  pl.current_cc             = '#products_items tbody tr:eq(0) td#td_cc';
  pl.current_task           = '#products_items tbody tr:eq(0) td#td_task';
  pl.current_cant_working   = '#products_items tbody tr:eq(0) td#td_time_worked';
  pl.current_performance    = '#products_items tbody tr:eq(0) td#td_performance';
  pl.current_payments_type  = '#products_items tbody tr:eq(0) td#td_payment_type';
  pl.current_save_employees = '#products_items tbody tr:eq(0) td#td_save_employees';
  pl.tabs_function          = false;
  pl.key_code_tab           = 9;
  pl.per_page               = 5;
  pl.messages = {
    employee_not_found: 'Por favor agrege un Empleado',
    employees_not_found: 'Por favor agrege al menos un Empleado',
    cc_not_found: 'Por favor agrege un Centro de Costo',
    task_not_found: 'Por favor agrege una Labor',
    cant_working_not_found: 'Por favor agrege Cant. Trabajada',
    cant_working_greater_zero: 'La Cant. Trabajada debe ser mayor a Cero',
    require_performance: 'Rendimiento es requerido',
    performance_range: 'Rendimiento debe ser mayor a 0 y menor a 999.99',
    performance_wrong_format: 'Rendimiento formato incorrecto',
    date_not_found: 'Fecha no seleccionada',
    employees_duplicated: 'Empleados con datos duplicados: ',
    last_line: 'Por favor elimine o guarde su última línea',
    incomplete_data: 'Datos incompletos.',
    perf_not_found: 'La labor indicada para el rendimiento no ha sido registrada, no se puede agregar el dato.',
    success_update: 'Actualización con Éxito.',
    changes_applied: 'Cambios aplicados a: ',
    bad_currency: 'No se puede seleccionar una labor con moneda distinta a la de la planilla',
    bad_cost: 'No se puede seleccionar una labor sin costo',
    employee_bad_currency: 'Moneda de pago a empleado es distinta a la de la planilla',
    bat_payment_type: 'Revise la configuración del tipo de pago e intente de nuevo'
  };

    /**************************************************************************************/
    /* Multi-Select */
    /**************************************************************************************/
    // Multi-Select: Employees list
    $('#payroll_logs_employee_ids').multiSelect({
      selectableHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;'  autocomplete='off' placeholder='Empleado...'>",
      selectionHeader: "<input type='text' class='form-control' style='margin-bottom: 10px;' autocomplete='off' placeholder='Empleado...'>",
      afterInit: function(ms) {
        var that = this,
        $selectableSearch = that.$selectableUl.prev(),
        $selectionSearch = that.$selectionUl.prev(),
        selectableSearchString = '#'+that.$container.attr('id')+' .ms-elem-selectable:not(.ms-selected)',
        selectionSearchString = '#'+that.$container.attr('id')+' .ms-elem-selection.ms-selected';

        that.qs1 = $selectableSearch.quicksearch(selectableSearchString)
        .on('keydown', function(e) {
          if(e.which === 40) {
            that.$selectableUl.focus();
            return false;
         }
        });

        that.qs2 = $selectionSearch.quicksearch(selectionSearchString)
        .on('keydown', function(e) {
          if(e.which == 40) {
            that.$selectionUl.focus();
            return false;
          }
        });
      },
      afterSelect: function(values) {
        // values => array[] with all IDs
        pl.multiSelectGetEmployees(values);
        // this.qs1.cache();
        this.qs2.cache();
      },
      afterDeselect: function() {
        // this.qs1.cache();
        this.qs2.cache();
      }
    });
	
    // Multi-Select: Select All
    $('#emplotee_select_all').parents('label').click(function() {
      pl.employeeSelectAll();
    });

    $('#emplotee_select_all').next().click(function() {
      pl.employeeSelectAll();
    });

    // Multi-Select: Options
    $('#options_employees').find('label').click(function() {
      pl.showHideOptions($(this).find('input'));
    });

  $('input[name=select_method]').next().click(function() {
    pl.showHideOptions($(this).parent().find('input'));
  });

  // Multi-Select: Options Initial
  pl.showHideOptions($('#select_method_all'));

  // // Multi-Select: Change Department
  $('#departments_employees').change(function() {
    pl.filterEmployees("department", $(this).val());
  });

  // Multi-Select: Change Superiors
  $('#superiors_employees').change(function() {
    pl.filterEmployees("superior", $(this).val());
  });

  // Multi-Select: Custom Search Task
  pl.customSearchTaskByCode();
  pl.customSearchTaskByName();

  /**************************************************************************************/
  /* Multi-Select */
  /**************************************************************************************/
  // Date
  $('#payroll_log_payroll_date').datepicker({
    format: 'dd/mm/yyyy',
    autoclose: true,
    language: "es"
  });

  // Add new Row
  $('form').on('click', '.add_fields', pl.addFields);

  // Tabs event about Search functionality
  $('body').on('keydown', '#select2-drop input', function(e) {
    var keyCode = e.keyCode || e.which;
    
    if( keyCode == pl.key_code_tab ) {
      pl.tabs_function = true;
      e.preventDefault();
      var e = $.Event('keydown');
      e.which = 27;
      $(this).trigger(e);
    }
  });

  $('.dropdown-menu').find('input, select').click(function (e) {
    e.stopPropagation();
  });

  $('#products_items').on('change','input[id*=_time_worked]', function() {
    pl.checkPerformance();
  });

  // Group performance is simple or not
  // Performance Checked
  $('#perf_is_simple').parents('label').click(function() {
    pl.checkPerformance();
  });

  $('#perf_is_simple').next().click(function() {
    pl.checkPerformance();
  });

  $('#group_performance').on('keyup', resources.twoDecimals);

  // Performance keyup for numbers with 2 decimals
  $('#products_items').on('keyup', 'input[id*=_performance]',resources.twoDecimals);

  // Add new row
  $('#products_items').on('focusout', 'select', function(e) {
    $('form .add_fields').trigger('click');
  });

  // Remove main table local
  $('#products_items').on('click', 'tr a.remove_fields', function(e) {
    e.preventDefault();

    var ids = [];
    var identificador = null;
    $(this).parents('tr').find('#td_save_employees input').each(function() {
      ids.push($(this).val());
      identificador = $(this).attr('name').match(/\d/g).join('');
    });

    if(ids.length == 0) {
      $(this).parents('tr').remove();
    } else {
      // Remove row in the main table
      $('#products_items').find('input[id*='+identificador+']:eq(0)').parents('tr').remove();
      
      $.each(ids, function(key, id) {
        // Remove data from session
        pl.removeEmployee(id, identificador);
        // Remove row in the table detail
        $('#tr_' + identificador + '_' + id).remove();
        // Show message
        resources.PNotify('Planilla', "Borrado con exito", 'success');
      });
    }
  });

  // Remove detail row local or server
  $('#accordion').on('click', 'tr button', function() {
    
    var isNew = resources.parseBool($(this).parent('td').find('input:hidden[id*=new]').val());
    var employee_id = $(this).parent('td').find('input:hidden[id*=employee_id]').val(); // employee_id
    var payroll_history_id = $(this).parent('td').find('input:hidden[id*=payroll_history_id]').val(); // payroll_history_id

    if(isNew) {
      // Remove data from session
      pl.removeEmployee(employee_id, payroll_history_id);
      // Remove row in the table detail
      $('#tr_' + payroll_history_id + '_' + employee_id).remove();
      // Remove row in the main table
      $('#products_items').find('input[id*='+payroll_history_id+']:eq(0)').parents('tr').remove();
      // Show message
      resources.PNotify('Planilla', "Borrado con exito", 'success');

    } else {      
      // Remove data from Server
      $.ajax({
        type: "GET",
        url: $(delete_employee_to_payment_payroll_logs_path).val(),
        dataType: "json",
        data: {
          employee_id : employee_id,
          payroll_history_id : payroll_history_id
        },
        success: function(msg) {
          // Remove data from session
          pl.removeEmployee(employee_id, payroll_history_id);
          // Remove row in the table
          $('#tr_' + employee_id + '_' + payroll_history_id).remove();
          // Show message
          resources.PNotify('Planilla', "Borrado con exito", 'success');
        },
        error: function(response, textStatus, errorThrown) {
          resources.PNotify('Planilla', "Error al intentar borrar el registro", 'danger');
        }
      });
    }
  });

  // Load prv data
  $.ajax({
    type: "GET",
    url: $(get_history_json_payroll_logs_path).val(),
    dataType: "json",
    data: {
      id: $('form').data('reference-id')
    },
    success: function(history) {
      pl.setSessionStorage(pl.search_types.history, history);
    }
  });

  $("input[name='commit']").click(function(e) {
    e.preventDefault();
    
    //validate at least one row is filled
    if($("#accordion").find("tr[id^=tr_]").length == 0 ) {
      resources.PNotify('Planilla', "Debe llenar al menos una fila", 'info');
      return false;
    }
    
    var currentEmployees = $(pl.current_save_employees).length;
    var rowIsDisabled = $(pl.current_payments_type+' select[id*=_payment_type_id]').parent('div').hasClass('a-not-active');
    

    if( currentEmployees == 1 && rowIsDisabled) {
      resources.PNotify('Planilla', pl.messages.last_line, 'info');
    } else {
      pl.ajaxUpdatePerformance();
    } 
    
  });

  // Click to apply general performance by Task
  $('#apply_performance').on('click', function(e) {
    e.preventDefault();

    var newPerformance = $('#group_performance').val();
    var idTask = $('#group_id_task').val();
    var date = $('#payroll_log_payroll_date').val();

    if( newPerformance == '' || idTask == '' || date == '' ) {
      resources.PNotify('Planilla', pl.messages.incomplete_data , 'info');
    } else {
      pl.applyGroupPerformance(newPerformance, idTask, date);
    }
  });

  $('#last_fingering').on('click', function(e) {
    pl.getLastFingering();
  });

}));
