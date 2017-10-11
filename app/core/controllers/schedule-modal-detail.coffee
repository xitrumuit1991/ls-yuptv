ScheduleModalDetailController = ($scope,modalItem, $modalInstance, ApiService, $state, Facebook,UtilityService,cfpLoadingBar) ->
  console.log 'modalItem',modalItem

  $scope.list = []
  $scope.item = modalItem

  params =
    roomId : $scope.item.id
    type : 'all'
  ApiService.getScheduleOfRoom params, (error, result)->
    return console.error(result) if error
    return console.error(result) if result and result.error
    console.log 'scheduleOfRoom ',result
    $scope.list = result

  $scope.clickFollowRoomInSchedule = (item)->
    console.log 'clickFollowRoomInSchedule', item
    ApiService.followIdol({roomId:item.id}, (error, result)->
      return if error
      return if result and result.error
      UtilityService.notifySuccess(result.message)
    )

  $scope.cancel = ()->
    console.log 'cancel'
    $modalInstance.dismiss 'cancel'
    return
  return

ScheduleModalDetailController.$inject = ['$scope', 'modalItem', '$modalInstance', 'ApiService', '$state', 'Facebook',
  'UtilityService', 'cfpLoadingBar'
]

angular
.module("app")
.controller "ScheduleModalDetailController", ScheduleModalDetailController