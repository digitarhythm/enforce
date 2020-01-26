class _vgamebutton extends _stationary
    #**************************
    # character constructor
    #**************************
    constructor:(initparam)->
        super(initparam)
        @push = false
        @visible = true

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
        @push = true
        @animnum = 1

    #**************************
    # swipe event
    #**************************
    #touchesMoved:(pos)->
    #    super(pos)

    #**************************
    # detach event
    #**************************
    touchesEnded:(pos)->
        super(pos)
        @push = false
        @animnum = 0

    #**************************
    # touch cancel event
    #**************************
    touchesCanceled:(pos)->
        super(pos)
        @animnum = 0
