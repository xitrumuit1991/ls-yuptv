config =
  platform : 'web'
  version : '1.0.0'
  uuid : (new Fingerprint({canvas : true, screen_resolution : false})).get()
  modelName : navigator.userAgent
  fBappId : '1952746048273281'
  API_URL : "http://dev.livestar.vn:1010/api/v1/"
  env : 'production'

switch ENV
  when 'production'
    config = _.extend config,
      fBappId : '1952746048273281'
      API_URL : "http://dev.livestar.vn:1010/api/v1/"
      env : 'production'

  when 'development'
    config = _.extend config,
      fBappId : '1952746048273281'
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
  "ui.carousel",
  "ui-notification"
])
.constant "AppName", "YUP"
.constant "GlobalConfig", config


appConfig = (
  $locationProvider,
  $stateProvider,
  $urlRouterProvider,
  FacebookProvider,
  GlobalConfig,
  $httpProvider,
  NotificationProvider) ->

  $httpProvider.interceptors.push "AuthInterceptor"
  $locationProvider.html5Mode(true).hashPrefix "!"
  $urlRouterProvider.otherwise "/"
  FacebookProvider.init config.fBappId
  NotificationProvider.setOptions({
    delay: 5000,
    startTop: 20,
    startRight: 20,
    verticalSpacing: 20,
    horizontalSpacing: 20,
    positionX: 'right',
    positionY: 'top'
  });

appConfig.$inject = [
  '$locationProvider',
  '$stateProvider',
  '$urlRouterProvider',
  'FacebookProvider',
  'GlobalConfig',
  '$httpProvider',
  'NotificationProvider',
]


angular
.module("app")
.config appConfig


angular.element(document).ready ()->
  angular.bootstrap document, ['app'], strictDi : true