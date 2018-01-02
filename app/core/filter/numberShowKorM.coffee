# Based on http://stackoverflow.com/questions/1571374/converting-values-to-unit-prefixes-in-jsp-page.
# The inner filter function can be used standalone.
angular.module('app').filter 'thousandSuffix', ->
  (input, decimals) ->
    exp = undefined
    rounded = undefined
    suffixes = [
      'K'
      'M'
      'G'
      'T'
      'P'
      'E'
    ]
    if !input
      return 0
    if isNaN(input) and _.isString(input)
      input = parseInt(input)
    if isNaN(input)
      return 0
    return input if input < 1000
    exp = Math.floor(Math.log(input)/Math.log(1000))
    return (input/Math.pow(1000, exp)).toFixed(decimals)+suffixes[exp-1]
