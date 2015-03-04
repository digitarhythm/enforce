class _vgamepadcontrol extends _stationary
    #**************************
    # character constructor
    #**************************
    constructor:(initparam)->
        super(initparam)
        @vgamepad = undefined
        @vgamecursor = undefined
        @vgamebuttonlist = []

        @input = []
        @input.axes = []
        @input.axes.up = false
        @input.axes.down = false
        @input.axes.left = false
        @input.axes.right = false
        @input.buttons = [false, false, false, false, false, false]

    #**************************
    # character destructor
    #**************************
    destructor:->
        super()
        removeObject(@vgamecursor) if (@vgamecursor?)
        removeObject(@vgamepad) if (@vgamepad?)
        for obj in @vgamebuttonlist
            removeObject(obj) if (obj?)

    #**************************
    # character behavior
    #**************************
    behavior:->
        super()
        switch @_processnumber
            when 0
                @input.axes.up = @vgamepad.input.axes.up
                @input.axes.down = @vgamepad.input.axes.down
                @input.axes.left = @vgamepad.input.axes.left
                @input.axes.right = @vgamepad.input.axes.right

                @input.buttons[0] = @vgamebuttonlist[0].push if (@vgamebuttonlist[0])
                @input.buttons[1] = @vgamebuttonlist[1].push if (@vgamebuttonlist[1])
                @input.buttons[2] = @vgamebuttonlist[2].push if (@vgamebuttonlist[2])
                @input.buttons[3] = @vgamebuttonlist[3].push if (@vgamebuttonlist[3])
                @input.buttons[4] = @vgamebuttonlist[4].push if (@vgamebuttonlist[4])
                @input.buttons[5] = @vgamebuttonlist[5].push if (@vgamebuttonlist[5])

    #**************************
    # touch event
    #**************************
    #touchesBegan:(pos)->
    #    super(pos)

    #**************************
    # swipe event
    #**************************
    #touchesMoved:(pos)->
    #    super(pos)

    #**************************
    # detach event
    #**************************
    #touchesEnded:(pos)->
    #    super(pos)

    #**************************
    # touch cancel event
    #**************************
    #touchesCanceled:(pos)->
    #    super(pos)

    createGamePad:(param)->
        if (param?)
            scale       = if (param.scale?)         then param.scale        else 1
            x           = if (param.x?)             then param.x            else (100 / 2) * scale
            y           = if (param.y?)             then param.y            else SCREEN_HEIGHT - ((100 / 2) * scale)
            visible     = if (param.visible?)       then param.visible      else true
            kind        = if (param.kind?)          then param.kind         else 0

            image       = if (param.image?)         then param.image        else undefined
            buttonscale = if (param.buttonscale?)   then param.buttonscale  else 1
            coord       = if (param.coord?)         then param.coord        else []

        # パッドの色を設定
        switch (kind)
            when 0
                padname = "_apad_w"
                padname2 = "_apad2_w"
            when 1
                padname = "_apad_b"
                padname2 = "_apad2_b"

        if (!image?)
            switch (kind)
                when 0
                    buttonname = "_button_w"
                when 1
                    buttonname = "_button_b"
                else
                    buttonname = "_button_w"
        else
            buttonname = image

        @vgamecursor = addObject
            image: padname2
            x: @x
            y: @y
            width: 40
            height: 40
            scaleX: scale
            scaleY: scale
            visible: false
            animlist: [
                [100, [0]]
            ]   
            scene: _SYSTEMSCENE

        @vgamepad = addObject
            motionObj: _vanalogpad
            image: padname
            x: @x
            y: @y
            width: 100
            height: 100
            animlist: [
                [100, [0]]
                [100, [1]]
                [100, [2]]
            ]
            visible: false
            scaleX: scale
            scaleY: scale
            scene: _SYSTEMSCENE

        @vgamepad.cursor = @vgamecursor if (@vgamecursor?)

        @vgamepad.visible = visible
        @vgamecursor.visible = visible

        for c, num in coord
            if (c?)
                obj = addObject
                    image: buttonname
                    motionObj: _vgamebutton
                    width: 64
                    height: 64
                    x: c[0]
                    y: c[1]
                    visible: false
                    scaleX: buttonscale
                    scaleY: buttonscale
                    animlist: [
                        [100, [0]]
                        [100, [1]]
                    ]
                    scene: _SYSTEMSCENE
                obj.visible = visible
                @vgamebuttonlist[num] = obj

    setVisible:(@visible)->
        @vgamecursor.visible = @visible if (@vgamecursor?)
        @vgamepad.visible = @visible #if (@vgamepad?)
        for obj in @vgamebuttonlist
            obj.visible = @visible if (obj?)

