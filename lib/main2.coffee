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

            if (DEBUG == true)
                _DEBUGLABEL = new tm.display.Label()
                _DEBUGLABEL.originX = 0
                _DEBUGLABEL.originY = 0
                _DEBUGLABEL.x = 0
                _DEBUGLABEL.y = 16
                _scenes[DEBUGSCENE].addChild(_DEBUGLABEL)

            for i in [0...OBJECTNUM]
                _objects[i] = new _originObject()
            _main = new enforceMain()

            return

        onenterframe: ->
            box2dworld.Step(1/FPS, 1, 1)
            if (typeof gamepadProcedure == 'function')
                _GAMEPADSINFO = gamepadProcedure()
                for num in [0..._GAMEPADSINFO.length]
                    if (!_GAMEPADSINFO[num]?)
                        continue
                    padobj = _GAMEPADSINFO[num]
                    PADBUTTONS[num] = _GAMEPADSINFO[num].padbuttons
                    PADAXES[num] = _GAMEPADSINFO[num].padaxes
                    ANALOGSTICK[num] = _GAMEPADSINFO[num].analogstick

            key = core.keyboard
                
            if (key.getKey("z") || (_VGAMEBUTTON[0]? && _VGAMEBUTTON[0].push))
                PADBUTTONS[0][0] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][0] = false

            if (key.getKey("x") || (_VGAMEBUTTON[1]? && _VGAMEBUTTON[1].push))
                PADBUTTONS[0][1] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][1] = false

            if (key.getKey("c") || (_VGAMEBUTTON[2]? && _VGAMEBUTTON[2].push))
                PADBUTTONS[0][2] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][2] = false

            if (key.getKey("v") || (_VGAMEBUTTON[3]? && _VGAMEBUTTON[3].push))
                PADBUTTONS[0][3] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][3] = false

            if (key.getKey("b") || (_VGAMEBUTTON[4]? && _VGAMEBUTTON[4].push))
                PADBUTTONS[0][4] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][4] = false

            if (key.getKey("n") || (_VGAMEBUTTON[5]? && _VGAMEBUTTON[5].push))
                PADBUTTONS[0][5] = true
            else if (!_GAMEPADSINFO[0]?)
                PADBUTTONS[0][5] = false

            if (key.getKey("left") || (_VGAMEPADOBJ? && _VGAMEPADOBJ.input.left))
                PADAXES[0][HORIZONTAL] = -1
            else if (key.getKey("right") || (_VGAMEPADOBJ? && _VGAMEPADOBJ.input.right))
                PADAXES[0][HORIZONTAL] = 1
            else if (!_GAMEPADSINFO[0]?)
                PADAXES[0][HORIZONTAL] = 0

            if (key.getKey("up") || (_VGAMEPADOBJ? && _VGAMEPADOBJ.input.up))
                PADAXES[0][VERTICAL] = -1
            else if (key.getKey("down") || (_VGAMEPADOBJ? && _VGAMEPADOBJ.input.down))
                PADAXES[0][VERTICAL] = 1
            else if (!_GAMEPADSINFO[0]?)
                PADAXES[0][VERTICAL] = 0

            LAPSEDTIME = (parseFloat((new Date) / 1000) - parseFloat(BEGINNINGTIME).toFixed(2))
            for obj in _objects
                if (obj.active == true && obj.motionObj != undefined && typeof(obj.motionObj.behavior) == 'function')
                    obj.motionObj.behavior()

    core = tm.display.CanvasApp("#stage")
    core.fps = FPS
    core.resize SCREEN_WIDTH, SCREEN_HEIGHT
    core.fitWindow()
    MEDIALIST['_notice'] = 'lib/notice.png'
    MEDIALIST['_execbutton'] = 'lib/execbutton.png'
    MEDIALIST['_pad'] = 'lib/pad.png'
    MEDIALIST['_button'] = 'lib/button.png'
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
        _DEBUGLABEL.fontColor = fontcolor
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
    rotation = if (param['rotation']?) then param['rotation'] else 0.0
    texture = if (param['texture']?) then param['texture'] else undefined
    fontsize = if (param['fontsize']?) then param['fontsize'] else '16px'
    color = if (param['color']?) then param['color'] else 'white'
    labeltext = if (param['labeltext']?) then param['labeltext'] else 'text'
    textalign = if (param['textalign']?) then param['textalign'] else 'left'
    active = if (param['active']?) then param['active'] else true
    kind = if (param['kind']?) then param['kind'] else DYNAMIC_BOX
    collider = if (param['collider']?) then param['collider'] else undefined
    offsetx = if (param['offsetx']?) then param['offsetx'] else 0
    offsety = if (param['offsety']?) then param['offsety'] else 0
    map = if (param['map']?) then param['map'] else undefined
    mapcollision = if (param['mapcollision']?) then param['mapcollision'] else undefined

    if (motionObj == null)
        motionObj = undefined

    retObject = undefined

    # スプライトを生成
    switch (_type)
        when CONTROL, SPRITE
            # 画像割り当て
            if (scene < 0)
                scene = GAMESCENE_SUB1

            if (animlist?)
                if (rigid)
                    if (!radius?)
                        radius = width

                    b2bodydef = new Box2D.Dynamics.b2BodyDef()
                    b2bodydef.position.Set(x, y)

                    switch (kind)
                        when DYNAMIC_BOX
                            b2bodydef.type = Box2D.Dynamics.b2_dynamicBody
                            b2box = new Box2D.Collision.Shapes.b2PolygonShape()
                        when DYNAMIC_CIRCLE
                            b2bodydef.type = Box2D.Dynamics.b2_dynamicBody
                            b2box = new Box2D.Collision.Shapes.b2CircleShape()
                        when STATIC_BOX
                            b2bodydef.type = Box2D.Dynamics.b2_staticBody
                            b2box = new Box2D.Collision.Shapes.b2PolygonShape()
                        when STATIC_CIRCLE
                            b2bodydef.type = Box2D.Dynamics.b2_staticBody
                            b2box = new Box2D.Collision.Shapes.b2CircleShape()

                    b2body = box2dworld.CreateBody(b2bodydef)
                    b2box.SetAsBox(width, height)

                    b2fixture = new Box2D.Dynamics.b2FixtureDef()
                    b2fixture.shape = b2box
                    b2fixture.density = density
                    b2fixture.friction = friction
                    b2fixture.restitution = restitution
                    b2body.CreateFixture(b2fixture)

                motionsprite = tm.display.Sprite(image, width, height)
                animtmp = animlist[animnum]
                motionsprite.frameIndex = animtmp[1][0]

                motionsprite.backgroundColor = "transparent"
                motionsprite.setOrigin(0.5, 0.5)
                motionsprite.x = Math.floor(x)
                motionsprite.y = Math.floor(y) - Math.floor(z)
                motionsprite.alpha = opacity
                motionsprite.rotation = rotation
                motionsprite.scaleX = scaleX
                motionsprite.scaleY = scaleY
                motionsprite.visible = visible
                motionsprite.width = width
                motionsprite.height = height
                motionsprite.boundingType = "rect"
            else
                motionsprite = tm.display.Sprite()
                motionsprite.visible = true

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
                parent: parent
                active: active
                collider: collider
                offsetx: offsetx
                offsety: offsety
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
            motionsprite.backgroundColor = "transparent"
            motionsprite.setOrigin(0.5, 0.5)
            motionsprite.setPosition(x, y)
            motionsprite.x = Math.floor(x)
            motionsprite.y = Math.floor(y) - Math.floor(z)
            motionsprite.alpha = opacity
            motionsprite.rotation = rotation
            motionsprite.scaleX = scaleX
            motionsprite.scaleY = scaleY
            motionsprite.visible = visible
            motionsprite.width = width
            motionsprite.height = height
            motionsprite.color = color
            motionsprite.text = labeltext
            motionsprite.fontSize = fontsize
            motionsprite.fontFamily = 'Arial'
            motionsprite.setAlign(textalign)
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
    initparam['animlist'] = if (param['animlist']?) then param['animlist'] else 0
    initparam['animnum'] = if (param['animnum']?) then param['animnum'] else 0
    initparam['visible'] = if (param['visible']?) then param['visible'] else true
    initparam['opacity'] = if (param['opacity']?) then param['opacity'] else 0
    initparam['rotation'] = if (param['rotation']?) then param['rotation'] else 0.0
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

    if (typeof(motionObj.destructor) == 'function')
        motionObj.destructor()

    if (motionObj._type == LABEL || motionObj._type == SPRITE || motionObj._type == PRIMITIVE || motionObj._type == COLLADA)
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
    else
        scale = 1.0
        x = (100 / 2) * scale
        y = SCREEN_HEIGHT - ((100 / 2) * scale)
        button = 2
        buttonscale = 1
        coord = []

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

        for i in [0...button]
            c = coord[i]
            if (!c?)
                c = []
                c[0] = SCREEN_WIDTH - ((64 / 2) * buttonscale)
                c[1] = (64 * buttonscale) * (i + 1)
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
            _VGAMEBUTTON.push(obj)

#**********************************************************************
# バーチャルゲームパッドの表示制御
#**********************************************************************
dispVirtualGamepad = (flag)->
    _VGAMEPADOBJ.visible = flag
    for obj in _VGAMEBUTTON
        obj.visible = flag

#**********************************************************************
#**********************************************************************
#**********************************************************************
# 以下は内部使用ライブラリ関数
#**********************************************************************
#**********************************************************************
#**********************************************************************

gamepaddisconnected =(e)->

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


