app.controller('PicklistCtrl', ['$scope', '$resource', ($scope, $resource) ->
  picklist = $resource('/api/deliveries/picklist.json')
  $scope.picklist = picklist.query()
  $scope.gridOptions = {
    data: 'picklist',
    columnDefs: [
      {field: 'picking_progress', displayName: 'Picking Progress'},
      {field: 'product_name', displayName: 'Product Name'},
      {field: 'shipping_weight', displayName: 'Shipping Weight'},
      {field: 'location', displayName: 'Location'},
      {field: 'delivery_id', displayName: 'Order ID'},
      {field: 'picked_status', displayName: 'Picked Status'},
      {field: 'picker_bin_number', displayName: 'Bin'},
      {field: 'store_sku', displayName: 'Store SKU'},
      {field: 'id', visible: false}
    ],
    multiSelect: false,
    enableHighlighting: true
  }

  unpicked_orders = $resource('/api/deliveries/unpicked_orders.json')
  $scope.unpicked_orders = unpicked_orders.query()

  $scope.focusScanner = true

  $scope.refreshUnpickedCount = ->
    $scope.unpicked_orders = unpicked_orders.query()

  $scope.loadNewOrder = ->
    loader = $resource('/api/deliveries/load_unpicked_order.json')
    $scope.picklist = loader.query()
    $scope.unpicked_orders = unpicked_orders.query()

  $scope.timer = ->
    today = new Date()
    $scope.time = today.toTimeString()

  $scope.time = $scope.timer()
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
])
