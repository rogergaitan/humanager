$(jQuery(document).ready(function($) {
    //$(".search-image").css('background', "url('/assets/busy.gif') no-repeat scroll 195px 50% #FCFCFA");

    //Obtain lines(id and name).
    $.getJSON('/lines/fetch', function(line_data) {
        $( "#product_line" ).autocomplete({
            source: $.map(line_data, function(item){
                $.data(document.body, 'line_'+ item.id+"", item.name);
                return{
                    label: item.name,                        
                    id: item.id
                }
            }),
            select: function( event, ui ) {
                $("#product_line_id").val(ui.item.id);
                //$("#product_line_name").val(ui.item.label);
            }
        }) 
        if($("#product_line_id").val()){
            var product_line_name = $.data(document.body, 'line_' + $("#product_line_id").val()+'');
            $("#product_line").val(product_line_name);
        }      
    })
    
    //Obtain sublines(id and name)
    $.getJSON('/sublines/fetch', function(subline_data) {
        $( "#product_subline" ).autocomplete({
            source: $.map(subline_data, function(item){
                $.data(document.body, 'subline_'+ item.id+"", item.name);
                return{
                    label: item.name,                        
                    id: item.id
                }
            }),
            select: function( event, ui ) {
                $("#product_subline_id").val(ui.item.id);
            }
        })
        if($("#product_subline_id").val()){
            var product_subline_name = $.data(document.body, 'subline_' + $("#product_subline_id").val()+'');
            $("#product_subline").val(product_subline_name);
        }       
    })

    //Obtanin categories(id and name)
    $.getJSON('/categories/fetch', function(category_data) {
        $( "#product_category" ).autocomplete({
            source: $.map(category_data, function(item){
                $.data(document.body, 'category_'+ item.id+"", item.name);
                return{
                    label: item.name,                        
                    id: item.id
                }
            }),
            select: function( event, ui ) {
                $("#product_category_id").val(ui.item.id);
            }

        })
        if($("#product_category_id").val()){
            var product_category_name = $.data(document.body, 'category_' + $("#product_category_id").val()+'');
            $("#product_category").val(product_category_name);
        }        
    })  

}))

