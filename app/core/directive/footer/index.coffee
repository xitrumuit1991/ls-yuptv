_directive = ($timeout, ApiService) ->
  link = ($scope, $element, $attrs) ->
    return null

  directive =
    restrict : 'E'
    link : link
    templateUrl : '/templates/directive/footer/view.html'
  return directive
_directive.$inject = ['$timeout','ApiService']
angular
.module 'app'
.directive "footer", _directive

