ScheduleModalDetailController = ($scope,modalItem, $modalInstance, ApiService, $state, Facebook,UtilityService,cfpLoadingBar) ->
  console.log 'modalItem',modalItem
  $scope.item = modalItem
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