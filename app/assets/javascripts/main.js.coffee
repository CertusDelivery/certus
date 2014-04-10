@app = angular.module('certus', ['ngResource', 'ui.bootstrap', 'ngGrid'])

$(document).ready -> 
  $(".print_button").click ->
    window.open($(this).attr("url"), 'printWindow','height=600,width=609,toolbar=no,menubar=no,scrollbars=yes, resizable=no,location=no, status=no')
  $("#history table tbody tr").click ->
    $("#history table tbody tr").removeClass 'selected'
    $(this).addClass 'selected'
