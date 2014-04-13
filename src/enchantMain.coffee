# motionObj, kind, x, y, xs, ys, g, image, chara_w, chara_h, opacity, animlist, anime, visible
class enchantMain
    constructor:->
        bearobj = addObject
            motionObj: bear
            type: SPRITE
            x: rand(320-32)
            y: rand(240-32)
            xs: rand(10) - 5
            gravity: 1
            animlist: [[0, 1, 2, 1]]
            image: 'chara1'
            cellx: 32
            celly: 32
