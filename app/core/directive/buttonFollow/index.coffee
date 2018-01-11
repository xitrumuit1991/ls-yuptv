_directive = ($rootScope, $timeout, ApiService) ->
  link = ($scope, $element, $attrs) ->
    $scope.user = $rootScope.user
#    console.log '$scope.user',$scope.user
    $scope.$watch 'item',(data)->
#      console.log '$scope.item',$scope.item
    $scope.$watch 'type',(data)->
#      console.log '$scope.type',$scope.type
#      console.log '$scope.followIdol',$scope.followIdol
#      console.log '$scope.unfollowIdol',$scope.unfollowIdol

    return
  directive =
    restrict : 'E'
    scope :
      item : '=ngItem'
      followIdol: '=ngActionFollow'
      unfollowIdol: '=ngActionUnfollow'
      type : '=ngType'
    link : link
    templateUrl : '/templates/directive/buttonFollow/view.html'
  return directive
_directive.$inject = ['$rootScope','$timeout','ApiService']
angular
.module 'app'
.directive "buttonFollow", _directive

