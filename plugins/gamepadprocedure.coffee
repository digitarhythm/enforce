_GAMEPADPROCEDURE_ = []
_start_rt = 0
_start_lt = 0

_GAMEPADPROCEDURE_['firefox_gamepad'] =(gamepadsinfo)->
    padresult = []
    for padnum in [0...gamepadsinfo.length]
        gamepad = gamepadsinfo[padnum]
        if (!gamepad?)
            continue

        # 各種ボタン情報取得
        buttons = gamepad.buttons
        axes = gamepad.axes
        index = gamepad.index
        id = gamepad.id

        # ゲームパッドボタン情報取得
        # 各種ゲームパッドで共通の情報が取れるがボタンが8つなので、それ以降のボタン情報は破棄する
        max = 13

        padbuttons = []
        analogstick = []

        if (id.match(/.*45e.*?28e.*/))
            xbox360pad = true
        else
            xbox360pad = false

        if (xbox360pad)
            ###
            for btnum in [0...max]
                bt = buttons[btnum]
                padbuttons[btnum] = bt.pressed
            ###
            padbuttons[0] = buttons[11].pressed
            padbuttons[1] = buttons[12].pressed
            padbuttons[2] = buttons[13].pressed
            padbuttons[3] = buttons[14].pressed

            padbuttons[4] = buttons[8].pressed
            padbuttons[5] = buttons[9].pressed

            padbuttons[6] = buttons[5].pressed
            padbuttons[7] = buttons[4].pressed

            if (_start_rt == axes[2])
                padbuttons[8] = 0
            else
                padbuttons[8] = ((axes[2] + 1) / 2)
            if (_start_lt == axes[5])
                padbuttons[9] = 0
            else
                padbuttons[9] = ((axes[5] + 1) / 2)

            padbuttons[10]= buttons[6].pressed
            padbuttons[11]= buttons[7].pressed

            padbuttons[12]= buttons[10].pressed

            analogstick[0] = [axes[0], axes[1]]
            analogstick[1] = [axes[3], axes[4]]
        else
            ###
            for btnum in [0...max]
                bt = buttons[btnum]
                padbuttons[btnum] = bt.pressed
            ###
            padbuttons[0] = buttons[0].pressed
            padbuttons[1] = buttons[1].pressed
            padbuttons[2] = buttons[2].pressed
            padbuttons[3] = buttons[3].pressed

            padbuttons[4] = buttons[6].pressed
            padbuttons[5] = buttons[7].pressed

            padbuttons[6] = buttons[8].pressed
            padbuttons[7] = buttons[9].pressed

            padbuttons[8] = parseFloat(if (buttons[4].pressed) then 1.0 else 0.0)
            padbuttons[9] = parseFloat(if (buttons[5].pressed) then 1.0 else 0.0)

            padbuttons[10] = buttons[10].pressed
            padbuttons[11] = buttons[11].pressed

            padbuttons[12] = 0

            analogstick[0] = [axes[0], axes[1]]
            analogstick[1] = [axes[2], axes[3]]

        # 水平方向ボタンデータ取得
        padaxes = []
        if ((gamepad.buttons[2]? && gamepad.buttons[2].pressed) || gamepad.axes[0].pressed || parseInt(gamepad.axes[0]) < 0)
            padaxes[0] = -1
        else if ((gamepad.buttons[3]? && gamepad.buttons[3].pressed) || gamepad.axes[0].pressed || parseInt(gamepad.axes[0]) > 0)
            padaxes[0] = 1
        else
            padaxes[0] = 0

        # 垂直方向ボタンデータ取得
        if ((gamepad.buttons[0]? && gamepad.buttons[0].pressed) || gamepad.axes[1].pressed || parseInt(gamepad.axes[1]) < 0)
            padaxes[1] = -1
        else if ((gamepad.buttons[1]? && gamepad.buttons[1].pressed) || gamepad.axes[1].pressed || parseInt(gamepad.axes[1]) > 0)
            padaxes[1] = 1
        else
            padaxes[1] = 0

        padresult[index] = []
        padresult[index].id = id
        padresult[index].padbuttons = padbuttons
        padresult[index].padaxes = padaxes
        padresult[index].analogstick = analogstick

    return padresult

_GAMEPADPROCEDURE_['chrome_gamepad'] =(gamepadsinfo)->
    padresult = []
    for padnum in [0...gamepadsinfo.length]
        gamepad = gamepadsinfo[padnum]
        if (!gamepad?)
            continue

        # 各種ボタン情報取得
        buttons = gamepad.buttons
        axes = gamepad.axes
        index = gamepad.index
        id = gamepad.id

        # ゲームパッドボタン情報取得
        # 各種ゲームパッドで共通の情報が取れるがボタンが8つなので、それ以降のボタン情報は破棄する
        max = 13

        padbuttons = []
        analogstick = []

        if (id.match(/.*45e.*?28e.*/))
            xbox360pad = true
            max = 9
        else
            xbox360pad = false

        if (xbox360pad)
            ###
            for btnum in [0...max]
                bt = buttons[btnum]
                padbuttons[btnum] = bt.pressed
            ###
            padbuttons[0] = buttons[0].pressed
            padbuttons[1] = buttons[1].pressed
            padbuttons[2] = buttons[2].pressed
            padbuttons[3] = buttons[3].pressed

            padbuttons[4] = buttons[4].pressed
            padbuttons[5] = buttons[5].pressed

            padbuttons[6] = buttons[8].pressed
            padbuttons[7] = buttons[9].pressed

            padbuttons[8] = buttons[6].value
            padbuttons[9] = buttons[7].value

            padbuttons[10] = buttons[10].pressed
            padbuttons[11] = buttons[11].pressed

            padbuttons[12] = buttons[16].pressed

            analogstick[0] = [axes[0], axes[1]]
            analogstick[1] = [axes[2], axes[3]]
        else
            ###
            for btnum in [0...max]
                bt = buttons[btnum]
                padbuttons[btnum] = bt.pressed
            ###
            padbuttons[0] = buttons[0].pressed
            padbuttons[1] = buttons[1].pressed
            padbuttons[2] = buttons[2].pressed
            padbuttons[3] = buttons[3].pressed

            padbuttons[4] = buttons[6].pressed
            padbuttons[5] = buttons[7].pressed

            padbuttons[6] = buttons[8].pressed if (buttons[8]?)
            padbuttons[7] = buttons[9].pressed if (buttons[9]?)

            padbuttons[8] = if (buttons[4].pressed) then 1.0 else 0.0
            padbuttons[9] = if (buttons[5].pressed) then 1.0 else 0.0

            padbuttons[10] = buttons[10].pressed
            padbuttons[11] = buttons[11].pressed

            padbuttons[12] = 0
            ##

            analogstick[0] = [axes[0], axes[1]]
            analogstick[1] = [axes[2], axes[5]]

        # 水平方向ボタンデータ取得
        padaxes = []
        if ((gamepad.buttons[14]? && gamepad.buttons[14].pressed) || gamepad.axes[0].pressed || parseInt(gamepad.axes[0]) < 0)
            padaxes[0] = -1
        else if ((gamepad.buttons[15]? && gamepad.buttons[15].pressed) || gamepad.axes[0].pressed || parseInt(gamepad.axes[0]) > 0)
            padaxes[0] = 1
        else
            padaxes[0] = 0

        # 垂直方向ボタンデータ取得
        if ((gamepad.buttons[12]? && gamepad.buttons[12].pressed) || gamepad.axes[1].pressed || parseInt(gamepad.axes[1]) < 0)
            padaxes[1] = -1
        else if ((gamepad.buttons[13]? && gamepad.buttons[13].pressed) || gamepad.axes[1].pressed || parseInt(gamepad.axes[1]) > 0)
            padaxes[1] = 1
        else
            padaxes[1] = 0

        padresult[index] = []
        padresult[index].id = id
        padresult[index].padbuttons = padbuttons
        padresult[index].padaxes = padaxes
        padresult[index].analogstick = analogstick

    return padresult

gamepadProcedure =->
    # ブラウザ大分類
    _ua = window.navigator.userAgent.toLowerCase()
    if (_ua.match(/.* firefox\/.*/))
        _browserMajorClass = "firefox"
    else if (_ua.match(/.*version\/.* safari\/.*/))
        _browserMajorClass = "safari"
    else if (_ua.match(/.*chrome\/.* safari\/.*/))
        _browserMajorClass = "chrome"
    else
        _browserMajorClass = "unknown"

    padresult = []
    browserGamepadFunctionName = _browserMajorClass+"_gamepad"
    if (typeof _GAMEPADPROCEDURE_[browserGamepadFunctionName] == 'function')
        gamepadsinfo = if (navigator.getGamepads) then navigator.getGamepads() else (if (navigator.webkitGetGamepads) then navigator.webkitGetGamepads else [])
        if (gamepadsinfo? && gamepadsinfo.length > 0)
            padresult = _GAMEPADPROCEDURE_[browserGamepadFunctionName](gamepadsinfo)

    return padresult

