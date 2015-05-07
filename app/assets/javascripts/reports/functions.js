general_functions = { }

$(document).ready(function() {

  $('#deduction_employee_ids').multiSelect({
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
      // this.qs1.cache();
      this.qs2.cache();
    },
    afterDeselect: function(){
      this.qs1.cache();
      this.qs2.cache();
    }
  });

	general_functions.datePicker();
  general_functions.searchInfoPayrolls();
  general_functions.showHideOptions($('#select_method_all')); // Set default

  $('#search_payrolls').click(function() {
    general_functions.searchInfoPayrolls();
  });

  $('#company').change(function(){
    general_functions.searchInfoPayrolls();
  });

  $('input[name=select_method]').change(function() {
    general_functions.showHideOptions($(this));
  });

  $('#departments_employees').change(function() {
    general_functions.filterEmployees("department", $(this).val());
  });

  $('#superiors_employees').change(function() {
    general_functions.filterEmployees("superior", $(this).val());
  });

	$("#payrolls_results").on("click", ".pag a", function() {
 	  $.getScript(this.href);
    return false;
  });

})

// Establishing the datepicker
general_functions.datePicker = function() {
  $("#start_date").datepicker({ //'dd/mm/yyyy'
    format: 'yyyy-mm-dd'
  });
  $("#end_date").datepicker({
    format: 'yyyy-mm-dd'
  });
}

// Find the information and calls the search function
general_functions.searchInfoPayrolls = function() {

  if( $('#company').val() === "" ) {
    $('#payrolls_results').html("<div class='alert alert-info'>Por favor seleccione una compañia</div>");
  } else {
    var start_date = $('#start_date').val(),
        end_date = $('#end_date').val(),
        url = $("form[id=search_payrolls_form]").attr('action')
        company_id = $('#company').val();

    general_functions.searchPayrolls(start_date, end_date, url, company_id);
  }
}

// Search the payrolls
general_functions.searchPayrolls = function(start_date, end_date, url, company_id) {
  return $.ajax({
    url: url,
    dataType: "script",
    data: {
      start_date: start_date,
      end_date: end_date,
      company_id: company_id
    }
  });
}

general_functions.showHideOptions = function(selected) {
  switch($(selected).val()) {
    case 'all':
      $('#ms-deduction_employee_ids').find('input:eq(0)').show();
      $('#list-departments').hide();
      $('#list-superior').hide(); 
      $('.ms-selection').css('margin-top', '0px');
      general_functions.filterEmployees("all");
      break;
    case 'boss':
      $('.ms-selection').css('margin-top', '-3.7%');
      $('#ms-deduction_employee_ids').find('input:eq(0)').hide();
      $('#list-departments').hide();
      general_functions.filterEmployees("superior", $('#superiors_employees').val());
      $('#list-superior').show(); 
      break;
    case 'department':
      $('.ms-selection').css('margin-top', '-3.7%');
      $('#ms-deduction_employee_ids').find('input:eq(0)').hide();
      $('#list-superior').hide(); 
      general_functions.filterEmployees("department", $('#departments_employees').val());
      $('#list-departments').show();
      break;
  }
}

general_functions.filterEmployees = function(type, id) {
  
  id = id ? id : 0;

  $('#ms-deduction_employee_ids .ms-selectable').find('li').each(function() {
    
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

general_functions.showMessage = function(type, message) {
  var icon;
  if(type === "success") {
    icon = 'check';
  }
  if(type === "danger") {
    icon = 'times';
  }
  if(type === "warning") {
    icon = 'warning';
  }
  if(type === "info") {
    icon = 'info-circle';
  }

  $('#div-message').show();
  $('#div-message').find('div.alert.alert-dismissable').addClass('alert-'+type);
  $('#div-message').find('label#message').html(message);
  $('#div-message').find('i').addClass('fa-'+icon);

  $('div.alert.alert-'+type).fadeIn(4000, function() {
    setTimeout(function() {
        $(this).fadeOut("slow");
        $('#div-message').find('div.alert.alert-dismissable').removeClass('alert-' + type);
        $('#div-message').find('i').removeClass('fa-' + icon);
        $('#div-message').hide();
    },4000);
  });
}
