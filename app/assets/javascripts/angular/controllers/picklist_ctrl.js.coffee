app.controller('PicklistCtrl', ['$scope', '$resource', '$http', ($scope, $resource, $http) ->
  picklist = $resource('/api/deliveries/picklist.json')
  $scope.picklist = picklist.query()
  $scope.location_sort = 'asc'
  $scope.mySelections = []
  $scope.gridOptions = {
    data: 'picklist',
    columnDefs: [
      {field: 'picking_progress', displayName: 'Picking Progress'},
      {field: 'product_name', displayName: 'Product Name'},
      {field: 'shipping_weight', displayName: 'Shipping Weight'},
      {field: 'location', displayName: 'Location'},
      {field: 'delivery_id', displayName: 'Delivery ID'},
      {field: 'picked_status', displayName: 'Picked Status'},
      {field: 'picker_bin_number', displayName: 'Bin'},
      {field: 'store_sku', displayName: 'Store SKU'},
      {field: 'id', visible: false}
    ],
    selectedItems: $scope.mySelections,
    multiSelect: false,
    enableSorting: false,
    enableHighlighting: true
  }

  $scope.$on('ngGridEventData', ->
    $scope.gridOptions.selectRow(0, true)
  )

  $scope.refreshUnpickedCount = ->
    $http.get('/api/deliveries/unpicked_orders').success( (data) ->
      $scope.unpicked_count = data
    )

  $scope.loadNewOrder = ->
    loader = $resource('/api/deliveries/load_unpicked_order.json')
    $scope.picklist = loader.query()

  $scope.loadOrdersByLocation = ->
    loader = $resource('/api/deliveries/sort_picking_orders.json', {direction: $scope.location_sort})
    if $scope.location_sort == 'asc'
      $scope.location_sort = 'desc'
    else
      $scope.location_sort = 'asc'
    $scope.picklist = loader.query()


  $scope.timer = ->
    today = new Date()
    $scope.time = today.toTimeString()

  $scope.focusScanner = true
  $scope.refreshUnpickedCount()
  $scope.timer()
  setInterval(
    ->
      $('#current_time').click()
    1000
  )
  setInterval(
    ->
      $('#unpicked_order_count').click()
    5000
  )

  $scope.pickProduct = ()->
    $scope.errorMessage = ''
    $http.post('/api/delivery_items/pick.json',
       barcode: $scope.scannedBarcode
    ).success((data, status, headers, config) ->
      $scope.scannedBarcode = ''
    ).error((data, status) ->
      if data.status is 'nok'
        $scope.scannedBarcode = ''
        $scope.errorMessage = data.message
    )
])
