#******************************************************************************
# enforce game engine(enchant)
#
# 2014.04.04 ver2.0
#
# Coded by Kow Sakazaki
#******************************************************************************

#******************************************************************************
# 初期化処理
#******************************************************************************

# 定数定義

# 色定義
WHITE         = 0
BLACK         = 1

# オブジェクトの種類
CONTROL       = 0
SPRITE        = 1
LABEL         = 2
SURFACE       = 3
PRIMITIVE       = 4
COLLADA       = 5
MAP         = 6
EXMAP         = 7
COLLIDER2D      = 8

# 物理スプライトの種類
DYNAMIC_BOX     = 0
DYNAMIC_CIRCLE    = 1
STATIC_BOX      = 2
STATIC_CIRCLE     = 3

# Easingの種類(kind)
LINEAR        = 0
SWING         = 1
BACK        = 2
BOUNCE        = 3
CIRCLE        = 4
CUBIC         = 5
ELASTIC       = 6
EXPO        = 7
QUAD        = 8
QUART         = 9
QUINT         = 10
SINE        = 11

# Easingの動き(move)
EASEINOUT       = 0
EASEIN        = 1
EASEOUT       = 2
NONE        = 3

# Easingの配列
EASINGVALUE     = []

# WebGLのプリミティブの種類
BOX         = 0
CUBE        = 1
SPHERE        = 2
CYLINDER      = 3
TORUS         = 4
PLANE         = 5

# Sceneの種類
BGSCENE       = 0
BGSCENE_SUB1    = 1
BGSCENE_SUB2    = 2
GAMESCENE       = 3
GAMESCENE_SUB1    = 4
GAMESCENE_SUB2    = 5
TOPSCENE      = 6
WEBGLSCENE      = 7
_SYSTEMSCENE    = 8
DEBUGSCENE      = 9
MAXSCENE      = (if (DEBUG) then DEBUGSCENE else _SYSTEMSCENE)

# ワールドビュー
_WORLDVIEW =
  centerx: SCREEN_WIDTH / 2
  centery: SCREEN_HEIGHT / 2

# 数学式
RAD         = (Math.PI / 180.0)
DEG         = (180.0 / Math.PI)

# グローバル初期化
GLOBAL        = []

# サウンドプリロード用
SOUNDARR      = []

# アスペクト比
ASPECT        = 0.0

# ゲームパッド情報格納変数
HORIZONTAL      = 0
VERTICAL      = 1
_GAMEPADSINFO     = []
PADBUTTONS      = []
PADBUTTONS[0]     = [false, false]
PADAXES       = []
PADAXES[0]      = [0, 0]
PADINFO       = []
ANALOGSTICK     = []
ANALOGSTICK[0]    = [[0, 0], [0, 0]]
_VGAMEPADCONTROL  = undefined

# Frame Per Seconds
if (!FPS?)
  FPS = 60

# box2dの重力値
if (!GRAVITY_X?)
  GRAVITY_X = 0.0
if (!GRAVITY_Y?)
  GRAVITY_Y = 0.0

# センサー系
MOTION_ACCEL    = [x:0, y:0, z:0]
MOTION_GRAVITY    = [x:0, y:0, z:0]
MOTION_ROTATE     = [alpha:0, beta:0, gamma:0]

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
LAPSEDTIME      = 0.0
# ゲーム起動時のUNIXTIME
BEGINNINGTIME     = undefined
# フレームレート調整用
__FRAMETIME     = 0.0

# 3D系
OCULUS        = undefined
RENDERER      = undefined
CAMERA        = undefined
LIGHT         = undefined

# デバイスサイズ
_frame = getBounds()
DEVICE_WIDTH = _frame[0]
DEVICE_HEIGHT = _frame[1]
if (!SCREEN_WIDTH? && !SCREEN_HEIGHT?)
  SCREEN_WIDTH = DEVICE_WIDTH
  SCREEN_HEIGHT = DEVICE_HEIGHT

# 動作状況
ACTIVATE      = true

# オブジェクトが入っている配列
_objects      = []

# Scene格納用配列
_scenes       = []

# 起動時に生成されるスタートオブジェクト
_main         = null

# デバッグ用LABEL
_DEBUGLABEL     = undefined
_FPSGAUGE       = undefined
__fpsgaugeunit    = 0
__fpscounter    = 0.0
__limittimefps    = 0.0

# enchantのcoreオブジェクト
core        = undefined

# box2dのworldオブジェクト
box2dworld      = undefined

# 3Dのscene
rootScene3d     = undefined

# enchantのrootScene
rootScene       = undefined

# アニメーション管理
__requestID = ( ->
  return window.requestAnimationFrame ||
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame ||
  window.oRequestAnimationFrame ||
  window.msRequestAnimationFrame ||
  (callback)->
    window.setTimeout(callback, 1000 / 60)
)()

#******************************************************************************
# 起動時の処理
#******************************************************************************

# enchantのオマジナイ
enchant()
enchant.ENV.MOUSE_ENABLED = false
enchant.ENV.SOUND_ENABLED_ON_MOBILE_SAFARI = false

# ゲーム起動時の処理
#window.addEventListener 'load', (e)->
window.onload = ->

  window.removeEventListener('load', arguments.callee, false)

  # ゲーム起動時間
  BEGINNINGTIME = __getTime()
  # アスペクト比
  ASPECT = (SCREEN_WIDTH / SCREEN_HEIGHT).toFixed(2)
  # enchant初期化
  core = new Core(SCREEN_WIDTH, SCREEN_HEIGHT)
  # FPS設定
  core.fps = FPS

  # Easing定義
  EASINGVALUE[LINEAR] = [enchant.Easing.LINEAR]
  EASINGVALUE[SWING]  = [enchant.Easing.SWING]
  EASINGVALUE[BACK]  = [enchant.Easing.BACK_EASEINOUT,  enchant.Easing.BACK_EASEIN,  enchant.Easing.BACK_EASEOUT]
  EASINGVALUE[BOUNCE] = [enchant.Easing.BOUNCE_EASEINOUT, enchant.Easing.BOUNCE_EASEIN, enchant.Easing.BOUNCE_EASEOUT]
  EASINGVALUE[CIRCLE] = [enchant.Easing.CIRCLE_EASEINOUT, enchant.Easing.CIRCLE_EASEIN, enchant.Easing.CIRCLE_EASEOUT]
  EASINGVALUE[CUBIC]  = [enchant.Easing.CUBIC_EASEINOUT,  enchant.Easing.CUBIC_EASEIN,  enchant.Easing.CUBIC_EASEOUT]
  EASINGVALUE[ELASTIC] = [enchant.Easing.ELASTIC_EASEINOUT, enchant.Easing.ELASTIC_EASEIN, enchant.Easing.ELASTIC_EASEOUT]
  EASINGVALUE[EXPO]  = [enchant.Easing.EXPO_EASEINOUT,  enchant.Easing.EXPO_EASEIN,  enchant.Easing.EXPO_EASEOUT]
  EASINGVALUE[QUAD]  = [enchant.Easing.QUAD_EASEINOUT,  enchant.Easing.QUAD_EASEIN,  enchant.Easing.QUAD_EASEOUT]
  EASINGVALUE[QUART]  = [enchant.Easing.QUART_EASEINOUT,  enchant.Easing.QUART_EASEIN,  enchant.Easing.QUART_EASEOUT]
  EASINGVALUE[QUINT]  = [enchant.Easing.QUINT_EASEINOUT,  enchant.Easing.QUINT_EASEIN,  enchant.Easing.QUINT_EASEOUT]
  EASINGVALUE[SINE]  = [enchant.Easing.SINE_EASEINOUT,  enchant.Easing.SINE_EASEIN,  enchant.Easing.SINE_EASEOUT]

  # ボタンの定義
  core.keybind( 90, 'a' )
  core.keybind( 88, 'b' )
  core.keybind( 67, 'c' )
  core.keybind( 86, 'd' )
  core.keybind( 66, 'e' )
  core.keybind( 78, 'f' )
  core.keybind( 77, 'g' )
  core.keybind( 188, 'h' )
  core.keybind( 32, 'space' )

  # メディアファイルのプリロード
  if (MEDIALIST?)
    MEDIALIST['_ascii_w'] = 'lib/ascii_w.png'
    MEDIALIST['_ascii_b'] = 'lib/ascii_b.png'
    MEDIALIST['_fpsgauge'] = 'lib/fpsgauge.png'
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
    mediaarr = []
    num = 0
    for obj of MEDIALIST
      mediaarr[num++] = MEDIALIST[obj]
    core.preload(mediaarr)

  # rootSceneをグローバルに保存
  rootScene = core.rootScene

  # モーションセンサーのイベント登録
  window.addEventListener 'devicemotion', (e)->
    MOTION_ACCEL = e.acceleration
    MOTION_GRAVITY = e.accelerationIncludingGravity
  window.addEventListener 'deviceorientation', (e)->
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

  if (WEBGL != undefined && WEBGL && isWebGL())
    # 3Dシーンを生成
    rootScene3d = new Scene3D()
    _scenes[WEBGLSCENE] = rootScene3d

    # スポットライト生成
    #DLIGHT = new DirectionalLight()
    #DLIGHT.color = [1.0, 1.0, 1.0]
    #dlight.directionX = 0
    #dlight.directionY = 100
    #dlight.directionZ = 0
    rootScene3d.setDirectionalLight(DLIGHT)

    # 環境光ライト生成
    #ALIGHT = new AmbientLight()
    #ALIGHT.color = [1.0, 1.0, 1.0]
    #alight.directionX = 0
    #alight.directionY = 100
    rootScene3d.setAmbientLight(ALIGHT)

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

  #if (DEBUG == true)
  #  core.debug()
  #else
  #  core.start()
  core.start()

#******************************************************************************
# 起動時の処理
#******************************************************************************
  core.onload = ->
    # ゲーム用オブジェクトを指定された数だけ確保
    for i in [0...OBJECTNUM]
      _objects[i] = new _originObject()
    _main = new enforceMain()

    if (DEBUG)
      _DEBUGLABEL = new Label()
      _DEBUGLABEL.x = 0
      _DEBUGLABEL.y = 0
      _DEBUGLABEL.width = SCREEN_WIDTH
      _DEBUGLABEL.color = "white"
      _DEBUGLABEL.font = "32px 'Arial'"
      _scenes[DEBUGSCENE].addChild(_DEBUGLABEL)
      _FPSGAUGE = new Sprite()
      _FPSGAUGE.x = SCREEN_WIDTH - 16
      _FPSGAUGE.y = 0
      _FPSGAUGE.width = 16
      _FPSGAUGE.height = 1
      _FPSGAUGE.scaleY = 1.0
      _FPSGAUGE.opacity = 0.5
      _FPSGAUGE.image = core.assets[MEDIALIST['_fpsgauge']]
      _FPSGAUGE.frame = 0
      _scenes[DEBUGSCENE].addChild(_FPSGAUGE)
      __fpscounter = 0
      __limittimefps = 0.0

    # フレーム処理（enchant任せ）
    rootScene.addEventListener 'enterframe', (e)->

      # 経過時間を計算
      LAPSEDTIME = parseFloat((__getTime() - parseFloat(BEGINNINGTIME.toFixed(2))) / 1000.0)

      # FPS表示（デバッグモード時のみ）
      if (DEBUG)
        __fpscounter++
        if (__limittimefps < parseFloat(LAPSEDTIME))
          __limittimefps = LAPSEDTIME + 1.0
          scale = parseFloat(((__fpscounter / FPS) * SCREEN_HEIGHT).toFixed(2))
          _FPSGAUGE.height = scale
          __fpscounter = 0

      # ジョイパッド処理
      if (typeof gamepadProcedure == 'function')
        _GAMEPADSINFO = gamepadProcedure()
        for num in [0..._GAMEPADSINFO.length]
          if (!_GAMEPADSINFO[num]?)
            continue
          padobj = _GAMEPADSINFO[num]
          PADBUTTONS[num] = padobj.padbuttons
          PADAXES[num] = padobj.padaxes
          ANALOGSTICK[num] = padobj.analogstick
          PADINFO[num] = []
          PADINFO[num].id = padobj.id
        if (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.analog?)
          vgpx1 = parseFloat(_VGAMEPADCONTROL.input.analog[HORIZONTAL])
          vgpy1 = parseFloat(_VGAMEPADCONTROL.input.analog[VERTICAL])
        else
          vgpx1 = 0
          vgpy1 = 0
        if (_GAMEPADSINFO? && _GAMEPADSINFO[0]?)
          vgpx2 = _GAMEPADSINFO[0].analogstick[0][HORIZONTAL]
          vgpy2 = _GAMEPADSINFO[0].analogstick[0][VERTICAL]
        else
          vgpx2 = 0
          vgpy2 = 0
      ANALOGSTICK[0][0][HORIZONTAL] = parseFloat(vgpx1 + vgpx2)
      ANALOGSTICK[0][0][VERTICAL] = parseFloat(vgpy1 + vgpy2)

      if (core.input.a || core.input.space || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[0]? && _VGAMEPADCONTROL.input.buttons[0]))
        PADBUTTONS[0][0] = true
      else if (!_GAMEPADSINFO[0]?)
        PADBUTTONS[0][0] = false

      if (core.input.b || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[1]? && _VGAMEPADCONTROL.input.buttons[1]))
        PADBUTTONS[0][1] = true
      else if (!_GAMEPADSINFO[0]?)
        PADBUTTONS[0][1] = false

      if (core.input.c || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[2]? && _VGAMEPADCONTROL.input.buttons[2]))
        PADBUTTONS[0][2] = true
      else if (!_GAMEPADSINFO[0]?)
        PADBUTTONS[0][2] = false

      if (core.input.d || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[3]? && _VGAMEPADCONTROL.input.buttons[3]))
        PADBUTTONS[0][3] = true
      else if (!_GAMEPADSINFO[0]?)
        PADBUTTONS[0][3] = false

      if (core.input.e || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[4]? && _VGAMEPADCONTROL.input.buttons[4]))
        PADBUTTONS[0][4] = true
      else if (!_GAMEPADSINFO[0]?)
        PADBUTTONS[0][4] = false

      if (core.input.f || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[5]? && _VGAMEPADCONTROL.input.buttons[5]))
        PADBUTTONS[0][5] = true
      else if (!_GAMEPADSINFO[0]?)
        PADBUTTONS[0][5] = false

      if (core.input.g || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[6]? && _VGAMEPADCONTROL.input.buttons[6]))
        PADBUTTONS[0][6] = true
      else if (!_GAMEPADSINFO[0]?)
        PADBUTTONS[0][6] = false

      if (core.input.h || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.buttons[7]? && _VGAMEPADCONTROL.input.buttons[7]))
        PADBUTTONS[0][7] = true
      else if (!_GAMEPADSINFO[0]?)
        PADBUTTONS[0][7] = false

      if (core.input.left || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.axes.left))
        PADAXES[0][HORIZONTAL] = -1
      else if (core.input.right || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.axes.right))
        PADAXES[0][HORIZONTAL] = 1
      else if (!_GAMEPADSINFO[0]?)
        PADAXES[0][HORIZONTAL] = 0

      if (core.input.up || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.axes.up))
        PADAXES[0][VERTICAL] = -1
      else if (core.input.down || (_VGAMEPADCONTROL? && _VGAMEPADCONTROL.input.axes.down))
        PADAXES[0][VERTICAL] = 1
      else if (!_GAMEPADSINFO[0]?)
        PADAXES[0][VERTICAL] = 0

      if (GAMEPADMIX? && GAMEPADMIX)
        mx = (ANALOGSTICK[0][0][HORIZONTAL] + PADAXES[0][HORIZONTAL])
        mx = 1 if (mx > 1)
        mx = -1 if (mx < -1)
        my = (ANALOGSTICK[0][0][VERTICAL] + PADAXES[0][VERTICAL])
        my = 1 if (my > 1)
        my = -1 if (my < -1)
        ANALOGSTICK[0][0][HORIZONTAL] = mx
        ANALOGSTICK[0][0][VERTICAL] = my

      # box2dの時間を進める
      box2dworld.step(core.fps)

      # 全てのオブジェクトの「behavior」を呼ぶ
      for obj in _objects
        if (obj.active == true && obj.motionObj != undefined && typeof(obj.motionObj.behavior) == 'function')
          obj.motionObj.behavior()
      # 更新した座標値をスプライトに適用する
      for obj in _objects
        if (obj.active == true && obj.motionObj != undefined && typeof(obj.motionObj.behavior) == 'function')
          wx = if (obj.motionObj.worldview? && obj.motionObj.worldview) then (_WORLDVIEW.centerx - (SCREEN_WIDTH / 2)) else 0
          wy = if (obj.motionObj.worldview? && obj.motionObj.worldview) then (_WORLDVIEW.centery - (SCREEN_HEIGHT / 2)) else 0
          switch (obj.motionObj._type)
            when CONTROL
              continue
            when PRIMITIVE, COLLADA
              obj.motionObj.sprite.x = Math.floor(obj.motionObj.x)
              obj.motionObj.sprite.y = Math.floor(obj.motionObj.y)
              obj.motionObj.sprite.z = Math.floor(obj.motionObj.z)
            when SPRITE, LABEL, SURFACE
              if (obj.motionObj.rigid)
                if (obj.motionObj._xback != obj.motionObj.x)
                  obj.motionObj.sprite.x = obj.motionObj.x - obj.motionObj._diffx - wx
                if (obj.motionObj._yback != obj.motionObj.y)
                  obj.motionObj.sprite.y = obj.motionObj.y - obj.motionObj._diffy - wy
              else
                rot = parseFloat(obj.motionObj.rotation)
                rot += parseFloat(obj.motionObj.rotate)
                if (rot >= 360.0)
                  rot = rot % 360
                obj.motionObj.rotation = rot
                obj.motionObj.sprite.rotation = parseInt(rot)
                # _reversePosFlagは、Timeline適用中はここの処理内では座標操作はせず、スプライトの座標をオブジェクトの座標に代入している
                if (obj.motionObj._type == LABEL)
                  diffx = 0
                  diffy = 0
                else
                  diffx = obj.motionObj._diffx
                  diffy = obj.motionObj._diffy
                if (obj.motionObj._reversePosFlag)
                  obj.motionObj.x = obj.motionObj.sprite.x + diffx
                  obj.motionObj.y = obj.motionObj.sprite.y + diffy
                else
                  obj.motionObj.sprite.x = Math.floor(obj.motionObj.x - diffx - wx)
                  obj.motionObj.sprite.y = Math.floor(obj.motionObj.y - diffy - wy)
                  if (obj.motionObj._uniqueID != obj.motionObj.collider._uniqueID)
                    obj.motionObj.collider.sprite.x = obj.motionObj.collider.x = obj.motionObj.sprite.x + diffx - obj.motionObj.collider._diffx + obj.motionObj.collider._offsetx
                    obj.motionObj.collider.sprite.y = obj.motionObj.collider.y = obj.motionObj.sprite.y + diffy - obj.motionObj.collider._diffy + obj.motionObj.collider._offsety
            when MAP, EXMAP
              diffx = obj.motionObj._diffx
              diffy = obj.motionObj._diffy
              obj.motionObj.sprite.x = Math.floor(obj.motionObj.x - diffx - wx)
              obj.motionObj.sprite.y = Math.floor(obj.motionObj.y - diffy - wy)
#, false

#******************************************************************************
# デバッグ用関数
#******************************************************************************
debugwrite = (param)->
  if (DEBUG)
    if (param.clear)
      labeltext = if (param.labeltext?) then param.labeltext else ""
    else
      labeltext = _DEBUGLABEL.text += if (param.labeltext?) then param.labeltext else ""
    fontsize = if (param.fontsize?) then param.fontsize else 32
    fontcolor = if (param.color?) then param.color else "white"
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
  rotate = if (param['rotate']?) then param['rotate'] else 0.0
  texture = if (param['texture']?) then param['texture'] else undefined
  fontsize = if (param['fontsize']?) then param['fontsize'] else '16'
  color = if (param['color']?) then param['color'] else 'white'
  labeltext = if (param['labeltext']?) then param['labeltext'].replace(/\n/ig, "<br>") else 'text'
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
  worldview = if (param['worldview']?) then param['worldview'] else false
  touchEnabled = if (param['touchEnabled']?) then param['touchEnabled'] else true

  tmp = __getNullObject()
  if (tmp == -1)
    return undefined

  if (motionObj == null)
    motionObj = undefined

  retObject = undefined

  # スプライトを生成
  switch (_type)
    #*****************************************************************
    # CONTROL、SPRITE
    #*****************************************************************
    when CONTROL, SPRITE, COLLIDER2D
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

      if (_type == COLLIDER2D)
        scene = GAMESCENE_SUB2
      if (scene < 0)
        scene = GAMESCENE_SUB1

      # アニメーション設定
      if (MEDIALIST[image]?)
        if (animlist?)
          animtmp = animlist[animnum]
          motionsprite.frame = animtmp[1][0]
        else
          motionsprite.frame = 0
        motionsprite.backgroundColor = "transparent"
        motionsprite.x = x - Math.floor(width / 2)
        motionsprite.y = y - Math.floor(height / 2) - Math.floor(z)
        motionsprite.opacity = if (_type == COLLIDER2D) then 0.8 else opacity
        motionsprite.rotation = rotation
        motionsprite.rotate = rotate
        motionsprite.scaleX = scaleX
        motionsprite.scaleY = scaleY
        motionsprite.visible = visible
        motionsprite.width = width
        motionsprite.height = height
        img = MEDIALIST[image]
        motionsprite.image = core.assets[img]
      else
        motionsprite.visible = false
        motionsprite.width = 0
        motionsprite.height = 0
        motionsprite.image = ""


      # スプライトを表示
      _scenes[scene].addChild(motionsprite)

      # 動きを定義したオブジェクトを生成する
      retObject = @__setMotionObj
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
        worldview: worldview
        touchEnabled: touchEnabled
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
      #motionsprite.backgroundColor = "transparent"

      #motionsprite.x = x - Math.floor(width / 2)
      #motionsprite.y = y - Math.floor(height / 2) - Math.floor(z)
      motionsprite.x = x
      motionsprite.y = y - Math.floor(z)

      motionsprite.opacity = opacity
      #motionsprite.rotation = rotation
      #motionsprite.rotate = rotate
      #motionsprite.scaleX = scaleX
      #motionsprite.scaleY = scaleY
      motionsprite.visible = visible
      motionsprite.width = width
      motionsprite.height = height
      motionsprite.color = color
      motionsprite.text = ""
      motionsprite.textAlign = textalign
      #motionsprite.font = fontsize+"px 'Arial'"
      # 動きを定義したオブジェクトを生成する
      retObject = @__setMotionObj
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
        worldview: worldview
        touchEnabled: touchEnabled
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
      retObject = @__setMotionObj
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
        worldview: worldview
        touchEnabled: touchEnabled

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
      retObject = @__setMotionObj
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
        worldview: worldview
        touchEnabled: touchEnabled
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

      retObject = @__setMotionObj
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
        worldview: worldview
        touchEnabled: touchEnabled
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
      retObject = @__setMotionObj
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
        worldview: worldview
        touchEnabled: touchEnabled
      return retObject


__setMotionObj = (param)->
  # 動きを定義したオブジェクトを生成する
  initparam =
    x       : if (param['x']?)       then param['x'] else 0
    y       : if (param['y']?)       then param['y'] else 0
    z       : if (param['z']?)       then param['z'] else 0
    xs      : if (param['xs']?)      then param['xs'] else 0
    ys      : if (param['ys']?)      then param['ys'] else 0
    zs      : if (param['zs']?)      then param['zs'] else 0
    visible     : if (param['visible']?)     then param['visible'] else true
    scaleX    : if (param['scaleX']?)    then param['scaleX'] else 1.0
    scaleY    : if (param['scaleY']?)    then param['scaleY'] else 1.0
    scaleZ    : if (param['scaleZ']?)    then param['scaleZ'] else 1.0
    radius    : if (param['radius']?)    then param['radius'] else 0.0
    radius2     : if (param['radius2']?)     then param['radius2'] else 0.0
    size      : if (param['size']?)      then param['size'] else 1.0
    gravity     : if (param['gravity']?)     then param['gravity'] else 0
    intersectFlag : if (param['intersectFlag']?) then param['intersectFlag'] else true
    width     : if (param['width']?)     then param['width'] else SCREEN_WIDTH
    height    : if (param['height']?)    then param['height'] else SCREEN_HEIGHT
    animlist    : if (param['animlist']?)    then param['animlist'] else undefined
    animnum     : if (param['animnum']?)     then param['animnum'] else 0
    image     : if (param['image']?)     then param['image'] else undefined
    visible     : if (param['visible']?)     then param['visible'] else true
    opacity     : if (param['opacity']?)     then param['opacity'] else 0
    rotation    : if (param['rotation']?)    then param['rotation'] else 0.0
    rotate    : if (param['rotate']?)    then param['rotate'] else 0.0
    motionsprite  : if (param['motionsprite']?)  then param['motionsprite'] else 0
    fontsize    : if (param['fontsize']?)    then param['fontsize'] else '16'
    color     : if (param['color']?)     then param['color'] else 'white'
    labeltext   : if (param['labeltext']?)   then param['labeltext'] else 'text'
    textalign   : if (param['textalign']?)   then param['textalign'] else 'left'
    parent    : if (param['parent']?)    then param['parent'] else undefined
    density     : if (param['density']?)     then param['density'] else 1.0
    friction    : if (param['friction']?)    then param['friction'] else 0.5
    restitution   : if (param['restitution']?)   then param['restitution'] else 0.1
    active    : if (param['active']?)    then param['active'] else true
    kind      : if (param['kind']?)      then param['kind'] else undefined
    rigid     : if (param['rigid']?)     then param['rigid'] else undefined
    context     : if (param['context']?)     then param['context'] else undefined
    surface     : if (param['surface']?)     then param['surface'] else undefined
    collider    : if (param['collider']?)    then param['collider'] else undefined
    offsetx     : if (param['offsetx']?)     then param['offsetx'] else 0
    offsety     : if (param['offsety']?)     then param['offsety'] else 0
    worldview   : if (param['worldview']?)   then param['worldview'] else false
    touchEnabled  : if (param['touchEnabled']?)  then param['touchEnabled'] else true

  scene = if (param['scene']?) then param['scene'] else GAMESCENE_SUB1
  _type = if (param['_type']?) then param['_type'] else SPRITE
  initparam._type = _type
  motionObj = if (param['motionObj']?) then param['motionObj'] else undefined

  map = if (param['map']?) then param['map'] else []
  if (_type == MAP || _type == EXMAP)
    mapwidth = map[0].length * initparam.width
    mapheight = map.length * initparam.height
    initparam.diffx = Math.floor(mapwidth / 2)
    initparam.diffy = Math.floor(mapheight / 2)
  else
    initparam.diffx = Math.floor(initparam.width / 2)
    initparam.diffy = Math.floor(initparam.height / 2)

  objnum = __getNullObject()
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
      when CONTROL, SPRITE, LABEL, MAP, EXMAP, PRIMITIVE, COLLADA, COLLIDER2D
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
# ワールドビューの設定
#**********************************************************************
setWorldView = (cx, cy)->
  if (!cx?)
    cx = SCREEN_WIDTH / 2
  if (!cy?)
    cy = SCREEN_HEIGHT / 2
  _WORLDVIEW =
    centerx: cx
    centery: cy

#**********************************************************************
# バーチャルゲームパッド
#**********************************************************************
createVirtualGamepad = (param)->
  if (param?)
    scale    = if (param.scale?)     then param.scale    else 1
    x      = if (param.x?)       then param.x      else (100 / 2) * scale
    y      = if (param.y?)       then param.y      else SCREEN_HEIGHT - ((100 / 2) * scale)
    visible   = if (param.visible?)    then param.visible   else true
    kind    = if (param.kind?)     then param.kind     else 0
    analog   = if (param.analog?)    then param.analog    else false

    button   = if (param.button?)    then param.button    else 0
    buttonscale = if (param.buttonscale?)  then param.buttonscale else 1
    image    = if (param.image?)     then param.image    else undefined
    coord    = if (param.coord?)     then param.coord    else []
  else
    param = []
    scale    = param.scale    = 1.0
    x      = param.x      = (100 / 2) * scale
    y      = param.y      = SCREEN_HEIGHT - ((100 / 2) * scale)
    visible   = param.visible   = true
    kind    = param.kind    = 0
    analog   = param.analog   = false

    button   = param.button   = 0
    image    = param.image    = undefined
    buttonscale = param.buttonscale = 1
    coord    = param.coord    = []

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
    okbutton.sprite.ontouchstart = (e)->
      removeObject(caution)
      removeObject(okbutton)
      func()
  else
    func()



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
__getNullObject = ->
  ret = -1
  for i in [0..._objects.length]
    if (_objects[i].active == false)
      ret = i
      break
  return ret

