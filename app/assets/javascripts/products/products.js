$(jQuery(document).ready(function($) {
    
    $.getJSON('/lines/fetch', function(line_data) {
        $( "#product_line" ).autocomplete({
            source: $.map(line_data, function(item){
                return{
                    label: item.name,                        
                    id: item.id
                }
            }),
            select: function( event, ui ) {
                $("#product_line_id").val(ui.item.id);
            }
        })       
    })
    
    $.getJSON('/sublines/fetch', function(subline_data) {
        $( "#product_subline" ).autocomplete({
            source: $.map(subline_data, function(item){
                return{
                    label: item.name,                        
                    id: item.id
                }
            }),
            select: function( event, ui ) {
                $("#product_subline_id").val(ui.item.id);
            }
        })       
    })

    $.getJSON('/categories/fetch', function(category_data) {
        $( "#product_category" ).autocomplete({
            source: $.map(category_data, function(item){
                return{
                    label: item.name,                        
                    id: item.id
                }
            }),
            select: function( event, ui ) {
                $("#product_category_id").val(ui.item.id);
            }
        });
        if($("#product_category_id").val()){
           $( "#product_category" ).autocomplete('search', $("#product_category_id").val() );             
        }       
    })


    
}))

