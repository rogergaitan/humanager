$(document).ready(function() {

	$('#sync-cc').on("click", function() {
		var cc_array = [];
		$('section.nav').append('<div class="notice">Sincronización en Proceso</div>');
    	$.getJSON('centro_de_costos/sync_cc', function(element) {
      		$(element.notice).each(function() { $('section.nav').append('<div class="notice">'+ this +'</div>').delay(5000).fadeOut(function(){location.reload();}); });
      		$(element.centrocostos).each(function() {
				cc_array.push(new Array(this.icentro_costo ? this.icentro_costo : 0, this.nombre_cc, this.icc_padre ? this.icc_padre : 0, this.id));
			});
			treeviewhr.cc_tree(cc_array);
      		$('#sync-cc').hide();
    	})
  	});

	treeviewhr.cc_tree(centro_costos);
	$('.expand_tree').on('click', treeviewhr.expand);
	$('a[rel=tooltip]').tooltip();
	
	// $('.tree-hover').on({
	// 	mouseenter: function() {
	// 	$(this).children('.tree-actions').show();
	// },
	// mouseleave:	function() {
	// 	$('.tree-actions').hide();
	// }})
})

function replace_value(value) {
  if (value == null) value = "";
  return value;
}