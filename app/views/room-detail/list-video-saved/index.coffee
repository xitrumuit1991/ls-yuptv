_directive = ($timeout, ApiService, UtilityService) ->
  link = ($scope, $element, $attrs) ->
    player = null
    $scope.modal =
      id : 'modal-video-saved'
      video:{}
      show : ()->
        angular.element("##{@.id}").modal('show')
      close : ()->
        angular.element("##{@.id}").modal('hide')
        player.stop() if _.isFunction(player.stop)
        player.destroy() if _.isFunction(player.destroy)
        player.pause() if _.isFunction(player.pause)
        player.dispose() if _.isFunction(player.dispose)
        angular.element("#div-player").html('')

    $scope.$on 'vjsVideoMediaChanged',  (e, data)->
      console.log('vjsVideoMediaChanged event was fired');

    $scope.listVideoSaved = []
    $scope.openModalVideo=(video)->
      console.log 'openModalVideo', video
      html = '<video style="width: 100% !important;" id="videojs-modal" controls="controls" preload="auto" width="600" height="400" autoplay="autoplay" class="video-js vjs-default-skin"></video>'
      angular.element("#div-player").html(html)
      $timeout(()->
        ApiService.room.getVideoDetailOfRoom {videoId : video.id, roomId: $scope.id },(err, result)->
          return if err
          return UtilityService.notifyError(result.message) if result and result.error
          return UtilityService.notifyError('Không thể lấy link play ') if !result.link and !result.link_play
          $scope.modal.video = result
          player = videojs('videojs-modal')
          if result.link_play
            player.src({src: (result.link_play) ,  type: "application/x-mpegURL"  })
          player.play()
          $scope.modal.show()
      ,100)


    params =
      page : 0
      limit : 1000
      roomId: $scope.id
    ApiService.getSavedVideo params , (err, result)->
      return if err
      $scope.listVideoSaved = result.videos
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

