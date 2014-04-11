@app = angular.module('certus', ['ngResource', 'ui.bootstrap', 'ngGrid'])

windowResize = ->
  scope = angular.element($('#picklist')[0]).scope()
  scope.$apply( ->
    if window.innerWidth > 768
      scope.gridOptions.$gridScope.columns[4].visible = true
    else
      scope.gridOptions.$gridScope.columns[4].visible = false
  )

$(document).ready -> 
  $(".print_button").click ->
    window.open($(this).attr("url"), 'printWindow','height=600,width=609,toolbar=no,menubar=no,scrollbars=yes, resizable=no,location=no, status=no')
  $("#history table tbody tr").click ->
    $("#history table tbody tr").removeClass 'selected'
    $(this).addClass 'selected'
  windowResize()
  window.onresize = windowResize
