class _vgamepad extends _stationary
    #**************************
    # character constructor
    #**************************
    constructor:(initparam)->
        super(initparam)
        @visible = true

        @input = []
        @input.up = false
        @input.down = false
        @input.left = false
        @input.right = false

    #**************************
    # character destructor
    #**************************
    destructor:->
        super()

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
        dx = (@x - (@width / 2 * @scaleX))
        dy = (@y - (@height / 2 * @scaleY))
        px = Math.floor((pos.x - dx) / @scaleX)
        py = Math.floor((pos.y - dy) / @scaleY)
        @tapArea(px, py)

    #**************************
    # swipe event
    #**************************
    touchesMoved:(pos)->
        super(pos)
        dx = (@x - (@width / 2 * @scaleX))
        dy = (@y - (@height / 2 * @scaleY))
        px = Math.floor((pos.x - dx) / @scaleX)
        py = Math.floor((pos.y - dy) / @scaleY)
        @tapArea(px, py)

    #**************************
    # detach event
    #**************************
    touchesEnded:(pos)->
        super(pos)
        @animnum = 0
        @input.up = false
        @input.down = false
        @input.left = false
        @input.right = false

    #**************************
    # touch cancel event
    #**************************
    touchesCanceled:(pos)->
        super(pos)
        @animnum = 0
        @input.up = false
        @input.down = false
        @input.left = false
        @input.right = false

    tapArea:(x, y)->
        ret = 0
        if (0 <= x && x < 33 && 0 <= y && y < 33)       # 1
            @input.up = true
            @input.down = false
            @input.left = true
            @input.right = false
            @animnum = 2
            @rotation = 0
        if (33 <= x && x < 66 && 0 <= y && y < 33)      # 2
            @input.up = true
            @input.down = false
            @input.left = false
            @input.right = false
            @animnum = 1
            @rotation = 0
        if (66 <= x && x < 100 && 0 <= y && y < 33)     # 3
            @input.up = true
            @input.down = false
            @input.left = false
            @input.right = true
            @animnum = 2
            @rotation = 90
        if (0 <= x && x < 33 && 33 <= y && y < 66)      # 4
            @input.up = false
            @input.down = false
            @input.left = true
            @input.right = false
            @animnum = 1
            @rotation = 270
        if (33 <= x && x < 66 && 33 <= y && y < 66)     # 5
            @input.up = false
            @input.down = false
            @input.left = false
            @input.right = false
            @animnum = 0
        if (66 <= x && x < 100 && 33 <= y && y < 66)    # 6
            @input.up = false
            @input.down = false
            @input.left = false
            @input.right = true
            @animnum = 1
            @rotation = 90
        if (0 <= x && x < 33 && 66 <= y && y < 100)     # 7
            @input.up = false
            @input.down = true
            @input.left = true
            @input.right = false
            @animnum = 2
            @rotation = 270
        if (33 <= x && x < 66 && 66 <= y && y < 100)    # 8
            @input.up = false
            @input.down = true
            @input.left = false
            @input.right = false
            @animnum = 1
            @rotation = 180
        if (66 <= x && x < 100 && 66 <= y && y < 100)   # 9
            @input.up = false
            @input.down = true
            @input.left = false
            @input.right = true
            @animnum = 2
            @rotation = 180

