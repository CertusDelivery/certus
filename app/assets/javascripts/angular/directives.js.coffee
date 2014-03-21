app.directive('focusMe', ($timeout, $parse) ->
  link: (scope, element, attrs) ->
    model = $parse(attrs.focusMe)
    scope.$watch(model, (value) ->
      console.log('value=', value)
      if value == true
        $timeout( ->
          element[0].focus()
        )
    )
    element.bind('blur', ->
      console.log('blur')
      scope.$apply(model.assign(scope, false))
      console.log('focus')
      scope.$apply(model.assign(scope, true))
    )
)