var treeviewhr = new function() {
	this.cc_tree = function(tree_array, isPopup, textField, idField) {
		var leftover = []
		$(tree_array.sort()).each(function() {
			if (this[2] == 0) {
				$('#list').append("<ul><li id='" + this[0] + "' data-id='"+ this[3] +"' class='accordion-group'><p class='main-parent tree-hover'><span><i class='icon-minus'></i>" + 
														this[1] + "</span> <span class='tree-actions'><a title='Eliminar' href='/costs_center/" + this[3] + 
														"' class='btn-mini icon-trash' data-confirm='¿Está seguro(a)?' data-method='delete' rel='tooltip'></a><a title='Modificar' href='/costs_center/" + 
														this[3] + "/edit' rel='tooltip' class='btn-mini icon-pencil'></a></span></p></li></ul>");
			} else {
				if ($('#list li#'+this[2]).length) {
					if (!($('#list li#' + this[2] + ' p:first i.icon-chevron-right').length)) {
						$('#list li#' + this[2] + ' p:first i').toggleClass('icon-minus icon-chevron-right');
					}
					$('#list li#' + this[2] + ' p:first span:first').addClass('expand_tree');
					$('#list li#' + this[2] + ' p:first span:first').removeClass('linkclass');
					$('#list li#' + this[2] + ' p:first span.tree-actions a.icon-trash').remove();
					$('#list li#' + this[2]).append("<ul style='display:none'><li id='" + this[0] + "' data-parent='" + this[2] + "' data-id='"+ this[3] +"'><p class='tree-hover'><span class='linkclass'><i class='icon-minus'></i><span>" + 
																						this[0] + ' - ' + this[1] + "</span></span> <span class='tree-actions'><a title='Eliminar' href='/costs_center/" + this[3] + 
																						"' class='btn-mini icon-trash' data-confirm='¿Está seguro(a)?' data-method='delete' rel='tooltip'></a><a title='Modificar' href='/costs_center/" + 
																						this[3] + "/edit' rel='tooltip' class='btn-mini icon-pencil'></a></span></p></li></ul>");
				} else {
					leftover.push(this);
				}
			}
		});
		if (leftover.length) {
			this.cc_tree(leftover, isPopup);
		}
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