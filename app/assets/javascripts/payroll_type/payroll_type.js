var payrollType = {};

$(document).ready(function() {
	// Load Routes
	payrollType.bank_accounts_path = $('#get_bank_account_ledger_accounts_path').val();

	// Load the tree Bank Account
	treeviewhr.cc_tree(bank_account, true);
	$('.expand_tree').click(treeviewhr.expand);

	// Event click in a Bank Account to set the id
	$('#list').on({
		click: payrollType.setAccount,
		
		mouseenter: function() {
			$(this).css("text-decoration", "underline");
		},
		mouseleave: function() {
			$(this).css("text-decoration", "none");
	}}, ".node_link");

	// Autocomplete to Bank Account
	payrollType.autocompleteBackAccounts();

});

// Set the hidden field with the Id and show the text (Bank Account)
payrollType.setAccount = function(e) {
	e.preventDefault();
    var accountId = $(this).closest('li').data('id'),
    	accountName = $(this).text();
    $('#payroll_type_ledger_account_id').val(accountId);
    $('#payroll_type_ledger_account').val(accountName);  
}

// Autocomplete to Bank Account
payrollType.autocompleteBackAccounts = function() {
	$.getJSON(payrollType.bank_accounts_path, function(category_data) {
		$('#payroll_type_ledger_account').autocomplete({
			source: $.map(category_data, function(item) {
				$.data(document.body, 'category_' + item.id+"", item.naccount);
				return {
					label: item.naccount,
					id: item.id
				}
			}),
			select: function( event, ui ) {
				$("#payroll_type_ledger_account_id").val(ui.item.id);
			},
			focus: function(event, ui) {
				$( "#payroll_type_ledger_account" ).val(ui.item.label);
			}
		});
		$('#payroll_type_ledger_account').removeClass('ui-autocomplete-input');
		if($("#payroll_type_ledger_account_id").val()) {
			var deducciones_cuentas = $.data(document.body, 'category_' + $("#payroll_type_ledger_account_id").val()+'');
			$("#payroll_type_ledger_account").val(deducciones_cuentas);
		}
	});
}
