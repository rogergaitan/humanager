$(jQuery(document).ready(function($) {

    treeviewhr.cc_tree(centro_costos, true);
//Obtiene las centros de costo
    $.getJSON('/centro_de_costos/load_cc', function(category_data) {
        $( "#load_centro_de_costo" ).autocomplete({
            source: $.map(category_data, function(item){
                $.data(document.body, 'category_' + item.id+"", item.nombre_cc);
                return{
                    label: item.nombre_cc,                        
                    id: item.id //icc_padre
                }
            }),
            select: function( event, ui ) {
                $('#department_centro_de_costos_id').val(ui.item.id);
            }

        })
        if($('#department_centro_de_costos_id').val()){
            var load_centro_de_costo_name = $.data(document.body, 'category_' + $('#department_centro_de_costos_id').val()+'');
            $("#other_salary_ledger_account").val(load_centro_de_costo_name);
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
    var accountId = $(this).closest('li').data('id'); //$(this).parent().attr('id');
    var accountName = $(this).text();
    $('#department_centro_de_costos_id').val(accountId);
    $('#load_centro_de_costo').val(accountName);
    
       
}