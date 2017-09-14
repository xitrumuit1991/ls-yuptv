"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base",
    url : "/"
    views :
      "main@" :
        templateUrl : "/templates/home/home.html"
        controller : "HomeCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->
  console.log 'base coffee '
  $scope.myInterval = 3000
  $scope.myInterval2 = 3000
  $scope.slides = []
  $scope.slides2 = []
  i=0
  while i < 4
    newWidth = 600 + $scope.slides.length + 1;
    $scope.slides.push({
      image: 'http://placekitten.com/' + newWidth + '/300',
      text: ['More','Extra','Lots of','Surplus'][$scope.slides.length % 4] + ' ' +
        ['Cats', 'Kittys', 'Felines', 'Cutes'][$scope.slides.length % 4]
    });
    i++

  i=0
  while i < 4
    newWidth = 600 + $scope.slides2.length + 1;
    $scope.slides2.push({
      image: 'http://placekitten.com/' + newWidth + '/300',
      text: ['More','Extra','Lots of','Surplus'][$scope.slides2.length % 4] + ' ' +
        ['Cats', 'Kittys', 'Felines', 'Cutes'][$scope.slides2.length % 4]
    });
    i++


ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "HomeCtrl", ctrl
