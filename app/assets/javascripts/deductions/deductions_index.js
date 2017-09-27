$(".pagination a[href]").attr("data-remote", true);

$("#clean_button").on("click", function () {
  cleanSearch();
});

$("#deduction_type, #calculation_type, #state").on("change", function () {
  search();
}); 

function search () {
  $.ajax({
    url: "deductions/search",
    dataType: "script",
    data: {
      deduction_type: $("#deduction_type").val(),
      calculation_type: $("#calculation_type").val(),
      state: $("#state").val()
    }
  });
}

function cleanSearch() {
  $("#deduction_type, #calculation_type, #state").val("");
  
  $.ajax({
    url: "deductions/",
    dataType: "script"
  });
}
