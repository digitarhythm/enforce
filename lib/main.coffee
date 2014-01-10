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
		for i in [0...OBJECTNUM]
			_objects[i] = new _originObject()
		main = new enchantMain()

		core.rootScene.addEventListener 'enterframe', (e)->
			lapsedtime = Math.floor(core.frame / FPS)

	core.start()

createObject = (motionObj = undefined, kind = 0, x = 0, y = 0, xs = 0, ys = 0, g = 0, image = 0, cellx = 0, celly = 0, opacity = 1.0, animlist = undefined, animnum = 0, visible = true)->
	if (motionObj == null)
		motionObj = undefined

	obj = _getNullObject()
	if (obj == undefined)
		JSLog("object undefined")
		return undefined

	# kindによってスプライトを生成する
	switch kind
		when 0 # Sprite
			# パラメータ初期化
			obj.sprite = new Sprite()
			obj.sprite.animlist = animlist
			obj.sprite.animnum = animnum
			obj.sprite.frame = 0
			obj.sprite.backgroundColor = "transparent"
			obj.sprite.x = x
			obj.sprite.y = y
			obj.sprite.xs = xs
			obj.sprite.ys = ys
			obj.sprite.gravity = g
			obj.sprite.width = cellx
			obj.sprite.height = celly
			obj.sprite.originX = cellx / 2
			obj.sprite.originY = celly / 2
			obj.sprite.opacity = opacity
			obj.sprite.rotation = 0.0
			obj.sprite.scaleX = 1.0
			obj.sprite.scaleY = 1.0
			obj.sprite.visible = visible

		when 1 # Label
			# パラメータ初期化
			obj.sprite = new Label()
			obj.sprite.x = x
			obj.sprite.y = y
			obj.sprite.xs = xs
			obj.sprite.ys = ys
			obj.sprite.gravity = g
			obj.sprite.opacity = opacity
			obj.sprite.text = ""
			obj.sprite.font = "12pt 'Arial'"
			obj.sprite.color = "black"
			obj.sprite.rotation = 0.0
			obj.sprite.scaleX = 1.0
			obj.sprite.scaleY = 1.0
			obj.sprite.visible = visible

		else
			obj.sprite = undefined

	if (obj.sprite?)
		core.rootScene.addChild(obj.sprite)

	if (IMAGELIST[image]? && animlist?)
		obj.sprite.image = core.assets[IMAGELIST[image]]

	if (animlist?)
		animpattern = obj.sprite.animlist[obj.sprite.animnum]
		obj.sprite.frame = animpattern[0]

	# イベント定義
	obj.sprite.addEventListener 'enterframe', ->
		obj.sprite.ys += obj.sprite.gravity
		obj.sprite.x += obj.sprite.xs
		obj.sprite.y += obj.sprite.ys

		if (animlist? && obj.motionObj != undefined)
			animpattern = obj.sprite.animlist[obj.sprite.animnum]
			obj.sprite.frame = animpattern[obj.sprite.age % animpattern.length]

		if (obj.motionObj != undefined && typeof(obj.motionObj.behavior) == 'function')
			obj.motionObj.behavior()

	# 動きを定義したオブジェクトを生成する
	if (motionObj != undefined)
		obj.motionObj = new motionObj(obj.sprite)
		obj.motionObj._objnum = obj._objnum
	else
		obj.motionObj = undefined


	return obj

#########################################################################
#########################################################################
removeObject = (_obj)->
	num = _obj._objnum
	obj = _objects[num]
	if (obj.motionObj? && typeof(obj.motionObj.destructor) == 'function')
		obj.motionObj.destructor()
	obj.sprite.removeEventListener('enterframe')
	core.rootScene.removeChild(obj.sprite)
	obj.active = false
	obj.motionObj = 0

#########################################################################
#########################################################################
_getNullObject = ->
	obj = undefined
	for i in [0..._objects.length]
		if (_objects[i].active == false)
			obj = _objects[i]
			obj.active = true
			obj._objnum = i
			break
	return obj
