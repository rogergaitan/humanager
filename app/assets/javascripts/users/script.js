var users = {}

$(document).ready(function() {

  $('#users-fb').on('click', function() {
    $.getJSON( $('#usersfb_users_path').val(), function(element) {
      $('section.nav').append('<div class="notice">'+ element.notice +'</div>');
      $(element.user).each(function() { 
        users.add_users(this, "table#user-data");
      });
      $('#users-fb').hide();
    })
  });

});

users.add_users = function (user, target_table) {
  var rootUsers = $('#users_path').val();
  var row = $(target_table + '> tbody:last').append('<tr>' +
              '<td><a href="/user/'+ user.id +'">'+ user.username +'</a></td>' +
              '<td>' + users.replace_value(user.name) + '</td>' +
              '<td>' + users.replace_value(user.email) + '</td>' +
              '<td>' +
              '<a href="'+rootUsers+'/'+ user.id +'/edit" class="btn btn-mini">Editar</a>' +
              '<a href="'+rootUsers+'/'+'permissions/'+user.id+'" class="btn btn-mini">Permisos</a>' +
            '</tr>');
  return row;
};

users.replace_value = function(value) {
  if (value == null) value = "";
    return value;
};

// $('#task-data a').click( function(e) {
//   e.preventDefault();
// });

// $('#task-data a').dblclick( function(e) {
//   var url = $(this).next().val();
//   document.location.href = url;
// });
