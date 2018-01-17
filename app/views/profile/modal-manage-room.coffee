ModalManageRoomController = ($scope,modalItem, $uibModalInstance, ApiService, $state, Facebook,UtilityService,cfpLoadingBar, $timeout) ->
  console.log 'modalItem',modalItem
  $scope.item = modalItem

  $scope.scheduleDate =
    opened: false
    start : if modalItem and modalItem.id then modalItem.start else null
#    end  : if modalItem and modalItem.id then modalItem.end else null

  $scope.addOrEdit = ()->
    params =
      start : (new Date($scope.scheduleDate.start)).getTime()/1000
      title : $scope.item.title
#      end : (new Date($scope.scheduleDate.end)).getTime()/1000
    if !$scope.item.id
      ApiService.addNewSchedule params, (error, result)->
        return if error
        return UtilityService.notifyError(result.message) if result and result.error
        UtilityService.notifySuccess('Thêm lịch diễn thành công')
        $scope.item.callback() if $scope.item and _.isFunction($scope.item.callback)
        $scope.cancel()
      return
    params.scheduleId = $scope.item.id
    ApiService.updateSchedule params, (error, result)->
      return if error
      return UtilityService.notifyError(result.message) if result and result.error
      UtilityService.notifySuccess('Cập nhật lịch diễn thành công')
      $scope.item.callback() if _.isFunction($scope.item.callback)
      $scope.cancel()
    return


  $scope.openDatePopup = () ->
    $scope.scheduleDate.opened = true

  $scope.cancel = ()->
    $uibModalInstance.dismiss 'cancel'
    return
  return

ModalManageRoomController.$inject = ['$scope', 'modalItem', '$uibModalInstance', 'ApiService', '$state', 'Facebook',
  'UtilityService', 'cfpLoadingBar', '$timeout'
]

angular
.module("app")
.controller "ModalManageRoomController", ModalManageRoomController