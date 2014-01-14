#***********************************************************************
# enchant.js game engine
#
# 2013.12.28 ver0.1
# 2014.01.09 ver0.2
#
# Coded by Kow Sakazaki
#***********************************************************************

# 定数定義 *************************************************************
# オブジェクトの種類
CONTROL = 0
SPRITE  = 1
LABEL   = 2
PHYSICS = 3
WEBGL   = 4
# Sceneの種類
BGSCENE			= 0
BGSCENE_SUB1	= 1
BGSCENE_SUB2	= 2
GAMESCENE		= 3
GAMESCENE_SUB1	= 4
GAMESCENE_SUB2	= 5
TOPSCENE		= 6

# 初期化処理 ***********************************************************
# オブジェクトが入っている配列
_objects = []
# Scene格納用配列
_scenes = []
# 起動時に生成されるスタートオブジェクト
_main = null
# enchantのcoreオブジェクト
core = null
# enchantのrootScene
rootScene = null
# ゲーム起動時からの経過時間（秒）
lapsedtime = 0
# enchantのオマジナイ
enchant()
# ゲーム起動時の処理
window.onload = ->
	core = new Core(SCREEN_WIDTH, SCREEN_HEIGHT)
	rootScene = core.rootScene
	core.rootScene.backgroundColor = BGCOLOR
	core.fps = FPS
	core.preload(IMAGELIST)

	for i in [0...(TOPSCENE+1)]
		scene = new Group()
		_scenes[i] = scene
		core.rootScene.addChild(scene)

	core.onload = ->
		for i in [0...OBJECTNUM]
			_objects[i] = new _originObject()
		_main = new enchantMain()

		core.rootScene.addEventListener 'enterframe', (e)->
			lapsedtime = core.frame / FPS
			lapsedtime = lapsedtime.toFixed(2)

	core.start()

createObject = (motionObj = undefined, kind = SPRITE, x = 0, y = 0, xs = 0, ys = 0, g = 0, image = 0, cellx = 0, celly = 0, opacity = 1.0, animlist = undefined, animnum = 0, visible = true, scene = GAMESCENE)->
	if (motionObj == null)
		motionObj = undefined

	obj = _getNullObject()
	if (obj == undefined)
		JSLog("object undefined")
		return undefined

	# kindによってスプライトを生成する
	switch kind
		when CONTROL
			obj.sprite = new Sprite()

		when SPRITE
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

		when LABEL
			# パラメータ初期化
			obj.sprite = new Label()
			obj.sprite.x = x
			obj.sprite.y = y
			obj.sprite.xs = xs
			obj.sprite.ys = ys
			obj.sprite.visible = visible
			obj.sprite.gravity = g
			obj.sprite.opacity = opacity
			obj.sprite.text = ""
			obj.sprite.textAlign = "left"
			obj.sprite.font = "12pt 'Arial'"
			obj.sprite.color = "black"

		else
			obj.sprite = null

	obj.kind = kind

	if (obj.sprite?)
		_scenes[scene].addChild(obj.sprite)

	if (IMAGELIST[image]? && animlist?)
		obj.sprite.image = core.assets[IMAGELIST[image]]

	if (animlist?)
		animpattern = obj.sprite.animlist[obj.sprite.animnum]
		obj.sprite.frame = animpattern[0]

	# イベント定義
	if (obj.sprite?)
		obj.sprite.addEventListener 'enterframe', ->
			if (obj.kind == SPRITE || obj.kind == LABEL)
				obj.sprite.ys += obj.sprite.gravity
				obj.sprite.x += obj.sprite.xs
				obj.sprite.y += obj.sprite.ys

			if (animlist?)
				animpattern = obj.sprite.animlist[obj.sprite.animnum]
				obj.sprite.frame = animpattern[obj.sprite.age % animpattern.length]

			if (obj.motionObj != undefined && typeof(obj.motionObj.behavior) == 'function')
				obj.motionObj.behavior()

	# 動きを定義したオブジェクトを生成する
	if (motionObj != undefined)
		obj.motionObj = new motionObj(obj.sprite)
		obj.motionObj._objnum = obj._objnum
		obj.motionObj._scene = scene
		obj.motionObj.self = obj.motionObj
	else
		obj.motionObj = undefined

	return obj

#**********************************************************************
removeObject = (_obj)->
	num = _obj._objnum
	obj = _objects[num]
	scene = obj.motionObj._scene
	if (obj.motionObj? && typeof(obj.motionObj.destructor) == 'function')
		obj.motionObj.destructor()
	obj.sprite.removeEventListener('enterframe')
	if (scene?)
		_scenes[scene].removeChild(obj.sprite)
	obj.sprite = 0
	obj.active = false
	obj.motionObj = 0

#**********************************************************************
_getNullObject = ->
	obj = undefined
	for i in [0..._objects.length]
		if (_objects[i].active == false)
			obj = _objects[i]
			obj.active = true
			obj._objnum = i
			break
	return obj

