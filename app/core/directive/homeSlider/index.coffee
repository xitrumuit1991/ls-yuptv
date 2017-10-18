_directive = ($timeout, ApiService) ->
  link = ($scope, $element, $attrs) ->
#    console.log 'home slider directive'
#    $scope.myInterval2 = 3000
    $scope.loadedBanner = false
    $scope.slides = []
#    $scope.slides2 = []
#    i=0
#    while i < 4
#      newWidth = 600 + $scope.slides.length + 1;
#      $scope.slides.push({
#        image: 'http://placekitten.com/' + newWidth + '/300',
#        text: ['More','Extra','Lots of','Surplus'][$scope.slides.length % 4] + ' ' +
#          ['Cats', 'Kittys', 'Felines', 'Cutes'][$scope.slides.length % 4]
#      });
#      i++

#    i=0
#    while i < 4
#      newWidth = 600 + $scope.slides2.length + 1;
#      $scope.slides2.push({
#        image: 'http://placekitten.com/' + newWidth + '/300',
#        text: ['More','Extra','Lots of','Surplus'][$scope.slides2.length % 4] + ' ' +
#          ['Cats', 'Kittys', 'Felines', 'Cutes'][$scope.slides2.length % 4]
#      });
#      i++

    ApiService.getListBanner({},(error, result)->
#      console.log result
      return if error
      $scope.slides = result if result
      $timeout(()->
        $scope.loadedBanner = true
      ,1000  )
    )
    return null

  directive =
    restrict : 'E'
    link : link
    templateUrl : '/templates/directive/homeSlider/view.html'
  return directive
_directive.$inject = ['$timeout','ApiService']
angular
.module 'app'
.directive "homeSlider", _directive

