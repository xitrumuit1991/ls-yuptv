Authenticator = (GlobalConfig, $rootScope, $http, $window) ->

  isLogged : ->
    !!$window.localStorage.content

Authenticator.$inject = ["GlobalConfig", "$rootScope", "$http", "$window"]
angular
.module("app").factory "Authenticator", Authenticator
