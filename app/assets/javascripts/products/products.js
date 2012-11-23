$(jQuery(document).ready(function($) {
    //$(".search-image").css('background', "url('/assets/busy.gif') no-repeat scroll 195px 50% #FCFCFA");

    function create_html_generic(type,id,name){
        return '<div><button class="btn btn-success bind_select_btn icon-check btn-mini" id_'+type+' ="'+id+'" name_type="'+type+'">  </button><span>'+name+'</span></div>';
    }

    //Obtain lines(id and name).
    $.getJSON('/lines/fetch', function(line_data) {
        var html_create='';
        $( "#product_line" ).autocomplete({
            source: $.map(line_data, function(item){
                $.data(document.body, 'line_'+ item.id+"", item.name);
                html_create += create_html_generic('line',item.id,item.name);
                return{
                    label: item.name,                        
                    id: item.id
                }
            }),
            select: function( event, ui ) {
                if(ui.item.id){
                    $("#product_line_id").val(ui.item.id);    
                }
                
                //$("#product_line_id").val(ui.item.id);
                //$("#product_line_name").val(ui.item.label);
            },
            focus: function(event, ui){
                $( "#product_line" ).val(ui.item.label);
            },
            change: function(event, ui){
                if(!ui.item){
                    alert('Ningún resultado contiene ' + $( "#product_line" ).val());
                    $( "#product_line" ).val("");
                    $("#product_line_id").val("");    
                } 
            }
        }) 
        if($("#product_line_id").val()){
            var product_line_name = $.data(document.body, 'line_' + $("#product_line_id").val()+'');
            $("#product_line").val(product_line_name);
        }
        $('#lines_list div:first').append(html_create);
        $('#lines_list').pagination(8);

    });

    //validate
   

    //Obtain sublines(id and name)
    $.getJSON('/sublines/fetch', function(subline_data) {
        var html_create='';
        $( "#product_subline" ).autocomplete({
            source: $.map(subline_data, function(item){
                            $.data(document.body, 'subline_'+ item.id+"", item.name);
                            html_create += create_html_generic('subline',item.id,item.name);
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
        $('#sublines_list div:first').append(html_create); 
        $('#sublines_list').pagination(10);      
    });

    //Obtanin categories(id and name)
    $.getJSON('/categories/fetch', function(category_data) {
        var html_create = '';
        $( "#product_category" ).autocomplete({
            source: $.map(category_data, function(item){
                $.data(document.body, 'category_'+ item.id+"", item.name);
                html_create += create_html_generic('category',item.id,item.name);
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
        $('#category_list div:first').append(html_create);  
        $('#category_list').pagination(10);      
    });  

    //Consider js response on create method from product_pricing controller
    jQuery.ajaxSetup({ 
        'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
    });

    //Create with ajax
    $("#new_product_pricing").submit(function(){
        $.post($(this).attr("action"), $(this).serialize(), null, "script" );
        return false;
    });

    $(".bind_select_btn").live('click',function(){
        var name_type = $(this).attr('name_type');
        var id = $(this).attr("id_"+name_type);
        var name_item = $(this).next('span').text();
        $("#product_"+name_type+"_id").val(id);
        $("#product_"+name_type+"").val(name_item);
        $('.click_cancel').trigger('click');

    });


}));

