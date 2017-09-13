_service = ($rootScope, $http, $resource, GlobalConfig)->
  self = this
  @commonData =
    platform : GlobalConfig.platform
    env : GlobalConfig.env
    uuid : GlobalConfig.uuid
    macAddress : '00:00:00:00:00:00'
    modelId : GlobalConfig.uuid
    modelName : GlobalConfig.modelName
    version : GlobalConfig.version
  @requestSuccess = (done, req)->
    done null, req

  @requestError = (done, data, status, header, config, statusText)->
    if status is 403
      return done true, data
    done true, data

  @request = (options, done)->
    self.requestParams = options.data
    options.data = _.extend _.clone(@commonData), options.data
    if options.method is 'GET'
      options.url = options.url + "?" + angular.element.param(options.data)
      delete options.data
    $http(options)
    .success @requestSuccess.bind(@, done)
    .error @requestError.bind(@, done)

  return null
_service.$inject = ['$rootScope', '$http',   '$resource', 'GlobalConfig']

angular
.module('app')
.service('ApiService', _service);

