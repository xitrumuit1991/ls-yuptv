_directive = ($timeout, ApiService,$rootScope,UtilityService) ->
  link = ($scope, $element, $attrs) ->
    $scope.listRank = []

    $scope.followIdolInHome = (item)->
      roomId = item.User.Room.id
      return unless roomId
      return unless $rootScope.user
      ApiService.followIdol({roomId:roomId},(error, result)->
        return if error
        return UtilityService.notifyError(result.message) if result and result.error
        index = _.findIndex($scope.listRank, {id: item.id})
        UtilityService.notifySuccess(result.message)
        $scope.listRank[index].User.Room.isFollow = true if index != -1
      )
    ApiService.getRankHeart({}, (error, result)->
      return if error
      $scope.listRank = result
    )
    return null

  directive =
    restrict : 'E'
    link : link
    templateUrl : '/templates/directive/homeBXHChannel/view.html'
  return directive
_directive.$inject = ['$timeout','ApiService', '$rootScope' ,'UtilityService']
angular
.module 'app'
.directive "homeBxhChannel", _directive

