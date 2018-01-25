_directive = ($rootScope,$timeout, ApiService) ->
  link = ($scope, $element, $attrs) ->
    $scope.user = $rootScope.user
    return
  directive =
    restrict : 'E'
    scope :
      room : '=ngItem'
      indexRoom : '=ngIndexRoom'
      fnFollow : '=ngActionFollow'
      fnUnfollow : '=ngActionUnfollow'
    link : link
    templateUrl : '/templates/directive/roomInCategory/view.html'
  return directive
_directive.$inject = ['$rootScope', '$timeout','ApiService']
angular
.module 'app'
.directive "roomInCategory", _directive

