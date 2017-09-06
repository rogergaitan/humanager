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
    var checkboxes = $("#list_tasks input[name=update_cost]:checked")
    
    if(elem.prop("checked")) {
      $("#update_costs").prop("disabled", false);
    } else  {
        $("#select_all").prop("checked", false);
    }
    
    if (checkboxes.length == 0 ) {
      $("#update_costs").prop("disabled", true);
    }
  } );
  
  //launch modal when checkbox is selected
  $("#list_tasks").on("click", "#select_all", function() {
    if($(this).prop("checked")) {
      $("#tasks_selection").modal();
    } else {
      $("#list_tasks input[type=checkbox]").prop("checked", false);
      $("#update_costs").prop("disabled", true)
      $("#update_all").attr("value", false);
    }
  }); 
  
  //open updates costs modal and add hidden field values to pass as parameters
  $("#list_tasks").on("click", "#update_costs" ,function() {
    $("#update_costs_modal").modal();
    
    var update_costs_form = $("#update_costs_form");
    
    if ($(this).attr("data-update-all")  == "true") {
      update_costs_form.find("#update_all").attr("value", true);
      update_costs_form.find("#tasks_ids").attr("value", "");
    } else {
      var tasks_ids = $("#list_tasks input[name=update_cost]:checked").map(function() { return this.value}).get().join();
      update_costs_form.find("#tasks_ids").attr("value", tasks_ids);
    }
    
    //apply mask to cost field to only allow decimal numbers
    $("#update_costs_form input[name=cost]").mask("0NNNNNNNNN.NN", {
      translation: {
       'N': {pattern: /\d/, optional: true}
      }
    });
  });
  
  //form validations
  $("#update_costs_form").validate({
      rules: {
        cost: {
          required: true,
          min: 0
        },
        currency: "required"
      },
      messages: {
        cost: {
          required:  "Campo costo es requerido",
          min: "Campo costo no puede ser menor que 0"
        },
        currency: "Campo moneda es requerido"
      },
      
      //handle form submit
      submitHandler:  function(form) {
        var form = $(form);
        
        if(confirm("¿Está Seguro? (Esta acción no se puede deshacer)")) {
          $.ajax({
            url: form.attr("action"),
            beforeSend: function(xhr) { xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')); },
            dataType: "json",
            method: "PUT",
            data: {
              cost: form.find("#cost").val(),
              currency: form.find("#currency").val(),
              tasks_ids: form.find("#tasks_ids").val(),
              update_all: form.find("#update_all").val(),
              unchecked_tasks_ids: $("#list_tasks input[name=update_cost]:not(:checked)").map(function() { return this.value}).get().join()
            }     
          }).done(function (data) {
  
            var selector = $("#list_tasks input[name=update_cost]:checked");
            
            $(selector).each(function (index) {
               $(this).parent().prev().text(data.currency_symbol + data.cost);
               $(this).parent().prev().prev().text(data.currency);
            });
          });
          
          $("#update_costs_modal").modal("hide");
        
        } else {
          $("#update_costs_modal").modal("hide");
      }  
    }
  });
  
  //select all checkbox on listing
  $("button[data-list=true], button[data-all=true]").on("click", function() {
      $("input[name=update_cost]").prop("checked", true);
      
      //only enable update costs button if there are results when customer chooses visible on list
      if($(this).attr("data-list") &&  $("input[name=update_cost]:checked").length  >= 1) {
        $("#update_costs").prop("disabled", false);
        $("#update_all").attr("value", false);
      }
      
      if($(this).attr("data-all")) {
        $("#update_costs").prop("disabled", false);
        //add value true to hidden field to select all checkboxes on each page
        $("#update_all").attr("value", true);
      }
      
      //add update all records attribute to update costs button when customer selects update all records
      if($(this).attr("data-all")  ) {
        $("#update_costs").attr("data-update-all", true); 
      } else {
        $("#update_costs").attr("data-update-all", false);
      }
      
      $("#tasks_selection").modal("hide");
  });
  
  //add ajax to pagination
  $(".pagination a[href]").attr("data-remote", true);
  
  //uncheck select all checkbox when closing modal when not all checkboxes are checked
  $("#tasks_selection").on("hidden.bs.modal", function () {
    if($("#list_tasks input[name=update_cost]:not(:checked)").lenght >= 1) {
      $("#select_all").prop("checked", false);
    }
  });

});
