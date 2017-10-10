_directive = ($timeout, ApiService) ->
  link = ($scope, elm, $attrs) ->
    $scope.loaded = false
    elm.ready ->
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
          moveSlides: 3
          slideMargin: 10
          pager: true
        })
        return
      ,1000)
      return
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

