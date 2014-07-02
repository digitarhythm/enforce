# motionObj, kind, x, y, xs, ys, g, image, chara_w, chara_h, opacity, animlist, anime, visible
class sample extends _stationary
    #**************************
    # character constructor
    #**************************
    constructor:(@sprite)->
        super(@sprite)

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
                    @ys = -@ys

                if (@x > SCREEN_WIDTH - @width / 2)
                    @x = SCREEN_WIDTH - @width / 2
                    @xs = -@xs
                    @scaleX = -@scaleX

                if (@x < @width / 2)
                    @x = @width / 2
                    @xs = -@xs
                    @scaleX = -@scaleX

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

