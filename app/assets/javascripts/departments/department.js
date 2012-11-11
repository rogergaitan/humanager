$(jQuery(document).ready(function($) {

    treeviewhr.cc_tree(cc_child);
//Obtiene las cuentas contables(ipadre y ncuenta)
    $.getJSON('/centro_de_costos/load_centro_de_costos', function(category_data) {
        $( "#load_centro_de_costo" ).autocomplete({
            source: $.map(category_data, function(item){
                $.data(document.body, 'category_' + item.id+"", item.nombre_cc;
                return{
                    label: item.nombre_cc,                        
                    id: item.id
                }
            }),
            select: function( event, ui ) {
                $("#department_centro_de_costos_id").val(ui.item.id);
            }

        })
        if($("#department_centro_de_costos_id").val()){
            var load_centro_de_costo_name = $.data(document.body, 'category_' + $("#department_centro_de_costos_id").val()+'');
            $("#other_salary_ledger_account").val(load_centro_de_costo_name);
        }        
    }); 
    $('.expand_tree').click(treeviewhr.expand);

    $('.node_link').click(set_account);

}));

function set_account(e) {
    e.preventDefault();
    var accountId = $(this).parent().attr('id');
    var accountName = $(this).text();
    $('#department_centro_de_costos_id').val(accountId);
    $('#load_centro_de_costo').val(accountName);
    
}