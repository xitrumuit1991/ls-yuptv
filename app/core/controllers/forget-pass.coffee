"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
    .state "base.forget-pass",
    url : "quen-mat-khau"
    views :
      "main@" :
        templateUrl : "/templates/forget-pass/view.html"
        controller : "ForgetPassCtrl"
route.$inject = ['$stateProvider', 'GlobalConfig']
ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval, UtilityService) ->


#code: AQAfHX04GuYTXb4TuaBbp1igmnR7IXVLlKaSmTkgG5sB37L6VOr2bBM4nwaXnHUuE4POKFjY0mJ3l9KG15-750n1WHi07Fe33h_CaFCBAuAEdev7mBJY-WUwflIjXF1ojz0S33AZ4DslPOX5Jyac-YU_VtyDosm5Yj18eyaB4NIIRbcjWzM6LSQnZQY-kQ9YrSnspWEip1XEDP-0HKeHrUjgxkHH336z7xynN1ciWVBBSWtT6Qk4XLxTh6_KcSnlj8xCjV9W8HmhI_FMQDIniiGJ"
#state: ed921b9e2248d0cb68329322c08e97b3"
#status: PARTIALLY_AUTHENTICATED"

  $scope.item =
    phone : ''
    accessToken : ''

  $scope.submit = ()->
    AccountKit.login('PHONE', {country_code: 84, phone_number: '841669383915'},(response)->
      console.log 'AccountKit.login response',response
    );

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval','UtilityService'
]
angular
  .module("app")
  .config route
  .controller "ForgetPassCtrl", ctrl
