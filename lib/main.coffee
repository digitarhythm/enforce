#########################################################################
# enchant.js game engine
#
# 2013.12.28 ver0.1
# 2014.01.09 ver0.2
#
# Coded by Kow Sakazaki
#########################################################################
_objects = []
core = null
main = null
rootScene = null
lapsedtime = 0
enchant()
window.onload = ->
	core = new Core(SCREEN_WIDTH, SCREEN_HEIGHT)
	rootScene = core.rootScene
	core.rootScene.backgroundColor = BGCOLOR
	core.fps = FPS
	core.preload(IMAGELIST)
	core.onload = ->

		#########################################################################
		seedObject = Class.create Sprite,
			initialize: ->
				@active = false
		#########################################################################

		for i in [0...OBJECTNUM]
			_objects[i] = new seedObject()
		main = new enchantMain()

		core.rootScene.addEventListener 'touchstart', (e)->
			if (typeof(main.touchesBegan) == 'function')
				main.touchesBegan(e)

		core.rootScene.addEventListener 'touchmove', (e)->
			if (typeof(main.touchesMoved) == 'function')
				main.touchesMoved(e)

		core.rootScene.addEventListener 'touchend', (e)->
			if (typeof(main.touchesEnded) == 'function')
				main.touchesEnded(e)

		core.rootScene.addEventListener 'touchcancel', (e)->
			if (typeof(main.touchesCanceled) == 'function')
				main.touchesCanceled(e)

		core.rootScene.addEventListener 'enterframe', (e)->
			lapsedtime = Math.floor(core.frame / FPS)

	core.start()

#########################################################################
#########################################################################
createObject = (x, y, xs, ys, g, image, cellx, celly, opacity, seedobj, animlist, animnum, visible)->
	obj = _getNullObject()
	if (obj == null) 
		return

	Sprite.call(obj, cellx, celly)
	obj.backgroundColor = "transparent"
	obj.x = x
	obj.y = y
	obj.width = cellx
	obj.height = celly
	obj.opacity = opacity
	obj.originX = cellx / 2
	obj.originY = celly / 2
	obj.rotation = 0.0
	obj.scaleX = 1.0
	obj.scaleY = 1.0
	core.rootScene.addChild(obj)

	obj.xs = xs
	obj.ys = ys
	obj.gravity = g
	obj.animlist = animlist
	obj.animnum = animnum

	obj.visible = visible

	if (IMAGELIST[image] != null)
		obj.image = core.assets[IMAGELIST[image]]

	if (obj.animlist != null)
		animpattern = obj.animlist[obj.animnum]
		obj.frame = animpattern[0]

	if (seedobj != null)
		obj.characterObj = new seedobj(obj)

	obj.addEventListener 'enterframe', ->
		obj.ys += obj.gravity
		obj.x += obj.xs
		obj.y += obj.ys

		if (obj.animlist != null)
			animpattern = obj.animlist[obj.animnum]
			obj.frame = animpattern[obj.age % animpattern.length]

		if (obj.characterObj != null && typeof(obj.characterObj.behavior) == 'function')
			obj.characterObj.behavior()

	return obj

#########################################################################
#########################################################################
removeObject = (obj)->
		for i in [0...obj.childlist.length]
			s = obj.childlist[i]
			core.rootScene.removeChild(s)
		obj.sprite.backgroundColor = "transparent"
		obj.sprite.width = 0
		obj.sprite.height = 0
		obj.sprite.opacity = 0
		obj.sprite.originX = 0
		obj.sprite.originY = 0
		obj.sprite.rotation = 0
		obj.sprite.scaleX = 0
		obj.sprite.scaleY = 0

		obj.sprite.x = 0
		obj.sprite.y = 0
		obj.sprite.xs = 0
		obj.sprite.ys = 0
		obj.sprite.gravity = 0
		obj.sprite.animlist = []
		obj.sprite.animnum = 0

		obj.sprite.active = false
		obj.sprite.visible = false
		obj.sprite.removeEventListener('enterframe')
		obj.sprite.characterObj = null
		core.rootScene.removeChild(obj.sprite)

#########################################################################
#########################################################################
_getNullObject = ->
	obj = null
	for i in [0..._objects.length]
		if (_objects[i].active == false)
			obj = _objects[i]
			obj.active = true
			obj.visible = false
			break
	return obj
