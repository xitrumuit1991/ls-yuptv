ModalManageRoomController = ($scope,modalItem, $uibModalInstance, ApiService, $state, Facebook,UtilityService,cfpLoadingBar, $timeout) ->
  console.log 'modalItem',modalItem
  $scope.item = modalItem

  $scope.scheduleDate =
    opened: false
    start : null
    end  : null

  $scope.addOrEdit = ()->
    params =
      start : ''
      end : ''

  $scope.openDatePopup = () ->
    console.log 'openDatePopup'
    $scope.scheduleDate.opened = true

  $scope.cancel = ()->
    console.log 'cancel'
    $uibModalInstance.dismiss 'cancel'
    return
  return

ModalManageRoomController.$inject = ['$scope', 'modalItem', '$uibModalInstance', 'ApiService', '$state', 'Facebook',
  'UtilityService', 'cfpLoadingBar', '$timeout'
]

angular
.module("app")
.controller "ModalManageRoomController", ModalManageRoomController