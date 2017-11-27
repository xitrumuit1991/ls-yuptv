_directive = ($timeout, ApiService, UtilityService,$rootScope) ->
  link = ($scope, $element, $attrs) ->
    $scope.list = []
    $scope.item = {}
    $scope.modal =
      id : 'modal-lich-dien-room-detail'
      show : ()->
        angular.element("##{@.id}").modal('show')
      close : ()->
        angular.element("##{@.id}").modal('hide')


    $scope.clickFollowRoomInSchedule = ()->
      ApiService.followIdol({roomId: $scope.id}, (error, result)->
        return if error
        return if result and result.error
        UtilityService.notifySuccess(result.message)
        $scope.action() if _.isFunction($scope.action)
      )

    $rootScope.$on 'open-lich-dien-room-detail',(event, data)->
      $scope.item = data.item if data and data.item
      params =
        roomId : $scope.id
        type : 'all'
      ApiService.getScheduleOfRoom params, (error, result)->
        return console.error(result) if error
        return console.error(result) if result and result.error
        console.log 'scheduleOfRoom ',result
        $scope.list = result
        $scope.modal.show()

    return null
  directive =
    restrict : 'E'
    scope :
      id : '=ngModel'
      action : '=ngAction'
    link : link
    templateUrl : '/templates/room-detail/lich-dien/view.html'
  return directive
_directive.$inject = ['$timeout','ApiService' , 'UtilityService', '$rootScope']
angular
.module 'app'
.directive "lichDienRoomDetail", _directive

