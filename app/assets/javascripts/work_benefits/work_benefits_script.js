$(jQuery(document).ready(function($) {
    $.getJSON('/ledger_accounts/fetch', function(category_data) {
        $( "#other_salary_ledger_account" ).autocomplete({
            source: $.map(category_data, function(item){
                $.data(document.body, 'category_' + item.ifather+"", item.naccount);
                return{
                    label: item.naccount,                        
                    id: item.ifather
                }
            }),
            select: function( event, ui ) {
                $("#other_salary_ledger_account_id").val(ui.item.id);
            }

        })
        if($("#other_salary_ledger_account_id").val()){
            var salarios_cuentas = $.data(document.body, 'category_' + $("#other_salary_ledger_account_id").val()+'');
            $("#other_salary_ledger_account").val(salarios_cuentas);
        }        
    }); 

}));