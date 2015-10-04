class _stationary
  #***************************************************************
  # コンストラクター
  #***************************************************************
  constructor:(initparam)->
    @_processnumber = 0
    @_waittime = 0.0
    @_dispframe = 0
    @_endflag = false
    @_returnflag = false
    @_autoRemove = false
    @_animTime = LAPSEDTIME * 1000
    @_reversePosFlag = false

    @sprite = initparam['motionsprite']
    if (@sprite?)
      # 非表示にしてから初期位置に設定する
      @sprite.visible = false
      @_type = initparam['_type']
      @_xback = @x = initparam['x']
      @_yback = @y = initparam['y']
      @z = initparam['z']
      @_xsback = @xs = initparam['xs']
      @_ysback = @ys = initparam['ys']
      @zs = initparam['zs']
      @visible = initparam['visible']
      @scaleX = initparam['scaleX']
      @scaleY = initparam['scaleY']
      @scaleZ = initparam['scaleZ']
      @gravity = initparam['gravity']
      @intersectFlag = initparam['intersectFlag']
      @width = initparam['width']
      @height = initparam['height']
      @depth = initparam['depth']
      @image = initparam['image']
      @size = initparam['size']
      @radius = initparam['radius']
      @radius2 = initparam['radius2']
      @_diffx = initparam['diffx']
      @_diffy = initparam['diffy']
      @animlist = initparam['animlist']
      @animnum = initparam['animnum']
      @opacity = initparam['opacity']
      @rotation = initparam['rotation']
      @rotate = initparam['rotate']
      @fontsize = initparam['fontsize']
      @color = initparam['color']
      @labeltext = initparam['labeltext']
      @textalign = initparam['textalign']
      @density = initparam['density']
      @friction = initparam['friction']
      @restitution = initparam['restitution']
      @active = initparam['active']
      @kind = initparam['kind']
      @rigid = initparam['rigid']
      @context = initparam['context']
      @surface = initparam['surface']
      @collider = initparam['collider']
      @_offsetx = initparam['offsetx']
      @_offsety = initparam['offsety']
      @parent = initparam['parent']
      @worldview = initparam['worldview']
      @touchEnabled = initparam['touchEnabled']

      @sprite.touchEnabled = @touchEnabled
      @sprite.visible = @visible
      @sprite.opacity = @opacity

      @animnum_back = @animnum

      if (!@collider?)
        @collider = @

      @hitflag = false
      @lastvisible = @visible

      @sprite.ontouchstart = (e)=>
        pos = {x:e.x, y:e.y}
        if (typeof @touchesBegan == 'function' && @visible && @touchEnabled)
          @touchesBegan(pos)
      @sprite.ontouchmove = (e)=>
        pos = {x:e.x, y:e.y}
        if (typeof @touchesMoved == 'function' && @visible && @touchEnabled)
          @touchesMoved(pos)
      @sprite.ontouchend = (e)=>
        pos = {x:e.x, y:e.y}
        if (typeof @touchesEnded == 'function' && @visible && @touchEnabled)
          @touchesEnded(pos)
      @sprite.ontouchcancel = (e)=>
        pos = {x:e.x, y:e.y}
        if (typeof @touchesCanceled == 'function' && @visible && @touchEnabled)
          @touchesCanceled(pos)

      @intersectFlag = true


  #***************************************************************
  # デストラクター
  #***************************************************************
  destructor:->

  #***************************************************************
  # ビヘイビアー
  #***************************************************************
  behavior:->
    # スプライトの座標等パラメータを更新する
    if (@sprite?)
      switch (@_type)
        when SPRITE
          if (!@rigid || @kind == STATIC_BOX || @kind == STATIC_CIRCLE)
            # 通常スプライト
            @ys += @gravity
            @x += @xs
            @y += @ys
            @z += @zs
          else
            # 物理演算スプライト
            if (@_xsback != @xs)
              @sprite.vx = @xs
            if (@_ysback != @ys)
              @sprite.vy = @ys

            @_xback = @x = @sprite.x + @_diffx
            @_yback = @y = @sprite.y + @_diffy + @z
            @_xsback = @xs = @sprite.vx
            @_ysback = @ys = @sprite.vy
          
          if (@opacity != @sprite.opacity)
            if (@opacity < 0.0)
              @opacity = 0.0
            if (@opacity > 1.0)
              @opacity = 1.0
            if (@sprite.opacity == @opacity_back || !@opacity_back?)
              @sprite.opacity = @opacity
            else
              @opacity = @sprite.opacity
          @opacity_back = @sprite.opacity

          # コライダーを追随させる
          if (@collider? && @collider.sprite?)
            if (@collider._uniqueID != @_uniqueID)
              @collider._type = COLLIDER2D
              @collider.worldview = @worldview
              @collider.sprite.visible = @collider.visible = DEBUG
              @collider.opacity = @collider.sprite.opacity = if (DEBUG) then 0.5 else 1.0

          @sprite.visible = @visible
          @sprite.scaleX = @scaleX
          @sprite.scaleY = @scaleY
          @sprite.width  = @width
          @sprite.height = @height
          @sprite.touchEnabled = @touchEnabled

          if (@animlist?)
            if (@animnum_back != @animnum)
              @_dispframe = 0
              @animnum_back = @animnum
            animtmp = @animlist[@animnum]
            animtime = animtmp[0]
            animpattern = animtmp[1]
            if (LAPSEDTIME * 1000 > @_animTime + animtime)
              if (@_dispframe >= animpattern.length)
                @_dispframe = 0
              framenum = animpattern[@_dispframe]
              @sprite.frameIndex = framenum
              @sprite.frame = framenum
              @_animTime = LAPSEDTIME * 1000
              @_dispframe++
              if (@_dispframe >= animpattern.length)
                if (@_endflag == true)
                  @_endflag = false
                  removeObject(@)
                  return
                else if (@_returnflag == true)
                  @_returnflag = false
                  @animnum = @_beforeAnimnum
                  @_dispframe = 0
                else
                  @_dispframe = 0
          else if (@image?)
            @sprite.frameIndex = 0
            @sprite.frame = 0


        when LABEL
          @x += @xs
          @y += @ys
          @z += @zs

          if (@opacity != @sprite.opacity)
            if (@sprite.opacity == @opacity_back)
              @sprite.opacity = @opacity
            else
              @opacity = @sprite.opacity
          @opacity_back = @sprite.opacity

          @sprite.visible = @visible
          @sprite.scaleX = @scaleX
          @sprite.scaleY = @scaleY
          @sprite.width = @width
          @sprite.height = @height
          @sprite.font = @fontsize+"px 'Arial'"
          @sprite.color = @color
          @sprite.text = @labeltext.replace(/\n/ig, "<br>")
          @sprite.textAlign = @textalign

        when PRIMITIVE, COLLADA
          if (@lastvisible != @visible)
            if (@visible)
              rootScene3d.addChild(@sprite)
            else
              rootScene3d.removeChild(@sprite)
            @lastvisible = @visible

          if (@scaleX != @sprite.scaleX)
            @sprite.scaleX = @scaleX
          if (@scaleY != @sprite.scaleY)
            @sprite.scaleY = @scaleY
          if (@scaleZ != @sprite.scaleZ)
            @sprite.scaleZ = @scaleZ

          @ys -= @gravity
          @x += @xs
          @y += @ys
          @z += @zs

        when MAP, EXMAP
          @sprite.x = Math.floor(@x - @_diffx)
          @sprite.y = Math.floor(@y - @_diffy)

          @x += @xs
          @y += @ys

          if (@opacity != @sprite.opacity)
            if (@opacity < 0.0)
              @opacity = 0.0
            if (@opacity > 1.0)
              @opacity = 1.0
            if (@sprite.opacity == @opacity_back)
              @sprite.opacity = @opacity
            else
              @opacity = @sprite.opacity
          @opacity_back = @sprite.opacity
          @sprite.visible = @visible

    if (@_waittime > 0 && LAPSEDTIME > @_waittime)
      @_waittime = 0
      @_processnumber = @_nextprocessnum

  #***************************************************************
  # WebGLオブジェクトにクォータニオンを設定する
  #***************************************************************
  setQuaternion:(v, angle)->
    if (@_type == COLLADA || @_type == PRIMITIVE)
      switch (v)
        when 0
          @sprite.rotationSet(new Quat(1, 0, 0, angle * RAD))
        when 1
          @sprite.rotationSet(new Quat(0, 1, 0, angle * RAD))
        when 2
          @sprite.rotationSet(new Quat(0, 0, 1, angle * RAD))
        
  #***************************************************************
  # WebGLオブジェクトにクォータニオンを合成する
  #***************************************************************
  applyQuaternion:(v, angle)->
    if (@_type == COLLADA || @_type == PRIMITIVE)
      switch (v)
        when 0
          @sprite.rotationApply(new Quat(1, 0, 0, angle * RAD))
        when 1
          @sprite.rotationApply(new Quat(0, 1, 0, angle * RAD))
        when 2
          @sprite.rotationApply(new Quat(0, 0, 1, angle * RAD))
  
  #***************************************************************
  # 3Dオブジェクトにテクスチャーをマッピングする
  #***************************************************************
  setTexture:(image)->
    if (@_type != PRIMITIVE && @_type != COLLADA)
      return
    texture = MEDIALIST[image]
    @sprite.texture = new Texture(texture)

  #***************************************************************
  # タッチ開始
  #***************************************************************
  touchesBegan:(e)->

  #***************************************************************
  # タッチしたまま移動
  #***************************************************************
  touchesMoved:(e)->

  #***************************************************************
  # タッチ終了
  #***************************************************************
  touchesEnded:(e)->

  #***************************************************************
  # タッチキャンセル
  #***************************************************************
  touchesCanceled:(e)->

  #***************************************************************
  # 次のプロセスへ
  #***************************************************************
  nextjob:->
    @_processnumber++

  #***************************************************************
  # 指定した秒数だけ待って次のプロセスへ
  #***************************************************************
  waitjob:(wtime)->
    @_waittime = parseFloat(LAPSEDTIME) + wtime
    @_nextprocessnum = @_processnumber + 1
    @_processnumber = -1
  
  #***************************************************************
  # プロセス番号を設定
  #***************************************************************
  setProcessNumber:(num)->
    @_processnumber = num

  #***************************************************************
  # スプライト同士の衝突判定(withIn)
  #***************************************************************
  isWithIn:(motionObj, range = -1)->
    if (!motionObj?)
      return false
    if (range < 0)
      range = motionObj.sprite.width / 2
    if (@intersectFlag == true && motionObj.intersectFlag == true)
      ret = @sprite.within(motionObj.sprite, range)
    else
      ret = false
    return ret

  #***************************************************************
  # スプライト同士の衝突判定(intersect)
  #***************************************************************
  isIntersect:(motionObj)->
    if (@_type == SPRITE)
      if (!motionObj? || !motionObj.collider? || !motionObj.collider.sprite? || !@collider? || !@collider.sprite?)
        ret = false
      else if (@intersectFlag == true && motionObj.intersectFlag == true)
        ret = @collider.sprite.intersect(motionObj.collider.sprite)
      else
        ret = false
    else if (@_type == MAP || @_type == EXMAP)
      if (!motionObj? || !motionObj.collider? || !motionObj.collider.sprite? || !@intersectFlag)
        ret = false
      else
        ret = @sprite.hitTest(motionObj.x, motionObj.y)
    else
      motionObj.sprite.type = 'AABB'
      @sprite.type = 'AABB'
      ret = @sprite.intersect(motionObj.sprite)
    return ret

  #***************************************************************
  # マップオブジェクトの指定した座標での衝突判定
  #***************************************************************
  isCollision:(x, y)->
    if (@_type == MAP || @_type == EXMAP)
      ret = @sprite.hitTest(x, y)
    else
      ret = false

  #***************************************************************
  # 指定されたアニメーションを再生した後オブジェクト削除
  #***************************************************************
  setAnimationToRemove:(animnum)->
    @animnum = animnum
    @_dispframe = 0
    @_endflag = true

  #***************************************************************
  # 指定したアニメーションを一回だけ再生し指定したアニメーションに戻す
  #***************************************************************
  setAnimationToOnce:(animnum, animnum2)->
    @_beforeAnimnum = animnum2
    @animnum = animnum
    @_dispframe = 0
    @_returnflag = true

  #***************************************************************
  # 3DスプライトにColladaモデルを設定する
  #***************************************************************
  setModel:(name)->
    model = MEDIALIST[name]
    @set(core.assets[model])

  #***************************************************************
  # タッチイベント登録
  #***************************************************************
  addTarget:(func)->
    @sprite.addEventListener 'touchend', (e)=>
      func(e.x, e.y, @) if (@touchEnabled)

  #***************************************************************
  # 2Dスプライト回転
  #***************************************************************
  spriteRotation:(ang)->
    @sprite.rotate(ang * DEG)

#*******************************************************************
# box2d関連
#*******************************************************************
  applyForce:(force)->
    @sprite.applyForce(force)
    
  applyImpulse:(impulse)->
    @sprite.applyImpulse(impulse)
    
  applyTorque:(torque)->
    @sprite.applyTorque(torque)

#*******************************************************************
# TimeLine 制御
#*******************************************************************

  #***************************************************************
  # スプライトをfadeInさせる
  #***************************************************************
  fadeIn:(time)->
    @sprite.tl
      .fadeIn(time * FPS / 1000)
    return @

  #***************************************************************
  # スプライトをフェイドアウトする
  #***************************************************************
  fadeOut:(time)->
    @sprite.tl
      .fadeOut(time * FPS / 1000)
    return @

  #***************************************************************
  # 指定した透過度にする
  #***************************************************************
  fadeTo:(num, time, easing_kind = LINEAR, easing_move = EASEINOUT)->
    move = EASINGVALUE[easing_kind]
    easing = move[easing_move]
    @sprite.tl
      .fadeTo(num, time * FPS / 1000, easing)
    return @

  #***************************************************************
  # タイムラインをループさせる
  #***************************************************************
  loop:->
    @sprite.tl.loop()

  #***************************************************************
  # ライムラインをクリアする
  #***************************************************************
  clear:->
    @sprite.tl.clear()

  #***************************************************************
  # 指定した位置へ移動させる
  #***************************************************************
  moveTo:(x, y, time, easing_kind = LINEAR, easing_move = EASEINOUT)->
    move = EASINGVALUE[easing_kind]
    easing = move[easing_move]
    @_reversePosFlag = true
    @sprite.tl
      .moveTo(x - @_diffx, y - @_diffy, time * FPS / 1000, easing)
      .then =>
        @_reversePosFlag = false
    return @

  #***************************************************************
  # 相対的に移動させる
  #***************************************************************
  moveBy:(x, y, time, easing_kind = LINEAR, easing_move = EASEINOUT)->
    move = EASINGVALUE[easing_kind]
    easing = move[easing_move]
    @_reversePosFlag = true
    @sprite.tl
      .moveBy(x, y, time * FPS / 1000, easing)
      .then =>
        @_reversePosFlag = false
    return @

  #***************************************************************
  # 指定した時間だけ待つ
  #***************************************************************
  delay:(time)->
    @sprite.tl.delay(time * FPS / 1000)
    return @

  #***************************************************************
  # 指定した処理を実行する
  #***************************************************************
  then:(func)->
    @sprite.tl.then =>
      func()
    return @

