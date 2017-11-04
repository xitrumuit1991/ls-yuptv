_directive = ($timeout, ApiService, UtilityService) ->
  link = ($scope, $element, $attrs) ->
    $scope.modal =
      id : 'modal-video-saved'
      video:{}
      show : ()->
        angular.element("##{@.id}").modal('show')
      close : ()->
        angular.element("##{@.id}").modal('hide')

    $scope.listVideoSaved = []
    $scope.openModalVideo=(video)->
      console.log 'openModalVideo', video
      $timeout(()->
        ApiService.room.getVideoDetailOfRoom({videoId : video.id, roomId: $scope.id },(err, result)->
          return if err
          return UtilityService.notifyError(result.message) if result and result.error
          $scope.modal.video = result
          $scope.modal.show()
        )
      ,1)

    ApiService.getSavedVideo({}, (err, result)->
      return if err
      $scope.listVideoSaved = result.videos
    )
    return null

  directive =
    restrict : 'E'
    scope :
      id : '=ngModel'
    link : link
    templateUrl : '/templates/room-detail/list-video-saved/view.html'
  return directive
_directive.$inject = ['$timeout','ApiService' , 'UtilityService']
angular
.module 'app'
.directive "listVideoSaved", _directive

