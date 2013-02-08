$(document).ready(function($) {
    $.getJSON('/employees/load_employees', function(employee_data) {
        $( "#employee_name" ).autocomplete({
            source: $.map(employee_data, function(item){
                $.data(document.body, 'employee_'+ item.id+"", item.entity.name + ' ' + item.entity.surname);
                return{
                    label: item.entity.name + ' ' + item.entity.surname,                        
                    id: item.id
                }
            }),
            minLength: 3,
            autoFocus: true, 
            select: function( event, ui ) {
                $("#cost_center_employee_id").val(ui.item.id);
                return ($this).val(ui.item.label);
            },
            focus: function(event, ui){
                return ($this).val(ui.item.label);
            },
            change: function(event, ui){
                if(!ui.item){
                    $("#cost_center_employee_id").val("");
                    $("#employee_name").val("");    
                } 
            }
        }) 
        if($("#cost_center_employee_id").val()){
            var load_employee_name = $.data(document.body, 'employee_' + $("#cost_center_employee_id").val()+'');
            $($this).val(load_employee_name);
        }      
    });
})