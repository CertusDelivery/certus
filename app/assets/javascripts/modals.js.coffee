$(document).ready -> 
  $(".print_button").click ->
    window.open($(this).attr("url"), 'printWindow','height=600,width=609,toolbar=no,menubar=no,scrollbars=yes, resizable=no,location=no, status=no')
  $(".link_button").click ->
    window.location.href = $(this).attr("url")
  $(".table-selected tbody tr").click ->
    $(".table-selected tbody tr").removeClass 'selected'
    $(this).addClass 'selected'