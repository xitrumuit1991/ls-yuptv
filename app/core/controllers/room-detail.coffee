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
  socket = null
  $scope.linkShareFacebook = "/room-detail/#{id}"
  $scope.loadedRoomDetail = false
  $scope.socketIsConnected = false
  $scope.roomNowLivestream = false
  $scope.showHeartAnimation = false
  $scope.linkPlayLive = ''
  $scope.id = $stateParams.id
  $scope.item = {}
  $scope.giftList =
    items : []

  $scope.getRoomDetail = (cb)->
    ApiService.room.getRoomById {roomId : $scope.id },(err, result)->
      return if err
      $scope.item = result
      cb() if _.isFunction(cb)

  $scope.openLichDien = ()->
    $rootScope.$emit 'open-lich-dien-room-detail', {item : $scope.item}

  $scope.clickSendHeart=()->
    param =
      roomId : if $scope.item then $scope.item.id else ''
    ApiService.room.sendHeart param, (err, result)->
      return if err
      return UtilityService.notifyError(result.message) if result and result.error
      $('#room-heart-number').text(result.total_heart) if result


  $scope.openListGift = ()->
#    console.log 'openListGift', param
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
#      console.log '$scope.giftList',$scope.giftList


  $scope.buyTicket = ()->
    return console.log 'buyTicket user not login' if !$rootScope.user or !$scope.item
    return unless confirm('Xác nhận mua vé!')
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
  $scope.initChatIcon = ()->
    window.emojiPicker = new EmojiPicker({
      emojiable_selector: '[data-emojiable=true]',
      assetsPath: 'img/',
      popupButtonClasses: 'fa fa-smile-o'
    })
    window.emojiPicker.discover()

  $scope.joinRoom = ()->
    $timeout(()->
      console.error 'init emoji-wysiwyg-editor'
      $('.emoji-wysiwyg-editor').keyup (e)->
        $scope.sendChatMsg() if e.keyCode == 13
    ,2000)
    return UtilityService.notifyError('Phòng này chưa diễn. Bạn vui lòng quay lại sao ') if $scope.item and !$scope.item.Session
    console.error 'user chua login' unless $rootScope.user
    paramJoin =
      roomId : $scope.id
      sessionId: if $scope.item and $scope.item.Session then $scope.item.Session.id else ''
      userId : if $rootScope.user then $rootScope.user.id else ''
#    console.log 'paramJoin',paramJoin
    ApiService.room.joinRoom paramJoin,(err, result)->
      $scope.loadedRoomDetail = true
      return if err
      return UtilityService.notifyError(result.message) if result and result.error
      return if !result.linkPlayLive
      $scope.roomNowLivestream = true
      player = videojs('videojs-room-detail-main')
      $scope.linkPlayLive = result.linkPlayLive
      player.src({ type: "application/x-mpegURL", src: $scope.linkPlayLive })
      player.play()
      player.on 'ended', ()->
        console.log 'ended'

      player.on 'error', (error)->
        console.log 'error',error

      player.on 'loadeddata', (loadeddata)->
        console.log 'loadeddata',loadeddata

      player.on 'loadedmetadata', (loadedmetadata)->
        console.log 'loadedmetadata',loadedmetadata

      player.on 'timeupdate', (timeupdate)->
#        console.log 'timeupdate',timeupdate
#      player.on 'useractive', (useractive)->
#        console.log 'useractive',useractive
#      player.on 'userinactive', (userinactive)->
#        console.log 'userinactive',userinactive
#
      player.on 'volumechange', (volumechange)->
        console.log 'volumechange',volumechange










  $scope.showUserConnectSocket = (data)->
#    console.log 'showUserConnectSocket', data
    html = '<div class="item"><p style="color: #fff;text-align: right;"><i style="color: #1c8abf; font-size: 18px;" class="fa fa-bicycle" aria-hidden="true"></i> '+data.message+'</p></div>'
    $('#content-chat-list').append(html)
    if $('#content-chat-list')[0]
      $('#content-chat-list').animate({ scrollTop: $('#content-chat-list')[0].scrollHeight }, 100)

  $scope.showUserDisConnectSocket = (data)->
#    console.log 'showUserDisConnectSocket', data
    html = '<div class="item"><p style="color: #fff; text-align: right;"><i style="color: #ff1c29;font-size: 18px;" class="fa fa-sign-out" aria-hidden="true"></i> '+data.message+'</p></div>'
    $('#content-chat-list').append(html)
    if $('#content-chat-list')[0]
      $('#content-chat-list').animate({ scrollTop: $('#content-chat-list')[0].scrollHeight }, 100)

  $scope.showReciveHeartSocket = (data)->
    message = '<span>'+data.message+'</span> <i style="color: #ff2491;" class="fa fa-heart" aria-hidden="true"></i>'
    re = new RegExp('<br>', 'g')
    message = message.replace(re, '')
    return unless message
    html = '<div class="item showReciveHeartSocket"><p class="text-right">'+message+'</p></div>'
    $('#content-chat-list').append(html)
    if $('#content-chat-list')[0]
      $('#content-chat-list').animate({ scrollTop: $('#content-chat-list')[0].scrollHeight }, 100)


  $scope.showNewCommentSocket = (data)->
    avatar = data.user.avatar || "http://via.placeholder.com/40x40"
    name = data.user.name
    message = data.message
    re = new RegExp('<br>', 'g')
    message = message.replace(re, '')
    return unless message
    name = "Me" if data and data.user.id == $rootScope.user.id
    html = '<div class="item"><img src="'+avatar+'" style="width:40px; height: 40px;" class="image"/> <div class="group-name"> <div class="name">'+name+'</div> <div class="subname">'+message+'</div></div> </div>'
    $('#content-chat-list').append(html)
    if $('#content-chat-list')[0]
      $('#content-chat-list').animate({ scrollTop: $('#content-chat-list')[0].scrollHeight }, 100)

  $scope.sendChatMsg = ()->
    message = $('.emoji-wysiwyg-editor').html()
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
  querySocket = {query : "Authorization=#{window.localStorage.token}&roomId=#{$scope.id}", 'forceNew': true, 'force new connection': true }
  socket = io( GlobalConfig.SOCKET_DOMAIN, querySocket)
  socket.on 'connect', ()->
    console.warn "socket.on 'connect'"

  socket.on "isConnected", ()->
    console.info 'socket isConnected'
    $scope.socketIsConnected = true

  socket.on 'newComment', (data)->
#    console.info "newComment",data
    $scope.showNewCommentSocket(data)


  socket.on 'connectUser', (data)->
    console.log 'connect User',data
#    UtilityService.notifySuccess(data.message) if data
    $scope.showUserConnectSocket(data)
    $rootScope.$emit 'reload-user-in-room'

  socket.on 'disconnectUser', (data)->
    console.error 'disconnect User',data
#    UtilityService.notifyError(data.message) if data
    $scope.showUserDisConnectSocket(data)
    $rootScope.$emit 'reload-user-in-room'

  socket.on 'notification', (data)->
    console.error 'notification',data

  socket.on 'sendGift', (data)->
    console.log 'sendGift',data
    avatar = data.user.avatar || "http://via.placeholder.com/40x40"
    name = data.user.name
    message = data.message+' <img style="width:20px; height:20px;" src="'+data.giftIcon+'"/>'
    re = new RegExp('<br>', 'g')
    message = message.replace(re, '')
    return unless message
    html = '<div class="item"><img src="'+avatar+'" style="width:40px; height: 40px;" class="image"/> <div class="group-name"> <div class="name">'+name+'</div> <div class="subname">'+message+'</div></div> </div>'
    $('#content-chat-list').append(html)
    $('#content-chat-list').animate({ scrollTop: $('#content-chat-list')[0].scrollHeight }, 100)

  socket.on 'sendHeart', (data)->
    console.log 'sendHeart',data
    $scope.showReciveHeartSocket(data)
#    $scope.showHeartAnimation = true
#    $('#heart-animation').show()
#    $rootScope.$emit 'fly-heart',()->
#      $scope.showHeartAnimation = false
#      $('#heart-animation').hide()

  socket.on 'disconnect', ()->
    console.error 'socket disconnect'
    $scope.socketIsConnected = false
    socket.removeAllListeners('sendHeart');
    socket.removeAllListeners('sendGift');
    socket.removeAllListeners('connectUser');
    socket.removeAllListeners('newComment');
    socket.removeAllListeners('disconnectUser');
    socket.removeAllListeners('disconnect');
    io.removeAllListeners('connection');





  $scope.$on '$destroy', ()->
    console.log '$destroy room detail'
    if socket
      console.log 'remove socket', socket
      socket.removeListener('sendHeart');
      socket.removeListener('sendGift');
      socket.removeListener('connectUser');
      socket.removeListener('newComment');
      socket.removeListener('disconnectUser');
      socket.removeListener('disconnect');
      socket.off('sendHeart')
      socket.off('sendGift')
      socket.off('connectUser')
      socket.off('newComment')
      socket.off('disconnectUser')
      socket.disconnect()
      socket.disconnect(true)
      socket.removeAllListeners()
      socket = null
    if player
      player.pause() if _.isFunction(player.pause)
      player.dispose() if _.isFunction(player.dispose)
      console.log '$destroy room detail player.dispose()'
    if(videojs.getPlayers()['videojs-room-detail-main'])
      console.log '$destroy room detail delete videojs.getPlayers'
      delete videojs.getPlayers()['videojs-room-detail-main']

  #call api
  $scope.getRoomDetail ()->
    $scope.initChatIcon()
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
