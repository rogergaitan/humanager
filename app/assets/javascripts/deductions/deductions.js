$(document).ready(function(){
	treeviewhr.cc_tree(cuenta_credito, true);
  	$('.expand_tree').click(treeviewhr.expand);

  	 $('.node_link').bind({
				click: set_account,
				mouseenter: function() {
					$(this).css("text-decoration", "underline");
				},
				mouseleave: function() {
					$(this).css("text-decoration", "none");
				}});
});

function set_account(e) {
    e.preventDefault();
    var accountId = $(this).closest('li').data('id');
    var accountName = $(this).text();
    $('#deduction_ledger_account_id').val(accountId);
    $('#deduction_ledger_account').val(accountName);  
}