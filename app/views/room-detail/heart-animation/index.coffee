_directive = ($timeout, ApiService, UtilityService,$rootScope) ->
  link = ($scope, $element, $attrs) ->
    $scope.maxTime = 0
    $rootScope.isFly = false

    randomHeart = ()->
      r_num = Math.floor(Math.random() * 40) + 1
      r_size = Math.floor(Math.random() * 65) + 10
      r_left = Math.floor(Math.random() * 100) + 1
      r_bg = Math.floor(Math.random() * 25) + 100
      r_time = Math.floor(Math.random()*2)+1
      r_num = parseInt(r_num)
      r_size = parseInt(r_size)
      r_left = parseInt(r_left)
      r_bg = parseInt(r_bg)
      r_time = parseInt(r_time)
      $scope.maxTime = r_time if r_time > $scope.maxTime
      html = '<div class="heart" style="
        width:'+r_size+'px;
        height:'+r_size+'px;
        left:'+r_left+'%;
        background:rgba(255,'+(r_bg-25)+','+r_bg+',1);
        -webkit-animation:love '+r_time+'s ease;
        -moz-animation:love '+r_time+'s ease;
        -ms-animation:love '+r_time+'s ease;
        animation:love '+r_time+'s ease;"></div>'
      $('#bg_heart').append(html)

    randomHeart_2 = ()->
      r_num = Math.floor(Math.random() * 40) + 1
      r_size = Math.floor(Math.random() * 65) + 10
      r_left = Math.floor(Math.random() * 100) + 1
      r_bg = Math.floor(Math.random() * 25) + 100
      r_time = Math.floor(Math.random())+2
      r_num = parseInt(r_num)
      r_size = parseInt(r_size)
      r_left = parseInt(r_left)
      r_bg = parseInt(r_bg)
      r_time = parseInt(r_time)
      $scope.maxTime = r_time if r_time > $scope.maxTime
      html = '<div class="heart" style="
        width:'+(r_size-10)+'px;
        height:'+(r_size-10)+'px;
        left:'+(r_left+5)+'%;
        background:rgba(255,'+(r_bg-25)+','+r_bg+',1);
        -webkit-animation:love '+r_time+'s ease;
        -moz-animation:love '+r_time+'s ease;
        -ms-animation:love '+r_time+'s ease;
        animation:love '+r_time+'s ease;"></div>'
      $('#bg_heart').append(html)

    $scope.flyHeart = (cb=null)->
      return if $rootScope.isFly == true
      $rootScope.isFly = true
      $timeout((->
        randomHeart()
        randomHeart_2()
        randomHeart()
        randomHeart_2()
        $timeout(()->
          $scope.maxTime = 0
          $rootScope.isFly = false
          $('#bg_heart').html('')
          cb() if _.isFunction(cb)
        ,$scope.maxTime*1000+1)

        $('#bg_heart .heart').each ()->
          top = $(this).css('top').replace(/[^-\d\.]/g, '')
          width = $(this).css('width').replace(/[^-\d\.]/g, '')
          $(this).detach() if top <= -100 or width >= 150
          return
        return
      ), 1)

    $rootScope.$on 'fly-heart',(event, cb)->
      $scope.flyHeart(cb)

    return
  directive =
    restrict : 'E'
    scope :
      id : '=ngModel'
    link : link
    templateUrl : '/templates/room-detail/heart-animation/view.html'
  return directive
_directive.$inject = ['$timeout','ApiService' , 'UtilityService', '$rootScope']
angular
.module 'app'
.directive "heartAnimation", _directive

