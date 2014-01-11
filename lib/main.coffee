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
SPRITE = 0
LABEL = 1
# Sceneの種類
BGSCENE = 0
GAMESCENE = 1
TOPSCENE = 2

# 初期化処理 ***********************************************************
# オブジェクトが入っている配列
_objects = []
# enchantのcoreオブジェクト
core = null
# 起動時に生成されるスタートオブジェクト
main = null
# enchantのrootScene
rootScene = null
# ゲーム起動時からの経過時間（秒）
lapsedtime = 0
# バックグラウンド用Scene
bgScene = undefined
# ゲーム画面用Scene
gameScene = undefined
# 最上位のScene（主にスワイプ用）
topScene = undefined
# enchantのオマジナイ
enchant()
# ゲーム起動時の処理
window.onload = ->
	core = new Core(SCREEN_WIDTH, SCREEN_HEIGHT)
	rootScene = core.rootScene
	core.rootScene.backgroundColor = BGCOLOR
	core.fps = FPS
	core.preload(IMAGELIST)

	bgScene = new Group()
	gameScene = new Group()
	topScene = new Group()

	core.rootScene.addChild(bgScene)
	core.rootScene.addChild(gameScene)
	core.rootScene.addChild(topScene)

	core.onload = ->
		for i in [0...OBJECTNUM]
			_objects[i] = new _originObject()
		main = new enchantMain()

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
		switch scene
			when BGSCENE
				bgScene.addChild(obj.sprite)
			when GAMESCENE
				gameScene.addChild(obj.sprite)
			when TOPSCENE
				topScene.addChild(obj.sprite)

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
	else
		obj.motionObj = undefined

	return obj

#########################################################################
#########################################################################
removeObject = (_obj)->
	num = _obj._objnum
	obj = _objects[num]
	scene = obj.motionObj._scene
	if (obj.motionObj? && typeof(obj.motionObj.destructor) == 'function')
		obj.motionObj.destructor()
	obj.sprite.removeEventListener('enterframe')
	switch scene
		when BGSCENE
			bgScene.removeChild(obj.sprite)
		when GAMESCENE
			gameScene.removeChild(obj.sprite)
		when TOPSCENE
			topScene.removeChild(obj.sprite)
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
