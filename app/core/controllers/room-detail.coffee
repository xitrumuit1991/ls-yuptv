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
ctrl = ($rootScope, $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval, UtilityService) ->
  id = $stateParams.id
  player = null
  $scope.socketIsConnected = false
  $scope.roomNowLivestream = false
  $scope.showHeartAnimation = false
  $scope.linkPlayLive = ''
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
      cb() if _.isFunction(cb)

  $scope.openLichDien = ()->
    $rootScope.$emit 'open-lich-dien-room-detail', {item : $scope.item}

  $scope.openListGift = ()->
    console.log 'openListGift', param
    param =
      items : $scope.giftList.items
      action : (item, cb=null )->
        return unless confirm('Tặng quà cho idol ?')
        paramsend =
          userId: if $rootScope.user then $rootScope.user.id else ''
          giftId: item.id
          quantity:1
          sessionId: if $scope.item.Session then $scope.item.Session.id else ''
        ApiService.room.sendGift paramsend,(err, result)->
          return if err
          return UtilityService.notifyError(result.message) if result and result.error
          UtilityService.notifySuccess('Tặng quà thành công ')
          cb() if _.isFunction(cb)
    $rootScope.$emit 'open-list-gift', param

  $scope.getListGift = ()->
    ApiService.room.giftList {page:0, limit:1000},(err, result)->
      return if err
      $scope.giftList.items = result.items
      console.log '$scope.giftList',$scope.giftList


  $scope.buyTicket = ()->
    return console.log 'buyTicket user not login' if !$rootScope.user or !$scope.item
    paramBuy =
      roomId : if $scope.item then $scope.item.id else ''
      sessionId: if $scope.item and $scope.item.Session then $scope.item.Session.id else ''
    ApiService.room.buyTicket paramBuy,(err, result)->
      return if err
      return UtilityService.notifyError(result.message) if result and result.error
      UtilityService.notifySuccess('Mua vé thành công') if result
      $state.reload()




  #room
  #room
  #room
  #room
  #room
  onLoadPlayer = (data)->
    console.error 'on onLoadPlayer player', data
  onPausePlayer = (data)->
    console.error 'on onPausePlayer player', data
  onPlayPlayer = (data)->
    console.error 'on onPlayPlayer player', data
  onErrorPlayer = (data)->
    console.error 'on error player', data

  $scope.joinRoom = ()->
    return UtilityService.notifyError('Phòng này chưa diễn. Bạn vui lòng quay lại sao ') if $scope.item and !$scope.item.Session
    console.error 'user chua login' unless $rootScope.user
    paramJoin =
      roomId : $scope.id
      sessionId: if $scope.item and $scope.item.Session then $scope.item.Session.id else ''
      userId : if $rootScope.user then $rootScope.user.id else ''
    console.log 'paramJoin',paramJoin
    ApiService.room.joinRoom paramJoin,(err, result)->
      return if err
      return UtilityService.notifyError(result.message) if result and result.error
      return if !result.linkPlayLive
      $scope.roomNowLivestream = true
      player = videojs('videojs-room-detail-main')
      $scope.linkPlayLive = result.linkPlayLive
      player.src({ type: "application/x-mpegURL", src: $scope.linkPlayLive })
      player.play()
      player.on 'error', onErrorPlayer






  $timeout(()->
    console.log 'init emoji-wysiwyg-editor'
    $('.emoji-wysiwyg-editor').keyup (e)->
      $scope.sendChatMsg() if e.keyCode == 13
  ,2000)


  $scope.showUserConnectSocket = (data)->
    console.log 'showUserConnectSocket', data
    html = '<div class="item"><p style="color: #fff;text-align: right;"><i style="color: #1c8abf; font-size: 18px;" class="fa fa-bicycle" aria-hidden="true"></i> '+data.message+'</p></div>'
    $('#content-chat-list').append(html)
    $('#content-chat-list').animate({ scrollTop: $('#content-chat-list')[0].scrollHeight }, 100)

  $scope.showUserDisConnectSocket = (data)->
    console.log 'showUserDisConnectSocket', data
    html = '<div class="item"><p style="color: #fff; text-align: right;"><i style="color: #ff1c29;font-size: 18px;" class="fa fa-sign-out" aria-hidden="true"></i> '+data.message+'</p></div>'
    $('#content-chat-list').append(html)
    $('#content-chat-list').animate({ scrollTop: $('#content-chat-list')[0].scrollHeight }, 100)

  $scope.showReciveHeartSocket = (data)->
    avatar = data.user.avatar || "http://via.placeholder.com/40x40"
    name = data.user.name
    message = data.message+' <i style="color: #ff2491;" class="fa fa-heart" aria-hidden="true"></i>'
    re = new RegExp('<br>', 'g')
    message = message.replace(re, '')
    return unless message
    html = '<div class="item"><p>'+message+'</p></div>'
    $('#content-chat-list').append(html)
    $('#content-chat-list').animate({ scrollTop: $('#content-chat-list')[0].scrollHeight }, 100)


  $scope.sendChatMsg = ()->
    message = $('.emoji-wysiwyg-editor').html()
    return unless message
    re = new RegExp('<br>', 'g');
    message = message.replace(re, '')
    return unless message
    socket.emit('comment', message)
    $('.emoji-wysiwyg-editor').html('')


  #socket
  #socket
  #socket
  #socket
  #socket
  #socket
  querySocket = {query : "Authorization=#{window.localStorage.token}&roomId=#{$scope.id}"}
  socket = io( GlobalConfig.SOCKET_DOMAIN, querySocket)
  socket.on 'connect', ()->
    console.warn "socket.on 'connect'"

  socket.on "isConnected", ()->
    console.info 'socket isConnected'
    $scope.socketIsConnected = true

  socket.on 'newComment', (data)->
    console.info "newComment",data
    avatar = data.user.avatar || "http://via.placeholder.com/40x40"
    name = data.user.name
    message = data.message
    return unless message
    re = new RegExp('<br>', 'g');
    message = message.replace(re, '');
    return unless message
    name = "Me" if data and data.user.id == $rootScope.user.id
    html = '<div class="item"><img src="'+avatar+'" style="width:40px; height: 40px;" class="image"/> <div class="group-name"> <div class="name">'+name+'</div> <div class="subname">'+message+'</div></div> </div>'
    $('#content-chat-list').append(html)
    $('#content-chat-list').animate({ scrollTop: $('#content-chat-list')[0].scrollHeight }, 100)

  socket.on 'connectUser', (data)->
    console.log 'connect User',data
#    UtilityService.notifySuccess(data.message) if data
    $scope.showUserConnectSocket(data)
    $rootScope.$emit 'reload-user-in-room'

  socket.on 'disconnectUser', (data)->
    console.log 'disconnect User',data
#    UtilityService.notifyError(data.message) if data
    $scope.showUserDisConnectSocket(data)
    $rootScope.$emit 'reload-user-in-room'

  socket.on 'notification', (data)->
    console.log 'notification',data

  socket.on 'sendGift', (data)->
    console.log 'sendGift',data
    avatar = data.user.avatar || "http://via.placeholder.com/40x40"
    name = data.user.name
    message = data.message +' <img style="width:10px; height:10px;" src="'+data.giftIcon+'"/>'
    return unless message
    re = new RegExp('<br>', 'g');
    message = message.replace(re, '');
    return unless message
    html = '<div class="item"><img src="'+avatar+'" style="width:40px; height: 40px;" class="image"/> <div class="group-name"> <div class="name">'+name+'</div> <div class="subname">'+message+'</div></div> </div>'
    $('#content-chat-list').append(html)
    $('#content-chat-list').animate({ scrollTop: $('#content-chat-list')[0].scrollHeight }, 100)

  socket.on 'sendHeart', (data)->
    console.log 'sendHeart',data
    $scope.showHeartAnimation = true
    $rootScope.$emit 'fly-heart',()->
      $scope.showHeartAnimation = false
    $scope.showReciveHeartSocket(data)

  socket.on 'disconnect', ()->
    console.log 'socket disconnect'
    $scope.socketIsConnected = false


  window.emojiPicker = new EmojiPicker({
    emojiable_selector: '[data-emojiable=true]',
    assetsPath: 'img/',
    popupButtonClasses: 'fa fa-smile-o'
  })
  window.emojiPicker.discover()



  #call api
  $scope.getRoomDetail ()->
    $scope.getListGift()
    $scope.joinRoom()

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval', 'UtilityService'
]
angular
.module("app")
.config route
.controller "RoomDetailCtrl", ctrl
