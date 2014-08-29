GAMEPADPROCEDURE['chrome_gamepad'] =->
    for padnum in [0..._GAMEPADSINFO.length]
        gamepad = _GAMEPADSINFO[padnum]
        if (!gamepad?)
            continue

        # 各種ボタン情報取得
        buttons = gamepad.buttons
        axes = gamepad.axes

        # ゲームパッドボタン情報取得
        # 各種ゲームパッドで共通の情報が取れるがボタンが6つなので、それ以降のボタン情報は破棄する
        max = (if (buttons.length < 6) then buttons.length else 6)
        if (padnum > 0)
            PADBUTTONS[padnum] = []
            PADAXES[padnum] = []
            ANALOGSTICK[padnum] = []
        for btnum in [0...max]
            bt = buttons[btnum]
            PADBUTTONS[padnum][btnum] = bt.pressed

        # アナログスティック情報取得
        ANALOGSTICK[padnum][VERTICAL] = gamepad.axes[VERTICAL]
        ANALOGSTICK[padnum][HORIZONTAL] = gamepad.axes[HORIZONTAL]
        ANALOGSTICK[padnum][VERTICAL2] = gamepad.axes[VERTICAL2]
        ANALOGSTICK[padnum][HORIZONTAL2] = gamepad.axes[HORIZONTAL2]

        # 水平方向ボタンデータ取得
        if ((gamepad.buttons[14]? && gamepad.buttons[14].pressed) || gamepad.axes[HORIZONTAL].pressed || parseInt(gamepad.axes[HORIZONTAL]) < 0)
            PADAXES[padnum][HORIZONTAL] = -1
        else if ((gamepad.buttons[15]? && gamepad.buttons[15].pressed) || gamepad.axes[HORIZONTAL].pressed || parseInt(gamepad.axes[HORIZONTAL]) > 0)
            PADAXES[padnum][HORIZONTAL] = 1
        else
            PADAXES[padnum][HORIZONTAL] = 0

        # 垂直方向ボタンデータ取得
        if ((gamepad.buttons[12]? && gamepad.buttons[12].pressed) || gamepad.axes[VERTICAL].pressed || parseInt(gamepad.axes[VERTICAL]) < 0)
            PADAXES[padnum][VERTICAL] = -1
        else if ((gamepad.buttons[13]? && gamepad.buttons[13].pressed) || gamepad.axes[VERTICAL].pressed || parseInt(gamepad.axes[VERTICAL]) > 0)
            PADAXES[padnum][VERTICAL] = 1
        else
            PADAXES[padnum][VERTICAL] = 0

