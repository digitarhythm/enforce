# random
rand = (n)->
    return parseInt(Math.floor(Math.random() * (n + 1)))

# debug write
JSLog = (a, b...)-> 
    if (DEBUG == true)
        for data in b
            match = a.match(/%0\d*@/)
            if (match?)
                repstr = match[0]
                num = parseInt(repstr.match(/\d+/))
                zero =""
                zero += "0" while (zero.length < num)
                data2 = (zero+data).substr(-num)
                a = a.replace(repstr, data2)
            else
                a = a.replace('%@', data)
        console.log(a)

# format strings
sprintf = (a, b...)-> 
    for data in b
        match = a.match(/%0\d*@/)
        if (match?)
            repstr = match[0]
            num = parseInt(repstr.match(/\d+/))
            zero =""
            zero += "0" while (zero.length < num)
            data2 = (zero+data).substr(-num)
            a = a.replace(repstr, data2)
        else
            a = a.replace('%@', data)
    return a

# create unique ID
uniqueID =->
    S4 = ->
        return (((1+Math.random())*0x10000)|0).toString(16).substring(1)
    return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4())

getBounds =->
    frame = [parseInt(document.documentElement.clientWidth - 1), parseInt(document.documentElement.clientHeight - 1)]
    return frame

getKeyDirection =->
    dir = {
        x: 0
        y: 0
    }
    if (core.input.up)
        dir['y'] = -1
    if (core.input.down)
        dir['y'] = 1
    if (core.input.right)
        dir['x'] = 1
    if (core.input.left)
        dir['x'] = -1
    return dir

# set cookie value
setCookie = (name, value, expireValue = 1)->
    maxage = expireValue * 24 * 3600
    document.cookie = (name+'='+escape(value)+'; max-age='+maxage)

# get cookie value
getCookie = (name)->
    result = []
    allcookies = document.cookie.split('; ')
    if (allcookies.length > 0)
        for i in [0...(allcookies.length)]
            cookie = allcookies[i].split('=')
            result[cookie[0]] = decodeURIComponent(cookie[1])
    return result[name]

# WebGL check
isWebGL = ->
    try
        return !! window.WebGLRenderingContext && !! document.createElement('canvas').getContext('experimental-webgl')
    catch e
        return false

# Swap value
swap = (a, b)->
    c = a
    a = b
    b = c

# URL Get Query Parser
separateGETquery = ->
    result = {}
    if (1 < window.location.search.length)
        query = window.location.search.substring(1)
        parameters = query.split('&')
        for i in [0...parameters.length]
            element = parameters[i].split('=')
            paramName = decodeURIComponent(element[0])
            paramValue = decodeURIComponent(element[1])
            result[paramName] = paramValue.replace(/\+/g, ' ')
    return result

# sanitize
userStr =
  encode: (str) ->
    str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace /'/g, '&#39;'
  decode: (str) ->
    str.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g, '\'').replace /&amp;/g, '&'

# 現在時間取得
__getTime = ->
    return parseFloat((new Date).getTime())

# do noting
nop =->

# disp strings
dispImageStrings = (param)->
    x = if (param.x?) then param.x else 0
    y = if (param.y?) then param.y else 0
    size = if (param.size?) then param.size else 1.0
    color = if (param.color?) then param.color else 0
    scene = if (param.scene?) then param.scene else GAMESCENE_SUB2
    opacity = if (param.opacity?) then param.opacity else 1.0
    labeltext = if (param.labeltext?) then param.labeltext else "text"

    obj = addObject
        type: CONTROL
        motionObj: _dispImageStrings
        x: x
        y: y
        opacity: opacity
    obj.dispStrings
        size: size
        labeltext: labeltext
        color: color
        scene: scene
    return obj
