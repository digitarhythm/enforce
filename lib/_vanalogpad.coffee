class _vanalogpad extends _stationary
    #**************************
    # character constructor
    #**************************
    constructor:(initparam)->
        super(initparam)

        @input = []
        @input.axes = []
        @input.axes.up = false
        @input.axes.down = false
        @input.axes.left = false
        @input.axes.right = false
        @input.analog = []
        @input.analog[HORIZONTAL] = 0.0
        @input.analog[VERTICAL] = 0.0

        @radius = parseFloat(@width * @scaleX / 2)
        @arclength = 0

    #**************************
    # character destructor
    #**************************
    destructor:->
        super()
        removeObject(@cursor)

    #**************************
    # character behavior
    #**************************
    behavior:->
        super()
        switch @_processnumber
            when 0
                nop()

    #**************************
    # touch event
    #**************************
    touchesBegan:(pos)->
        super(pos)
        @movePad(pos)

    #**************************
    # swipe event
    #**************************
    touchesMoved:(pos)->
        super(pos)
        @movePad(pos)

    #**************************
    # detach event
    #**************************
    touchesEnded:(pos)->
        super(pos)
        @cursor.x = @x if (@cursor?)
        @cursor.y = @y if (@cursor?)
        @input.axes.up = false
        @input.axes.down = false
        @input.axes.left = false
        @input.axes.right = false
        @input.analog[HORIZONTAL] = 0.0
        @input.analog[VERTICAL] = 0.0

    #**************************
    # touch cancel event
    #**************************
    touchesCanceled:(pos)->
        super(pos)
        @cursor.x = @x if (@cursor?)
        @cursor.y = @y if (@cursor?)
        @input.axes.up = false
        @input.axes.down = false
        @input.axes.left = false
        @input.axes.right = false
        @inout.analog[HORIZONTAL] = 0.0
        @input.analog[VERTICAL] = 0.0

    movePad:(pos)->
        # 底辺を求める
        @alength = pos.x - @x
        # 高さを求める
        @blength = pos.y - @y
        # 角度を求める
        if (@alength > 0)
            @angle =  90 - (Math.atan(@blength / @alength) * DEG)
        else
            @angle = 270 - (Math.atan(@blength / @alength) * DEG)
        @angle -= 90
        @angle = 360 + @angle if (@angle < 0)

        # 斜辺を求める
        @arclength = Math.abs(Math.sqrt(@alength * @alength + @blength * @blength))

        if (@arclength > @radius)
            @arclength = @radius
            mx = @x + Math.cos((360 - @angle) * RAD) * (50 * @scaleX)
            my = @y + Math.sin((360 - @angle) * RAD) * (50 * @scaleX)
        else
            mx = pos.x
            my = pos.y
        @cursor.x = mx if (@cursor?)
        @cursor.y = my if (@cursor?)

        h = @alength / @radius
        if (h > 1.0) then h = 1.0
        if (h < -1.0) then h = -1.0
        v = @blength / @radius
        if (v > 1.0) then v = 1.0
        if (v < -1.0) then v = -1.0

        @input.analog[HORIZONTAL] = h
        @input.analog[VERTICAL] = v

