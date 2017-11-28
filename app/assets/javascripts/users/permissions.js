var permissions = { 
  'permissions_user' : []
}

$(document).ready(function() {
  
  //hide and show search form and results
  $('#copy_permissions').on('change', function() {
    if($(this).prop('checked')) {
      $('#users_results , #user_permissions_search').removeClass('hidden');
    } else {
      $('#users_results , #user_permissions_search').addClass('hidden');
    }
  });

  $('#search_users').click(function() {
    permissions.searchInfoUsers();
  });
	
  $('#users_results').on('click', '.pag a', function() {
    $.getScript(this.href);
    return false;
  });

  $('#users_results').on('click', 'input:button', function() {
    var id = $(this).attr('id');
    var url = $('#get_permissions_user_users_path').val();
    permissions.getPermissions(url, id);
  });

  $('#btn_save').on('click', function(e) {
    e.preventDefault();
    permissions.savePermissions();
  });

  $('table[id^=category_] thead input').change(function() {
    var checked = $(this).is(':checked');
    
    var element = $(this).val().split('-');
    $('#' + element[0] + ' tbody tr').each(function(){
      var id = $(this).attr('id');
      $('#' + id + ' td:eq(' + element[1] + ') input').prop('checked', checked);
    });
  });

});

// Search the users
permissions.searchUsers = function(username, name, url, actualuser) {

  return $.ajax({
    url: url,
    dataType: 'script',
    data: {
      username: username,
      name: name,
      actualuser: actualuser
    }
  });
}

// Find the information and calls the search function
permissions.searchInfoUsers = function() {

  var username = $('#username').val();
  var name = $('#name').val();
  var url = $('form[id=search_users_form]').attr('action');
  var actualuser = $('#userId').val();

  permissions.searchUsers(username, name, url, actualuser);
}

permissions.savePermissions = function() {

  var tr_id = '', t = 0, id = '', str = '', opction = '';

  $('#accordion .panel-body table tbody tr').each(function() {
		
    tr_id = $(this).attr('id');
    t = tr_id.length - tr_id.indexOf("_");
    t = t - 1;
    id = tr_id.substring(tr_id.length-t, tr_id.length);
    var data = {
      'id_subcategory' : id,
      'p_create' : false, 
      'p_view' : false,
      'p_modify' : false, 
      'p_delete' : false, 
      'p_close' : false, 
      'p_accounts' : false, 
      'p_pdf' : false, 
      'p_exel' : false
    };
		
    $('#' + tr_id + ' td input' ).each(function() {
			
      str = $(this).attr('id');
      var checked = $(this).is(':checked');
      if(checked) {
        t = str.length - str.indexOf('_');
        opction = str.substring(0,str.length - t);
        data = permissions.saveInformation(opction, checked, data);
      }
    });
     permissions.permissions_user.push(data);
   });
   permissions.sendInformation();
}

permissions.saveInformation = function(opction, checked, data) {

  switch (opction) {
    	
    case 'create':
      data.p_create = checked;
    break;

    case 'view':
      data.p_view = checked;
    break;

    case 'modify':
      data.p_modify = checked;
    break;

    case 'delete':
      data.p_delete = checked;
    break;

    case 'close':
      data.p_close = checked;
    break;

    case 'accounts':
      data.p_accounts = checked;
    break;

    case 'pdf':
      data.p_pdf = checked;
    break;

    case 'exel':
      data.p_exel = checked;
    break;
  }
  return data;
}

permissions.sendInformation = function() {

  var urlRedirect = $('#users_path').val();
  var user_id = $('#user_id').val();

  $.ajax({
    url: $('#save_permissions_users_path').val(),
    type: "POST",
    dataType: "json",
    data: {
      permissions_user: permissions.permissions_user,
      user_id: user_id
    },
    xhrFields: {
      withCredentials: true
    },
  })
  .always(function() {
    window.location = '/users';
  })
}

permissions.getPermissions = function(url, id) {

  $.get( url, {
     id: id
  }, function(data) {
    permissions.loadPermissions(data['data']);
  });
}

permissions.loadPermissions = function(data) {

  var id_subcategory;
	
  $.each(data, function(i, obj) {
	  
    id_subcategory = obj['permissions_subcategory_id']

    $.each(obj, function(index, value) {
      permissions.setValue(index, value, id_subcategory);
    });
  });
}

permissions.setValue = function(opction, value, id_subcategory) {

  switch (opction) {
    	
    case 'p_create':
      $('#create_' + id_subcategory).prop('checked', value);
    break;

    case 'p_view':
      $('#view_' + id_subcategory).prop('checked', value);
    break;

    case 'p_modify':
      $('#modify_' + id_subcategory).prop('checked', value);
    break;

    case 'p_delete':
      $('#delete_' + id_subcategory).prop('checked', value);
    break;

    case 'p_close':
      $('#close_' + id_subcategory).prop('checked', value);
    break;

    case 'p_accounts':
      $('#accounts_' + id_subcategory).prop('checked', value);
    break;

    case 'p_pdf':
     $('#pdf_' + id_subcategory).prop('checked', value);
    break;

    case 'p_exel':
      $('#exel_' + id_subcategory).prop('checked', value);
    break;
  }
}

