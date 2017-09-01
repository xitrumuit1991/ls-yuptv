HttpBuffer = ($injector) ->
  ###
 Holds all the requests, so they can be re-requested in future.
 ###

  ###
  Service initialized later because of circular dependency problem.
  ###
  retryHttpRequest = (config, deferred) ->
    successCallback = (response) ->
      deferred.resolve response
    errorCallback = (response) ->
      deferred.reject response
    $http = $http or $injector.get("$http")
    $http(config).then successCallback, errorCallback
  buffer = []
  $http = undefined

  ###
  Appends HTTP request configuration object with deferred response attached to buffer.
  ###
  append : (config, deferred) ->
    buffer.push
      config : config
      deferred : deferred

  ###
  Abandon or reject (if reason provided) all the buffered requests.
  ###
  rejectAll : (reason) ->
    if reason
      i = 0

      while i < buffer.length
        buffer[i].deferred.reject reason
        ++i
    buffer = []


  ###
  Retries all the buffered requests clears the buffer.
  ###
  retryAll : ->
    i = 0

    while i < buffer.length
      retryHttpRequest buffer[i].config, buffer[i].deferred
      ++i
    buffer = []

HttpBuffer.$inject = ["$injector"]
angular
.module("app").factory "HttpBuffer", HttpBuffer
