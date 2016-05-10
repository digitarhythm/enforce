class enforceMain
    constructor:->
        sampleobj = addObject
            motionObj: sample
            type: SPRITE
            x: SCREEN_WIDTH / 2
            y: SCREEN_HEIGHT / 2
            image: 'bear'
            gravity: 1.0
            width: 32
            height: 32
            opacity: 1.0
            animlist: [
                [50, [0, 0, 1, 1, 2, 2, 1, 1]]
            ]
