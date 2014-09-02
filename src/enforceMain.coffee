class enforceMain
    constructor:->
        dir = rand(16) - 8
        bearobj = addObject
            motionObj: sample
            type: SPRITE
            x: SCREEN_WIDTH / 2
            y: 100
            gravity: 1.0
            xs: dir
            image: 'bear'
            width: 32
            height: 32
            opacity: 1.0
            scaleX: if (dir < 0) then -1 else 1
            animlist: [
                [50, [0, 0, 1, 1, 2, 2, 1, 1]]
            ]
        ###
        droidobj = addObject
            motionObj: droid
            type: COLLADA
            model: 'droid'
            x: 0
            y: 10
            z: 0
            scaleX: 5.0
            scaleY: 5.0
            scaleZ: 5.0
            gravity: -0.1
        ###
