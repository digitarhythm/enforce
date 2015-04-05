class _dispImageStrings extends _stationary
    #**************************
    # character constructor
    #**************************
    constructor:(initparam)->
        super(initparam)
        @stringslist = undefined

    #**************************
    # character destructor
    #**************************
    destructor:->
        super()
        for obj in @stringslist
            removeObject(obj)

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

    dispStrings:(param = [])->
        if (!@stringslist?)
            @strsize = if (param.size?) then param.size else 1.0
            @labeltext = if (param.labeltext?) then param.labeltext else "text"
            @strcolor = if (param.color?) then param.color else 0
            @strscene = if (param.scene?) then param.scene else GAMESCENE_SUB2
            @stringslist = []

            x = @x + ((32 * @strsize) / 2)
            y = @y

            for num in [0...(@labeltext.length)]
                code = @labeltext.charCodeAt(num) - 32
                param.code = code
                param.x = x
                param.y = y
                obj = @createStringObj(param)
                @stringslist.push(obj)
                x += 30 * @strsize
        else
            @strsize = param.size if (param.size?)
            @labeltext = param.labeltext.toString() if (param.labeltext?)
            @strcolor = param.color if (param.color?)
            image = if (@strcolor == 0) then "_ascii_w" else "_ascii_b"
            @strscene = param.scene if (param.scene?)

            x = @x + ((32 * @strsize) / 2)
            y = @y

            diff = @stringslist.length - @labeltext.length

            if (diff > 0)
                for i in [0...diff]
                    removeObject(@stringslist[@stringslist.length - 1])
                    @stringslist.splice(@stringslist.length - 1, 1)

            for obj, num in @stringslist
                code = @labeltext.charCodeAt(num) - 32
                obj.x = x
                obj.y = y
                obj.animnum = code
                x += 30 * @strsize
            
            if (diff < 0)
                length = @stringslist.length
                for num in [0...(-diff)]
                    code = @labeltext.charCodeAt(num + length) - 32
                    param.code = code
                    param.x = x
                    param.y = y
                    obj = @createStringObj(param)
                    @stringslist.push(obj)
                    x += 30 * @strsize

                    
    createStringObj:(param = [])->
        image = if (@strcolor == 0) then "_ascii_w" else "_ascii_b"
        code = if (param.code?) then param.code else " "
        x = if (param.x?) then param.x else 0
        y = if (param.y?) then param.y else 0

        obj = addObject
            image: image
            x: x
            y: y
            width: 32
            height: 64
            scaleX: @strsize
            scaleY: @strsize
            scene: @strscene
            opacity: @opacity
            animnum: code
            animlist: [
                [100, [ 0]], [100, [ 1]], [100, [ 2]], [100, [ 3]], [100, [ 4]], [100, [ 5]], [100, [ 6]], [100, [ 7]], 
                [100, [ 8]], [100, [ 9]], [100, [10]], [100, [11]], [100, [12]], [100, [13]], [100, [14]], [100, [15]], 
                [100, [16]], [100, [17]], [100, [18]], [100, [19]], [100, [20]], [100, [21]], [100, [22]], [100, [23]], 
                [100, [24]], [100, [25]], [100, [26]], [100, [27]], [100, [28]], [100, [29]], [100, [30]], [100, [31]], 
                [100, [32]], [100, [33]], [100, [34]], [100, [35]], [100, [36]], [100, [37]], [100, [38]], [100, [39]], 
                [100, [40]], [100, [41]], [100, [42]], [100, [43]], [100, [44]], [100, [45]], [100, [46]], [100, [47]], 
                [100, [48]], [100, [49]], [100, [50]], [100, [51]], [100, [52]], [100, [53]], [100, [54]], [100, [55]], 
                [100, [56]], [100, [57]], [100, [58]], [100, [59]], [100, [60]], [100, [61]], [100, [62]], [100, [63]], 
                [100, [64]], [100, [65]], [100, [66]], [100, [67]], [100, [68]], [100, [69]], [100, [70]], [100, [71]], 
                [100, [72]], [100, [73]], [100, [74]], [100, [75]], [100, [76]], [100, [77]], [100, [78]], [100, [79]], 
                [100, [80]], [100, [81]], [100, [82]], [100, [83]], [100, [84]], [100, [85]], [100, [86]], [100, [87]], 
                [100, [88]], [100, [89]], [100, [90]], [100, [91]], [100, [92]], [100, [93]], [100, [94]], [100, [95]]
            ]

        return obj

