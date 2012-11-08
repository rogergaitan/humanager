var treeviewhr = new function() {
	this.cc_tree = function(tree_array) {
		var leftover = []
		$(tree_array.sort()).each(function() {
			if (this[2] == 0) {
				$('#list').append("<ul><li id='" + this[0] + "' class='accordion-group'><p class='main-parent'>" + this[1] + "</p></li></ul>");
			}
			else {
				if ($('#list li#'+this[2]).length) {
					$('#list li#' + this[2] + ' p:first').addClass('expand_tree');
					$('#list li#' + this[2]).append("<ul style='display:none'><li id='" + this[0] + "' data-parent='" + this[2] + "'><p>" + this[1] + "</p></li></ul>");
				}
				else {
					leftover.push(this);
				};
			};
		})
		if (leftover.length) {
			this.cc_tree(leftover);
		}
	}
	
	this.expand = function(e) {
		e.stopPropagation();
		$(this).siblings().slideToggle('fast', 'linear');
	}
};