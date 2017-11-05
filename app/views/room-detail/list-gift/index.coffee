_directive = ($timeout, ApiService, UtilityService,$rootScope) ->
  link = ($scope, $element, $attrs) ->
    $scope.items = []
    $scope.action = ()->
    $scope.modal =
      id : 'modal-list-gift'
      video:{}
      show : ()->
        angular.element("##{@.id}").modal('show')
      close : ()->
        angular.element("##{@.id}").modal('hide')

    $scope.buyGift = (ite)->
      $scope.action(ite) if _.isFunction($scope.action)

    $rootScope.$on 'open-list-gift',(event, data)->
      console.log 'open-list-gift',data
      $scope.modal.show()
      $scope.items = data.items if data and data.items
      $scope.action = data.action if _.isFunction(data.action)

    return null
  directive =
    restrict : 'E'
    scope :
      id : '=ngModel'
    link : link
    templateUrl : '/templates/room-detail/list-gift/view.html'
  return directive
_directive.$inject = ['$timeout','ApiService' , 'UtilityService', '$rootScope']
angular
.module 'app'
.directive "listGift", _directive

