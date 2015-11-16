$(jQuery(document).ready(function($) {

	$("#products_items tbody").on('keydown', 'td:eq(0)#td_employees a', function(e) {
		var keyCode = e.keyCode || e.which;

		if( keyCode == pl.key_code_tab ) {
			e.preventDefault();
			window.a = $(this);
			$(pl.current_employee).find('#search_name_employee').select2("open");
		} 
	});


	$('body').on('keydown', '#select2-drop input', function(e) {
		var keyCode = e.keyCode || e.which;

		if( keyCode == pl.key_code_tab ) {
			e.preventDefault();
			window.b = $(this);
			$(pl.current_employee).find('#search_name_employee').select2("open");
		} 
	});

}));
