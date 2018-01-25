_directive = ($timeout, ApiService) ->
  link = ($scope, elm, $attrs) ->

    $scope.clickItem = (item, $index)->
      $timeout(()->
        $scope.onItemClick(item, $index)
      ,1)

    $scope.$watch 'items',()->
      $timeout(()->
        $(elm).find('.bxslider').bxSlider({
          captions: true
          auto: false
          autoControls: false
          autoHover: true
          controls : true
          slideWidth: 131
          minSlides: 1
          maxSlides: 7
          moveSlides: 7
          slideMargin: 10
          pager: true
          infiniteLoop:false
          hideControlOnEnd:true
        })
        $timeout(()->
          $(elm).find('.bx-loading').remove()
        ,100)
      ,1)
#    elm.ready ->
#      $timeout(()->
#        $(elm).find('.bxslider').bxSlider({
#          captions: true
#          auto: false
#          autoControls: false
#          autoHover: true
#          controls : true
#          slideWidth: 131
#          minSlides: 1
#          maxSlides: 7
#          moveSlides: 3
#          slideMargin: 10
#          pager: true
#        })
#        return
#      ,1000)
#      return
    return

  directive =
    restrict : 'E'
    scope :
      items : '='
      onItemClick : '='
    link : link
    templateUrl : '/templates/directive/bxslider/view.html'
  return directive
_directive.$inject = ['$timeout','ApiService']
angular
.module 'app'
.directive "bxslider", _directive

