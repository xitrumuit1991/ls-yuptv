_directive = ($rootScope, $timeout, ApiService) ->
  link = ($scope, $element, $attrs) ->
    $scope.user = $rootScope.user

    $scope.$watch 'item',(data)->
#      console.log '$scope.item',$scope.item

    return null
  directive =
    restrict : 'E'
    scope :
      item : '=ngItem'
      index : '=ngIndex'
      actionFollow: '=ngActionFollow'
      actionUnfollowIdol: '=ngActionUnfollow'
    link : link
    templateUrl : '/templates/directive/buttonFollowPlusMinus/view.html'
  return directive
_directive.$inject = ['$rootScope', '$timeout','ApiService']
angular
.module 'app'
.directive "buttonFollowPlusMinus", _directive

