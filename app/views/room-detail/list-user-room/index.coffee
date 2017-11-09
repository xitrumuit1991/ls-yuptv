_directive = ($rootScope, $timeout, ApiService, UtilityService) ->
  link = ($scope, $element, $attrs) ->
    $scope.users = null

    $scope.$watch 'id',(data)->
      ApiService.room.listUserInRoom {roomId : $scope.id},(err, result)->
        return if err
        return if result and result.error
        $scope.users = result.items
        console.log '$scope.users',$scope.users


    $rootScope.$on 'reload-user-in-room',(event)->
      ApiService.room.listUserInRoom {roomId : $scope.id},(err, result)->
        return if err
        return if result and result.error
        $scope.users = result.items


    return
  directive =
    restrict : 'E'
    scope :
      id : '=ngModel'
    link : link
    templateUrl : '/templates/room-detail/list-user-room/view.html'
  return directive
_directive.$inject = ['$rootScope', '$timeout','ApiService' , 'UtilityService']
angular
.module 'app'
.directive "listUserRoom", _directive

