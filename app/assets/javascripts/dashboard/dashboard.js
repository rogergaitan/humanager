var new_date = '';
var current_tab = '';

load_purchase_orders = function(e) {
	//needed to in-start function for this if
	if($('a#user_logged').length > 0) {
		$('.flap_search form#normal-search').css({'top' : '50px', 'right' : '10px', 'z-index' : '0'});
		$('.flap_search form#advance-search').css({'top' : '50px', 'right' : '10px', 'z-index' : '0'});
	}	
	if($('#purchase_orders').length > 0) {
		e.preventDefault();
		current_tab = '#load_purchase_orders';
		if(!$('#purchase_orders').is(':empty')) {
			$.ajax({
				url: '/purchase_orders',
				dataType: 'script',
				data: {
					date: new_date
				},
			});
		}
	}
};

load_purchases = function(e) {
	e.preventDefault();
	current_tab = '#load_purchases';
	if(!$('#purchases').is(':empty')) {
		$.ajax({
			url: '/purchases',
			dataType: 'script',
			data: {
				date: new_date
			},
		});
	}
};

load_quotations = function(e) {
	e.preventDefault();
	current_tab = '#load_quotations';
	if(!$('#quotations').is(':empty')) {
		$.ajax({
			url: '/quotations',
			dataType: 'script',
			data: {
				date: new_date
			},
		});
	}
};

load_invoices = function(e) {
	e.preventDefault();
	current_tab = '#load_invoices';
	if(!$('#invoices').is(':empty')) {
		$.ajax({
			url: '/invoices',
			dataType: 'script',
			data: {
				date: new_date
			},
		});
	}
};

show_hide_advance_search = function() {
	if($('.flap_search form#normal-search').is(':visible')) {
		$('div.navbar-search a#desplegar').text('Menos');
	}
	else {
		$('div.navbar-search a#desplegar').text('Más');
	}
	$('.flap_search form#normal-search').slideToggle('fast');
	$('.flap_search form#advance-search').slideToggle('fast');
};

submit_normal_search = function() {
	if($('.flap_search form#normal-search #search').val().length == 0) {
		return false;
	}
	else {
		return true;
	}
};

submit_advance_search = function(e) {
	if(($('.flap_search form#advance-search #code').val().length == 0) &&
		 ($('.flap_search form#advance-search #name').val().length == 0) &&
		 ($('.flap_search form#advance-search #applications').val().length == 0) &&
		 ($('.flap_search form#advance-search #part_number').val().length == 0)) {
		return false;
	}
	else {
		if(e.which == 13) {
			$('.flap_search form#advance-search').submit();
		}
	}
};

$(document).ready(function() {

	$(document).on('ready', load_purchase_orders);

	$('ul.nav').on('click', '#load_purchase_orders', load_purchase_orders);	

	$('ul.nav').on('click', '#load_purchases', load_purchases);

	$('ul.nav').on('click', '#load_quotations', load_quotations);

	$('ul.nav').on('click', '#load_invoices', load_invoices);

	$('.flap_search form#normal-search').on('submit', submit_normal_search);

	$('.flap_search form#advance-search').on('keyup',submit_advance_search);

	$('div.navbar-search').on('click', 'a#desplegar', show_hide_advance_search);
	
	$('input#global_date').datepicker().on('changeDate', function() {
		new_date = $('#global_date').val();
		$(current_tab).trigger('click');
		$('.datepicker').datepicker('hide');
	});
	
});