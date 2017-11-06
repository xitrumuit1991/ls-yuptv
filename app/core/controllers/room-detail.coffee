"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.room-detail",
    url : "room-detail/:id"
    views :
      "main@" :
        templateUrl : "/templates/room-detail/view.html"
        controller : "RoomDetailCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval, UtilityService) ->
  console.log 'RoomDetailCtrl coffee ',$stateParams.id
  id = $stateParams.id
  player = videojs('videojs-room-detail-main')
  $scope.id = $stateParams.id
  $scope.item = {}
  $scope.ticketList =
    items : []
    totalItems:0
    currentPage:0
  $scope.giftList =
    items : []
    totalItems:0
    currentPage:0

  $scope.getRoomDetail = (cb)->
    ApiService.room.getRoomById {roomId : $scope.id },(err, result)->
      return if err
      $scope.item = result
      console.log 'getRoomById',$scope.item
      cb()


  $scope.openLichDien = ()->
    param =
      item : $scope.item
    $rootScope.$emit 'open-lich-dien-room-detail', param

  $scope.openListGift = ()->
    param =
      items : $scope.giftList.items
      action : (item)->
        console.log 'click action', item
    console.log 'openListGift', param
    $rootScope.$emit 'open-list-gift', param

  $scope.getListGift = ()->
    ApiService.room.giftList({page:0, limit:1000},(err, result)->
      return if err
      $scope.giftList.items = result.items
      console.log '$scope.giftList',$scope.giftList
    )

  $scope.getListTicket = ()->
    ApiService.room.ticketList({page:0, limit:1000},(err, result)->
      return if err
      $scope.ticketList = result
      console.log '$scope.ticketList',$scope.ticketList
    )


  $scope.joinRoom = ()->
    paramJoin =
      roomId:$scope.id
      sessionId: $scope.item.Session.id
      userId : if $rootScope.user then $rootScope.user.id else ''
    ApiService.room.joinRoom(paramJoin,(err, result)->
      return if err
      return UtilityService.notifyError(result.message) if result and result.error
      console.log "ApiService.room.joinRoom", result

      player.src(result.linkPlayLive)
      player.play()
    )

  socket = io(GlobalConfig.SOCKET_DOMAIN, { query: { Authorization: localStorage.token, roomId: $scope.id } })
  socket.on 'connect', ()->
    console.warn "socket.on 'connect'"
    socket.emit('comment', {msg: 'new msg from room detail', user: $rootScope.user })
    ApiService.room.listUserInRoom({roomId : $scope.id},(err, result)->
      return if err
      console.log 'listUserInRoom', result
    )

  $scope.chat = (msg)->
    param =
      msg:msg
    socket.emit('comment', param)

  socket.on 'newComment', (data)->
    console.info "newComment",data

  socket.on 'connectUser', (data)->
    console.log 'connectUser',data

  socket.on 'notification', (data)->
    console.log 'notification',data

  socket.on 'sendGift', (data)->
    console.log 'sendGift',data

  socket.on 'sendHeart', (data)->
    console.log 'sendHeart',data

  socket.on 'disconnectUser', (data)->
    console.log 'disconnectUser',data

  socket.on 'disconnect', ()->
    console.log 'socket disconnect'



  window.emojiPicker = new EmojiPicker({
    emojiable_selector: '[data-emojiable=true]',
    assetsPath: 'img/',
    popupButtonClasses: 'fa fa-smile-o'
  })
  window.emojiPicker.discover()


  $scope.getRoomDetail(()->
    $scope.getListGift()
    $scope.getListTicket()
    $scope.joinRoom()
  )

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval', 'UtilityService'
]
angular
.module("app")
.config route
.controller "RoomDetailCtrl", ctrl
