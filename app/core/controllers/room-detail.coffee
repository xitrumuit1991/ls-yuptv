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
  $scope.linkShareFacebook = "http://yuptv.vn/room-detail/#{id}"
  $scope.loadedRoomDetail = false
  $scope.socketIsConnected = false
  $scope.roomNowLivestream = false
  $scope.showHeartAnimation = false
  $scope.linkPlayLive = ''
  $scope.id = $stateParams.id
  $scope.item = null
  $scope.category = null
  $scope.roomNowOnAir = null
  $scope.giftList =
    items : []

  $scope.getRoomDetail = (cb)->
    ApiService.room.getRoomById {roomId : $scope.id },(err, result)->
      return if err
      $scope.item = result
      $scope.loadedRoomDetail = true
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
      $scope.showHeartAnimation = true
      $rootScope.$emit 'fly-heart',()->
        $scope.showHeartAnimation = false


  showSendGiftSuccess = (itemGift, resultApi)->
    iconGift = itemGift.icon or itemGift.icons.icon or "http://via.placeholder.com/20x20"
    message = "Bạn vừa gửi tặng "
    html = '<div class="item text-right"><div class="group-name"><div class="text-right text-success bold">'+message+'<img style="width:20px;height:20px;" src="'+iconGift+'" /></div></div></div>'
    $('#content-chat-list').append(html)
    if $('#content-chat-list')[0]
      $('#content-chat-list').animate({ scrollTop: $('#content-chat-list')[0].scrollHeight }, 100)

  $scope.openListGift = ()->
    param =
      items : $scope.giftList.items
      action : (item, cb=null )->
        console.log 'click item gift',item
        return unless confirm('Tặng quà cho idol ?')
        paramsend =
          userId: if $rootScope.user then $rootScope.user.id else ''
          giftId: item.id
          quantity:1
          sessionId: if $scope.item.Session then $scope.item.Session.id else ''
        ApiService.room.sendGift paramsend,(err, result)->
          return if err
          return UtilityService.notifyError(result.message) if result and result.error
          if result
            UtilityService.notifySuccess( (result.message || 'Tặng quà thành công' ))
            cb() if _.isFunction(cb)
            showSendGiftSuccess(item, result)
    $rootScope.$emit 'open-list-gift', param

  $scope.getListGift = ()->
    ApiService.room.giftList {page:0, limit:1000},(err, result)->
      return if err
      $scope.giftList.items = result.items


  $scope.getListRoomSameCategory = ()->
    if $scope.item and $scope.item.categoryId
      ApiService.getListRoomInCategory {categoryId: $scope.item.categoryId},(err, result)->
        return if err or !result
#        console.log 'getListRoomInCategory', result
        $scope.category = result.category
#        console.log 'getListRoomInCategory', $scope.category

  $scope.listRoomNowOnAir = ()->
    ApiService.onAir {onair : true, page:0, limit:1000 },(err, result)->
      return if err or !result
      return UtilityService.notifyError(result.message) if result and result.error
      $scope.roomNowOnAir = result.rooms

  $scope.buyTicket = ()->
    if !$rootScope.user or !$scope.item
      console.log 'buyTicket user not login'
      UtilityService.notifySuccess('Vui lòng đăng nhập ')
      return
    return unless confirm('Xác nhận mua vé!')
    paramBuy =
      roomId : if $scope.item then $scope.item.id else ''
      sessionId: if $scope.item and $scope.item.Session then $scope.item.Session.id else ''
    ApiService.room.buyTicket paramBuy,(err, result)->
      return if err or !result
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
      popupButtonClasses: 'fa fa-smile-o',
      'data-emoji-input' : "unicode"
    })
    window.emojiPicker.discover()

  $scope.joinRoom = ()->
    $timeout(()->
      $('.emoji-wysiwyg-editor').keyup (e)->
        $scope.sendChatMsg() if e.keyCode == 13
    ,2000)
#    return UtilityService.notifyError('Phòng này chưa diễn. Bạn vui lòng quay lại sao ') if $scope.item and !$scope.item.Session
    return UtilityService.notifyError("#{$scope.item.title} hiện chưa phát sóng. Bạn trở lại sau nhé.") if $scope.item and !$scope.item.Session
    console.error 'user chua login' unless $rootScope.user
    paramJoin =
      roomId : $scope.id
      sessionId: if $scope.item and $scope.item.Session then $scope.item.Session.id else ''
      userId : if $rootScope.user then $rootScope.user.id else ''
#    console.log 'paramJoin',paramJoin
    ApiService.room.joinRoom paramJoin,(err, result)->
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
    name = "Me" if data and $rootScope.user and data.user.id == $rootScope.user.id
    html = '<div class="item"><img src="'+avatar+'" style="width:40px; height: 40px;" class="image"/> <div class="group-name"> <div class="name">'+name+'</div> <div class="subname">'+message+'</div></div> </div>'
    $('#content-chat-list').append(html)
    if $('#content-chat-list')[0]
      $('#content-chat-list').animate({ scrollTop: $('#content-chat-list')[0].scrollHeight }, 100)

  $scope.sendChatMsg = ()->
    message = $('.emoji-wysiwyg-editor').html()
    re = new RegExp('<br>', 'g')
    message = message.replace(re, '')
    rex = new RegExp('&nbsp;', 'g')
    message = message.replace(rex, ' ')
#    console.error 'sendChatMsg', message
    return unless message
    return $('.emoji-wysiwyg-editor').html('') if message == '&nbsp;'
    return $('.emoji-wysiwyg-editor').html('') if message and /^[ ]*$/.test(message) == true
    socket.emit('comment', message)
    $('.emoji-wysiwyg-editor').html('')


  #socket
  #socket
  #socket
  #socket
  #socket
  #socket

  addListennerSocketInit = ()->
    socket.on 'connect', ()->
      console.warn "socket.on 'connect'"
    socket.on "isConnected", ()->
      console.info 'socket isConnected'
      $scope.socketIsConnected = true
    socket.on 'newComment', (data)->
  #    console.info 'on newComment', data
      return if data && data.message == '&nbsp;'
      $scope.showNewCommentSocket(data)
    socket.on 'connectUser', (data)->
      console.log 'connect User',data
      $scope.showUserConnectSocket(data)
      $rootScope.$emit 'reload-user-in-room'
  #    $scope.getListUser()
    socket.on 'disconnectUser', (data)->
      console.error 'disconnect User',data
      $scope.showUserDisConnectSocket(data)
      $rootScope.$emit 'reload-user-in-room'
  #    $scope.getListUser()
    socket.on 'notification', (data)->
      console.error 'notification',data
    socket.on 'sendGift', (data)->
      console.warn '--------sendGift--------'
      console.log data
      avatar = data.user.avatar || "http://via.placeholder.com/40x40"
      name = data.user.name
      message = data.message+' <img style="width:20px; height:20px;" src="'+data.giftIcon+'"/>'
      re = new RegExp('<br>', 'g')
      message = message.replace(re, '')
      return unless message
      html = '<div class="item" style="margin-bottom: 5px;"><img src="'+avatar+'" style="width:40px; height: 40px;" class="image"/> <div class="group-name"> <div class="name">'+name+'</div> <div class="subname">'+message+'</div></div> </div>'
      $('#content-chat-list').append(html)
      $('#content-chat-list').animate({ scrollTop: $('#content-chat-list')[0].scrollHeight }, 100)

    socket.on 'hostDisconnect', (data)->
      console.error 'hostDisconnect', data
      UtilityService.notifyError('Phòng này đã ngừng diễn')
      $scope.showPopupStopLiveStream()

    socket.on 'sendHeart', (data)->
  #    console.log 'sendHeart',data
      console.log 'off show html sendHeart',data
  #    $scope.showReciveHeartSocket(data)

    socket.on 'disconnect', ()->
      console.error 'socket disconnect'
      $scope.socketIsConnected = false
      socket.removeAllListeners('sendHeart')
      socket.removeAllListeners('sendGift')
      socket.removeAllListeners('connectUser')
      socket.removeAllListeners('newComment')
      socket.removeAllListeners('disconnectUser')
      socket.removeAllListeners('disconnect')
      io.removeAllListeners('connection') if _.isFunction(io.removeAllListeners)





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
#      console.log '$destroy room detail player.dispose()'
    if videojs.getPlayers() and videojs.getPlayers()['videojs-room-detail-main']
#      console.log '$destroy room detail delete videojs.getPlayers'
      delete videojs.getPlayers()['videojs-room-detail-main']

  $scope.sameRoomFollowIdol = (item, indexRoom)->
    return unless item
    return UtilityService.notifyError('Vui lòng đăng nhập') unless $rootScope.user
    ApiService.followIdol {roomId:item.id}, (error, result)->
      return if error
      return UtilityService.notifyError(result.message)  if result and result.error
      UtilityService.notifySuccess(result.message) if result
      if $scope.category.Rooms and $scope.category.Rooms[indexRoom]
        $scope.category.Rooms[indexRoom].isFollow = true

  $scope.nowOnAirFollowIdol = (item, indexRoom)->
    return unless item
    return UtilityService.notifyError('Vui lòng đăng nhập') unless $rootScope.user
    ApiService.followIdol {roomId:item.id}, (error, result)->
      return if error
      return UtilityService.notifyError(result.message)  if result and result.error
      UtilityService.notifySuccess(result.message) if result
      if $scope.roomNowOnAir and $scope.roomNowOnAir[indexRoom]
        $scope.roomNowOnAir[indexRoom].isFollow = true

  $scope.showPopupStopLiveStream = ()->
    params =
      title : 'Thông báo',
      message : "#{($scope.item.title || "Phòng này")} đã ngừng phát sóng. Bạn xem sang chương trình khác nhé!"
      textBtnSave : 'OK'
      textBtnCancel : 'Đóng'
      cancel : ()->
        return $state.go 'base',{},{reload: true }
      save: null
    $rootScope.$emit 'popup-confirm', params

  $scope.callbackAfterFollowThisRoom = ()->
    $scope.item.isFollow = true

  #call api

  $scope.getRoomDetail ()->
#    console.log 'getRoomDetail; $scope.item',$scope.item
    $scope.getListRoomSameCategory()
    $scope.listRoomNowOnAir()
    if $scope.item and ($scope.item.mode == 2 or $scope.item.mode == '2')
      console.log 'room han che'
    else
      querySocket = {query : "Authorization=#{window.localStorage.token}&roomId=#{$scope.id}", 'forceNew': true, 'force new connection': true }
      socket = io( GlobalConfig.SOCKET_DOMAIN, querySocket)
      addListennerSocketInit() if socket
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
