_directive = ($timeout, ApiService) ->
  link = ($scope, $element, $attrs) ->
    $scope.listOnAir = []
    ApiService.getRoomOnAir({},(error, result)->
      return if error
      return if result.rooms.length <= 0
      $scope.listOnAir = result.rooms
    )
    return null

  directive =
    restrict : 'E'
    link : link
    templateUrl : '/templates/directive/homeOnAirChannel/view.html'
  return directive
_directive.$inject = ['$timeout','ApiService']
angular
.module 'app'
.directive "homeOnAirChannel", _directive

