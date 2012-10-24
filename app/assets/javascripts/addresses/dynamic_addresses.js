function provinceSelected() {
  province_id = $('#district_province_id').val();
  $('#district_canton_id').find('option').remove();
  $(cantons).each(function() {
    if (this[0] == province_id) {
      $('#district_canton_id').append("<option value='" + this[2] + "'>" + this[1] + "</option>");
    } 
  });
}
$(document).ready(function() {
  provinceSelected();
  $('#district_province_id').change(provinceSelected);
})