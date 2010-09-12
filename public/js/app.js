$(function() {
  Date.format = 'yyyy-mm-dd';
  $('input.date').datePicker({clickInput:true});
  
  // new flight form
  
  $('#flight_number').change(function() {
    var number = $(this).val();
    $('#flight_from, #flight_to').addClass('waiting');
    $.getJSON('/flights?number=' + number, function(flight) {
      $('#flight_from, #flight_to').removeClass('waiting');
      if(flight) {
        $('#flight_from').val(flight.from);
        $('#flight_to').val(flight.to);
      };
    })
  });
});