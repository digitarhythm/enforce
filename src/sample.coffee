class sample extends _stationary
    #**************************
    # character constructor
    #**************************
    constructor:(param)->
        super(param)

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
                if (@y > SCREEN_HEIGHT - (@height / 2))
                    @y = SCREEN_HEIGHT - (@height / 2)

                button = PADBUTTONS[0]
                if (button[0])
                    @ys = -24

    #**************************
    # touch event
    #**************************
    #touchesBegan:(pos)->
    #   super(pos)

    #**************************
    # swipe event
    #**************************
    #touchesMoved:(pos)->
    #   super(pos)

    #**************************
    # detouch event
    #**************************
    #touchesEnded:(pos)->
    #   super(pos)

    #**************************
    # touch cancel event
    #**************************
    #touchesCanceled:(pos)->
    #   super(pos)

