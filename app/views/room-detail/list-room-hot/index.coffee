_directive = ($timeout, ApiService, UtilityService,$rootScope, $state) ->
  link = ($scope, $element, $attrs) ->
    $scope.hotRoom = null
    $scope.gotoDetailRoom =(item)->
      $state.go 'base.room-detail',{id :  item.id},{reload: true}

    param =
      categoryId: '9ac8fc48-86f2-11e7-b556-0242ac110005'
      page : 0
      limit : 20
    ApiService.getListRoomInCategory param,(err, result)->
      return if err or !result
      console.log 'hotRoom= ', result
      $scope.hotRoom = result.category.Rooms

  directive =
    restrict : 'E'
    scope :
      item : '=ngItem'
    link : link
    templateUrl : '/templates/room-detail/list-room-hot/view.html'
  return directive
_directive.$inject = ['$timeout','ApiService' , 'UtilityService', '$rootScope', '$state']
angular
.module 'app'
.directive "listRoomHot", _directive

