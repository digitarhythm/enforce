_GAMEPADPROCEDURE_ = []
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

        # ゲームパッドボタン情報取得
        # 各種ゲームパッドで共通の情報が取れるがボタンが6つなので、それ以降のボタン情報は破棄する
        max = (if (buttons.length < 6) then buttons.length else 6)

        # ボタン情報を取得する
        padbuttons = []
        for btnum in [0...max]
            bt = buttons[btnum]
            padbuttons[btnum] = bt.pressed

        # アナログスティック情報取得
        analogstick = []
        analogstick[0] = [gamepad.axes[0], gamepad.axes[1]]
        analogstick[1] = [gamepad.axes[2], gamepad.axes[3]]

        # 水平方向ボタンデータ取得
        padaxes = []
        if ((gamepad.buttons[13]? && gamepad.buttons[13].pressed) || gamepad.axes[0].pressed || parseInt(gamepad.axes[0]) < 0)
            padaxes[0] = -1
        else if ((gamepad.buttons[14]? && gamepad.buttons[14].pressed) || gamepad.axes[0].pressed || parseInt(gamepad.axes[0]) > 0)
            padaxes[0] = 1
        else
            padaxes[0] = 0

        # 垂直方向ボタンデータ取得
        if ((gamepad.buttons[11]? && gamepad.buttons[11].pressed) || gamepad.axes[1].pressed || parseInt(gamepad.axes[1]) < 0)
            padaxes[1] = -1
        else if ((gamepad.buttons[12]? && gamepad.buttons[12].pressed) || gamepad.axes[1].pressed || parseInt(gamepad.axes[1]) > 0)
            padaxes[1] = 1
        else
            padaxes[1] = 0

        padresult[index] = []
        padresult[index].id = gamepad.id
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

        # ゲームパッドボタン情報取得
        # 各種ゲームパッドで共通の情報が取れるがボタンが6つなので、それ以降のボタン情報は破棄する
        max = (if (buttons.length < 6) then buttons.length else 6)

        # ボタン情報を取得する
        padbuttons = []
        for btnum in [0...max]
            bt = buttons[btnum]
            padbuttons[btnum] = bt.pressed

        # アナログスティック情報取得
        analogstick = []
        analogstick[0] = [gamepad.axes[0], gamepad.axes[1]]
        analogstick[1] = [gamepad.axes[2], gamepad.axes[3]]

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
        padresult[index].id = gamepad.id
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

