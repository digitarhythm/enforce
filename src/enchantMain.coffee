# x, y, xs, ys, g, image, chara_w, chara_h, frame, opacity, behavior, anime, visible
class enchantMain
	constructor:->
		obj = addObject(rand(240), 32, rand(10)-5, 0, 0.5, 0, 32, 32, 0, 100, stationary, [0, 1, 2, 1], true)
