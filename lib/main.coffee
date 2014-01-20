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
CONTROL			= 0
SPRITE			= 1
LABEL			= 2
PHYSICS			= 3
WEBGL			= 4
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
# デバッグ用LABEL
_DEBUGLABEL = null
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

		if (DEBUG == true)
			_DEBUGLABEL = new Label()
			_DEBUGLABEL.x = 0
			_DEBUGLABEL.y = 0
			_DEBUGLABEL.color = "black"
			_DEBUGLABEL.font = "10px 'Arial'"
			_scenes[TOPSCENE].addChild(_DEBUGLABEL)

		core.rootScene.addEventListener 'enterframe', (e)->
			lapsedtime = core.frame / FPS
			lapsedtime = parseFloat(lapsedtime.toFixed(2))

	core.start()

debugwrite = (str)->
	if (DEBUG == true)
		_DEBUGLABEL.text = str

createObject = (motionObj = undefined, _type_ = SPRITE, x = 0, y = 0, xs = 0.0, ys = 0.0, g = 0.0, image = 0, cellx = 0, celly = 0, opacity = 1.0, animlist = undefined, animnum = 0, visible = true, scene = GAMESCENE)->
	if (motionObj == null)
		motionObj = undefined

	obj = _getNullObject()
	if (obj == undefined)
		JSLog("object undefined")
		return undefined

	obj.active = true

	# スプライトを生成
	switch (_type_)
		when CONTROL, SPRITE
			motionsprite = new Sprite()
		when LABEL
			motionsprite = new Label()
		else
			motionsprite = new Sprite()

	# スプライトを表示
	_scenes[scene].addChild(motionsprite)

	# _type_によってスプライトを初期化する
	switch _type_
		when SPRITE
			# パラメータ初期化
			motionsprite.frame = 0
			motionsprite.backgroundColor = "transparent"
			motionsprite.x = x
			motionsprite.y = y
			motionsprite.x2 = x
			motionsprite.y2 = y
			motionsprite.width = cellx
			motionsprite.height = celly
			motionsprite.originX = cellx / 2
			motionsprite.originY = celly / 2
			motionsprite.opacity = opacity
			motionsprite.rotation = 0.0
			motionsprite.scaleX = 1.0
			motionsprite.scaleY = 1.0
			motionsprite.visible = visible
			motionsprite.intersectFlag = true
			motionsprite.animlist = animlist
			motionsprite.animnum = animnum
			motionsprite.xs = xs
			motionsprite.ys = ys
			motionsprite.gravity = g
		when LABEL
			# パラメータ初期化
			motionsprite.x = x
			motionsprite.y = y
			motionsprite.x2 = x
			motionsprite.y2 = y
			motionsprite.textAlign = "left"
			motionsprite.font = "12pt 'Arial'"
			motionsprite.color = "black"

	# 動きを定義したオブジェクトを生成する
	if (motionObj != undefined)
		obj.motionObj = new motionObj(motionsprite)
	else
		obj.motionObj = new _stationary(motionsprite)

	obj.motionObj._objnum = obj._objnum
	obj.motionObj._scene = scene

	if (motionsprite != undefined)
		# イベント定義
		motionsprite.addEventListener 'enterframe', ->
			if (obj.motionObj != undefined && typeof(obj.motionObj.behavior) == 'function')
				obj.motionObj.behavior()

	# 画像割り当て
	if (IMAGELIST[image]? && animlist?)
		motionsprite.image = core.assets[IMAGELIST[image]]

	# 初期画像
	if (animlist?)
		animpattern = animlist[animnum]
		motionsprite.frame = animpattern[0]

	obj.motionObj._type_ = _type_
	return obj.motionObj

#**********************************************************************
removeObject = (obj)->
	if (obj == undefined)
		return
	num = obj._objnum
	parent = _objects[num]
	scene = obj._scene
	if (typeof(obj.destructor) == 'function')
		obj.destructor()
	if (scene != undefined)
		_scenes[scene].removeChild(obj.sprite)
	obj.sprite = 0
	parent.active = false
	parent.motionObj = undefined

#**********************************************************************
_getNullObject = ->
	retobj = undefined
	for i in [0..._objects.length]
		obj = _objects[i]
		if (obj.active == false)
			retobj = obj
			retobj._objnum = i
			break
	return retobj

