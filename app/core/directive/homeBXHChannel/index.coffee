_directive = ($timeout, ApiService) ->
  link = ($scope, $element, $attrs) ->
    $scope.listRank = []
    ApiService.getRankCoin({}, (error, result)->
      return if error
      $scope.listRank = result
    )
    return null

  directive =
    restrict : 'E'
    link : link
    templateUrl : '/templates/directive/homeBXHChannel/view.html'
  return directive
_directive.$inject = ['$timeout','ApiService']
angular
.module 'app'
.directive "homeBxhChannel", _directive

