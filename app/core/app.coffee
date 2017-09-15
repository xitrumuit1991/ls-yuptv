config =
  platform : 'web'
  version : '1.0.0'
  uuid : (new Fingerprint({canvas : true, screen_resolution : false})).get()
  modelName : navigator.userAgent
  fBappId : '903378619781560'
  API_URL : "http://dev.livestar.vn:1010/api/v1/"
  env : 'production'

switch ENV
  when 'production'
    config = _.extend config,
      fBappId : '903378619781560'
      API_URL : "http://dev.livestar.vn:1010/api/v1/"
      env : 'production'

  when 'development'
    config = _.extend config,
      fBappId : '903378619781560'
      API_URL : "http://dev.livestar.vn:1010/api/v1/"
      env : 'development'

initInjector = angular.injector(["ng"])
$http = initInjector.get("$http");

angular
.module("app", [
  "ngResource",
  "ngMessageFormat",
#  'ngAnimate',
  "ui.router",
  "facebook",
  "ngSanitize",
  "angularFileUpload",
  "fancyboxplus",
  "ui.bootstrap",
  "ui.carousel"
])
.constant "AppName", "YUP"
.constant "GlobalConfig", config


appConfig = ($locationProvider,
  $stateProvider,
  $urlRouterProvider,
  FacebookProvider,
  GlobalConfig,
  $httpProvider) ->
  $httpProvider.interceptors.push "AuthInterceptor"
  $locationProvider.html5Mode(true).hashPrefix "!"
  $urlRouterProvider.otherwise "/"
  FacebookProvider.init config.fBappId

appConfig.$inject = [
  '$locationProvider'
  '$stateProvider'
  '$urlRouterProvider'
  'FacebookProvider'
  'GlobalConfig'
  '$httpProvider'
]


angular
.module("app")
.config appConfig


angular.element(document).ready ()->
  angular.bootstrap document, ['app'], strictDi : true