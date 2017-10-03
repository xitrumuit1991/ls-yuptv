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

  self.getSavedVideo = (params, done)->
    options =
      url : GlobalConfig.API_URL + "user/video"
      method : 'GET'
      data : params
    self.request options, done


  return null
_service.$inject = ['$rootScope', '$http',   '$resource', 'GlobalConfig']

angular
.module('app')
.service('ApiService', _service);

