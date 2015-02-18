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
LABEL               = 2
SURFACE             = 3
PRIMITIVE           = 4
COLLADA             = 5
MAP                 = 6
EXMAP               = 7

# 物理スプライトの種類
DYNAMIC_BOX         = 0
DYNAMIC_CIRCLE      = 1
STATIC_BOX          = 2
STATIC_CIRCLE       = 3

# WebGLのプリミティブの種類
BOX                 = 0
CUBE                = 1
SPHERE              = 2
CYLINDER            = 3
TORUS               = 4
PLANE               = 5

# Sceneの種類
BGSCENE             = 0
BGSCENE_SUB1        = 1
BGSCENE_SUB2        = 2
GAMESCENE           = 3
GAMESCENE_SUB1      = 4
GAMESCENE_SUB2      = 5
TOPSCENE            = 6
WEBGLSCENE          = 7
_SYSTEMSCENE        = 8
DEBUGSCENE          = 9
MAXSCENE            = (if (DEBUG) then DEBUGSCENE else _SYSTEMSCENE)

# 数学式
RAD                 = (Math.PI / 180.0)
DEG                 = (180.0 / Math.PI)

# グローバル初期化
GLOBAL              = []

# サウンドプリロード用
SOUNDARR            = []

# アスペクト比
ASPECT              = 0.0

# ゲームパッド情報格納変数
HORIZONTAL          = 0
VERTICAL            = 1
_GAMEPADSINFO       = []
PADBUTTONS          = []
PADBUTTONS[0]       = [false, false]
PADAXES             = []
PADAXES[0]          = [0, 0]
ANALOGSTICK         = []
ANALOGSTICK[0]      = [0, 0, 0, 0]
_VGAMEPADOBJ        = undefined
_VGAMEBUTTON        = []

# Frame Per Seconds
if (!FPS?)
    FPS = 30

# box2dの重力値
if (!GRAVITY_X?)
    GRAVITY_X = 0.0
if (!GRAVITY_Y?)
    GRAVITY_Y = 0.0

# センサー系
MOTION_ACCEL        = [x:0, y:0, z:0]
MOTION_GRAVITY      = [x:0, y:0, z:0]
MOTION_ROTATE       = [alpha:0, beta:0, gamma:0]

# User Agent
_useragent = window.navigator.userAgent.toLowerCase()
# 標準ブラウザ
if (_useragent.match(/^.*android.*?mobile safari.*$/i) != null && _useragent.match(/^.*\) chrome.*/i) == null)
    _defaultbrowser = true
else
    _defaultbrowser = false
# ブラウザ大分類
if (_useragent.match(/.* firefox\/.*/))
    _browserMajorClass = "firefox"
else if (_useragent.match(/.*version\/.* safari\/.*/))
    _browserMajorClass = "safari"
else if (_useragent.match(/.*chrome\/.* safari\/.*/))
    _browserMajorClass = "chrome"
else
    _browserMajorClass = "unknown"

# ゲーム起動時からの経過時間（秒）
LAPSEDTIME          = 0
# ゲーム起動時のUNIXTIME
BEGINNINGTIME       = parseFloat((new Date) / 1000)

# 3D系
WEBGL               = undefined
OCULUS              = undefined
RENDERER            = undefined
CAMERA              = undefined
LIGHT               = undefined

# デバイスサイズ
_frame = getBounds()
DEVICE_WIDTH = _frame[0]
DEVICE_HEIGHT = _frame[1]
if (!SCREEN_WIDTH? && !SCREEN_HEIGHT?)
    SCREEN_WIDTH = DEVICE_WIDTH
    SCREEN_HEIGHT = DEVICE_HEIGHT

# 動作状況
ACTIVATE            = true

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
enchant.ENV.MOUSE_ENABLED = false
enchant.ENV.SOUND_ENABLED_ON_MOBILE_SAFARI = false

# ゲーム起動時の処理
window.onload = ->
    # アスペクト比
    ASPECT = (SCREEN_WIDTH / SCREEN_HEIGHT).toFixed(2)
    # enchant初期化
    core = new Core(SCREEN_WIDTH, SCREEN_HEIGHT)
    # FPS設定
    core.fps = FPS

    # 「A」ボタンの定義
    core.keybind( 90, 'a' )
    core.keybind( 88, 'b' )
    core.keybind( 67, 'c' )
    core.keybind( 86, 'd' )
    core.keybind( 66, 'e' )
    core.keybind( 78, 'f' )
    core.keybind( 32, 'space' )

    # メディアファイルのプリロード
    if (MEDIALIST?)
        MEDIALIST['_notice'] = 'lib/notice.png'
        MEDIALIST['_execbutton'] = 'lib/execbutton.png'
        MEDIALIST['_pad'] = 'lib/pad.png'
        MEDIALIST['_button'] = 'lib/button.png'
        mediaarr = []
        num = 0
        for obj of MEDIALIST
            mediaarr[num++] = MEDIALIST[obj]
        core.preload(mediaarr)

    # rootSceneをグローバルに保存
    rootScene = core.rootScene

    # モーションセンサーのイベント登録
    window.addEventListener 'devicemotion', (e)=>
        MOTION_ACCEL = e.acceleration
        MOTION_GRAVITY = e.accelerationIncludingGravity
    window.addEventListener 'deviceorientation', (e)=>
        MOTION_ROTATE.alpha = e.alpha
        MOTION_ROTATE.beta = e.beta
        MOTION_ROTATE.gamma = e.gamma

    # box2d初期化
    box2dworld = new PhysicsWorld(GRAVITY_X, GRAVITY_Y)

    # シーングループを生成
    for i in [0..MAXSCENE]
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
        _scenes[DEBUGSCENE].addChild(_DEBUGLABEL)
        ###
        _FPSLABEL = new Label()
        _FPSLABEL.x = 0
        _FPSLABEL.y = SCREEN_HEIGHT - 24
        _FPSLABEL.width = 48
        _FPSLABEL.height = 24
        _FPSLABEL.opacity = 0.8
        _FPSLABEL.font = "24px 'Arial'"
        _FPSLABEL.textAlign = "center"
        _FPSLABEL.color = "gray"
        _scenes[DEBUGSCENE].addChild(_FPSLABEL)
        ###

    if (WEBGL && isWebGL())
        # 3Dシーンを生成
        rootScene3d = new Scene3D()
        _scenes[WEBGLSCENE] = rootScene3d

        # スポットライト生成
        #dlight = new DirectionalLight()
        #dlight.directionX = 0
        #dlight.directionY = 100
        #dlight.directionZ = 0
        #dlight.color = [1.0, 1.0, 1.0]
        #rootScene3d.setDirectionalLight(dlight)

        # 環境光ライト生成
        #alight = new AmbientLight()
        #alight.directionX = 0
        #alight.directionY = 100
        #alight.directionZ = 0
        #alight.color = [1.0, 1.0, 1.0]
        #rootScene3d.setAmbientLight(alight)

        # カメラ生成
        CAMERA = new Camera3D()
        CAMERA.x = 0
        CAMERA.y = 0
        CAMERA.z = 160
        CAMERA.centerX = 0
        CAMERA.centerY = 0
        CAMERA.centerZ = 0
        rootScene3d.setCamera(CAMERA)
    else
        rootScene.backgroundColor = BGCOLOR
        WEBGL = false

    core.onload = ->
        # ゲーム用オブジェクトを指定された数だけ確保
        for i in [0...OBJECTNUM]
            _objects[i] = new _originObject()
        _main = new enforceMain()

        __total = 0
        __count = 0
        __limittimefps = parseFloat(LAPSEDTIME) + 1.0

        # フレーム処理（enchant任せ）
        rootScene.addEventListener 'enterframe', (e)->
            # FPS表示（デバッグモード時のみ）
            ###
            if (DEBUG)
                __total += parseFloat(core.actualFps.toFixed(2))
                __count++
                if (__limittimefps < LAPSEDTIME)
                    fpsnum = (__total / __count).toFixed(2)
                    __total = 0
                    __count = 0
                    __limittimefps = parseFloat(LAPSEDTIME) + 1.0
                    _FPSLABEL.text =fpsnum
            ###

            # ジョイパッド処理
            if (typeof gamepadProcedure == 'function')
                _GAMEPADSINFO = gamepadProcedure()
                for num in [0..._GAMEPADSINFO.length]
                    if (!_GAMEPADSINFO[num]?)
                        continue
                    PADBUTTONS[num] = _GAMEPADSINFO[num].padbuttons
                    PADAXES[num] = _GAMEPADSINFO[num].padaxes
                    ANALOGSTICK[num] = _GAMEPADSINFO[num].analogstick

            if (core.input.a || core.input.space || (_VGAMEBUTTON[0]? && _VGAMEBUTTON[0].push))
                PADBUTTONS[0][0] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][0] = false

            if (core.input.b || (_VGAMEBUTTON[1]? && _VGAMEBUTTON[1].push))
                PADBUTTONS[0][1] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][1] = false

            if (core.input.c || (_VGAMEBUTTON[2]? && _VGAMEBUTTON[2].push))
                PADBUTTONS[0][2] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][2] = false

            if (core.input.d || (_VGAMEBUTTON[3]? && _VGAMEBUTTON[3].push))
                PADBUTTONS[0][3] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][3] = false

            if (core.input.e || (_VGAMEBUTTON[4]? && _VGAMEBUTTON[4].push))
                PADBUTTONS[0][4] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][4] = false

            if (core.input.f || (_VGAMEBUTTON[5]? && _VGAMEBUTTON[5].push))
                PADBUTTONS[0][5] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][5] = false

            if (core.input.left || (_VGAMEPADOBJ? && _VGAMEPADOBJ.input.left))
                PADAXES[0][HORIZONTAL] = -1
            else if (core.input.right || (_VGAMEPADOBJ? && _VGAMEPADOBJ.input.right))
                PADAXES[0][HORIZONTAL] = 1
            else if (!_GAMEPADSINFO[0]?)
                PADAXES[0][HORIZONTAL] = 0

            if (core.input.up || (_VGAMEPADOBJ? && _VGAMEPADOBJ.input.up))
                PADAXES[0][VERTICAL] = -1
            else if (core.input.down || (_VGAMEPADOBJ? && _VGAMEPADOBJ.input.down))
                PADAXES[0][VERTICAL] = 1
            else if (!_GAMEPADSINFO[0]?)
                PADAXES[0][VERTICAL] = 0

            # box2dの時間を進める
            box2dworld.step(core.fps)

            # 経過時間を計算
            LAPSEDTIME = (parseFloat((new Date) / 1000) - parseFloat(BEGINNINGTIME).toFixed(2))

            # 全てのオブジェクトの「behavior」を呼ぶ
            for obj in _objects
                if (obj.active == true && obj.motionObj != undefined && typeof(obj.motionObj.behavior) == 'function')
                    obj.motionObj.behavior()

    if (DEBUG == true)
        core.debug()
    else
        core.start()

debugwrite = (param)->
    if (DEBUG)
        if (param.clear)
            labeltext = if (param.labeltext?) then param.labeltext else ""
        else
            labeltext = _DEBUGLABEL.text += if (param.labeltext?) then param.labeltext else ""
        fontsize = if (param.fontsize?) then param.fontsize else 12
        fontcolor = if (param.fontcolor?) then param.fontcolor else "white"
        _DEBUGLABEL.font = fontsize+"px 'Arial'"
        _DEBUGLABEL.text = labeltext
        _DEBUGLABEL.color = fontcolor
debugclear =->
    if (DEBUG)
        _DEBUGLABEL.text = ""

#******************************************************************************
# 2D/3D共用オブジェクト生成メソッド
#******************************************************************************
addObject = (param, parent = undefined)->
    # パラメーター
    motionObj = if (param['motionObj']?) then param['motionObj'] else undefined
    _type = if (param['type']?) then param['type'] else SPRITE
    x = if (param['x']?) then param['x'] else 0
    y = if (param['y']?) then param['y'] else 0
    z = if (param['z']?) then param['z'] else 0
    xs = if (param['xs']?) then param['xs'] else 0.0
    ys = if (param['ys']?) then param['ys'] else 0.0
    zs = if (param['zs']?) then param['zs'] else 0.0
    gravity = if (param['gravity']?) then param['gravity'] else 0.0
    image = if (param['image']?) then param['image'] else undefined
    model = if (param['model']?) then param['model'] else undefined
    width = if (param['width']?) then param['width'] else 1
    height = if (param['height']?) then param['height'] else 1
    depth = if (param['depth']?) then param['depth'] else 1.0
    opacity = if (param['opacity']?) then param['opacity'] else 1.0
    animlist = if (param['animlist']?) then param['animlist'] else undefined
    animnum = if (param['animnum']?) then param['animnum'] else 0
    visible = if (param['visible']?) then param['visible'] else true
    scene = if (param['scene']?) then param['scene'] else -1
    rigid = if (param['rigid']?) then param['rigid'] else false
    density = if (param['density']?) then param['density'] else 1.0
    friction = if (param['friction']?) then param['friction'] else 1.0
    restitution = if (param['restitution']?) then param['restitution'] else 1.0
    radius = if (param['radius']?) then param['radius'] else undefined
    radius2 = if (param['radius2']?) then param['radius2'] else 1.0
    size = if (param['size']?) then param['size'] else 1.0
    scaleX = if (param['scaleX']?) then param['scaleX'] else 1.0
    scaleY = if (param['scaleY']?) then param['scaleY'] else 1.0
    scaleZ = if (param['scaleZ']?) then param['scaleZ'] else 1.0
    rotation = if (param['rotation']?) then param['rotation'] else 0.0
    texture = if (param['texture']?) then param['texture'] else undefined
    fontsize = if (param['fontsize']?) then param['fontsize'] else '16'
    color = if (param['color']?) then param['color'] else 'white'
    labeltext = if (param['labeltext']?) then param['labeltext'] else 'text'
    textalign = if (param['textalign']?) then param['textalign'] else 'left'
    active = if (param['active']?) then param['active'] else true
    kind = if (param['kind']?) then param['kind'] else DYNAMIC_BOX
    map = if (param['map']?) then param['map'] else undefined
    map2 = if (param['map2']?) then param['map2'] else undefined
    mapcollision = if (param['mapcollision']?) then param['mapcollision'] else undefined
    collider = if (param['collider']?) then param['collider'] else undefined
    offsetx = if (param['offsetx']?) then param['offsetx'] else 0
    offsety = if (param['offsety']?) then param['offsety'] else 0
    bgcolor = if (param['bgcolor']?) then param['bgcolor'] else 'transparent'

    if (motionObj == null)
        motionObj = undefined

    retObject = undefined

    # スプライトを生成
    switch (_type)
        #*****************************************************************
        # CONTROL、SPRITE
        #*****************************************************************
        when CONTROL, SPRITE
            motionsprite = undefined
            if (_type == SPRITE)
                if (rigid)
                    if (!radius?)
                        radius = width
                    switch (kind)
                        when DYNAMIC_BOX
                            motionsprite = new PhyBoxSprite(width, height, enchant.box2d.DYNAMIC_SPRITE, density, friction, restitution, true)
                        when DYNAMIC_CIRCLE
                            motionsprite = new PhyCircleSprite(radius, enchant.box2d.DYNAMIC_SPRITE, density, friction, restitution, true)
                        when STATIC_BOX
                            motionsprite = new PhyBoxSprite(width, height, enchant.box2d.STATIC_SPRITE, density, friction, restitution, true)
                        when STATIC_CIRCLE
                            motionsprite = new PhyCircleSprite(radius, enchant.box2d.STATIC_SPRITE, density, friction, restitution, true)

            if (!motionsprite?)
                motionsprite = new Sprite()
                # TimeLineを時間ベースにする
                motionsprite.tl.setTimeBased()


            if (scene < 0)
                scene = GAMESCENE_SUB1

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
                image: image
                _type: _type
                motionsprite: motionsprite
                motionObj: motionObj
                rotation: rotation
                parent: parent
                radius: radius
                density: density
                friction: friction
                restitution: restitution
                active: active
                rigid: rigid
                kind: kind
                collider: collider
                offsetx: offsetx
                offsety: offsety
            return retObject

        #*****************************************************************
        # LABEL
        #*****************************************************************
        when LABEL
            if (scene < 0)
                scene = GAMESCENE_SUB1
            if (width == 0)
                width = 120
            if (height == 0)
                height = 64
            # ラベルを生成
            motionsprite = new Label(labeltext)
            # ラベルを表示
            _scenes[scene].addChild(motionsprite)
            # 値を代入
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
            motionsprite.color = color
            motionsprite.text = labeltext
            motionsprite.textAlign = textalign
            motionsprite.font = fontsize+"px 'Arial'"
            # TimeLineを時間ベースにする
            motionsprite.tl.setTimeBased()
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
                width: width
                height: height
                opacity: opacity
                scene: scene
                _type: _type
                active: active
                motionsprite: motionsprite
                motionObj: motionObj
                fontsize: fontsize
                color: color
                labeltext: labeltext
                textalign: textalign
                parent: parent
            return retObject

        #*****************************************************************
        # プリミティブ
        #*****************************************************************
        when PRIMITIVE
            if (!radius?)
                radius = 1.0
            switch (model)
                when BOX
                    motionsprite = new Box(width, height, depth)
                when CUBE
                    motionsprite = new Cube(size)
                when SPHERE
                    motionsprite = new Sphere(size)
                when CYLINDER
                    motionsprite = new Cylinder(radius, height)
                when TORUS
                    motionsprite = new Torus(radius, radius2)
                when PLANE
                    motionsprite = new Plane(size)
                else
                    return undefined

            if (texture?)
                imagefile = MEDIALIST[texture]
                tx = new Texture(imagefile)
                motionsprite.mesh.texture = tx

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
                radius: radius
                radius2: radius2
                size: size
                gravity: gravity
                width: width
                height: height
                depth: depth
                animlist: animlist
                animnum: animnum
                active: active
                opacity: opacity
                scene: WEBGLSCENE
                _type: _type
                motionsprite: motionsprite
                motionObj: motionObj
                parent: parent

            if (visible)
                rootScene3d.addChild(motionsprite)

            return retObject

        #*****************************************************************
        # COLLADAモデル
        #*****************************************************************
        when COLLADA
            if (!radius?)
                radius = 1.0
            if (MEDIALIST[model]?)
                motionsprite = new Sprite3D()
                motionsprite.set(core.assets[MEDIALIST[model]].clone())
            else
                return undefined

            # 動きを定義したオブジェクトを生成する
            if (visible)
                rootScene3d.addChild(motionsprite)
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
                radius: radius
                radius2: radius2
                active: active
                size: size
                gravity: gravity
                width: width
                height: height
                depth: depth
                animlist: animlist
                animnum: animnum
                opacity: opacity
                scene: WEBGLSCENE
                _type: _type
                motionsprite: motionsprite
                motionObj: motionObj
                parent: parent
            return retObject

        #*****************************************************************
        # Surface
        #*****************************************************************
        when SURFACE
            if (scene < 0)
                scene = GAMESCENE_SUB1
            motionsprite = new Sprite(SCREEN_WIDTH, SCREEN_HEIGHT)
            surface = new Surface(SCREEN_WIDTH, SCREEN_HEIGHT)
            motionsprite.image = surface
            context = surface.context

            ###
            # パスの描画の初期化
            context.beginPath()
            # 描画開始位置の移動
            context.moveTo(10, 10)
            # 指定座標まで直線を描画
            context.lineTo(100, 100)
            # 線の色を指定 (指定しないと黒)
            context.strokeStyle = "rgba(0, 255, 255, 0.5)";      
            # 描画を行う
            context.stroke()
            ###

            retObject = @setMotionObj
                width: SCREEN_WIDTH
                height: SCREEN_HEIGHT
                opacity: opacity
                scene: scene
                _type: _type
                motionsprite: motionsprite
                motionObj: motionObj
                parent: parent
                context: context
                active: active
                surface: surface
            _scenes[scene].addChild(motionsprite)
            return retObject

        #*****************************************************************
        # Mapオブジェクト
        #*****************************************************************
        when MAP, EXMAP
            if (!map? || image == "")
                JSLog("parameter not enough.")
            else
                if (scene < 0)
                    scene = BGSCENE_SUB1
                if (_type == MAP)
                    motionsprite = new Map(width, height)
                    motionsprite.loadData(map)
                else
                    motionsprite = new ExMap(width, height)
                    motionsprite.loadData(map, map2)
                img = MEDIALIST[image]
                motionsprite.image = core.assets[img]
                if (mapcollision?)
                    motionsprite.collisionData = mapcollision
                _scenes[scene].addChild(motionsprite)
                motionsprite.tl.setTimeBased()
            retObject = @setMotionObj
                x: x
                y: y
                xs: xs
                ys: ys
                map: map
                visible: visible
                width: width
                height: height
                opacity: opacity
                scene: scene
                active: active
                image: image
                _type: _type
                motionsprite: motionsprite
                motionObj: motionObj
                parent: parent
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
    initparam['radius'] = if (param['radius']?) then param['radius'] else 0.0
    initparam['radius2'] = if (param['radius2']?) then param['radius2'] else 0.0
    initparam['size'] = if (param['size']?) then param['size'] else 1.0
    initparam['gravity'] = if (param['gravity']?) then param['gravity'] else 0
    initparam['intersectFlag'] = if (param['intersectFlag']?) then param['intersectFlag'] else true
    initparam['width'] = if (param['width']?) then param['width'] else SCREEN_WIDTH
    initparam['height'] = if (param['height']?) then param['height'] else SCREEN_HEIGHT
    initparam['animlist'] = if (param['animlist']?) then param['animlist'] else 0
    initparam['animnum'] = if (param['animnum']?) then param['animnum'] else 0
    initparam['image'] = if (param['image']?) then param['image'] else undefined
    initparam['visible'] = if (param['visible']?) then param['visible'] else true
    initparam['opacity'] = if (param['opacity']?) then param['opacity'] else 0
    initparam['rotation'] = if (param['rotation']?) then param['rotation'] else 0.0
    initparam['motionsprite'] = if (param['motionsprite']?) then param['motionsprite'] else 0
    initparam['fontsize'] = if (param['fontsize']?) then param['fontsize'] else '16'
    initparam['color'] = if (param['color']?) then param['color'] else 'white'
    initparam['labeltext'] = if (param['labeltext']?) then param['labeltext'] else 'text'
    initparam['textalign'] = if (param['textalign']?) then param['textalign'] else 'left'
    initparam['parent'] = if (param['parent']?) then param['parent'] else undefined
    initparam['density'] = if (param['density']?) then param['density'] else 1.0
    initparam['friction'] = if (param['friction']?) then param['friction'] else 0.5
    initparam['restitution'] = if (param['restitution']?) then param['restitution'] else 0.1
    initparam['active'] = if (param['active']?) then param['active'] else true
    initparam['kind'] = if (param['kind']?) then param['kind'] else undefined
    initparam['rigid'] = if (param['rigid']?) then param['rigid'] else undefined
    initparam['context'] = if (param['context']?) then param['context'] else undefined
    initparam['surface'] = if (param['surface']?) then param['surface'] else undefined
    initparam['collider'] = if (param['collider']?) then param['collider'] else undefined
    initparam['offsetx'] = if (param['offsetx']?) then param['offsetx'] else 0
    initparam['offsety'] = if (param['offsety']?) then param['offsety'] else 0

    scene = if (param['scene']?) then param['scene'] else GAMESCENE_SUB1
    _type = if (param['_type']?) then param['_type'] else SPRITE
    initparam['_type'] = _type
    motionObj = if (param['motionObj']?) then param['motionObj'] else undefined

    map = if (param['map']?) then param['map'] else []
    if (_type == MAP || _type == EXMAP)
        mapwidth = map[0].length * initparam['width']
        mapheight = map.length * initparam['height']
        initparam['diffx'] = Math.floor(mapwidth / 2)
        initparam['diffy'] = Math.floor(mapheight / 2)
    else
        initparam['diffx'] = Math.floor(initparam['width'] / 2)
        initparam['diffy'] = Math.floor(initparam['height'] / 2)


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

    if (motionObj.collider._uniqueID != motionObj._uniqueID)
        removeObject(motionObj.collider)

    if (typeof(motionObj.destructor) == 'function')
        motionObj.destructor()

    if (motionObj.rigid)
        object.motionObj.sprite.destroy()
    else
        switch (motionObj._type)
            when SPRITE, LABEL, MAP, EXMAP, PRIMITIVE, COLLADA
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
# サウンド再生
#**********************************************************************
playSound = (name, vol = 1.0, flag = false)->
    soundfile = MEDIALIST[name]
    sound = core.assets[soundfile].clone()
    if (sound.src?)
        sound.play()
        sound.volume = vol
        sound.src.loop = flag
        return sound

#**********************************************************************
# サウンド一時停止
#**********************************************************************
pauseSound = (obj)->
    obj.pause()

#**********************************************************************
# サウンド再開
#**********************************************************************
resumeSound = (obj, flag = false)->
    obj.play()
    #obj.src.loop = flag
    obj.loop = flag

#**********************************************************************
# サウンド停止
#**********************************************************************
stopSound = (obj)->
    obj.stop()

#**********************************************************************
# サウンド音量設定
#**********************************************************************
setSoundLoudness = (obj, num)->
    obj.volume = num

#**********************************************************************
# サウンド再生位置（時間）取得
#**********************************************************************
getSoundCurrenttime = (obj)->
    return obj.currenttime

#**********************************************************************
# サウンド再生位置（時間）設定
#**********************************************************************
setSoundCurrenttime = (obj, num)->
    obj.currenttime = num

#**********************************************************************
# ゲーム一時停止
#**********************************************************************
pauseGame =->
    ACTIVATE = false
    core.pause()

#**********************************************************************
# ゲーム再開
#**********************************************************************
resumeGame =->
    ACTIVATE = true
    core.resume()

#**********************************************************************
# バーチャルゲームパッド
#**********************************************************************
createVirtualGamepad = (param)->
    if (param?)
        if (param.scale?) then scale = param.scale else scale = 1
        if (param.x?) then x = param.x else x = (100 / 2) * scale
        if (param.y?) then y = param.y else y = SCREEN_HEIGHT - ((100 / 2) * scale)
        if (param.button?) then button = param.button else button = 0
        if (param.buttonscale?) then buttonscale = param.buttonscale else buttonscale = 1
        if (param.coord?) then coord = param.coord else coord = []
        if (param.visible?) then visible = param.visible else visible = true
    else
        scale = 1.0
        x = (100 / 2) * scale
        y = SCREEN_HEIGHT - ((100 / 2) * scale)
        button = 0
        buttonscale = 1
        coord = []
        visible = true

    if (button > 6)
        button = 6

    if (!_VGAMEPADOBJ?)
        _VGAMEPADOBJ = addObject
            motionObj: _vgamepad
            image: '_pad'
            x: x
            y: y
            width: 100
            height: 100
            animlist: [
                [100, [0]]
                [100, [1]]
                [100, [2]]
            ]
            visible: false
            scaleX: scale
            scaleY: scale
            scene: _SYSTEMSCENE
        _VGAMEPADOBJ.visible = visible

        for i in [0...button]
            c = coord[i]
            if (!c?)
                c = []
                c[0] = SCREEN_WIDTH - ((64 / 2) * buttonscale)
                c[1] = (64 * buttonscale) * i + (32 * buttonscale)
            obj = addObject
                image: '_button'
                motionObj: _vgamebutton
                width: 64
                height: 64
                x: c[0]
                y: c[1]
                visible: false
                scaleX: buttonscale
                scaleY: buttonscale
                animlist: [
                    [100, [0]]
                    [100, [1]]
                ]
                scene: _SYSTEMSCENE
            obj.visible = visible
            _VGAMEBUTTON.push(obj)

#**********************************************************************
# バーチャルゲームパッドの表示制御
#**********************************************************************
dispVirtualGamepad = (flag)->
    _VGAMEPADOBJ.visible = flag if (_VGAMEPADOBJ?)
    for obj in _VGAMEBUTTON
        obj.visible = flag

#**********************************************************************
#**********************************************************************
#**********************************************************************
# 以下は内部使用ライブラリ関数
#**********************************************************************
#**********************************************************************
#**********************************************************************

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
    if (_defaultbrowser)
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


