$(jQuery(document).ready(function($) {
	var defaultList = [];
	$('div.employees-list input[type=checkbox]:checked').each(function() { 
		defaultList.push($(this).attr('id'));
	});
	$('#debit-button').click(function(){
		treeviewhr.cc_tree(debit_account, true, 'load_debit_accounts', 'work_benefit_debit_account');
	});
	$('#credit-button').click(function(){
		treeviewhr.cc_tree(credit_account, true, 'load_credit_account_name', 'work_benefit_credit_account');
	});
    fetchPopulateAutocomplete('/work_benefits/fetch_debit_accounts', "load_debit_accounts", "work_benefit_debit_account");
    fetchPopulateAutocomplete('/work_benefits/fetch_credit_accounts', "load_credit_account_name", "work_benefit_credit_account");
	$('#list').on("click", "span.expand_tree", treeviewhr.expand);
	$('button.delete-accounts').click(function() {
		$('#list').empty();
	});		
    $('#list').on({
				click: set_account,
				mouseenter: function() {
					$(this).css("text-decoration", "underline");
				},
				mouseleave: function() {
					$(this).css("text-decoration", "none");
				}}, ".node_link");
	$('input[name=select_method]').change(function() {
		selectEmployee(defaultList, $(this));
	});
	$('#add-to-list').click(moveToRight);
}));

function moveToRight(e) {
	e.preventDefault();
	var appendEmployees = "";
	$('div.employees-list input[type=checkbox]:checked').each(function() {
		appendEmployees = "<div class='checkbox-group'>" +
									"<div class='checkbox-margin'>" +
										"<input type='checkbox' checked='checked' class='align-checkbox' name='work_benefit[employee_ids][]' />" +
										"<label class='checkbox-label' for='hola'>hola</lable>" +
									"</div>" +
								"</div>";	
		$('#list-to-save').append(appendEmployees);
	});
}

function selectEmployee(list, selected) {
	switch($(selected).val()) {
		case 'all':
			$('#list-departments').hide();
			$("div.employees-list input[type='checkbox']").attr('checked', true);
			break;
		case 'none':
			$('#list-departments').hide();
			$("div.employees-list input[type='checkbox']").attr('checked', false);
			break;
		case 'default':
			$('#list-departments').hide();
			$("div.employees-list input[type='checkbox']").attr('checked', false);
			$.each(list, function() {
				$('#'+this).attr('checked', true);
			});
			break;
		case 'department':
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

function set_account(e) {
    e.preventDefault();
    var accountId = $(this).closest('li').data('id');
    var accountName = $(this).text();
    $(document.getElementById($('#idFieldPopup').val())).val(accountId);
    $(document.getElementById($('#textFieldPopup').val())).val(accountName);
	$('#list').empty();
}