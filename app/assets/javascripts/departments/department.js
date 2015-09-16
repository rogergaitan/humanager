$(jQuery(document).ready(function($) {

  $('form').on('dblclick', '#load_costs_centers', function() {
    $('#myModal').modal('show');
  });

  treeviewhr.cc_tree(costs_centers, true);
  // Get the Costs Centers
  $.getJSON('/costs_centers/load_cc', function(category_data) {
    $('#load_costs_centers').autocomplete({
      source: $.map(category_data, function(item) {
        $.data(document.body, 'category_' + item.id + "", item.name_cc);
        return {
          label: item.name_cc,
          id: item.id
        }
      }),
      select: function( event, ui ) {
        $('#department_costs_center_id').val(ui.item.id);
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
}));

function set_account(e) {
  e.preventDefault();
  var accountId = $(this).closest('li').data('id');
  var accountName = $(this).text();
  $('#department_costs_center_id').val(accountId);
  $('#load_costs_centers').val(accountName);
}
