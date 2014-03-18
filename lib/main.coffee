#***********************************************************************
# enchant.js game engine
#
# 2013.12.28 ver0.1
# 2014.01.09 ver0.2
#
# Coded by Kow Sakazaki
#***********************************************************************

#******************************************************************************
# 初期化処理
#******************************************************************************

# 定数定義

# オブジェクトの種類
CONTROL             = 0
SPRITE              = 1
LABEL               = 2
PHYSICAL            = 3
GLMODEL             = 4
# Sceneの種類
BGSCENE             = 0
BGSCENE_SUB1        = 1
BGSCENE_SUB2        = 2
GAMESCENE           = 3
GAMESCENE_SUB1      = 4
GAMESCENE_SUB2      = 5
TOPSCENE            = 6

# グローバル初期化

# センサー系
MOTION_ACCEL        = [x:0, y:0, z:0]
MOTION_GRAVITY      = [x:0, y:0, z:0]
MOTION_ROTATE       = [alpha:0, beta:0, gamma:0]
# ゲーム起動時からの経過時間（秒）
LAPSEDTIME          = 0
# 3D系
CAMERA              = undefined

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
# 3Dのscene
rootScene3D = null
# enchantのrootScene
rootScene = null

#******************************************************************************
# 起動時の処理
#******************************************************************************

# enchantのオマジナイ
enchant()
# ゲーム起動時の処理
window.onload = ->
    # enchant初期化
    enchant.ENV.MOUSE_ENABLED = false
    core = new Core(SCREEN_WIDTH, SCREEN_HEIGHT)
    core.fps = FPS
    core.preload(IMAGELIST)
    # box2d初期化
    world = new PhysicsWorld(0, GRAVITY)
    # 3Dシーンを生成
    if (typeof(Scene3D) == 'function')
        rootScene3D = new Scene3D()

        # スポットライト生成
        #dlight = new DirectionalLight()
        #dlight.directionX = 0
        #dlight.directionY = 100
        #dlight.directionZ = 0
        #dlight.color = [1.0, 1.0, 1.0]
        #rootScene3D.setDirectionalLight(dlight)

        # 環境光ライト生成
        alight = new AmbientLight()
        alight.directionX = 0
        alight.directionY = 100
        alight.directionZ = 0
        alight.color = [1.0, 1.0, 1.0]
        rootScene3D.setAmbientLight(alight)

        # カメラ生成
        CAMERA = new Camera3D()
        CAMERA.x = 0
        CAMERA.y = 0
        CAMERA.z = 300
        CAMERA.centerX = 0
        CAMERA.centerY = 0
        CAMERA.centerZ = 0
        rootScene3D.setCamera(CAMERA)

    rootScene = core.rootScene
    window.addEventListener 'devicemotion', (e)=>
        MOTION_ACCEL = e.acceleration
        MOTION_GRAVITY = e.accelerationIncludingGravity
    window.addEventListener 'deviceorientation', (e)=>
        MOTION_ROTATE.alpha = e.alpha
        MOTION_ROTATE.beta = e.beta
        MOTION_ROTATE.gamma = e.gamma

    # キーバインド
    core.keybind('Z'.charCodeAt(0), 'a')
    core.keybind('X'.charCodeAt(0), 'b')
    core.keybind(32, "space")

    # シーングループを生成
    for i in [0...(TOPSCENE+1)]
        scene = new Group()
        _scenes[i] = scene
        rootScene.addChild(scene)

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

        rootScene.addEventListener 'enterframe', (e)->
            world.step(core.fps)
            LAPSEDTIME = core.frame / FPS
            LAPSEDTIME = parseFloat(LAPSEDTIME.toFixed(2))
    core.start()

debugwrite = (str, fontsize = 10)->
    if (DEBUG == true)
        _DEBUGLABEL.font = fontsize+"px 'Arial'"
        _DEBUGLABEL.text = str

#******************************************************************************
# 2D/3D共用オブジェクト生成メソッド
#******************************************************************************
addObject = (param)->
    # 2D用パラメーター
    motionObj = if (param.motionObj?) then param.motionObj else undefined
    _type_ = if (param.type?) then param.type else SPRITE
    x = if (param.x?) then param.x else 0.0
    y = if (param.y?) then param.y else 0.0
    xs = if (param.xs?) then param.xs else 0.0
    ys = if (param.ys?) then param.ys else 0.0
    gravity = if (param.gravity?) then param.gravity else 0.0
    image = if (param.image?) then param.image else 0
    cellx = if (param.cellx?) then param.cellx else 0.0
    celly = if (param.celly?) then param.celly else 0.0
    opacity = if (param.opacity?) then param.opacity else 1.0
    animlist = if (param.animlist?) then param.animlist else [[0]]
    animnum = if (param.animnum?) then param.animnum else 0
    visible = if (param.visible?) then param.visible else true
    scene = if (param.scene?) then param.scene else -1
    model = if (param.model?) then param.model else undefined
    # 3D用パラメーター
    z = if (param.z?) then param.z else 0.0
    zs = if (param.zs?) then param.zs else 0.0

    # オブジェクト生成
    switch _type_
        # 2Dオブジェクト
        when CONTROL, SPRITE, LABEL, PHYSICAL
            obj = createObject(motionObj, _type_, x, y, xs, ys, gravity image, cellx, celly, opacity, animlist, animnum, visible, scene)

        # 3Dオブジェクト
        when GLMODEL
            obj = createObject2(motionObj, _type_, x, y, z, xs, ys, zs, gravity, model, opacity)

    return obj

#******************************************************************************
# 3Dスプライト生成
#******************************************************************************
createObject2 = (motionObj = undefined, _type_ = GLMODEL, x = 0, y = 0, z = 0, xs = 0.0, ys = 0.0, zs = 0.0, gravity = 0.0, model = Sphere, opacity = 1.0)->

    if (motionObj == null)
        motionObj = undefined

    objnum = _getNullObject()
    if (objnum < 0)
        return undefined

    obj = _objects[objnum]
    obj.active = true

    # 3Dスプライトを生成
    switch _type_
        when GLMODEL
            if (isFinite(model))
                motionsprite = new Sprite3D()
            else
                motionsprite = new model()

    # スプライトを表示
    rootScene3D.addChild(motionsprite)

    # モデル割り当て
    if (isFinite(model))
        if (IMAGELIST[model]? && model?)
            motionsprite.set(core.assets[IMAGELIST[model]])

    # 値を設定する
    motionsprite.x = parseInt(x)
    motionsprite.y = parseInt(y)
    motionsprite.z = parseInt(z)
    motionsprite._x_ = x
    motionsprite._y_ = y
    motionsprite._z_ = z
    motionsprite.xs = xs
    motionsprite.ys = ys
    motionsprite.zs = zs
    motionsprite.a = parseFloat(opacity)
    motionsprite.gravity = gravity

    # 動きを定義したオブジェクトを生成する
    if (motionObj != undefined)
        obj.motionObj = new motionObj(motionsprite)
    else
        obj.motionObj = new _stationary(motionsprite)

    uid = uniqueID()
    obj.motionObj._uniqueID = uid
    obj.motionObj._scene = rootScene3D

    if (motionsprite != undefined)
        # イベント定義
        motionsprite.addEventListener 'enterframe', ->
            if (obj.motionObj != undefined && typeof(obj.motionObj.behavior) == 'function')
                obj.motionObj.behavior()

    obj.motionObj._type_ = _type_

    return obj.motionObj

#******************************************************************************
# enforce1.x互換用2Dスプライト生成メソッド
#******************************************************************************
createObject = (motionObj = undefined, _type_ = SPRITE, x = 0, y = 0, xs = 0.0, ys = 0.0, gravity = 0.0, image = 0, cellx = 0, celly = 0, opacity = 1.0, animlist = undefined, animnum = 0, visible = true, scene = -1)->
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
                scene = GAMESCENE_SUB1
        when LABEL
            motionsprite = new Label()
            if (scene < 0)
                scene = GAMESCENE_SUB2
        else
            motionsprite = undefined
            if (scene < 0)
                scene = GAMESCENE_SUB1

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
            motionsprite.gravity = gravity

        when LABEL
            # パラメータ初期化
            motionsprite.x = x
            motionsprite.y = y
            motionsprite._x_ = x
            motionsprite._y_ = y
            motionsprite.textAlign = "left"
            motionsprite.font = "12pt 'Arial'"
            motionsprite.color = "black"

        when PHYSICAL
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
# オブジェクト削除（画面からも消える）
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
# オブジェクトリストの中で未使用のものの配列番号を返す。
# 無かった場合は-1を返す
#**********************************************************************
_getNullObject = ->
    ret = -1
    for i in [0..._objects.length]
        if (_objects[i].active == false)
            ret = i
            break
    return ret

#**********************************************************************
# オブジェクトリストの指定した番号のオブジェクトを返す
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
