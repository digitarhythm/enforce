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
CONTROL         = 0
SPRITE          = 1
LABEL           = 2
WEBGL           = 3
PHYCIRCLE       = 4
PHYBOX          = 5
# Sceneの種類
BGSCENE         = 0
BGSCENE_SUB1    = 1
BGSCENE_SUB2    = 2
GAMESCENE       = 3
GAMESCENE_SUB1  = 4
GAMESCENE_SUB2  = 5
TOPSCENE        = 6
# センサー系
MOTION_ACCEL    = undefined
MOTION_GRAVITY  = undefined
MOTION_ROTATE   = undefined
# ゲーム起動時からの経過時間（秒）
LAPSEDTIME      = 0

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
# box2dのworldオブジェクト
world = null
# enchantのrootScene
rootScene = null
# enchantのオマジナイ
enchant()
# ゲーム起動時の処理
window.onload = ->
    bounds = getBounds()
    # enchant初期化
    core = new Core(SCREEN_WIDTH, SCREEN_HEIGHT)
    core.rootScene.backgroundColor = BGCOLOR
    core.fps = FPS
    core.preload(IMAGELIST)
    # box2d初期化
    world = new PhysicsWorld(0, GRAVITY)

    rootScene = core.rootScene
    window.addEventListener 'devicemotion', (e)=>
        MOTION_ACCEL = e.acceleration
        MOTION_GRAVITY = e.accelerationIncludingGravity
        MOTION_ROTATE = e.rotationRate

    # キーバインド
    core.keybind('Z'.charCodeAt(0), 'a')
    core.keybind('X'.charCodeAt(0), 'b')
    core.keybind(32, "space")

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
            _DEBUGLABEL.color = "white"
            _DEBUGLABEL.font = "10px 'Arial'"
            _scenes[TOPSCENE].addChild(_DEBUGLABEL)
        core.rootScene.addEventListener 'enterframe', (e)->
            world.step(core.fps)
            LAPSEDTIME = core.frame / FPS
            LAPSEDTIME = parseFloat(LAPSEDTIME.toFixed(2))
    core.start()

debugwrite = (str)->
    if (DEBUG == true)
        _DEBUGLABEL.text = str

# 2D/3D共用オブジェクト生成メソッド
addObject = (param)->
    # 2D用パラメーター
    motionobj = if (param.motionobj?) then param.motionobj else undefined
    _type_ = if (param.type?) then param.type else SPRITE
    x = if (param.x?) then param.x else 0
    y = if (param.y?) then param.y else 0
    xs = if (param.xs?) then param.xs else 0
    ys = if (param.ys?) then param.ys else 0
    g = if (param.gravity?) then param.gravity else 0
    image = if (param.image?) then param.image else 0
    cellx = if (param.cellx?) then param.cellx else 0
    celly = if (param.celly?) then param.celly else 0
    opacity = if (param.opacity?) then param.opacity else 1.0
    animlist = if (param.animlist?) then param.animlist else [[0]]
    animnum = if (param.animnum?) then param.animnum else 0
    visible = if (param.visible?) then param.visible else true
    scene = if (param.scene?) then param.scene else -1
    # 3D用パラメーター
    z = if (param.z?) then param.z else 0
    zs = if (param.zs?) then param.zs else 0

    switch _type_
        when CONTROL, SPRITE, LABEL
            obj = createObject(motionobj, _type_, x, y, xs, ys, g, image, cellx, celly, opacity, animlist, animnum, visible, scene)

        when PHYCIRCLE, PHYCUBE
            nop()

        when GLSPHERE, GLCUBE
            nop()

    return obj

# enforce1.x互換用2Dスプライト生成メソッド
createObject = (motionObj = undefined, _type_ = SPRITE, x = 0, y = 0, xs = 0.0, ys = 0.0, g = 0.0, image = 0, cellx = 0, celly = 0, opacity = 1.0, animlist = undefined, animnum = 0, visible = true, scene = -1)->
    if (motionObj == null)
        motionObj = undefined

    objnum = _getNullObject()
    if (objnum < 0)
        return undefined

    obj = _objects[objnum]
    obj.active = true

    # スプライトを生成
    switch (_type_)
        when CONTROL, SPRITE
            motionsprite = new Sprite()
            if (scene < 0)
                scene = GAMESCENE
        when LABEL
            motionsprite = new Label()
            if (scene < 0)
                scene = GAMESCENE_SUB2
        else
            motionsprite = undefined
            if (scene < 0)
                scene = GAMESCENE

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
            motionsprite._x_ = x
            motionsprite._y_ = y
            motionsprite.width = cellx
            motionsprite.height = celly
            motionsprite.originX = parseInt(cellx / 2)
            motionsprite.originY = parseInt(celly / 2)
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
            motionsprite._x_ = x
            motionsprite._y_ = y
            motionsprite.textAlign = "left"
            motionsprite.font = "12pt 'Arial'"
            motionsprite.color = "black"

        when WEBGL
            nop()

        when PHYCIRCLE
            nop()

        when PHYBOX
            nop()


    # 動きを定義したオブジェクトを生成する
    if (motionObj != undefined)
        obj.motionObj = new motionObj(motionsprite)
    else
        obj.motionObj = new _stationary(motionsprite)

    uid = uniqueID()
    obj.motionObj._uniqueID = uid
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
#**********************************************************************
removeObject = (motionObj)->
    if (!motionObj?)
        return
    ret = false
    for parent in _objects
        if (!parent.motionObj?)
            continue
        if (parent.motionObj._uniqueID == motionObj._uniqueID)
            ret = true
            break
    if (ret == false)
        return

    if (typeof(motionObj.destructor) == 'function')
        motionObj.destructor()

    _scenes[parent.motionObj._scene].removeChild(parent.motionObj.sprite)
    parent.motionObj.sprite = 0

    parent.motionObj = 0
    parent.active = false

#**********************************************************************
#**********************************************************************
_getNullObject = ->
    ret = -1
    for i in [0..._objects.length]
        if (_objects[i].active == false)
            ret = i
            break
    return ret

#**********************************************************************
#**********************************************************************
getObject:(id)->
    ret = undefined
    for i in [0..._objects.length]
        if (!_objects[i].motionObj?)
            continue
        if (_objects[i].motionObj._uniqueID == id)
            ret = _objects[i].motionObj
            break
    return ret

#**********************************************************************
#**********************************************************************
