_start_rt = 0
_start_lt = 0

_GAMEPADPROCEDURE =(browser, gamepadsinfo)->
    padresult = []
    for padnum in [0...gamepadsinfo.length]
        gamepad = gamepadsinfo[padnum]
        if (!gamepad?)
            continue

        # 各種ボタン情報取得
        buttons = gamepad.buttons
        axes = gamepad.axes
        index = gamepad.index
        #mapping = gamepad.mapping
        connected = gamepad.connected
        id = gamepad.id

        ###
        for btnum in [0...max]
            bt = buttons[btnum]
            padbuttons[btnum] = bt.pressed
        ###
        kind = _getGamePadKind(id)
        ret = _getControllerValue(browser, kind, buttons, axes)
        if (!ret?)
            return undefined
        padbuttons = ret[0]
        analogstick = ret[1]

        # 水平方向ボタンデータ取得
        padaxes = []
        if (gamepad.axes[0].pressed || parseInt(gamepad.axes[0]) < 0)
            padaxes[0] = -1
        else if (gamepad.axes[0].pressed || parseInt(gamepad.axes[0]) > 0)
            padaxes[0] = 1
        else
            padaxes[0] = 0

        # 垂直方向ボタンデータ取得
        if (gamepad.axes[1].pressed || parseInt(gamepad.axes[1]) < 0)
            padaxes[1] = -1
        else if (gamepad.axes[1].pressed || parseInt(gamepad.axes[1]) > 0)
            padaxes[1] = 1
        else
            padaxes[1] = 0

        padresult[index] = []
        padresult[index].id = id
        padresult[index].padbuttons = padbuttons
        padresult[index].padaxes = padaxes
        padresult[index].analogstick = analogstick

    return padresult

_getControllerValue = (browser, kind, buttons, axes)->
    ret = undefined
    if (kind.match(/.*xbox.*/))
        # ゲームパッドボタン情報取得
        # 各種ゲームパッドで共通の情報が取れるがボタンが8つなので、それ以降のボタン情報は破棄する
        max = 13
        ret = _getXBOX360Controller(browser, buttons, axes)
    else if (kind.match(/.*psx.*/))
        # ゲームパッドボタン情報取得
        # 各種ゲームパッドで共通の情報が取れるがボタンが8つなので、それ以降のボタン情報は破棄する
        max = 13
        ret = _getPSXController(browser, buttons, axes)
    else if (kind.match(/.*bsgp1204p.*/))
        # ゲームパッドボタン情報取得
        # 各種ゲームパッドで共通の情報が取れるがボタンが8つなので、それ以降のボタン情報は破棄する
        max = 13
        ret = _getBSGP1204pController(browser, buttons, axes)
    else
        # ゲームパッドボタン情報取得
        # 各種ゲームパッドで共通の情報が取れるがボタンが8つなので、それ以降のボタン情報は破棄する
        max = 8
        ret = _getOtherController(browser, buttons, axes)
    return ret

_getXBOX360Controller = (browser, buttons, axes)->
    padbuttons = []
    analogstick = []
    if (browser == "firefox")
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

        ret = [padbuttons, analogstick]
    else if (browser == "chrome")
        padbuttons[0] = buttons[0].pressed
        padbuttons[1] = buttons[1].pressed
        padbuttons[2] = buttons[2].pressed
        padbuttons[3] = buttons[3].pressed

        padbuttons[4] = buttons[4].pressed
        padbuttons[5] = buttons[5].pressed

        padbuttons[6] = buttons[8].pressed
        padbuttons[7] = buttons[9].pressed

        if (_start_rt == buttons[6].value)
            padbuttons[8] = 0
        else
            padbuttons[8] = ((buttons[6].value + 1) / 2)

        if (_start_lt == buttons[7].value)
            padbuttons[9] = 0
        else
            padbuttons[9] = ((buttons[7].value + 1) / 2)

        padbuttons[10]= buttons[10].pressed
        padbuttons[11]= buttons[11].pressed

        padbuttons[12]= buttons[16].pressed

        analogstick[0] = [axes[0], axes[1]]
        analogstick[1] = [axes[3], axes[2]]

        ret = [padbuttons, analogstick]

    return ret

_getPSXController = (browser, buttons, axes)->
    padbuttons = []
    analogstick = []
    if (browser == "firefox")
        padbuttons[0] = buttons[0].pressed
        padbuttons[1] = buttons[1].pressed
        padbuttons[2] = buttons[2].pressed
        padbuttons[3] = buttons[3].pressed

        padbuttons[4] = buttons[4].pressed
        padbuttons[5] = buttons[6].pressed

        padbuttons[6] = buttons[8].pressed
        padbuttons[7] = buttons[9].pressed

        padbuttons[8] = parseFloat(if (buttons[5].pressed) then 1.0 else 0.0)
        padbuttons[9] = parseFloat(if (buttons[7].pressed) then 1.0 else 0.0)

        padbuttons[10] = buttons[10].pressed
        padbuttons[11] = buttons[11].pressed

        padbuttons[12] = 0

        analogstick[0] = [axes[0], axes[1]]
        analogstick[1] = [axes[2], axes[3]]

        ret = [padbuttons, analogstick]
    else if (browser == "chrome")
        padbuttons[0] = buttons[0].pressed
        padbuttons[1] = buttons[1].pressed
        padbuttons[2] = buttons[2].pressed
        padbuttons[3] = buttons[3].pressed

        padbuttons[4] = buttons[4].pressed
        padbuttons[5] = buttons[6].pressed

        padbuttons[6] = buttons[8].pressed
        padbuttons[7] = buttons[9].pressed

        padbuttons[8] = parseFloat(if (buttons[5].pressed) then 1.0 else 0.0)
        padbuttons[9] = parseFloat(if (buttons[7].pressed) then 1.0 else 0.0)

        padbuttons[10] = buttons[10].pressed
        padbuttons[11] = buttons[11].pressed

        padbuttons[12] = 0

        analogstick[0] = [axes[0], axes[1]]
        analogstick[1] = [axes[2], axes[3]]

        ret = [padbuttons, analogstick]

    return ret

_getBSGP1204pController = (browser, buttons, axes)->
    padbuttons = []
    analogstick = []
    if (browser == "firefox")
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

        ret = [padbuttons, analogstick]
    else if (browser == "chrome")
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
        analogstick[1] = [axes[2], axes[5]]

        ret = [padbuttons, analogstick]

    return ret

_getOtherController = (browser, buttons, axes)->
    padbuttons = []
    analogstick = []
    if (browser == "firefox")
        padbuttons[0] = buttons[0].pressed
        padbuttons[1] = buttons[1].pressed
        padbuttons[2] = buttons[2].pressed
        padbuttons[3] = buttons[3].pressed

        padbuttons[4] = buttons[4].pressed
        padbuttons[5] = buttons[5].pressed

        padbuttons[6] = buttons[6].pressed
        padbuttons[7] = buttons[7].pressed

        analogstick[0] = [0.0, 0.0]
        analogstick[1] = [0.0, 0.0]

        ret = [padbuttons, analogstick]
    else if (browser == "chrome")
        padbuttons[0] = buttons[0].pressed
        padbuttons[1] = buttons[1].pressed
        padbuttons[2] = buttons[2].pressed
        padbuttons[3] = buttons[3].pressed

        padbuttons[4] = buttons[4].pressed
        padbuttons[5] = buttons[5].pressed

        padbuttons[6] = buttons[6].pressed
        padbuttons[7] = buttons[7].pressed

        analogstick[0] = [0.0, 0.0]
        analogstick[1] = [0.0, 0.0]

        ret = [padbuttons, analogstick]

    return ret


_getGamePadKind = (id)->
    kind = "unknown"
    if (id.match(/.*45e.*28e.*/))
        kind = "xbox360.wired"
    else if (id.match(/.*d9d.*3013.*/))
        kind = "psx.wired"
    else if (id.match(/.*1dd8.*0010.*/))
        kind = "ibuffalo.bsgp1204p"

    return kind

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
    gamepadsinfo = if (navigator.getGamepads) then navigator.getGamepads() else (if (navigator.webkitGetGamepads) then navigator.webkitGetGamepads else [])
    if (gamepadsinfo? && gamepadsinfo.length > 0)
        padresult = _GAMEPADPROCEDURE(_browserMajorClass, gamepadsinfo)

    return padresult

