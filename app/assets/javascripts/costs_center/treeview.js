var treeviewhr = new function() {

	this.cc_tree = function(tree_array, isPopup, textField, idField) {

		var principal = {};
		var items = {};

		$('#list').html('');

		$(tree_array.sort()).each(function() {
			if(this.father == 0) {
				principal[this.iaccount] = this;
			}

			if(this.father != 0) {
				if(!$.isArray(items[this.father])) items[this.father] = [];
				items[this.father].push(this);
			}
		});

		$.each(principal, function(id, item) {
			var childs = false;
			if(items[this.iaccount] != undefined) childs = items[this.iaccount].length > 0;
			var clss = childs ? 'expand_tree': '';
			var p = "<p class='main-parent tree-hover'><span class='" + clss + "'><i class='icon-minus'></i>" + this.name + "</span></p>";
			var li = "<li id='" + this.iaccount + "' data-id='" + this.id + "' class='accordion-group'>" + p + "</li>";
			var ul = "<ul>" + li + "</ul>";
			$('#list').append(ul);
		});

		var leftover = [];
		$.each(items, function(id, list) {
			var html = '';
			$(list).each(function() {
				if( $('#list li#' + this.father).length ) {
					var p = "<p class='tree-hover'><span class='linkclass'><i class='icon-minus'></i><span>" + this.iaccount + ' - ' + this.name + "</span></span></p>";
					var li = "<li id='" + this.iaccount + "' data-parent='" + this.father + "' data-id='" + this.id + "'>" + p + "</li>";
					var ul = "<ul style='display:none'>" + li + "</ul>";
					html = ul + html;
				} else {
					leftover.push(this);
				}
			});

			$('#list li#' + id + ' p:first span:first').addClass('expand_tree').removeClass('linkclass');
			$('#list li#' + id + ' p:first span.tree-actions a.icon-trash').remove();
			$('#list li#' + id).append(html);
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