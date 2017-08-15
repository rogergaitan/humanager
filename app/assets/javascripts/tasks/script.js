$(document).ready(function() {

  var task = {
    search_length : 3
  }

  $('#task-fb').click(function() { 
    task_fb();
  });

  $('#search_form input').keyup(function() {
    return search_task();
  });
  
  $("#list_tasks").on("change", "#currency", function(event) {
     search_task();
     
  });

  $('#clear').click(function(e){
    search_all();
    $('#search_code').val('');
    $('#search_desc').val('');
    $('#search_activity').val('');
    $("#currency").val("");
  });

  function search_task() {
    var code = $('#search_code').val(),
        description = $('#search_desc').val(),
        activity = $('#search_activity').val(),
        currency = $("#currency").val();

    if( code.length >= 1 || description.length >= task.search_length || activity.length >= task.search_length || 
         code != "" || description != "" || activity != "" ||  currency != "")
    {

      return $.ajax({
        url: $('#search_form').attr('action'),
        dataType: "script",
        data: {
          search_code: code,
          search_desc: description,
          search_activity: activity,
          currency: currency
        }
      });
    }
  }

  function search_all() {
    return $.ajax({
      url: $('#search_form').attr('action'),
      dataType: "script",
      data: {
          search_code: "",
          search_desc: "",
          search_activity: "",
          currency: ""
        }
    });
  }

  function task_fb() {
    $.ajax('tasks/tasksfb', {
      type: 'GET',
      beforeSend: function() {
        resources.showMessage(
          'info',
          'Sincronización en Proceso, por favor espere...', 
          {'dissipate': false, 'icon': 'fa fa-fw fa-spinner fa-spin'}
        );
      },
      complete: function() {
        setTimeout(function() {
          resources.showMessage('info', 'Resfrescando...');
          location.reload();
        },2000);
      },
      success: function(result) {
        var msj = jQuery.map( result.notice, function( value, index ) {
          return value + '';
        });
        resources.showMessage('info', msj);
        $('#task-fb').hide();
      },
      error: function(result) {
        resources.showMessage('danger','Imposible cargar las Labores');
      }
    });
  }
  
  //enable update costs button
  $("#list_tasks").on("click", "input[name='update_cost']" , function() {
    var elem = $( this );
    
    if(elem.prop('checked')) {
        $("#update_costs").prop('disabled', false)
     } else if ($("#list_tasks input:checked").length == 0) {
        $("#update_costs").prop('disabled', true)
    } 
  } );
  
  //launch modal when checkbox is selected
  $("#list_tasks").on("click", "#select_all", function() {
    if($(this).prop('checked')) {
      $("#tasks_selection").modal();
    } else {
      $("#list_tasks input[type=checkbox]").prop("checked", false);
      $("#update_costs").prop('disabled', true)
    }
  }); 
  
  //open updates costs modal and add hidden field values to pass parameters
  $("#list_tasks").on("click", "#update_costs" ,function() {
    $("#update_costs_modal").modal();
    
    $("#update_costs_form input[name=cost]").mask("0000000000.00");
  
    //form validations
    $("#update_costs_form").validate({
      rules: {
        cost: "required",
        currency: "required"
      } ,
      messages: {
        cost: "Campo costo es requerido",
        currency: "Campo moneda es requerido"
      }
    });
    
    var update_costs_form = $("#update_costs_form");
    
    if ($(this).attr("data-update-all")  == "true") {
      update_costs_form.find("#update_all").attr("value", true);
    } else {
      var tasks_ids = $("#list_tasks input[name=update_cost]:checked").map(function() { return this.value}).get().join();
      update_costs_form.find("#tasks_ids").attr("value", tasks_ids);
    }
  });
  
  //select all checkbox on listing
  $("#list_tasks").on("click",  "button[data-list=true], button[data-all=true]", function() {
      $("input[name=update_cost]").prop("checked", true);
      
      //only enable update costs button if there are result when customer chooses visible on list
      if($(this).attr("data-list") &&  $("input[name=update_cost]:checked").length  >= 1) {
        $("#update_costs").prop("disabled", false);
      }
      
      if($(this).attr("data-all")) {
        $("#update_costs").prop("disabled", false);    
      }
      
      //add update all records attribute to update costs button when customer selects update all records
      if($(this).attr("data-all")  ) {
        $("#update_costs").attr("data-update-all", true); 
      } else {
        $("#update_costs").attr("data-update-all", false);
      }
      
      $("#tasks_selection").modal('hide'); 
  });

})
