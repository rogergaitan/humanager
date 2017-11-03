$(jQuery(document).ready(function($) {

  treeviewhr.cc_tree(costs_centers, true);

  // Get the Costs Centers
  $.getJSON('/costs_centers/load_cc', function(category_data) {
    $('#load_costs_centers').autocomplete({
      source: $.map(category_data, function(item) {
        $.data(document.body, 'category_' + item.id + "", item.icost_center + " - " + item.name_cc);
        return {
          label: item.icost_center + " - " + item.name_cc,
          id: item.id
        }
      }),
      select: function( event, ui ) {
        $('#department_costs_center_id').val(ui.item.id);
      },
      change: function(event, ui) {
        if(!ui.item) {
          $('#load_costs_centers').val('');
          $('#department_costs_center_id').val('');
        }
      }
    });
    if($('#department_costs_center_id').val()) {
      var load_costs_center_name = $.data(document.body, 'category_' + $('#department_costs_center_id').val() + '');
      $('#load_costs_centers').val(load_costs_center_name);
    }        
  });

  $('.expand_tree').click(treeviewhr.expand);

  $('.node_link').bind({
    click: set_account, 
    
    mouseenter: function() {
      $(this).css("text-decoration", "underline");
    },
    mouseleave: function() {
      $(this).css("text-decoration", "none");
    }
  });

  /* Employee */
  $.getJSON('/employees/load_employees', function(employee_data) {
    $("#load_employee").autocomplete({
      source: $.map(employee_data, function(item){
      $.data(document.body, 'employee_'+ item.id+"", item.entity.name + ' ' + item.entity.surname);
      return{
        label: item.entity. name + ' ' + item.entity.surname,                        
        id: item.id
      }
      }),
      select: function( event, ui ) {
        if(ui.item.id){
          $("#department_employee_id").val(ui.item.id);    
        }
      },
      focus: function(event, ui){
        $( "#load_employee" ).val(ui.item.label);
      },
      change: function(event, ui){
        if(!ui.item){
          $("#load_employee").val("");
          $("#load_employee_id").val("");    
        }
      }
    })
    if($("#department_employee_id").val()){
      var load_employee_name = $.data(document.body, 'employee_' + $("#department_employee_id").val()+'');
      $("#load_employee").val(load_employee_name);
    }
  });

}));

function set_account(e) {
  e.preventDefault();
  var accountId = $(this).closest('li').data('id');
  var accountName = $(this).text();
  $('#department_costs_center_id').val(accountId);
  $('#load_costs_centers').val(accountName);
}
