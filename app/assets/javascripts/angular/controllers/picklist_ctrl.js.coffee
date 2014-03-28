app.controller('PicklistCtrl', ['$scope', '$resource', '$http', ($scope, $resource, $http) ->
  picklist = $resource('/api/deliveries/picklist.json')
  $scope.picklist = picklist.query()
  $scope.location_sort = 'asc'
  $scope.mySelections = []
  cellEditableTemplate = "<input ng-class=\"'colt' + col.index\" ng-input=\"COL_FIELD\" ng-model=\"COL_FIELD\" ng-change=\"updateEntity(row.entity)\" />"
  $scope.gridOptions = {
    data: 'picklist',
    columnDefs: [
      {field: 'picking_progress', displayName: 'Qty', width: '10%'},
      {field: 'product_name', displayName: 'Product', width: '40%'},
      {field: 'shipping_weight', visible: false},
      {field: 'location', displayName: 'Location', sortable: false, enableCellEdit: true, editableCellTemplate: cellEditableTemplate, width: '15%'},
      {field: 'delivery_id', displayName: 'ID', width: '10%'},
      {field: 'picked_status', displayName: 'Status', width: '10%'},
      {field: 'store_sku', displayName: 'SKU', width: '15%'},
      {field: 'id', visible: false}
    ],
    selectedItems: $scope.mySelections,
    multiSelect: false,
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
    $scope.notice = ''
    $scope.errorMessage = ''
    loader = $resource('/api/deliveries/load_unpicked_order.json')
    $scope.picklist = loader.query()
    $scope.refreshUnpickedCount()

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

  # operation_code: 1 -> normal, 2 -> out of stock
  $scope.pickProduct = (operation_code) ->
    $scope.notice = ''
    $scope.errorMessage = ''
    barcode = $scope.scannedBarcode
    deliveryItem = $scope.mySelections[0]
    if deliveryItem.picking_progress.split('/')[2] isnt '0'
      $scope.substituteProduct(deliveryItem.id, deliveryItem.product_name, barcode)
      return
    barcode = "OUT_OF_STOCK" if operation_code == 2
    return false unless barcode
    $http.post('/api/delivery_items/pick.json',
       barcode: barcode,
       id: deliveryItem.id,
       delivery_id: deliveryItem.delivery_id,
       operation_code: operation_code
    ).success((data) ->
      $scope.scannedBarcode = ''
      $scope.notice = data.message if data.message
      if data.remove_completed_delivery
        $scope.picklist = picklist.query()
      else
        angular.forEach $scope.picklist, (row, index) ->
          if row.id == data.id
            $scope.picklist[index].picking_progress = data.delivery_item.picking_progress
            $scope.picklist[index].picked_status = data.delivery_item.picked_status
            $scope.gridOptions.selectItem(index, true)
            $('.ngGrid').find('.selected').fadeTo('fast',0).fadeTo('fast',1)
            if data.delivery_item.picked_status is 'PICKED'
              $scope.gridOptions.selectItem(index+1, true)
    ).error((data) ->
      if data.status is 'nok'
        $scope.scannedBarcode = ''
        $scope.errorMessage = data.message
    )

  $scope.markAsOutOfStock = ->
    $scope.pickProduct(2)

  $scope.substituteProduct = (deliveryItemID, deliveryItemName, productBarcode) ->
    # product = $source('').query()
    # mock here
    product = { id: 1, name: "Alternative Product" }
    ensureMsg = 'Are you sure to substitude ' + product.name + ' for ' + deliveryItemName + '?'
    if confirm ensureMsg
      $http.post('api/delivery_items/'+deliveryItemID+'/substitute.json',
        produt_id: product.id
      ).success((data) ->
        alert(data.message)
      )


  $scope.removePickedOrders = ->
    $scope.notice = ''
    $scope.errorMessage = ''
    $http.delete('/api/deliveries/remove_picked_orders.json'
    ).success((data) ->
      $scope.notice = data.message if data.message
      $scope.picklist = picklist.query()
    )

  $scope.updateEntity = (row) ->
    #update, note
    #$scope.focusScanner = true
    #alert "Pending... value = " + row.location
    return

])
