_directive = ($rootScope,$timeout, ApiService) ->
  link = ($scope, $element, $attrs) ->

    return
  directive =
    restrict : 'E'
    scope :
      room : '=ngItem'
      groupIdol : '=ngGroupIdol'
      indexRoom : '=ngIndexRoom'
      homeClickFollowIdol : '=ngActionFollow'
      homeClickunFollowIdol : '=ngActionUnfollow'
    link : link
    templateUrl : '/templates/directive/roomInHome/view.html'
  return directive
_directive.$inject = ['$rootScope', '$timeout','ApiService']
angular
  .module 'app'
  .directive "roomInHome", _directive

