$(document).ready(function($) {
    //Gets all data from employees
    $.getJSON($('#load_payrolls_payrolls_path').val(), function(payroll_data) {
        $( "#load_payroll" ).autocomplete({
            source: $.map(payroll_data, function(item) {
                $.data(document.body, 'payroll_'+ item.id+"", item.payroll_type.description);
                return {
                    label: item.payroll_type.description,                        
                    id: item.id
                }
            }),
            select: function( event, ui ) {
                if( ui.item.id ) {
                    $("#payroll_log_payroll_id").val(ui.item.id);    
                }
            },
            focus: function(event, ui) {
                $( "#load_payroll" ).val(ui.item.label);
            },
            change: function(event, ui) {
                if( !ui.item ) {
                    alert('Ningún resultado contiene ' + $( "#load_payroll" ).val());
                    $( "#load_payroll" ).val("");
                    $("#load_payroll_id").val("");    
                } 
            }
        }) 
        if($("#payroll_log_payroll_id").val()) {
            var load_payroll_name = $.data(document.body, 'payroll_' + $("#payroll_log_payroll_id").val()+'');
            $("#load_payroll").val(load_payroll_name);
        }      
    });
})