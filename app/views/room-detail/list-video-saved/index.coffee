_directive = ($timeout, ApiService, UtilityService) ->
  link = ($scope, $element, $attrs) ->
    $scope.modal =
      id : 'modal-video-saved'
      video:{}
      show : ()->
        angular.element("##{@.id}").modal('show')
      close : ()->
        angular.element("##{@.id}").modal('hide')

    $scope.mediaToggle = {
      sources: [
#        {
#          src: 'images/happyfit2.mp4',
#          type: 'video/mp4'
#        }
      ],
      tracks: [
#        {
#          kind: 'subtitles',
#          label: 'English subtitles',
#          src: 'assets/subtitles.vtt',
#          srclang: 'en',
#          default: true
#        }
      ],
      poster: 'images/screen.jpg'
    };

    $scope.$on('vjsVideoMediaChanged',  (e, data)->
      console.log('vjsVideoMediaChanged event was fired');
    )

    $scope.listVideoSaved = []
    $scope.openModalVideo=(video)->
      console.log 'openModalVideo', video
      $timeout(()->
        ApiService.room.getVideoDetailOfRoom({videoId : video.id, roomId: $scope.id },(err, result)->
          return if err
          return UtilityService.notifyError(result.message) if result and result.error
          return UtilityService.notifyError('Không thể lấy link play ') unless result.link
          $scope.modal.video = result
          $scope.modal.show()
          player = videojs('videojs-modal')
#          player.src({
#            type: "application/x-mpegURL"
#            src: result.linkPlayLive
#          })
#          player.play()
          player.src({src: result.link})
#          player.src(result.link)
          player.play()
        )
      ,1)


    params =
      page : 0
      limit : 1000
      roomId: $scope.id
    ApiService.getSavedVideo( params , (err, result)->
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

