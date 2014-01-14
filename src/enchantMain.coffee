# motionObj, kind, x, y, xs, ys, g, image, chara_w, chara_h, opacity, animlist, anime, visible
class enchantMain
	constructor:->
		animlist = [[0, 0, 0, 1, 1, 1, 0, 0, 0, 2, 2, 2]]
		bearObj = createObject(bear, SPRITE, rand(320-32), rand(240-32), rand(10) - 5, 0, 1, 0, 32, 32, 1.0, animlist, 0, true)
