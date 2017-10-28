_service = ($rootScope, $http, $resource, GlobalConfig)->
  self = this
  self.commonData =
    platform : GlobalConfig.platform
    env : GlobalConfig.env
    uuid : GlobalConfig.uuid
    macAddress : '00:00:00:00:00:00'
    modelId : GlobalConfig.uuid
    modelName : GlobalConfig.modelName
    version : GlobalConfig.version

  self.requestSuccess = (done, req)->
    return done null, req

  self.requestError = (done, data, status, header, config, statusText)->
    return done data, data

  self.request = (options, done)->
    options.ignoreLoadingBar = false #off loading bar
    self.requestParams = options.data
    options.data = _.extend _.clone(self.commonData), options.data
    if options.method and options.method.toUpperCase() == 'GET'
      options.url = options.url + "?" + angular.element.param(options.data)
      delete options.data
    $http(options)
    .success self.requestSuccess.bind(self, done)
    .error self.requestError.bind(self, done)

  self.getListBanner = (params, done)->
    options =
      url : GlobalConfig.API_URL + "app/poster"
      method : 'GET'
      data : params
    self.request options, done

  self.getHomeContent = (params, done)->
    options =
      url : GlobalConfig.API_URL + "app/room-by-category"
      method : 'GET'
      data : params
    self.request options, done

  self.getRankCoin = (params, done)->
    options =
      url : GlobalConfig.API_URL + "user/rank-coin"
      method : 'GET'
      data : params
    self.request options, done

  self.getRankHeart = (params, done)->
    options =
      url : GlobalConfig.API_URL + "user/rank-heart"
      method : 'GET'
      data : params
    self.request options, done

  self.getRankShareFacebook = (params, done)->
    options =
      url : GlobalConfig.API_URL + "user/rank-share-fb"
      method : 'GET'
      data : params
    self.request options, done

  self.registerAccount = (params, done)->
    options =
      url : GlobalConfig.API_URL + "auth/register"
      method : 'POST'
      data : params
    self.request options, done

  self.registerAccountActive = (params, done)->
    options =
      url : GlobalConfig.API_URL + "auth/active"
      method : 'POST'
      data : params
    self.request options, done

  self.loginPhone = (params, done)->
    options =
      url : GlobalConfig.API_URL + "auth/login"
      method : 'POST'
      data : params
    self.request options, done

  self.getProfile = (params, done)->
    options =
      url : GlobalConfig.API_URL + "user/profile"
      method : 'GET'
      data : params
    self.request options, done

  self.loginFacebook = (params, done)->
    options =
      url : GlobalConfig.API_URL + "auth/fb-register"
      method : 'POST'
      data : params
    self.request options, done

  self.getRoomOnAir = (params, done)->
    options =
      url : GlobalConfig.API_URL + "room/list-by-view"
      method : 'GET'
      data : params
    self.request options, done

  self.updateUserProfile = (params, done)->
    options =
      url : GlobalConfig.API_URL + "user/profile"
      method : 'POST'
      data : params
    self.request options, done

  self.changePassword = (params, done)->
    options =
      url : GlobalConfig.API_URL + "auth/change-password"
      method : 'POST'
      data : params
    self.request options, done

  self.getSavedVideo = (params, done)->
    options =
      url : GlobalConfig.API_URL + "user/video"
      method : 'GET'
      data : params
    self.request options, done

  self.getUserFollowing = (params, done)->
    options =
      url : GlobalConfig.API_URL + "user/following"
      method : 'GET'
      data : params
    self.request options, done

  self.getUserFollower = (params, done)->
    options =
      url : GlobalConfig.API_URL + "user/follower"
      method : 'GET'
      data : params
    self.request options, done

  self.followIdol = (params, done)->
    options =
      url : GlobalConfig.API_URL + "room/follow"
      method : 'PUT'
      data : params
    self.request options, done

  self.unFollowIdol = (params, done)->
    options =
      url : GlobalConfig.API_URL + "room/follow"
      method : 'POST'
      data : params
    self.request options, done

  self.getListRoomSchedule = (params, done)->
#    keyword	String
#    type	String Type in [day, day3, week, month, all]
#    time optional	Timestamp Tính từ ngày
    options =
      url : GlobalConfig.API_URL + "room/list-by-schedule"
      method : 'GET'
      data : params
    self.request options, done

  self.getListCategory = (params, done)->
    options =
      url : GlobalConfig.API_URL + "room/category"
      method : 'GET'
      data : params
    self.request options, done

  self.getScheduleOfRoom=(params, done)->
    #http://dev.livestar.vn:1010/api/v1/room/schedule?roomId=bbc61145-9a59-49d5-9ebb-73db072ce4f0&type=all
    options =
      url : GlobalConfig.API_URL + "room/schedule"
      method : 'GET'
      data : params
    self.request options, done

  self.addNewSchedule =(params, done)->
    #start end
    options =
      url : GlobalConfig.API_URL + "room/schedule"
      method : 'PUT'
      data : params
    self.request options, done

  self.updateSchedule =(params, done)->
    options =
      url : GlobalConfig.API_URL + "room/schedule"
      method : 'POST'
      data : params
    self.request options, done

  self.deleteSchedule =(params, done)->
    options =
      url : GlobalConfig.API_URL + "room/schedule"
      method : 'DELETE'
      data : params
    self.request options, done

  self.getHistorySendGift =(params, done)->
    params.type = 'send' if params and _.isObject(params)
    options =
      url : GlobalConfig.API_URL + "gift/history"
      method : 'POST'
      data : params
    self.request options, done

  self.getHistoryReceiveGift =(params, done)->
    params.type = 'receive' if params and _.isObject(params)
    options =
      url : GlobalConfig.API_URL + "gift/history"
      method : 'POST'
      data : params
    self.request options, done

  self.getListPackage =(params, done)->
    options =
      url : GlobalConfig.API_URL + "payment/package"
      method : 'GET'
      data : params
    self.request options, done

  self.chargeByTelcoCard = (params, done)->
    options =
      url : GlobalConfig.API_URL + "payment/card"
      method : 'POST'
      data : params
    self.request options, done

  self.chargeBankLocal = (params, done)->
    options =
      url : GlobalConfig.API_URL + "payment/bank"
      method : 'POST'
      data : params
    self.request options, done
  self.confirmChargeBankLocal = (params, done)->
    options =
      url : GlobalConfig.API_URL + "payment/bank-callback"
      method : 'GET'
      data : params
    self.request options, done

  self.onAir = (params, done)->
    options =
      url : GlobalConfig.API_URL + "room/list-by-view"
      method : 'GET'
      data : params
    self.request options, done

  self.onAirByCategory = (params, done)->
    options =
      url : GlobalConfig.API_URL + "room/list-by-category"
      method : 'GET'
      data : params
    self.request options, done

  self.getCategory = (params, done)->
    options =
      url : GlobalConfig.API_URL + "room/category"
      method : 'GET'
      data : params
    self.request options, done






#  self.getListRoomInCategory = (params, done)->
#    return done('Missing categoryId getListRoomInCategory api', null) unless params.categoryId
#    options =
#      url : GlobalConfig.API_URL + "room/list-by-category"
#      method : 'GET'
#      data : params
#    self.request options, done


  return null
_service.$inject = ['$rootScope', '$http',   '$resource', 'GlobalConfig']

angular
.module('app')
.service('ApiService', _service);

