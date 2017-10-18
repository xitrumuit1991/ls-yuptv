AuthInterceptor = ($rootScope, $q, $window, HttpBuffer, GlobalConfig) ->
  request : (config) ->
    config.headers = {} unless config.headers
    config.headers["Accept-Language"] = "vi"
    if window.localStorage.token
      config.headers.Authorization = window.localStorage.token
    config.beforeSend() if config.beforeSend and _.isFunction(config.beforeSend)
    return config

  response : (response)->
    if response.config.complete and _.isFunction(response.config.complete)
      response.config.complete(response)
    return response

  responseError : (response) ->
    if(response.config.complete)
      response.config.complete(response)
    if response.status == 403
      console.error 'token expried'
    $q.reject response

AuthInterceptor.$inject = ["$rootScope", "$q", "$window", "HttpBuffer", "GlobalConfig"]
angular
.module("app").factory "AuthInterceptor", AuthInterceptor
