$(jQuery(document).ready(function($) {

    treeviewhr.cc_tree(cuenta_contable, true);
//Obtiene las cuentas contables(ipadre y ncuenta)
    $.getJSON('/ledger_accounts/fetch', function(category_data) {
        $( "#other_salary_ledger_account" ).autocomplete({
            source: $.map(category_data, function(item){
                $.data(document.body, 'category_' + item.id+"", item.naccount);
                return{
                    label: item.naccount,                        
                    id: item.id
                }
            }),
            select: function( event, ui ) {
                $("#other_salary_ledger_account_id").val(ui.item.id);
            },
            focus: function(event, ui){
                $( "#other_salary_ledger_account" ).val(ui.item.label);
            }

        })
        if($("#other_salary_ledger_account_id").val()){
            var salarios_cuentas = $.data(document.body, 'category_' + $("#other_salary_ledger_account_id").val()+'');
            $("#other_salary_ledger_account").val(salarios_cuentas);
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
				}});

}));

//obtiene del treeview el nombre y id de la cuenta seleccionada
function set_account(e) {
    e.preventDefault();
    var accountId = $(this).closest('li').data('id');
    var accountName = $(this).text();
    $('#other_salary_ledger_account_id').val(accountId);
    $('#other_salary_ledger_account').val(accountName);  
}