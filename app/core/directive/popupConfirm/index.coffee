popupConfirm = ($rootScope, $timeout) ->
  link = (scope, element, attr) ->
#    console.info 'Init popupConfirm'
    scope.popup =
      allowClose : false
      status : false
      type : 'confirm' # 'alert'
      title : 'Title default '
      content : 'Content default '
      textOk : 'Đăng kí '
      textCancel : 'Huỷ '
      okFn : ()->
        console.log 'OK btn click '
      cancelFn : ()->
        scope.popup.status = false
        console.log 'Cancel btn click '

    scope.clickOK = ()->
      scope.closePopup()
      scope.popup.okFn()

    scope.clickCancel = ()->
      scope.closePopup()
      scope.popup.cancelFn()

    scope.closePopup = ()->
      scope.popup.status = false

    scope.openPopup = ()->
      scope.popup.status = true

    $rootScope.$on 'popup-confirm', (event, data) ->
      return unless data
      scope.popup = _.extend scope.popup, data
      scope.popup.type = 'alert' unless data.type
      scope.openPopup()
  #params =
  #    status : true,
  #    type: 'alert',
  #    title : 'Thông báo',
  #    content : 'Vui lòng bật 3G Mobifone để tiếp tục đăng kí và nhận miễn phí gói FIMB30',
  #    textOk : 'Đăng kí'
  #    textCancel : 'Huỷ'
  #    okFn : ()->
  #        console.log ''
  #    cancelFn : ()->
  #        console.log ''
  #$rootScope.$emit 'popup-confirm', params
  directive =
    restrict : 'E'
    templateUrl : '/templates/directive/popupConfirm/view.html'
    link : link
  return directive
popupConfirm.$inject = ['$rootScope', '$timeout']
angular
.module 'app'
.directive "popupConfirm", popupConfirm