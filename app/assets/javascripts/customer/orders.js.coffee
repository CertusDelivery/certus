$(document).ready -> 
  $('#customer_order_form select').change ->
    $('#customer_order_form').submit()
