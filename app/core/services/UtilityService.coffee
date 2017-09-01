"use strict"
angular.module("app").factory "UtilityService", [
  '$rootScope',
  '$timeout',
  '$window',
  '$http'
  ($rootScope,
    $timeout,
    $window,
    $http)->

    showMovieRentTimeCountDown = (item) ->
      clearListInterval()
      sec = ((new Date(parseInt(item._extra.expiryDate, 10) * 1000)) - (new Date())) / 1000
      item._extra.hourLeft = Math.floor(sec / 3600)
      item._extra.minuteLeft = strPadLeft(Math.floor((sec % 3600) / 60))
      idInterval = setInterval(()->
        sec = ((new Date(parseInt(item._extra.expiryDate, 10) * 1000)) - (new Date())) / 1000
        item._extra.hourLeft = Math.floor(sec / 3600)
        item._extra.minuteLeft = strPadLeft(Math.floor((sec % 3600) / 60))
        item._extra.secondLeft = strPadLeft(Math.floor(sec - item._extra.hourLeft * 3600 - item._extra.minuteLeft * 60))
        console.log "hh:mm:ss = " + item._extra.hourLeft + ":" + item._extra.minuteLeft + ":" + item._extra.secondLeft
        console.log "hh:mm:ss = " + item._extra.title
      , 1000 * 10)
      addInterval(idInterval)

    addInterval = (idInterval) ->
      $rootScope.listIdInterval.push(idInterval)

    clearListInterval = ()->
      if $rootScope.listIdInterval
        i = 0
        while i < $rootScope.listIdInterval.length
          clearInterval($rootScope.listIdInterval[i])
          console.log 'clear interval id=' + $rootScope.listIdInterval[i]
          i++
        $rootScope.listIdInterval = []

    strPadLeft = (string, pad, length) ->
      pad = "0"  unless pad
      length = 2  unless length
      (new Array(length + 1).join(pad) + string).slice -length

    convertToSlug = (s, character, tolowercase)->
      if !s then return ''
      if !character then character = '-'
      s = s.replace(/á|à|ả|ạ|ã|ă|ắ|ằ|ẳ|ẵ|ặ|â|ấ|ầ|ẩ|ẫ|ậ|a/gi, 'a');
      s = s.replace(/é|è|ẻ|ẽ|ẹ|ê|ế|ề|ể|ễ|ệ|e/gi, 'e');
      s = s.replace(/i|í|ì|ỉ|ĩ|ị|i/gi, 'i');
      s = s.replace(/ó|ò|ỏ|õ|ọ|ô|ố|ồ|ổ|ỗ|ộ|ơ|ớ|ờ|ở|ỡ|ợ|o/gi, 'o');
      s = s.replace(/ú|ù|ủ|ũ|ụ|ư|ứ|ừ|ử|ữ|ự|u/gi, 'u');
      s = s.replace(/ý|ỳ|ỷ|ỹ|ỵ|y/gi, 'y');
      s = s.replace(/đ|d/gi, 'd');
      s = s.replace(/Á|À|Ả|Ạ|Ã|Ă|Ắ|Ằ|Ẳ|Ẵ|Ặ|Â|Ấ|Ầ|Ẩ|Ẫ|Ậ/gi, 'A');
      s = s.replace(/É|È|Ẹ|Ẻ|Ẽ|Ê|Ế|Ề|Ệ|Ể|Ễ|E/gi, 'E');
      s = s.replace(/Í|Ì|Ị|Ỉ|Ĩ|I/gi, 'I');
      s = s.replace(/Ó|Ò|Ọ|Ỏ|Õ|Ô|Ố|Ồ|Ộ|Ổ|Ỗ|Ơ|Ớ|Ờ|Ợ|Ở|Ỡ/gi, 'O');
      s = s.replace(/Ú|Ù|Ụ|Ủ|Ũ|Ư|Ứ|Ừ|Ự|Ử|Ữ/gi, 'U');
      s = s.replace(/Ý|Ỳ|Ỵ|Ỷ|Ỹ/gi, 'Y');
      s = s.replace(/Đ/gi, 'D');
      s = s.replace(/\`|\~|\!|\@|\#|\||\$|\%|\^|\&|\*|\(|\)|\+|\=|\,|\.|\/|\?|\>|\<|\'|\"|\:|\;|_/gi, '');
      s = s.replace(/^-+/gi, '');
      s = s.replace(/-+$/g, '');
      s = s.replace(/([^0-9a-z-\s])/gi, '');
      s = s.replace(/(\s+)/gi, character);
      if tolowercase then return s.toLowerCase()
      return s

    parseTimeStampToDayAgo = (timestamp)->
      res = ''
      date = new Date(timestamp)
      d = new Date()
      dateBetween = d.getDate() - date.getDate()
      if dateBetween == 0
        res = "hôm nay";
      else if(dateBetween >= 1 and dateBetween <= 7)
        res = dateBetween + " ngày trước";
      else
        day = date.getDate();
        year = date.getFullYear();
        month = (date.getMonth() + 1);
        month = '0' + month if(month < 10)
        day = '0' + day if(day < 10)
        res = day + "-" + month + "-" + year;
      return res;

    getMonthMM = (month)->
      if month and parseInt(month) < 10
        return '0' + '' + month
      return '' + month

    checkIsPhoneNumber = (phone)->
      data =
        isPhone : true
        message : ''
      unless phone
        data =
          isPhone : false
          message : 'Vui lòng nhập vào số điện thoại'
        return data
      if phone
        patt = new RegExp("^0");
        res = patt.test(phone)
        if !res
          data.message = "Số điện thoại không đúng định dạng"
          data.isPhone = false
          return data
        patt = new RegExp("^[0-9]+$");
        res = patt.test(phone)
        if !res
          data.message = "Số điện thoại không đúng định dạng"
          data.isPhone = false
          return data
        if phone.length < 10 or phone.length > 11
          data.message = "Số điện thoại không đúng định dạng"
          data.isPhone = false
          return data
        return data
      return data

    checkIsMbfPhoneNumber = (phone)->
      return false unless phone
      phone = phone.toString()
      arrMbfPhone = ['090', '093', '0120', '0121', '0122', '0126', '0128', '089']
      # 0904144144
      isPhone = checkIsPhoneNumber(phone)
      if isPhone.isPhone is false
        return false
      if isPhone.isPhone is true
        sub3Char = phone.substring(0, 3)
        sub4Char = phone.substring(0, 4)
        if sub4Char in arrMbfPhone
          return true
        if sub3Char in arrMbfPhone
          return true
        return false
      return false

    prepareExcludeObToBuyItem = (dataMovie)->
      obQueryexclude = {}
      obQueryexclude = $rootScope.mergeEnvPlatformVersion({exclude : dataMovie.notAllowChargeOnMethod})
      if dataMovie.notAllowChargeOnMethod and dataMovie.notAllowChargeOnMethod.toString() == "[]" or dataMovie.notAllowChargeOnMethod == null
        obQueryexclude = $rootScope.mergeEnvPlatformVersion({exclude : null})
      return obQueryexclude

    getNameOfRedefineTVOD = (method, sources)->
      return unless method
      return method.name unless sources
      return method.name if sources.length <= 0
      i = 0
      while i < sources.length
        if method and sources[i] and method.type == sources[i].methodType
          if method.type == 'MOMO'
            if sources[i].detail
              return "#{sources[i].name} - #{sources[i].detail.mobile}"
          if method.type == 'CCSTRIPE'
            if sources[i].detail
              return "#{sources[i].name} - #{sources[i].detail.last4}"
          if method.type == 'SMARTLINK'
            return sources[i].name + ' '
        i++
      return method.name

    checkMethodIsSource = (method, sources)->
      return false unless method
      return false unless sources
      return false if sources.length <= 0
      i = 0
      while i < sources.length
        if method and sources[i] and method.type == sources[i].methodType
          return true
        i++
      return false

    getSourceIdIfMethodIsSource = (method, sources)->
      return '' unless method
      return '' unless sources
      return '' if sources.length <= 0
      i = 0
      while i < sources.length
        if method and sources[i] and method.type == sources[i].methodType
          return sources[i].id
        i++
      return ''

    checkMovieTimeleftLess48Hour = (movie)->
      compareTime = 48 * 60 * 60 * 1000 #return true if < 48h else false
      if movie and movie.timeLeft < compareTime
        return true
      return false

    checkAndGetSourceVISA = (source)->
      return null unless source
      return null if source.length <= 0
      i = 0
      while i < source.length
        if source[i] and source[i].methodType == 'CCSTRIPE' and source[i].isCurrent == true
          return source[i]
        i++
      return null

    uuid_v4 = ()->
      dt = (new Date).getTime()
      uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
        r = (dt + Math.random() * 16) % 16 | 0
        dt = Math.floor(dt / 16)
        (if c == 'x' then r else r & 0x3 | 0x8).toString 16
      )
      return uuid
    showMessageSyncMomo = (status_code)->
      switch parseInt(status_code)
        when 1006
          return 'Liên kết MoMo không thành công. Lỗi hệ thống'
        when 1007
          return 'Liên kết MoMo không thành công. Lỗi DB'
        when 2001
          return 'Liên kết MoMo không thành công. Token đã tồn tại'
        when 2003
          return 'Liên kết MoMo không thành công. Token không tồn tại'
        when 0
          return 'Liên kết MoMo thành công'
        else
          return ''

    strPadLeft = (string, pad, length) ->
      pad = "0"  unless pad
      length = 2  unless length
      (new Array(length + 1).join(pad) + string).slice -length

    coverTime = (number, isDuration)->
      time_str = ''
      if number >= 3600
        hours = Math.floor(number / 3600)
        time_str += Math.floor(number / 3600) + ':'
        number -= 3600 * hours
      pad = (number, padLength)->
        str = number.toString()
        while(str.length < padLength)
          str = '0' + str
        str
      time_str += pad(Math.floor(number / 60), 2) + ':' + pad(Math.floor(number % 60), 2)
      while(time_str.length < 9)
        if isDuration then time_str = ' ' + time_str
        else time_str += ' '
      return time_str
    parseTimeStampToDayAgo = (timestamp)->
      res = ''
      date = new Date(timestamp)
      d = new Date()
      dateBetween = d.getDate() - date.getDate()
      if dateBetween == 0
        res = "hôm nay";
      else if(dateBetween >= 1 and dateBetween <= 7)
        res = dateBetween + " ngày trước";
      else
        day = date.getDate();
        year = date.getFullYear();
        month = (date.getMonth() + 1);
        if(month < 10)
          month = '0' + month;
        if(day < 10)
          day = '0' + day;
        res = day + "-" + month + "-" + year;
      return res;

    getMonthMM = (month)->
      if month and parseInt(month) < 10
        return '0' + '' + month
      return '' + month

    isSafari = ()->
      unless platform
        return false
      if platform.name and platform.name.toUpperCase().indexOf('SAFARI') != -1
        return true
      return false

    isFirefox = ()->
      typeof InstallTrigger != 'undefined'

    isOpera = ()->
      (!!window.opr and !!opr.addons) or !!window.opera or navigator.userAgent.indexOf(' OPR/') >= 0

    isIE = ()->
      false or !!document.documentMode

    isEdge = ()->
      !isIE() and !!window.StyleMedia

    isChrome = ()->
      !!window.chrome and !!window.chrome.webstore

    isMac = ()->
      return false unless platform
      if platform.ua and platform.ua.toUpperCase().indexOf('MAC') != -1
        return true
      return false

    getVersion = ()->
      ua = navigator.userAgent
      tem = null
      M = ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || []
      if /trident/i.test(M[1])
        tem = /\brv[ :]+(\d+)/g.exec(ua) || [];
        return tem[1] || ''
      if(M[1] is 'Chrome')
        tem = ua.match(/\bOPR\/(\d+)/)
        if(tem != null)
          return tem[1]
      M = if M[2] then [M[1], M[2]] else [navigator.appName, navigator.appVersion, '-?']
      if (tem = ua.match(/version\/(\d+)/i)) != null
        M.splice(1, 1, tem[1])
      return M[1]

    timestamp = ()->
      return (new Date).getTime()

    current = ()->
      dateTime =
        year : 0
        month : 0
        date : 0
        day : ''
        hour : ''
        minute : ''
        second : ''
      currentTime = new Date()
      dateTime.year = currentTime.getFullYear()
      dateTime.month = currentTime.getMonth()
      dateTime.date = currentTime.getDate()
      dateTime.day = currentTime.getDay()
      dateTime.hour = currentTime.getHours()
      dateTime.minute = currentTime.getMinutes()
      dateTime.second = currentTime.getSeconds()
      return dateTime

    digits = (number, isDuration)->
      time_str = ''
      if number >= 3600
        hours = Math.floor(number / 3600)
        time_str += Math.floor(number / 3600) + ':'
        number -= 3600 * hours
      pad = (number, padLength)->
        str = number.toString()
        while(str.length < padLength)
          str = '0' + str
        str
      time_str += pad(Math.floor(number / 60), 2) + ':' + pad(Math.floor(number % 60), 2)
      while(time_str.length < 9)
        if isDuration then time_str = ' ' + time_str
        else time_str += ' '
      return time_str

    fullscreen = (element)->
      if document.fullscreenElement is null or document.mozFullScreenElement is null or document.webkitFullscreenElement is null or document.msFullscreenElement is null
        if element.requestFullscreen
          element.requestFullscreen()
        else if element.msRequestFullscreen
          element.msRequestFullscreen()
        else if element.mozRequestFullScreen
          element.mozRequestFullScreen()
        else if element.webkitRequestFullscreen
          element.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT)
        return true
      else
        if document.exitFullscreen
          document.exitFullscreen()
        else if document.msExitFullscreen
          document.msExitFullscreen()
        else if document.mozCancelFullScreen
          document.mozCancelFullScreen()
        else if document.webkitExitFullscreen
          document.webkitExitFullscreen()
        return false

    isFullscreen = ()->
      not (document.fullscreenElement is null or document.mozFullScreenElement is null or document.webkitFullscreenElement is null or document.msFullscreenElement is null)

    getText = (text)->
      unless text
        return 'Unknown error'
      _lang =
        error_message :
          vi : 'Kết nối đến máy chủ tạm thời gián đoạn. Nếu liên tục xảy ra tình trạng này vui lòng liên hệ 18009090'
        error_103 :
          vi : 'Lỗi: Không xem được do bảo mật nội dung. Bạn đang kết nối với màn hình hoặc thiết bị không hỗ trợ chuẩn HDCP (thường do có 1 màn hình thứ 2 được kết nối với máy tính của bạn). <br>Để biết thêm thông tin vui lòng liên hệ 18009090'
        error_widevine :
          vi : 'Trình duyệt của quý khách cần cài đặt plugin widevine để xem phim trên Fim+. Vui lòng cài đặt theo hướng dẫn tại đây:<br><a target="_blank" href="http://www.widevine.com/download/videooptimizer">http://www.widevine.com/download/videooptimizer</a>'
        error_version_firefox :
          vi : 'Hiện tại Fim+ đã ngưng hỗ trợ Firefox {version}. Vui lòng cập nhật Firefox lên phiên bản mới nhất tại đây:<br><a target="_blank" href="https://www.mozilla.org/en-US/firefox/new/">https://www.mozilla.org/en-US/firefox/new/</a>'
        error_code :
          vi : 'Mã lỗi'
        error_get_playlist_107 :
          vi : 'Không thể lấy được dữ liệu. Vui lòng thử lại'
        view_controlbar_option_back :
          vi : 'Trở về'
        view_controlbar_option_subtitle :
          vi : 'Phụ đề'
        view_controlbar_option_subtitle_off :
          vi : 'Tắt'
        view_controlbar_option_quality :
          vi : 'Chất lượng'
        view_controlbar_option_quality_auto :
          vi : 'Tự động'
      return _lang[text]['vi']

    havePlugin = (name)->
      try
        if navigator.mimeTypes[name]
          return true
        return false
      catch
        return false

    qualityToLabel = (quality)->
      label = ''
      if quality.height
        label = quality.height + 'p'
        if quality.bandwidth
          if( (quality.height is 720 and quality.bandwidth > 3000000) or (quality.height is 1080 and quality.bandwidth > 6000000) )
            label += '+'
      else if quality.bandwidth
        label = parseInt((quality.bandwidth / 1024) + ' kbps')
      return label

    stringToArray = (str)->
      buffer = new ArrayBuffer str.length * 2
      arr = new Uint16Array buffer
      strLen = str.length
      for i in [0..strLen - 1]
        arr[i] = str.charCodeAt i
      return arr

    arrayToString = (arr)->
      uint16array = new Uint16Array arr.buffer
      String.fromCharCode.apply null, uint16array

    base64DecodeUint8Array = (input)->
#window.localStorage.base64DecodeUint8Array = JSON.stringify(input)
      raw = window.atob(input)
      rawLength = raw.length
      array = new Uint8Array new ArrayBuffer(rawLength)
      for i in [0..rawLength - 1]
        array[i] = raw.charCodeAt(i)
      return array

    base64EncodeUint8Array = (input)->
#            input = input.replace(/\s/g, '') if input
      keyStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='
      output = ''
      chr1 = null
      chr2 = null
      chr3 = null
      enc1 = null
      enc2 = null
      enc3 = null
      enc4 = null
      i = 0
      while i < input.length
        chr1 = input[i++]
        chr2 = if i < input.length then input[i++] else Number.NaN
        chr3 = if i < input.length then input[i++] else Number.NaN

        enc1 = chr1 >> 2
        enc2 = ((chr1 & 3) << 4) | (chr2 >> 4)
        enc3 = ((chr2 & 15) << 2) | (chr3 >> 6)
        enc4 = chr3 & 63
        if isNaN chr2
          enc3 = enc4 = 64
        else if isNaN chr3
          enc4 = 64
        output += keyStr.charAt(enc1) + keyStr.charAt(enc2) + keyStr.charAt(enc3) + keyStr.charAt(enc4)
      return output

    getConfigPlayer = (options)->
      unless options
        console.error 'getConfigPlayer ERROR, options NULL'
        return {}
      obconfig =
        customData :
          userId : options.userId
          sessionId : options.sessionPlayId
          merchant : 'fimplus'
        assetId : ''
        variantId : ''
        authenticationToken : null
        widevineLicenseServerURL : 'https://lic.drmtoday.com/license-proxy-widevine/cenc/'
        accessLicenseServerURL : 'https://lic.drmtoday.com/flashaccess/LicenseTrigger/v1'
        playReadyLicenseServerURL : 'https://lic.drmtoday.com/license-proxy-headerauth/drmtoday/RightsManager.asmx'
        fairPlayLicenseServerURL : 'https://lic.drmtoday.com/license-server-fairplay/'
        fairPlayCertificateServerURL : 'https://lic.drmtoday.com/license-server-fairplay/cert/'
        silverlightFile : "/player/#{player.version}/dasheverywhere#{player.versionDashEverywhere}/dashcs/dashcs.xap?t=" + (new Date).getTime()
        flashFile : "/player/#{player.version}/dasheverywhere#{player.versionDashEverywhere}/dashas/dashas.swf?t=" + (new Date).getTime()
        techs : ['dashjs', 'dashas']
      if window.ENV in ['staging', 'dev', 'sandbox', 'local']
        obconfig.widevineLicenseServerURL = 'https://lic.staging.drmtoday.com/license-proxy-widevine/cenc/'
        obconfig.accessLicenseServerURL = 'https://lic.staging.drmtoday.com/flashaccess/LicenseTrigger/v1'
        obconfig.playReadyLicenseServerURL = 'https://lic.staging.drmtoday.com/license-proxy-headerauth/drmtoday/RightsManager.asmx'
        obconfig.fairPlayLicenseServerURL = 'https://lic.staging.drmtoday.com/license-server-fairplay/'
        obconfig.fairPlayCertificateServerURL = 'https://lic.staging.drmtoday.com/license-server-fairplay/cert/'
      return obconfig
    timeMs = (val)->
      regex = /(\d+):(\d{2}):(\d{2}).(\d{3})/
      parts = regex.exec val
      return 0 if parts is null
      i = 1
      while i < 5
        parts[i] = parseInt parts[i], 10
        parts[i] = 0  if isNaN parts[i]
        i++
      # hours + minutes + seconds + ms
      time = parts[1] * 3600000 + parts[2] * 60000 + parts[3] * 1000 + parts[4]
      return time
    parseRequest = (track, data, cb)->
#            console.log 'parseRequest', data
      data = data.replace /\r/g, ''
      regex = /(\d{2}:\d{2}:\d{2}.\d{3}) --> (\d{2}:\d{2}:\d{2}.\d{3})/g
      window.data = data
      data = data.split regex
      data.shift()
      items = []
      i = 0
      while i < data.length
        try
          items.push({
            id : data[i].trim(),
            startTime : timeMs(data[i].trim()),
            endTime : timeMs(data[i + 1].trim()),
            text : data[i + 2].split('\n\n')[0].trim()
          })
        catch error
          console.error 'UtilityService parseRequest', error
        i = i + 3
      return cb(track, items)

    searchSub = (sub, time) ->
      if sub is undefined
#                console.error 'searchSub sub is undefined'
        return false
      left = 0
      right = sub.length - 1
      mid = 0
      a = 0
      while left < right
        a++
        mid = (left + right ) / 2
        mid = Math.ceil(mid)
        if sub[0] and time >= sub[0].startTime and time <= sub[0].endTime
          return sub[0]
        if sub[mid] and time >= sub[mid].startTime and time <= sub[mid].endTime
          return sub[mid]
        if time > sub[mid].endTime
          left = mid
        else
          right = mid - 1
      return false
    return {
      showMovieRentTimeCountDown : showMovieRentTimeCountDown,
      convertToSlug : convertToSlug,
      parseTimeStampToDayAgo : parseTimeStampToDayAgo,
      getMonthMM : getMonthMM,
      coverTime : coverTime,
      checkIsPhoneNumber : checkIsPhoneNumber,
      checkIsMbfPhoneNumber : checkIsMbfPhoneNumber,
      prepareExcludeObToBuyItem : prepareExcludeObToBuyItem,
      getNameOfRedefineTVOD : getNameOfRedefineTVOD,
      checkMethodIsSource : checkMethodIsSource,
      getSourceIdIfMethodIsSource : getSourceIdIfMethodIsSource,
      checkMovieTimeleftLess48Hour : checkMovieTimeleftLess48Hour,
      checkAndGetSourceVISA : checkAndGetSourceVISA,
      uuid_v4 : uuid_v4,
      showMessageSyncMomo : showMessageSyncMomo,
      player : {
        getConfigPlayer : getConfigPlayer,
        isSafari : isSafari,
        isFirefox : isFirefox,
        isOpera : isOpera,
        getVersion : getVersion,
        isIE : isIE,
        isMac : isMac,
        isChrome : isChrome,
        isEdge : isEdge,
        timestamp : timestamp,
        digits : digits,
        current : current,
        fullscreen : fullscreen,
        isFullscreen : isFullscreen,
        getText : getText,
        havePlugin : havePlugin,
        qualityToLabel : qualityToLabel,
        stringToArray : stringToArray,
        arrayToString : arrayToString,
        base64DecodeUint8Array : base64DecodeUint8Array,
        base64EncodeUint8Array : base64EncodeUint8Array,
        timeMs : timeMs,
        parseRequest : parseRequest,
        searchSub : searchSub,
      }
    }
]
