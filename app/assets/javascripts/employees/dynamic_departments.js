function departmentSelected() {
  department_id = $('#employee_department_id').val();
  $('#employee_role_id').find('option').remove();
  $(roles).each(function() {
    if (this[0] == department_id) {
      $('#employee_role_id').append("<option value='" + this[2] + "'>" + this[1] + "</option>");
    } 
  });
}
$(document).ready(function() {
  departmentSelected();
  $('#employee_department_id').change(departmentSelected);
})