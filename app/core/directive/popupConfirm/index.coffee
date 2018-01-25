directive = ($rootScope, $document) ->
  link = ($scope, element, attr) ->
    $scope.modal =
      id : 'popup-alert'
      title : 'Thông báo'
      message : ''
      textBtnSave : 'OK'
      textBtnCancel : 'Cancel'
      show : ()->
        $("##{@.id}").modal('show')
      hide : ()->
        $("##{@.id}").modal('hide')

    $scope.saveAction = null
    $scope.cancelAction = ()->
      $scope.modal.hide()

    $rootScope.$on 'popup-confirm',(event, data)->
      $scope.modal.title = data.title if data.title
      $scope.modal.message = data.message if data.message
      $scope.modal.textBtnSave = data.textBtnSave if data.textBtnSave
      $scope.modal.textBtnCancel = data.textBtnCancel if data.textBtnCancel
      if data.cancel and _.isFunction(data.cancel)
        $scope.cancelAction = ()->
          data.cancel()
          $scope.modal.hide()
      if data.save and _.isFunction(data.save)
        $scope.saveAction = ()->
          data.save()
          $scope.modal.hide()
      $scope.modal.show()


    #call
#    params =
#      title : 'Thông báo',
#      message : 'Phòng này đã ngừng diễn!',
#      textBtnSave : 'OK'
#      textBtnCancel : 'Cancel'
#      cancel : ()->
#        return $state.go 'base'
#      save: null
#    $rootScope.$emit 'popup-confirm', params
    return
  directive =
    restrict: 'E'
    templateUrl : '/templates/directive/popupConfirm/view.html'
    link    : link
  return directive
directive.$inject = ['$rootScope', '$document']
angular
  .module 'app'
  .directive "popupConfirm", directive