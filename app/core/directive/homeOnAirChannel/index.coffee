_directive = ($timeout, ApiService) ->
  link = ($scope, $element, $attrs) ->
    $scope.listOnAir = []
    ApiService.getRoomOnAir {onair :true, onAir: true},(error, result)->
      return if error
      return if result and result.rooms and result.rooms.length <= 0
      $scope.listOnAir = result.rooms
      console.info 'home on air Directive=',result

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

