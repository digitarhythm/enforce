#***********************************************************************
# enforce game engine(enchant)
#
# 2014.04.04 ver2.0
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
DSPRITE_BOX         = 2
DSPRITE_CIRCLE      = 3
SSPRITE_BOX         = 4
SSPRITE_CIRCLE      = 5
WEBGL               = 6

# WebGLのプリミティブの種類
SPHERE              = 0
CUBE                = 1
PLANE               = 2

# Sceneの種類
BGSCENE             = 0
BGSCENE_SUB1        = 1
BGSCENE_SUB2        = 2
GAMESCENE           = 3
GAMESCENE_SUB1      = 4
GAMESCENE_SUB2      = 5
TOPSCENE            = 6
WEBGLSCENE          = 7

# 数学式
RAD                 = (Math.PI / 180.0)
DEG                 = (180.0 / Math.PI)

# グローバル初期化

# センサー系
MOTION_ACCEL        = [x:0, y:0, z:0]
MOTION_GRAVITY      = [x:0, y:0, z:0]
MOTION_ROTATE       = [alpha:0, beta:0, gamma:0]

# User Agent
_useragent = window.navigator.userAgent.toLowerCase()
# 標準ブラウザ
if (_useragent.match(/^.*android.*?mobile safari.*$/i) != null && _useragent.match(/^.*\) chrome.*/i) == null)
    _standardbrowser = true
else
    _standardbrowser = false

# ゲーム起動時からの経過時間（秒）
LAPSEDTIME          = 0
# ゲーム起動時のUNIXTIME
BEGINNINGTIME       = ~~(new Date()/1000)

# 3D系
WEBGL               = undefined
OCULUS              = undefined
RENDERER            = undefined
CAMERA              = undefined
LIGHT               = undefined

# オブジェクトが入っている配列
_objects            = []

# Scene格納用配列
_scenes             = []

# 起動時に生成されるスタートオブジェクト
_main               = null

# デバッグ用LABEL
_DEBUGLABEL         = undefined

# enchantのcoreオブジェクト
core                = undefined

# box2dのworldオブジェクト
box2dworld          = undefined

# 3Dのscene
rootScene3d         = undefined

# enchantのrootScene
rootScene           = undefined

#******************************************************************************
# 起動時の処理
#******************************************************************************

# enchantのオマジナイ
enchant()
enchant.Sound.enabledInMobileSafari = true
enchant.ENV.MOUSE_ENABLED = false

# ゲーム起動時の処理
window.onload = ->
    # enchant初期化
    core = new Core(SCREEN_WIDTH, SCREEN_HEIGHT)
    #core.rootScene.backgroundColor = BGCOLOR
    core.fps = FPS

    if (MEDIALIST?)
        MEDIALIST['_notice'] = 'lib/notice.png'
        MEDIALIST['_execbutton'] = 'lib/execbutton.png'
        imagearr = []
        i = 0
        for obj of MEDIALIST
            imagearr[i++] = MEDIALIST[obj]
        core.preload(imagearr)
    rootScene = core.rootScene
    window.addEventListener 'devicemotion', (e)=>
        MOTION_ACCEL = e.acceleration
        MOTION_GRAVITY = e.accelerationIncludingGravity
    window.addEventListener 'deviceorientation', (e)=>
        MOTION_ROTATE.alpha = e.alpha
        MOTION_ROTATE.beta = e.beta
        MOTION_ROTATE.gamma = e.gamma

    # box2d初期化
    box2dworld = new PhysicsWorld(0, GRAVITY)

    # シーングループを生成
    for i in [0..TOPSCENE]
        scene = new Group()
        scene.backgroundColor = "black"
        _scenes[i] = scene
        rootScene.addChild(scene)

    if (DEBUG == true)
        _DEBUGLABEL = new Label()
        _DEBUGLABEL.x = 0
        _DEBUGLABEL.y = 0
        _DEBUGLABEL.color = "white"
        _DEBUGLABEL.font = "10px 'Arial'"
        _scenes[TOPSCENE].addChild(_DEBUGLABEL)

    if (WEBGL && isWebGL())
        # 3Dシーンを生成
        rootScene3d = new Scene3D()

        # スポットライト生成
        dlight = new DirectionalLight()
        dlight.directionX = 0
        dlight.directionY = 100
        dlight.directionZ = 100
        dlight.color = [1.0, 1.0, 1.0]
        rootScene3d.setDirectionalLight(dlight)

        # 環境光ライト生成
        alight = new AmbientLight()
        alight.directionX = 0
        alight.directionY = 1000
        alight.directionZ = 0
        alight.color = [1.0, 1.0, 1.0]
        rootScene3d.setAmbientLight(alight)

        # カメラ生成
        CAMERA = new Camera3D()
        CAMERA.x = 0
        CAMERA.y = 0
        CAMERA.z = 300
        CAMERA.centerX = 0
        CAMERA.centerY = 0
        CAMERA.centerZ = 0
        rootScene3d.setCamera(CAMERA)
    else
        WEBGL = false

    core.onload = ->
        for i in [0...OBJECTNUM]
            _objects[i] = new _originObject()
        _main = new enforceMain()
        rootScene.addEventListener 'enterframe', (e)->
            box2dworld.step(core.fps)
            #LAPSEDTIME = parseFloat((core.frame / FPS).toFixed(2))
            LAPSEDTIME = ((~~(new Date()/1000)) - @BEGINNINGTIME).toFixed(2)
            for obj in _objects
                if (obj.active == true && obj.motionObj != undefined && typeof(obj.motionObj.behavior) == 'function')
                    obj.motionObj.behavior()
    core.start()

debugwrite = (param)->
    str = _DEBUGLABEL.text += if (param.str?) then param.str else ""
    fontsize = if (param.fontsize?) then param.fontsize else 10
    fontcolor = if (param.fontcolor?) then param.fontcolor else "white"
    if (DEBUG == true)
        _DEBUGLABEL.font = fontsize+"px 'Arial'"
        _DEBUGLABEL.text = str
        _DEBUGLABEL.color = fontcolor
debugclear =->
    _DEBUGLABEL.text = ""

#******************************************************************************
# 2D/3D共用オブジェクト生成メソッド
#******************************************************************************
addObject = (param)->
    # パラメーター
    motionObj = if (param['motionObj']?) then param['motionObj'] else undefined
    _type = if (param['type']?) then param['type'] else SPRITE
    x = if (param['x']?) then param['x'] else 0.0
    y = if (param['y']?) then param['y'] else 0.0
    z = if (param['z']?) then param['z'] else 0.0
    xs = if (param['xs']?) then param['xs'] else 0.0
    ys = if (param['ys']?) then param['ys'] else 0.0
    zs = if (param['zs']?) then param['zs'] else 0.0
    gravity = if (param['gravity']?) then param['gravity'] else 0.0
    image = if (param['image']?) then param['image'] else undefined
    width = if (param['width']?) then param['width'] else 0.0
    height = if (param['height']?) then param['height'] else 0.0
    opacity = if (param['opacity']?) then param['opacity'] else 1.0
    animlist = if (param['animlist']?) then param['animlist'] else undefined
    animnum = if (param['animnum']?) then param['animnum'] else 0
    visible = if (param['visible']?) then param['visible'] else true
    scene = if (param['scene']?) then param['scene'] else -1
    model = if (param['model']?) then param['model'] else undefined
    density = if (param['density']?) then param['density'] else 1.0
    friction = if (param['friction']?) then param['friction'] else 0.5
    restitution = if (param['restitution']?) then param['restitution'] else 0.1
    move = if (param['move']?) then param['move'] else false
    scaleX = if (param['scaleX']?) then param['scaleX'] else 1.0
    scaleY = if (param['scaleY']?) then param['scaleY'] else 1.0
    scaleZ = if (param['scaleZ']?) then param['scaleZ'] else 1.0
    rotation = if (param['rotation']?) then param['rotation'] else 0.0

    if (motionObj == null)
        motionObj = undefined

    # スプライトを生成
    switch (_type)
        when CONTROL, SPRITE
            motionsprite = new Sprite()
            if (scene < 0)
                scene = GAMESCENE_SUB1

            # TimeLineを時間ベースにする
            motionsprite.tl.setTimeBased()

            if (animlist?)
                animtmp = animlist[animnum]
                motionsprite.frame = animtmp[1][0]

                motionsprite.backgroundColor = "transparent"
                motionsprite.x = x - Math.floor(width / 2)
                motionsprite.y = y - Math.floor(height / 2) - Math.floor(z)
                motionsprite.opacity = opacity
                motionsprite.rotation = rotation
                motionsprite.scaleX = scaleX
                motionsprite.scaleY = scaleY
                motionsprite.visible = visible
                motionsprite.width = width
                motionsprite.height = height

                # 画像割り当て
                if (MEDIALIST[image]? && animlist?)
                    img = MEDIALIST[image]
                    motionsprite.image = core.assets[img]

                # スプライトを表示
                _scenes[scene].addChild(motionsprite)

            # 動きを定義したオブジェクトを生成する
            retObject = @setMotionObj
                x: x
                y: y
                z: z
                xs: xs
                ys: ys
                zs: zs
                visible: visible
                scaleX: scaleX
                scaleY: scaleY
                scaleZ: scaleZ
                gravity: gravity
                width: width
                height: height
                animlist: animlist
                animnum: animnum
                opacity: opacity
                scene: scene
                _type: _type
                motionsprite: motionsprite
                motionObj: motionObj
                rotation: rotation
            return retObject

        when WEBGL
            if (isFinite(image))
                switch (image)
                    when SPHERE
                        JSLog('SHPERE')
                    when CUBE
                        JSLog('CUBE')
                    when PLANE
                        JSLog('PLANE')
            else
                if (MEDIALIST[image]?)
                    motionsprite = new Sprite3D()
                    rootScene3d.addChild(motionsprite)
                    motionsprite.set(core.assets[MEDIALIST[image]].clone())
                    # 動きを定義したオブジェクトを生成する
                    retObject = @setMotionObj
                        x: x
                        y: y
                        z: z
                        xs: xs
                        ys: ys
                        zs: zs
                        visible: visible
                        scaleX: scaleX
                        scaleY: scaleY
                        scaleZ: scaleZ
                        gravity: gravity
                        width: width
                        height: height
                        animlist: animlist
                        animnum: animnum
                        opacity: opacity
                        scene: WEBGLSCENE
                        _type: _type
                        motionsprite: motionsprite
                        motionObj: motionObj
                else
                    retObject = undefined

            return retObject

setMotionObj = (param)->
    # 動きを定義したオブジェクトを生成する
    initparam = []
    initparam['x'] = if (param['x']?) then param['x'] else 0
    initparam['y'] = if (param['y']?) then param['y'] else 0
    initparam['z'] = if (param['z']?) then param['z'] else 0
    initparam['xs'] = if (param['xs']?) then param['xs'] else 0
    initparam['ys'] = if (param['ys']?) then param['ys'] else 0
    initparam['zs'] = if (param['zs']?) then param['zs'] else 0
    initparam['visible'] = if (param['visible']?) then param['visible'] else true
    initparam['scaleX'] = if (param['scaleX']?) then param['scaleX'] else 1.0
    initparam['scaleY'] = if (param['scaleY']?) then param['scaleY'] else 1.0
    initparam['scaleZ'] = if (param['scaleZ']?) then param['scaleZ'] else 1.0
    initparam['gravity'] = if (param['gravity']?) then param['gravity'] else 0
    initparam['intersectFlag'] = if (param['intersectFlag']?) then param['intersectFlag'] else true
    initparam['width'] = if (param['width']?) then param['width'] else 0
    initparam['height'] = if (param['height']?) then param['height'] else 0
    initparam['animlist'] = if (param['animlist']?) then param['animlist'] else 0
    initparam['animnum'] = if (param['animnum']?) then param['animnum'] else 0
    initparam['visible'] = if (param['visible']?) then param['visible'] else true
    initparam['opacity'] = if (param['opacity']?) then param['opacity'] else 0
    initparam['rotation'] = if (param['rotation']?) then param['rotation'] else 0.0
    initparam['motionsprite'] = if (param['motionsprite']?) then param['motionsprite'] else 0
    initparam['diffx'] = Math.floor(initparam['width'] / 2)
    initparam['diffy'] = Math.floor(initparam['height'] / 2)
    scene = if (param['scene']?) then param['scene'] else GAMESCENE
    _type = if (param['_type']?) then param['_type'] else SPRITE
    initparam['_type'] = _type
    motionObj = if (param['motionObj']?) then param['motionObj'] else undefined

    objnum = _getNullObject()
    if (objnum < 0)
        return undefined

    obj = _objects[objnum]
    obj.active = true

    if (motionObj?)
        obj.motionObj = new motionObj(initparam)
    else
        obj.motionObj = new _stationary(initparam)

    uid = uniqueID()
    obj.motionObj._uniqueID = uid
    obj.motionObj._scene = scene
    obj.motionObj._type = _type

    return obj.motionObj

#**********************************************************************
# オブジェクト削除（画面からも消える）
#**********************************************************************
removeObject = (motionObj)->
    if (!motionObj?)
        return

    # 削除しようとしているmotionObjがオブジェクトリストのどこに入っているか探す
    ret = false
    for object in _objects
        if (!object.motionObj?)
            continue
        if (object.motionObj._uniqueID == motionObj._uniqueID)
            ret = true
            break
    if (ret == false)
        return

    if (typeof(motionObj.destructor) == 'function')
        motionObj.destructor()

    if (motionObj._type == DSPRITE_BOX || motionObj._type == DSPRITE_CIRCLE || motionObj._type == SSPRITE_BOX || motionObj._type == SSPRITE_CIRCLE)
        object.motionObj.sprite.destroy()
    else
        _scenes[object.motionObj._scene].removeChild(object.motionObj.sprite)
    object.motionObj.sprite = undefined

    object.motionObj = undefined
    object.active = false

#**********************************************************************
# オブジェクトリストの指定した番号のオブジェクトを返す
#**********************************************************************
getObject = (id)->
    ret = undefined
    for i in [0..._objects.length]
        if (!_objects[i]?)
            continue
        if (!_objects[i].motionObj?)
            continue
        if (_objects[i].motionObj._uniqueID == id)
            ret = _objects[i].motionObj
            break
    return ret

#**********************************************************************
#**********************************************************************
#**********************************************************************
# 以下は内部使用ライブラリ関数
#**********************************************************************
#**********************************************************************
#**********************************************************************

#**********************************************************************
# サウンド再生
#**********************************************************************
playSound = (name)->
    soundfile = MEDIALIST[name]
    soundassets = core.assets[soundfile].clone()
    soundassets.play()
    return soundassets

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
# 標準ブラウザは非推奨というダイアログ表示
#**********************************************************************
dispDefaultBrowserCheck = (func)->
    if (_standardbrowser)
        cautionscale = SCREEN_WIDTH / 320
        caution = addObject
            image: '_notice'
            x: SCREEN_WIDTH / 2
            y: 200
            width: 300
            height: 140
            animlist: [
                [100, [0]]
            ]
            scaleX: cautionscale
            scaleY: cautionscale
        okbutton = addObject
            image: '_execbutton'
            x: SCREEN_WIDTH / 2
            y: 320
            width: 80
            height: 32
            animlist: [
                [100, [0]]
            ]
            scaleX: cautionscale
            scaleY: cautionscale
        okbutton.sprite.ontouchstart = (e)=>
            removeObject(caution)
            removeObject(okbutton)
            func()
    else
        func()

