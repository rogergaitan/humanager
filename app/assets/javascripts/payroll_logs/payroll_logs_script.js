$(jQuery(document).ready(function($) {
	
	//generates the treeview with the different accounts
	//populates the filter for employees
	populateEmployeesFilter('fetch_employees', 'load_filter_employees_text', 'load_filter_employees_id');

	//allows expand the treeview
	$('#list').on("click", "span.expand_tree", treeviewhr.expand);
	
	//delete the treeview after the user clicks on close
	$('button.delete-accounts').click(function() {
		$('#list').empty();
	});	
	
	//allows add the selected account to the textfield	
  $('#list').on({
		click: set_account,
		mouseenter: function() {
			$(this).css("text-decoration", "underline");
		},
		mouseleave: function() {
			$(this).css("text-decoration", "none");
		}}, ".node_link");
		
	//executes different options to select the employees
	$('input[name=select_method]').change(function() {
		selectEmployeesLeft($(this));
	});
	
	$('div.options-right input[name=check-employees-right]').change(selectEmployeesRight);
	
	//when the employees are loaded in the page move the selected to the right
	moveEmployees();
	
	//moves the selected employees to the list at the right
	$('#add-to-list').click(moveToRight);
	$('#remove-to-list').click(moveToLeft);
	
	$('#departments_employees').change(function() {
		filterDepartment($(this).val());
		});
	
	$('#superiors_employees').change(function() {
		filterSuperior($(this).val());
	});
	
	$('div#marcar-desmarcar input[name=check-employees]').change(marcarDesmarcar);
}));