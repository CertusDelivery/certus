app.directive('focusMe', ['$timeout', '$parse', ($timeout, $parse) ->
  link: (scope, element, attrs) ->
    model = $parse(attrs.focusMe)
    scope.$watch(model, (value) ->
      if value == true
        $timeout( ->
          element[0].focus()
        )
    )
    element.bind('blur', ->
      scope.$apply(model.assign(scope, false))
      scope.$apply(model.assign(scope, true))
    )
])