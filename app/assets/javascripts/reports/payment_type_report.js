var paymentTypeReports = {}

$(document).ready(function() {

  $('#report_task_ids').multiSelect({
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
        if(e.which === 40){
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

  // task_id_select_all
  $('#task_id_select_all').parents('label').click(function() {
    paymentTypeReports.selectUnselectTaks();
  });

  $('#task_id_select_all').next().click(function() {
    paymentTypeReports.selectUnselectTaks();
  });
  
  // CC
  $('#report_cc_ids').multiSelect({
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
        if(e.which === 40){
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

  // cc_id_select_all
  $('#cc_id_select_all').parents('label').click(function() {
    paymentTypeReports.selectUnselectCC();
  });

  $('#cc_id_select_all').next().click(function() {
    paymentTypeReports.selectUnselectCC();
  });

  // Button Create PDF
  $('#btn_create_pdf').on('click', function() {
    paymentTypeReports.validateData('pdf');
  });

  // Button Create XML
  $('#btn_create_xml').on('click', function() {
    paymentTypeReports.validateData('xlsx');
  });

});

paymentTypeReports.selectUnselectTaks = function(){
  if( $('#task_id_select_all').is(':checked') ) {
    $('#report_task_ids').multiSelect('select_all');
  } else {
    $('#report_task_ids').multiSelect('deselect_all');
  }
}

paymentTypeReports.selectUnselectCC = function(){
  if( $('#cc_id_select_all').is(':checked') ) {
    $('#report_cc_ids').multiSelect('select_all');
  } else {
    $('#report_cc_ids').multiSelect('deselect_all');
  }
}

paymentTypeReports.createPdfOrExel = function(format) {

  var url = $('#show_reports_path').val();
  var type = $('#type_report').val();
  var payrollIds = [];
  var employees = [];
  var tasks = [];
  var cc = [];
  var orderBy = $('#order_by').val();
  var currency = $('#currency').val();

  $('#payrolls_results input:checked').each(function() {
    payrollIds.push($(this).val());
  });

  $('#ms-deduction_employee_ids .ms-selection li.ms-selected').each(function() {
    employees.push($(this).attr('id').replace('-selection',''));
  });

  $('#ms-report_task_ids .ms-selection li.ms-selected').each(function() {
    tasks.push($(this).attr('id').replace('-selection',''));
  });
  
  $('#ms-report_cc_ids .ms-selection li.ms-selected').each(function() {
    cc.push($(this).attr('id').replace('-selection',''));
  });

  url = url + '/' + payrollIds[0] + '.' + format;

  window.open( url
    + '?type=' + type
    + '&format=' + format
    + '&employees=' + employees
    + '&payroll_ids=' + payrollIds
    + '&order=' + orderBy
    + '&tasks=' + tasks
    + '&cc=' + cc
    + '&currency=' + currency
  );
}

paymentTypeReports.validateData = function(format) {

  // Validation
  if($('#payrolls_results input:checked').length === 0) {
    resources.PNotify('Atención!', 'Por favor selecione una planilla.', 'error');
    return false;
  }
    
  if($('#ms-deduction_employee_ids .ms-selection li.ms-selected').length === 0) {
    resources.PNotify('Atención!', 'Por favor selecione los empleados.', 'error'); 
    return false;
  }
	
  if($('#ms-report_task_ids .ms-selection li.ms-selected').length === 0) {
    resources.PNotify('Atención!', 'Por favor seleccione las labores.', 'error');
    return false;
  }
  
  if($('#ms-report_cc_ids .ms-selection li.ms-selected').length  === 0) {
    resources.PNotify('Atención', 'Por favor seleccione los centros de costs.', 'error');
    return false;
  }

  paymentTypeReports.createPdfOrExel(format);
}
