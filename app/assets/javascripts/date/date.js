$(document).ready(function() {
	$('.datepicker').datepicker('setDate',new Date());

	$('.current_date').val($('#global_date').val());
});