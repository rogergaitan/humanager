$(".pagination a[href]").attr("data-remote", true);

$("#clean_button").on("click", function () {
  cleanSearch();
});

$("#work_benefits_type, #calculation_type, #state").on("change", function () {
  search();
}); 

function search () {
  $.ajax({
    url: "work_benefits/search",
    dataType: "script",
    data: {
      work_benefits_type: $("#work_benefits_type").val(),
      calculation_type: $("#calculation_type").val(),
      state: $("#state").val()
    }
  });
}

function cleanSearch() {
  $("#work_benefits_type, #calculation_type, #state").val("");
  
  $.ajax({
    url: "work_benefits/",
    dataType: "script"
  });
}
 
