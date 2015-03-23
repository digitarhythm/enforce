#***********************************************************************
# enforce game engine(tmlib)
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
COLLIDER2D          = 8

# 物理スプライトの種類
DYNAMIC_BOX         = 0
DYNAMIC_CIRCLE      = 1
STATIC_BOX          = 2
STATIC_CIRCLE       = 3

# Easingの種類(kind)
LINEAR              = 0
SWING               = 1
BACK                = 2
BOUNCE              = 3
CIRCLE              = 4
CUBIC               = 5
ELASTIC             = 6
EXPO                = 7
QUAD                = 8
QUART               = 9
QUINT               = 10
SINE                = 11

# Easingの動き(move)
EASEINOUT           = 0
EASEIN              = 1
EASEOUT             = 2
NONE                = 3

# Easingの配列
EASINGVALUE         = []

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

# ワールドビュー
_WORLDVIEW          =
    sx: 0
    sy: 0
    ex: SCREEN_WIDTH
    ey: SCREEN_HEIGHT

# 数学式
RAD                 = (Math.PI / 180.0)
DEG                 = (180.0 / Math.PI)

# グローバル初期化
GLOBAL              = []

# ゲームパッド情報格納変数
HORIZONTAL          = 0
VERTICAL            = 1
_GAMEPADSINFO       = []
PADBUTTONS          = []
PADBUTTONS[0]       = [false, false]
PADAXES             = []
PADAXES[0]          = [0, 0]
ANALOGSTICK         = []
ANALOGSTICK[0]      = [[], []]
_VGAMEPADCONTROL    = undefined

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

# メディアデータ用配列
ASSETS              = []

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

# ゲーム起動時の処理
tm.main ->
    tm.define "customLoadingScene",
        superClass: "tm.app.Scene"
        init: (param) ->
            @superInit()
            @bg = tm.display.Shape().addChildTo(@)
            @bg.canvas.clearColor "#000000"
            @bg.setOrigin 0, 0
            label = tm.display.Label("loading")
            label.x = param.width / 2
            label.y = param.height / 2
            label.width = param.width
            label.align = "center"
            label.baseline = "middle"
            label.fontSize = 24
            label.setFillStyle "#ffffff"
            label.counter = 0
            label.update = (app) ->
                if app.frame % 30 is 0
                    @text += "."
                    @counter += 1
                    if @counter > 3
                        @counter = 0
                        @text = "loading"
                return
            label.addChildTo @bg



            label = tm.display.Label("powerd by tmlib.js")
            label.x = param.width / 2
            label.y = param.height - 20
            label.width = param.width
            label.align = "center"
            label.baseline = "middle"
            label.fontSize = 16
            label.setFillStyle "#ffffff"
            label.counter = 0
            label.addChildTo @bg



            @bg.tweener.clear().fadeIn(100).call (->
                if param.assets
                    loader = tm.asset.Loader()
                    loader.onload = (->
                        @bg.tweener.clear().wait(300).fadeOut(300).call (->
                            core.replaceScene param.nextScene()  if param.nextScene
                            e = tm.event.Event("load")
                            @fire e
                            return
                        ).bind(@)
                        return
                    ).bind(@)
                    loader.onprogress = ((e) ->
                        event = tm.event.Event("progress")
                        event.progress = e.progress
                        @fire event
                        return
                    ).bind(@)
                    loader.load param.assets
                return
            ).bind(@)
            return

    tm.define "mainScene",
        superClass: "tm.app.Scene"
        init: ->
            @superInit()
            core.background = BGCOLOR
            rootScene = @
            for i in [0..MAXSCENE]
                scene = tm.display.CanvasElement().addChildTo(rootScene)
                _scenes[i] = scene

            gravity = new Box2D.Common.Math.b2Vec2(GRAVITY_X, GRAVITY_Y)
            box2dworld = new Box2D.Dynamics.b2World(gravity, true)

            # Easing定義
            EASINGVALUE[LINEAR]  = ["linear"]
            EASINGVALUE[SWING]   = ["swing"]
            EASINGVALUE[BACK]    = ["easeInOutBack",    "easeInBack",   "easeOutBack"]
            EASINGVALUE[BOUNCE]  = ["easeInOutBounce",  "easeInBounce", "easeOutBounce"]
            EASINGVALUE[CIRCLE]  = ["easeInOutCirc",    "easeInCirc",   "easeOutCirc"]
            EASINGVALUE[CUBIC]   = ["easeInOutCubic",   "easeInCubic",  "easeOutCubic"]
            EASINGVALUE[ELASTIC] = ["easeInOutElastic", "easeInElastic","easeOutElastic"]
            EASINGVALUE[EXPO]    = ["easeInOutExpo",    "easeInExpo",   "easeOutExpo"]
            EASINGVALUE[QUAD]    = ["easeInOutQuad",    "easeInQuad",   "easeOutQuad"]
            EASINGVALUE[QUART]   = ["easeInOutQuart",   "easeInQuart",  "easeOutQuart"]
            EASINGVALUE[QUINT]   = ["easeInOutQuint",   "easeInQuint",  "easeOutQuint"]
            EASINGVALUE[SINE]    = ["easeInOutSine",    "easeInSine",   "easeOutSine"]

            if (DEBUG == true)
                _DEBUGLABEL = new tm.display.Label()
                _DEBUGLABEL.originX = 0
                _DEBUGLABEL.originY = 0
                _DEBUGLABEL.x = SCREEN_WIDTH / 2
                _DEBUGLABEL.y = SCREEN_HEIGHT / 2
                _DEBUGLABEL.align = "center"
                _scenes[DEBUGSCENE].addChild(_DEBUGLABEL)

            for i in [0...OBJECTNUM]
                _objects[i] = new _originObject()
            _main = new enforceMain()

            return

        onenterframe: ->
            if (typeof gamepadProcedure == 'function')
                _GAMEPADSINFO = gamepadProcedure()
                for num in [0..._GAMEPADSINFO.length]
                    if (!_GAMEPADSINFO[num]?)
                        continue
                    padobj = _GAMEPADSINFO[num]
                    PADBUTTONS[num] = _GAMEPADSINFO[num].padbuttons
                    PADAXES[num] = _GAMEPADSINFO[num].padaxes
                    ANALOGSTICK[num] = _GAMEPADSINFO[num].analogstick

                if (_VGAMEPADCONTROL? &&_VGAMEPADCONTROL.input.analog?)
                    vgpx1 = parseFloat(_VGAMEPADCONTROL.input.analog[HORIZONTAL])
                    vgpy1 = parseFloat(_VGAMEPADCONTROL.input.analog[VERTICAL])
                else
                    vgpx1 = 0
                    vgpy1 = 0
                if (_GAMEPADSINFO[0]?)
                    vgpx2 = _GAMEPADSINFO[0].analogstick[0][HORIZONTAL]
                    vgpy2 = _GAMEPADSINFO[0].analogstick[0][VERTICAL]
                else
                    vgpx2 = 0
                    vgpy2 = 0
            ANALOGSTICK[0][0][HORIZONTAL] = parseFloat(vgpx1 + vgpx2)
            ANALOGSTICK[0][0][VERTICAL]   = parseFloat(vgpy1 + vgpy2)

            key = core.keyboard
                
            if (key.getKey("space") || key.getKey("z") || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[0]? && _VGAMEPADCONTROL.input.buttons[0]))
                PADBUTTONS[0][0] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][0] = false

            if (key.getKey("x") || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[1]? && _VGAMEPADCONTROL.input.buttons[1]))
                PADBUTTONS[0][1] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][1] = false

            if (key.getKey("c") || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[2]? && _VGAMEPADCONTROL.input.buttons[2]))
                PADBUTTONS[0][2] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][2] = false

            if (key.getKey("v") || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[3]? && _VGAMEPADCONTROL.input.buttons[3]))
                PADBUTTONS[0][3] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][3] = false

            if (key.getKey("b") || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[4]? && _VGAMEPADCONTROL.input.buttons[4]))
                PADBUTTONS[0][4] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][4] = false

            if (key.getKey("n") || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[5]? && _VGAMEPADCONTROL.input.buttons[5]))
                PADBUTTONS[0][5] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][5] = false

            if (key.getKey("m") || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[6]? && _VGAMEPADCONTROL.input.buttons[6]))
                PADBUTTONS[0][6] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][6] = false

            if (key.getKey("comma") || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[7]? && _VGAMEPADCONTROL.input.buttons[7]))
                PADBUTTONS[0][7] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][7] = false

            if (key.getKey("left") || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.axes.left))
                PADAXES[0][HORIZONTAL] = -1.0
            else if (key.getKey("right") || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.axes.right))
                PADAXES[0][HORIZONTAL] = 1.0
            else if (!_GAMEPADSINFO[0]?)
                PADAXES[0][HORIZONTAL] = 0.0

            if (key.getKey("up") || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.axes.up))
                PADAXES[0][VERTICAL] = -1
            else if (key.getKey("down") || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.axes.down))
                PADAXES[0][VERTICAL] = 1
            else if (!_GAMEPADSINFO[0]?)
                PADAXES[0][VERTICAL] = 0

            if (GAMEPADMIX? && GAMEPADMIX)
                mx = (ANALOGSTICK[0][0][HORIZONTAL] + PADAXES[0][HORIZONTAL])
                mx = 1  if (mx > 1)
                mx = -1 if (mx < -1)
                my = (ANALOGSTICK[0][0][VERTICAL] + PADAXES[0][VERTICAL])
                my = 1  if (my > 1)
                my = -1 if (my < -1)
                ANALOGSTICK[0][0][HORIZONTAL] = mx
                ANALOGSTICK[0][0][VERTICAL] = my

            #debugwrite
            #    labeltext: sprintf("ax=%@, ay=%@, dx=%@, dy=%@, mx=%@, my=%@", ANALOGSTICK[0][0][HORIZONTAL], ANALOGSTICK[0][0][VERTICAL], PADAXES[0][HORIZONTAL], PADAXES[0][VERTICAL], mx, my)
            #    clear:true


            LAPSEDTIME = (parseFloat((new Date) / 1000) - parseFloat(BEGINNINGTIME).toFixed(2))
            for obj in _objects
                if (obj.active == true && obj.motionObj != undefined && typeof(obj.motionObj.behavior) == 'function')
                    obj.motionObj.behavior()
            for obj in _objects
                if (obj.active == true && obj.motionObj != undefined && typeof(obj.motionObj.behavior) == 'function')
                    wx = if (obj.motionObj.worldview? && obj.motionObj.worldview) then _WORLDVIEW.sx else 0
                    wy = if (obj.motionObj.worldview? && obj.motionObj.worldview) then _WORLDVIEW.sy else 0
                    switch (obj.motionObj._type)
                        when CONTROL
                            continue
                        when PRIMITIVE, COLLADA
                            obj.motionObj.sprite.x = Math.floor(obj.motionObj.x)
                            obj.motionObj.sprite.y = Math.floor(obj.motionObj.y)
                            obj.motionObj.sprite.z = Math.floor(obj.motionObj.z)
                        when SPRITE, LABEL, SURFACE, COLLIDER2D
                            rot = parseFloat(obj.motionObj.rotation)
                            rot += parseFloat(obj.motionObj.rotate)
                            if (rot > 359)
                                rot = rot % 360
                            obj.motionObj.rotation = rot
                            obj.motionObj.sprite.rotation = parseInt(rot)
                            # _reversePosFlagは、Timeline適用中はここの処理内では座標操作はせず、スプライトの座標をオブジェクトの座標に代入している
                            if (obj.motionObj._reversePosFlag)
                                obj.motionObj.x = obj.motionObj.sprite.x + wx
                                obj.motionObj.y = obj.motionObj.sprite.y + wy + obj.motionObj.z
                            else
                                obj.motionObj.sprite.x = Math.floor(obj.motionObj.x - wx)
                                obj.motionObj.sprite.y = Math.floor(obj.motionObj.y - wy - obj.motionObj.z)
                        when MAP, EXMAP
                            rot = obj.motionObj.sprite.rotation
                            rot += obj.motionObj.rotation
                            if (rot > 359)
                                rot = rot % 360
                            obj.motionObj.sprite.rotation = rot
                            obj.motionObj.sprite.x = Math.floor(obj.motionObj.x - wx - obj.motionObj._diffx)
                            obj.motionObj.sprite.y = Math.floor(obj.motionObj.y - wy - obj.motionObj._diffy)

    core = tm.app.CanvasApp("#stage")
    core.fps = FPS
    core.resize SCREEN_WIDTH, SCREEN_HEIGHT
    core.fitWindow()

    # メディアファイルのプリロード
    if (MEDIALIST?)
        MEDIALIST['_notice'] = 'lib/notice.png'
        MEDIALIST['_execbutton'] = 'lib/execbutton.png'
        MEDIALIST['_pad_w'] = 'lib/pad_w.png'
        MEDIALIST['_pad_b'] = 'lib/pad_b.png'
        MEDIALIST['_apad_w'] = 'lib/apad_w.png'
        MEDIALIST['_apad_b'] = 'lib/apad_b.png'
        MEDIALIST['_apad2_w'] = 'lib/apad2_w.png'
        MEDIALIST['_apad2_b'] = 'lib/apad2_b.png'
        MEDIALIST['_button_w'] = 'lib/button_w.png'
        MEDIALIST['_button_b'] = 'lib/button_b.png'

    core.replaceScene customLoadingScene(
        assets: MEDIALIST
        nextScene: mainScene
        width: SCREEN_WIDTH
        height: SCREEN_HEIGHT
    )
    core.run()

    # モーションセンサーのイベント登録
    window.addEventListener 'devicemotion', (e)=>
        MOTION_ACCEL = e.acceleration
        MOTION_GRAVITY = e.accelerationIncludingGravity
    window.addEventListener 'deviceorientation', (e)=>
        MOTION_ROTATE.alpha = e.alpha
        MOTION_ROTATE.beta = e.beta
        MOTION_ROTATE.gamma = e.gamma

debugwrite = (param)->
    if (DEBUG == true)
        if (param.clear)
            labeltext = if (param.labeltext?) then param.labeltext else ""
        else
            labeltext = _DEBUGLABEL.text += if (param.labeltext?) then param.labeltext else ""
        fontsize = if (param.fontsize?) then param.fontsize else 12
        fontcolor = if (param.fontcolor?) then param.fontcolor else "red"
        _DEBUGLABEL.fontSize = fontsize
        _DEBUGLABEL.text = labeltext
        _DEBUGLABEL.fillStyle = fontcolor
debugclear =->
    if (DEBUG == true)
        _DEBUGLABEL.text = ""

#******************************************************************************
# 2D/3D共用オブジェクト生成メソッド
#******************************************************************************
addObject = (param, parent = undefined)->
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
    model = if (param['model']?) then param['model'] else undefined
    width = if (param['width']?) then param['width'] else 100.0
    height = if (param['height']?) then param['height'] else 100.0
    depth = if (param['depth']?) then param['depth'] else 100.0
    opacity = if (param['opacity']?) then param['opacity'] else 1.0
    animlist = if (param['animlist']?) then param['animlist'] else undefined
    animnum = if (param['animnum']?) then param['animnum'] else 0
    visible = if (param['visible']?) then param['visible'] else true
    scene = if (param['scene']?) then param['scene'] else -1
    rigid = if (param['rigid']?) then param['rigid'] else false
    model = if (param['model']?) then param['model'] else undefined
    density = if (param['density']?) then param['density'] else 1.0
    friction = if (param['friction']?) then param['friction'] else 0.5
    restitution = if (param['restitution']?) then param['restitution'] else 0.1
    radius = if (param['radius']?) then param['radius'] else 100.0
    radius2 = if (param['radius2']?) then param['radius2'] else 100.0
    size = if (param['size']?) then param['size'] else 100.0
    scaleX = if (param['scaleX']?) then param['scaleX'] else 1.0
    scaleY = if (param['scaleY']?) then param['scaleY'] else 1.0
    scaleZ = if (param['scaleZ']?) then param['scaleZ'] else 1.0
    rotation = if (param['rotation']?) then param['rotation'] else 0.0 # 現在の角度
    rotate = if (param['rotate']?) then param['rotate'] else 0.0 # 角度に追加される値
    texture = if (param['texture']?) then param['texture'] else undefined
    fontsize = if (param['fontsize']?) then param['fontsize'] else '16px'
    color = if (param['color']?) then param['color'] else 'white'
    labeltext = if (param['labeltext']?) then param['labeltext'].replace(/<br>/ig, "\n") else 'text'
    textalign = if (param['textalign']?) then param['textalign'] else 'left'
    active = if (param['active']?) then param['active'] else true
    kind = if (param['kind']?) then param['kind'] else DYNAMIC_BOX
    collider = if (param['collider']?) then param['collider'] else undefined
    offsetx = if (param['offsetx']?) then param['offsetx'] else 0
    offsety = if (param['offsety']?) then param['offsety'] else 0
    bgcolor = if (param['bgcolor']?) then param['bgcolor'] else 'transparent'
    map = if (param['map']?) then param['map'] else undefined
    mapcollision = if (param['mapcollision']?) then param['mapcollision'] else undefined
    worldview = if (param['worldview']?) then param['worldview'] else false
    touchEnabled = if (param['touchEnabled']?) then param['touchEnabled'] else true

    if (motionObj == null)
        motionObj = undefined

    retObject = undefined

    # スプライトを生成
    switch (_type)
        when CONTROL, SPRITE, COLLIDER2D
            if (_type == COLLIDER2D)
                scene = GAMESCENE_SUB2
            if (scene < 0)
                scene = GAMESCENE_SUB1

            if (rigid)
                if (!radius?)
                    radius = width

            if (image?)
                if (!motionsprite?)
                    motionsprite = tm.display.Sprite(image, width, height)
                    motionsprite.backgroundColor = "transparent"
                    motionsprite.setOrigin(0.5, 0.5)
                    motionsprite.x = Math.floor(x)
                    motionsprite.y = Math.floor(y) - Math.floor(z)
                    motionsprite.alpha = if (_type == COLLIDER2D) then 0.8 else opacity
                    motionsprite.rotation = rotation
                    motionsprite.rotate = rotate
                    motionsprite.scaleX = scaleX
                    motionsprite.scaleY = scaleY
                    motionsprite.visible = visible
                    motionsprite.width = width
                    motionsprite.height = height
                    motionsprite.boundingType = "rect"
            else
                motionsprite = tm.display.Sprite()

            if (animlist?)
                animtmp = animlist[animnum]
                motionsprite.frameIndex = animtmp[1][0]

            # スプライトを表示
            motionsprite.addChildTo(_scenes[scene])

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
                rotate: rotate
                parent: parent
                active: active
                collider: collider
                offsetx: offsetx
                offsety: offsety
                worldview: worldview
                touchEnabled: touchEnabled
            return retObject

        when LABEL
            if (scene < 0)
                scene = GAMESCENE_SUB1
            if (width == 0)
                width = 120
            if (height == 0)
                height = 64
            # ラベルを生成
            motionsprite = tm.display.Label(labeltext)
            # 値を代入
            motionsprite.setOrigin(0.5, 0.5)
            motionsprite.setPosition(x, y)
            motionsprite.x = Math.floor(x)
            motionsprite.y = Math.floor(y) - Math.floor(z)
            motionsprite.alpha = opacity
            motionsprite.rotation = rotation
            motionsprite.rotate = rotate
            motionsprite.scaleX = scaleX
            motionsprite.scaleY = scaleY
            motionsprite.visible = visible
            motionsprite.width = width
            motionsprite.height = height
            motionsprite.fillStyle = color
            motionsprite.text = labeltext
            motionsprite.fontSize = fontsize
            motionsprite.align = textalign
            motionsprite.fontFamily = 'Arial'
            motionsprite.setBaseline("middle")
            # スプライトを表示
            motionsprite.addChildTo(_scenes[scene])
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
                image: image
                _type: _type
                motionsprite: motionsprite
                motionObj: motionObj
                fontsize: fontsize
                color: color
                labeltext: labeltext
                textalign: textalign
                parent: parent
                active: active
                collider: collider
                offsetx: offsetx
                offsety: offsety
                worldview: worldview
                touchEnabled: touchEnabled
            return retObject

        when PRIMITIVE
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
                opacity: opacity
                scene: WEBGLSCENE
                _type: _type
                motionsprite: motionsprite
                motionObj: motionObj
                parent: parent
                worldview: worldview
                touchEnabled: touchEnabled

            if (visible)
                rootScene3d.addChild(motionsprite)

            return retObject

        when COLLADA
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
                worldview: worldview
                touchEnabled: touchEnabled
            return retObject

        #*****************************************************************
        # Mapオブジェクト
        #*****************************************************************
        when MAP
            if (!map? || image == "")
                JSLog("parameter not enough.")
            else
                if (scene < 0)
                    scene = BGSCENE_SUB1

                img = MEDIALIST[image]
                mapdata = []
                wlength = map[0].length
                hlength = map.length
                for t in map
                    for t2 in t
                        mapdata.push(t2)
                mapsheet = tm.asset.MapSheet
                    tilewidth: width
                    tileheight: height
                    width: wlength
                    height: hlength
                    tilesets: [
                        {
                            image: img
                        }
                    ]
                    layers: [
                        {
                            data: mapdata
                        }
                    ]
                motionsprite = tm.display.MapSprite(mapsheet, width, height)
                _scenes[scene].addChild(motionsprite)
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
                image: image
                _type: _type
                motionsprite: motionsprite
                motionObj: motionObj
                parent: parent
                worldview: worldview
                touchEnabled: touchEnabled
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
    initparam['radius'] = if (param['radius']?) then param['radius'] else 1.0
    initparam['radius2'] = if (param['radius2']?) then param['radius2'] else 1.0
    initparam['size'] = if (param['size']?) then param['size'] else 1.0
    initparam['gravity'] = if (param['gravity']?) then param['gravity'] else 0
    initparam['intersectFlag'] = if (param['intersectFlag']?) then param['intersectFlag'] else true
    initparam['width'] = if (param['width']?) then param['width'] else 0
    initparam['height'] = if (param['height']?) then param['height'] else 0
    initparam['animlist'] = if (param['animlist']?) then param['animlist'] else undefined
    initparam['animnum'] = if (param['animnum']?) then param['animnum'] else 0
    initparam['visible'] = if (param['visible']?) then param['visible'] else true
    initparam['opacity'] = if (param['opacity']?) then param['opacity'] else 0
    initparam['rotation'] = if (param['rotation']?) then param['rotation'] else 0.0
    initparam['rotate'] = if (param['rotate']?) then param['rotate'] else 0.0
    initparam['motionsprite'] = if (param['motionsprite']?) then param['motionsprite'] else 0
    initparam['fontsize'] = if (param['fontsize']?) then param['fontsize'] else '16px'
    initparam['color'] = if (param['color']?) then param['color'] else 'white'
    initparam['labeltext'] = if (param['labeltext']?) then param['labeltext'] else 'text'
    initparam['textalign'] = if (param['textalign']?) then param['textalign'] else 'left'
    initparam['parent'] = if (param['parent']?) then param['parent'] else undefined
    initparam['active'] = if (param['active']?) then param['active'] else true
    initparam['collider'] = if (param['collider']?) then param['collider'] else undefined
    initparam['offsetx'] = if (param['offsetx']?) then param['offsetx'] else 0
    initparam['offsety'] = if (param['offsety']?) then param['offsety'] else 0
    initparam['worldview'] = if (param['worldview']?) then param['worldview'] else false
    initparam['touchEnabled'] = if (param['touchEnabled']?) then param['touchEnabled'] else false

    scene = if (param['scene']?) then param['scene'] else GAMESCENE
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
        nop()
    else
        switch (motionObj._type)
            when CONTROL, SPRITE, LABEL, PRIMITIVE, COLLADA, MAP, EXMAP, COLLIDER2D
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
    org = tm.asset.Manager.get(name)
    sound = org.clone()
    if (sound.loop?)
        sound.volume = vol
        sound.play()
        sound.loop = flag
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
# ワールドビューの設定
#**********************************************************************
setWorldView = (sx, sy, ex = undefined, ey = undefined)->
    if (!ex?)
        ex = sx + SCREEN_WIDTH
    if (!ey?)
        ey = sy + SCREEN_HEIGHT
    _WORLDVIEW =
        sx: sx
        sy: sy
        ex: ex
        ey: ey

#**********************************************************************
# バーチャルゲームパッド
#**********************************************************************
createVirtualGamepad = (param)->
    if (param?)
        scale       = if (param.scale?)         then param.scale        else 1
        x           = if (param.x?)             then param.x            else (100 / 2) * scale
        y           = if (param.y?)             then param.y            else SCREEN_HEIGHT - ((100 / 2) * scale)
        visible     = if (param.visible?)       then param.visible      else true
        kind        = if (param.kind?)          then param.kind         else 0
        analog      = if (param.analog?)        then param.analog       else false

        button      = if (param.button?)        then param.button       else 0
        image       = if (param.image?)         then param.image        else undefined
        buttonscale = if (param.buttonscale?)   then param.buttonscale  else 1
        coord       = if (param.coord?)         then param.coord        else []
    else
        param = []
        scale       = param.scale       = 1.0
        x           = param.x           = (100 / 2) * scale
        y           = param.y           = SCREEN_HEIGHT - ((100 / 2) * scale)
        visible     = param.visible     = true
        kind        = param.kind        = 0
        analog      = param.analog      = false

        button      = param.button      = 0
        image       = param.image       = undefined
        buttonscale = param.buttonscale = 1
        coord       = param.coord       = []

    if (button > 6)
        button = param.button = 6

    if (!_VGAMEPADCONTROL?)
        _VGAMEPADCONTROL = addObject
            x: x
            y: y
            type: CONTROL
            motionObj: _vgamepadcontrol
        _VGAMEPADCONTROL.createGamePad(param)

#**********************************************************************
# バーチャルゲームパッドの表示制御
#**********************************************************************
dispVirtualGamepad = (flag)->
    _VGAMEPADCONTROL.setVisible(flag) if (_VGAMEPADCONTROL?)

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


