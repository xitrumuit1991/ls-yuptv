_directive = ($timeout, ApiService, UtilityService,$rootScope) ->
  link = ($scope, $element, $attrs) ->
    $scope.items = []
    $scope.action = ()->
    $scope.modal =
      id : 'modal-list-gift-id'
      video:{}
      show : ()->
        $("#modal-list-gift-id").modal('show')
      close : ()->
        $("#modal-list-gift-id").modal('hide')

    $scope.buyGift = (ite)->
      callback = ()->
        $scope.modal.close()
      $scope.action(ite,callback) if _.isFunction($scope.action)

    $rootScope.$on 'open-list-gift',(event, data)->
      console.log 'open-list-gift',data
      $scope.modal.show()
      $scope.items = data.items if data and data.items
      $scope.action = data.action if _.isFunction(data.action)

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

