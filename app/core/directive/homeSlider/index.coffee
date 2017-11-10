_directive = ($rootScope,$timeout, ApiService) ->
  link = ($scope, $element, $attrs) ->
    $scope.loadedBanner = false
    $scope.slides = []
    $rootScope.$watch 'homeslides',(data)->
      $scope.slides = data if data
      $timeout(()->
        $scope.loadedBanner = true
      ,1)

#    ApiService.getListBanner {},(error, result)->
#      return if error
#      $scope.slides = result if result
#      $timeout(()->
#        $scope.loadedBanner = true
#      ,1000 )

    return
  directive =
    restrict : 'E'
    link : link
    templateUrl : '/templates/directive/homeSlider/view.html'
  return directive
_directive.$inject = ['$rootScope', '$timeout','ApiService']
angular
.module 'app'
.directive "homeSlider", _directive

