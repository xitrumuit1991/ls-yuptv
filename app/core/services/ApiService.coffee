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
    return done true, data

  self.request = (options, done)->
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

  return null
_service.$inject = ['$rootScope', '$http',   '$resource', 'GlobalConfig']

angular
.module('app')
.service('ApiService', _service);

