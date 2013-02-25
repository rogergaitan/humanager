$(jQuery(document).ready(function($) {
    //$(".search-image").css('background', "url('/assets/busy.gif') no-repeat scroll 195px 50% #FCFCFA");

    function create_html_generic(type,id,name){
        return '<div><button class="btn btn-success bind_select_btn icon-check btn-mini" id_'+type+' ="'+id+'" name_type="'+type+'">  </button><span>'+name+'</span></div>';
    }
    $('div#tab3').click(function (e) {
        $(this).tab('show');
        $("form#new_product_application").enableClientSideValidations();
    })
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
            minLength: 3,
            autoFocus: true, 
            select: function( event, ui ) {
                //if(ui.item.id){
                  //  $("#product_line_id").val(ui.item.id);    
                //}
                
                //$("#product_line_id").val(ui.item.id);
                //$("#product_line_name").val(ui.item.label);
                $("#product_line_id").val(ui.item.id);
                return $(this).val(ui.item.label);
            },
            focus: function(event, ui){
                //$("#product_line").val(ui.item.label);
                return $(this).val(ui.item.label)
            },
            change: function(event, ui){                
                if(!ui.item){
                    //alert('Ningún resultado contiene ' + $( "#product_line" ).val());
                    $("#product_line").val("");
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

    //Obtain sublines(id and name)
    $.getJSON('/sublines/fetch', function(subline_data) {
        var html_create='';
        $("#product_subline").autocomplete({
            source: $.map(subline_data, function(item){
                $.data(document.body, 'subline_'+ item.id+"", item.name);
                html_create += create_html_generic('subline',item.id,item.name);
                return{
                    label: item.name,
                    id: item.id
                }
            }),
            minLength: 3,
            autoFocus: true, 
            select: function( event, ui ) {
                $("#product_subline_id").val(ui.item.id);
                return $(this).val(ui.item.label);
            },
            focus: function(event, ui){
                return $(this).val(ui.item.label);
            },
            change: function(event, ui){                
                if(!ui.item){
                    //alert('Ningún resultado contiene ' + $( "#product_line" ).val());
                    $("#product_subline").val("");
                    $("#product_subline_id").val("");
                }
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
            minLength: 3,
            autoFocus: true, 
            select: function( event, ui ) {
                $("#product_category_id").val(ui.item.id);
                return $(this).val(ui.item.label);
            },
            focus: function(event, ui){
                return $(this).val(ui.item.label);
            },
            change: function(event, ui){                
                if(!ui.item){
                    //alert('Ningún resultado contiene ' + $( "#product_line" ).val());
                    $("#product_category").val("");
                    $("#product_category_id").val("");
                }
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

    $("#lines_list").on('click',".bind_select_btn",function(){
        var name_type = $(this).attr('name_type');
        var id = $(this).attr("id_"+name_type);
        var name_item = $(this).next('span').text();
        $("#product_"+name_type+"_id").val(id);
        $("#product_"+name_type+"").val(name_item);
        $('.click_cancel').trigger('click');

    });
    $("#sublines_list").on('click',".bind_select_btn",function(){
        var name_type = $(this).attr('name_type');
        var id = $(this).attr("id_"+name_type);
        var name_item = $(this).next('span').text();
        $("#product_"+name_type+"_id").val(id);
        $("#product_"+name_type+"").val(name_item);
        $('.click_cancel').trigger('click');

    });
    $("#category_list").on('click',".bind_select_btn",function(){
        var name_type = $(this).attr('name_type');
        var id = $(this).attr("id_"+name_type);
        var name_item = $(this).next('span').text();
        $("#product_"+name_type+"_id").val(id);
        $("#product_"+name_type+"").val(name_item);
        $('.click_cancel').trigger('click');

    });
    // $(".bind_select_btn").live('click',function(){
    //     var name_type = $(this).attr('name_type');
    //     var id = $(this).attr("id_"+name_type);
    //     var name_item = $(this).next('span').text();
    //     $("#product_"+name_type+"_id").val(id);
    //     $("#product_"+name_type+"").val(name_item);
    //     $('.click_cancel').trigger('click');

    // });
    
    $(function() {
        var hash = window.location.hash;
        $('a[href="' + hash + '"]').tab("show")
       //$('[href=' + window.location.hash + ']').click();
        //activeTab && activeTab.tab('show');

    });

  $("#tableprices").on("click", ".edit_price", function() {
    var row;
    row = $(this).closest("tr");
    $("#new_product_pricing").attr("action", "/product_pricings/" + row.find($(".product_id input")).val() );
    $("#new_product_pricing div:first").append('<input id="hidden_put" type="hidden" value="put" name="_method">');
    $("input.new-edit").val("Actualizar Precio");
    $("#product_pricing_utility").val(row.find($(".utility")).text());
    $("#product_pricing_price_type").val(row.find($(".price_type")).text());
    $("#product_pricing_category").val(row.find($(".category")).text());
    $("#product_pricing_sell_price").val(row.find($(".sell_price")).text());
  });
    
    $("a.new_price").click(function() {
    var row;
    row = $(this).closest("tr");
    $("#new_product_pricing").attr("action", "/product_pricings");
    $("#new_product_pricing div input#hidden_put").replaceWith("");
    $("input.new-edit").val("Crear Precio");
    $("form#new_product_pricing input[type='text']").val("");
  });
    
    
}));

