AuthInterceptor = ($rootScope, $q, $window, HttpBuffer, GlobalConfig) ->
  obPlatform =
    env : GlobalConfig.env,
    platform : GlobalConfig.platform,
    version : GlobalConfig.version

  addAuthorizationToRequest = (config)->
    Authorization = null
    Authorization = $window.localStorage.auth if config.url.indexOf(GlobalConfig.auth) isnt -1
    Authorization = $window.localStorage.content if config.url.indexOf(GlobalConfig.content) isnt -1
    Authorization = $window.localStorage.content if config.url.indexOf(GlobalConfig.ubs) isnt -1
    Authorization = $window.localStorage.payment if config.url.indexOf(GlobalConfig.payment) isnt -1
    Authorization = $window.localStorage.billing if config.url.indexOf(GlobalConfig.billing) isnt -1
    return Authorization

  UnauthorizedLogoutLoginAgain = ()->
    delete $window.localStorage.auth if $window.localStorage.auth
    delete $window.localStorage.content if $window.localStorage.content
    delete $window.localStorage.payment if $window.localStorage.payment
    delete $window.localStorage.billing if $window.localStorage.billing
    if $window.localStorage.user
      delete $window.localStorage.user
      $rootScope.user = null
      $rootScope.notifyUpdateEmail.type = null
      $rootScope.inAppNotify = null
      $rootScope.notifyError('Token hết hạn. Bạn vui lòng đăng nhập lại để tiếp tục.')
      $rootScope.$emit('unauthorized')

  request : (config) ->
    return config if config.url.indexOf('https://jsonip.com') isnt -1
    config.headers["Accept-Language"] = "vi" if config.headers
    if(config.method is "POST")
      if config.data then config.data = _.extend(config.data, obPlatform) else config.data = obPlatform
    unless config.headers.Authorization
      config.headers.Authorization = addAuthorizationToRequest(config)
    config.beforeSend() if(config.beforeSend)
    return config

  response : (response)->
    if(response.config.complete)
      response.config.complete(response)
    return response

  responseError : (response) ->
    if(response.config.complete)
      response.config.complete(response)
    if response.status == 403
#      if((response.data.message == 'Chưa chứng thực tài khoản' and response.data.error == 1005) or (response.data.message == "Unauthorized." and response.data.error == 403) or (response.data.message == "Chưa chứng thực tài khoản" and response.data.error == 1002) )
      if response.data.error == 1005 or response.data.error == 403 or response.data.error == 1002
        UnauthorizedLogoutLoginAgain()
    $q.reject response

AuthInterceptor.$inject = ["$rootScope", "$q", "$window", "HttpBuffer", "GlobalConfig"]
angular
.module("app").factory "AuthInterceptor", AuthInterceptor
