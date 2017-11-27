_directive = ($rootScope, $timeout, ApiService, UtilityService) ->
  link = ($scope, $element, $attrs) ->
    $scope.users = []
#    itemUser = {
#      "birthday": "2000-01-1",
#      "id": "fa92d7ad-65fa-4790-bbd6-0dc55f721936",
#      "name": "[Nix] RONNNA",
#      "email": "rockozem@gmail.com",
#      "address": null,
#      "phone": null,
#      "countryPrefix": "84",
#      "gender": "male",
#      "avatar": "http://static.yuptv.vn/api/user/users/fa92d7ad-65fa-4790-bbd6-0dc55f721936/d779f3f4-4d5f-42c1-bc23-78887530351e.jpg",
#      "cover": null,
#      "coverCrop": null,
#      "fbId": "1397787283682129",
#      "gpId": null,
#      "fbLink": null,
#      "twitterLink": null,
#      "instagramLink": null,
#      "money": 982,
#      "exp": 60,
#      "activeCode": null,
#      "activeDate": "2017-11-21T04:11:08.000Z",
#      "isBroadcaster": false,
#      "heart": 0,
#      "follower": 1,
#      "isBanned": null,
#      "token": null,
#      "deviceToken": "enPeZqLQTLw:APA91bF51bywXKLav4HV6GRF2Z_r7LR3iy-G0CUpVez2yEOzB0hZ5aT8pmziG3WR42K-JYqagQgBjPJKQd0acxY374kUCIQvjA8A9SOIA2FfwtsE5D0HHopAJ0zDRmR4Of4zSdaawNgY",
#      "socketId": "4FR4ink_85YCyFLpABHQ",
#      "lastLogin": "2017-11-27T02:18:45.000Z",
#      "levelId": 1,
#      "failedAttempts": null,
#      "failedAt": null,
#      "lockedAt": null,
#      "version": "v2",
#      "source": "facebook",
#      "isIdol": true,
#      "liveNotify": true,
#      "systemNotify": true,
#      "birthdayNotify": true,
#      "scheduleNotify": true,
#      "shortId": "2B9OH4AQ",
#      "status": true,
#      "modelName": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:57.0) Gecko/20100101 Firefox/57.0",
#      "platform": "web",
#      "createdAt": "2017-11-21T04:11:08.000Z",
#      "updatedAt": "2017-11-27T02:51:31.000Z",
#      "Room": {
#        "id": "ec08f7ed-d26b-443c-af53-6deba51128aa",
#        "banner": null,
#        "background": null,
#        "title": "Rock Oem",
#        "slug": "rock-oem",
#        "description": null,
#        "thumb": null,
#        "thumbCrop": null,
#        "thumbPoster": null,
#        "onAir": false,
#        "linkBroadcast": null,
#        "mode": "1",
#        "receivedHeart": 0,
#        "follow": 5,
#        "views": 0,
#        "shares": 0,
#        "gifts": 1,
#        "hearts": 0,
#        "status": true,
#        "shortId": "2B9O4AQ7",
#        "createdAt": "2017-11-21T04:11:10.000Z",
#        "updatedAt": "2017-11-27T02:13:11.000Z",
#        "categoryId": null,
#        "userId": "fa92d7ad-65fa-4790-bbd6-0dc55f721936",
#        "ticketId": null,
#        "Category": null,
#        "isFollow": false,
#        "banners": {
#          "banner": null,
#          "w1080h622": null,
#          "w512h512": null,
#          "w720h415": null,
#          "w330h330": null
#        },
#        "backgrounds": {
#          "background": null,
#          "background_w160h190": null
#        },
#        "followers": 5
#      },
#      "avatars_path": {
#        "avatar": "http://static.yuptv.vn/api/user/users/fa92d7ad-65fa-4790-bbd6-0dc55f721936/d779f3f4-4d5f-42c1-bc23-78887530351e.jpg",
#        "w60h60": "http://static.yuptv.vn/api/user/users/fa92d7ad-65fa-4790-bbd6-0dc55f721936/w60h60_d779f3f4-4d5f-42c1-bc23-78887530351e.jpg",
#        "w160h160": "http://static.yuptv.vn/api/user/users/fa92d7ad-65fa-4790-bbd6-0dc55f721936/w160h160_d779f3f4-4d5f-42c1-bc23-78887530351e.jpg",
#        "w300h300": "http://static.yuptv.vn/api/user/users/fa92d7ad-65fa-4790-bbd6-0dc55f721936/w300h300_d779f3f4-4d5f-42c1-bc23-78887530351e.jpg",
#        "w512h512": "http://static.yuptv.vn/api/user/users/fa92d7ad-65fa-4790-bbd6-0dc55f721936/w512h512_d779f3f4-4d5f-42c1-bc23-78887530351e.jpg"
#      },
#      "followings": 1
#    }


    $scope.getListUserInRoom = ()->
      ApiService.room.listUserInRoom {roomId : $scope.id},(err, result)->
        return if err
        return if result and result.error
        $scope.users = result.items

    $scope.$watch 'id',(data)->
      return unless data
      $scope.getListUserInRoom()

    $rootScope.$on 'reload-user-in-room',(event)->
      $scope.getListUserInRoom()

    return
  directive =
    restrict : 'E'
    scope :
      id : '=ngModel'
    link : link
    templateUrl : '/templates/room-detail/list-user-room/view.html'
  return directive
_directive.$inject = ['$rootScope', '$timeout','ApiService' , 'UtilityService']
angular
.module 'app'
.directive "listUserRoom", _directive

