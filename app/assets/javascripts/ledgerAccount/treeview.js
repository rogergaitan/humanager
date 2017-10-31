function appendMainParent(tree_array) {
    tree_array.forEach(function(item) {
      if (item[2] == 0) {
        $('#list').append("<ul><li id='" + item[0] + "' data-id='"+ item[3] +"' class='accordion-group'><p class='main-parent tree-hover'><span><i class='icon-minus'></i>" + 
        item[1] + "</span> <span class='tree-actions'><a title='Eliminar' href='/ledger_accounts/" + item[3] + 
        "' class='btn-mini icon-trash' data-confirm='¿Está seguro(a)?' data-method='delete' rel='tooltip'></a><a title='Modificar' href='/ledger_accounts/" + 
        item[3] + "/edit' rel='tooltip' class='btn-mini icon-pencil'></a></span></p></li></ul>");
      }  
    })
}
    
function appendChildren(tree_array) {
  tree_array.forEach(function (item) {
    if ($('#list li#'+item[2]).length) {
      if (!($('#list li#' + item[2] + ' p:first i.icon-chevron-right').length)) {
        $('#list li#' + item[2] + ' p:first i').toggleClass('icon-minus icon-chevron-right');
      }
    
    $('#list li#' + item[2] + ' p:first span:first').addClass('expand_tree');
    $('#list li#' + item[2] + ' p:first span:first').removeClass('linkclass');
    $('#list li#' + item[2] + ' p:first span.tree-actions a.icon-trash').remove();
      
    $('#list li#' + item[2]).append("<ul style='display:none'><li id='" + item[0] + "' data-parent='" + item[2] + "' data-id='"+ item[3] +"'><p class='tree-hover'>" + 
      "<span class='linkclass'><i class='icon-minus'></i><span>" + 
      item[4] + ' - ' + item[1] + "</span></span> <span class='tree-actions'><a title='Eliminar' href='/ledger_accounts/" + item[3] + 
      "' class='btn-mini icon-trash' data-confirm='¿Está seguro(a)?' data-method='delete' rel='tooltip'></a><a title='Modificar' href='/ledger_accounts/" + 
      item[3] + "/edit' rel='tooltip' class='btn-mini icon-pencil'></a></span></p></li></ul>");
    }    
  })
}

var treeviewhr = new function() {
	this.cc_tree = function(tree_array, isPopup, textField, idField) {

    appendMainParent(tree_array);
    appendChildren(tree_array);
    
		
    if (isPopup == true) {
      $('span.linkclass span').addClass('node_link').attr("data-dismiss", "modal");
      $('#list').append("<input id='textFieldPopup' type='hidden' value='" + textField + "' />");
      $('#list').append("<input id='idFieldPopup' type='hidden' value='" + idField + "' />");
    }
}
	
	this.expand = function(e) {
		e.stopPropagation();
		$(this).children('i').toggleClass('icon-chevron-right icon-chevron-down');
		$(this).parent().siblings().slideToggle(400, 'linear');
	}
};
