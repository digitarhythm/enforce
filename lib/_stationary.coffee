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
            @_type = initparam['_type']
            switch (@_type)
                when SPRITE, CONTROL, LABEL, PRIMITIVE, COLLADA, SURFACE
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

            if (!@collider?)
                @collider = @

            @hitflag = false
            @lastvisible = @visible

            @sprite.scaleX = @scaleX
            @sprite.scaleY = @scaleY
            @sprite.scaleZ = @scaleZ

            @sprite.visible = @visible
            @sprite.opacity = @opacity

            @sprite.ontouchstart = (e)=>
                pos = {x:e.x, y:e.y}
                if (typeof @touchesBegan == 'function')
                    @touchesBegan(pos)
            @sprite.ontouchmove = (e)=>
                pos = {x:e.x, y:e.y}
                if (typeof @touchesMoved == 'function')
                    @touchesMoved(pos)
            @sprite.ontouchend = (e)=>
                pos = {x:e.x, y:e.y}
                if (typeof @touchesEnded == 'function')
                    @touchesEnded(pos)
            @sprite.ontouchcancel = (e)=>
                pos = {x:e.x, y:e.y}
                if (typeof @touchesCanceled == 'function')
                    @touchesCanceled(pos)

            @intersectFlag = true

            # 非表示にしてから初期位置に設定する
            switch (@_type)
                when SPRITE, CONTROL, LABEL, PRIMITIVE, COLLADA, SURFACE
                    @sprite.visible = false
                    @sprite.x = Math.floor(@x - @_diffx)
                    @sprite.y = Math.floor(@y - @_diffy)

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
                        @sprite.x = Math.floor(@x - @_diffx)
                        @sprite.y = Math.floor(@y - @_diffy - @z)

                        @ys += @gravity
                        @x += @xs
                        @y += @ys
                        @z += @zs

                        if (@collider? && @collider.sprite?)
                            if (@collider._uniqueID != @_uniqueID)
                                @collider.sprite.visible = false
                                @collider.visible = false
                            @collider.x = @x + @collider._offsetx
                            @collider.y = @y + @collider._offsety
                            @collider._xback = @sprite.x + @collider._offsetx
                            @collider._yback = @sprite.y + @collider._offsety

                        if (@rotation > 359)
                            @rotation = @rotation % 360
                        @sprite.rotation = @rotation
                    else
                        # 物理演算スプライト
                        if (@_xsback != @xs)
                            @sprite.vx = @xs
                        if (@_ysback != @ys)
                            @sprite.vy = @ys

                        if (@_xback != @x)
                            @sprite.x = @x - @_diffx
                        if (@_yback != @y)
                            @sprite.y = @y - @_diffy - @z

                        @_xback = @x = @sprite.x + @_diffx
                        @_yback = @y = @sprite.y + @_diffy + @z
                        @_xsback = @xs = @sprite.vx
                        @_ysback = @ys = @sprite.vy

                        @sprite.radius = @radius
                        @sprite.density = @density
                        @sprite.friction = @friction
                        @sprite.restitution = @restitution

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
                    @sprite.scaleX  = @scaleX
                    @sprite.scaleY  = @scaleY
                    @sprite.width = @width
                    @sprite.height = @height

                    if (@animlist?)
                        animtmp = @animlist[@animnum]
                        animtime = animtmp[0]
                        animpattern = animtmp[1]
                        if (LAPSEDTIME * 1000 > @_animTime + animtime)
                            if (@_dispframe >= animpattern.length)
                                @_dispframe = 0
                            @sprite.frameIndex = animpattern[@_dispframe]
                            @sprite.frame = animpattern[@_dispframe]
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


                when LABEL
                    if (@_reversePosFlag)
                        @x = (@sprite.x + @_diffx)
                        @y = (@sprite.y + @_diffy + @z)
                    else
                        @sprite.x = Math.floor(@x - @_diffx)
                        @sprite.y = Math.floor(@y - @_diffy - @z)

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
                    @sprite.scaleX  = @scaleX
                    @sprite.scaleY  = @scaleY
                    @sprite.width = @width
                    @sprite.height = @height
                    @sprite.font = @fontsize+"px 'Arial'"
                    @sprite.color = @color
                    @sprite.text = @labeltext
                    @sprite.textAlign = @textalign

                when PRIMITIVE, COLLADA
                    if (@lastvisible != @visible)
                        if (@visible)
                            rootScene3d.addChild(@sprite)
                        else
                            rootScene3d.removeChild(@sprite)
                        @lastvisible = @visible
                                
                    @sprite.x = @x
                    @sprite.y = @y
                    @sprite.z = @z

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
                if (!@rigid)
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
            func(e.x, e.y)

    #***************************************************************
    # 2Dスプライト回転
    #***************************************************************
    spriteRotation:(ang)->
        @sprite.rotate(ang * DEG)

#*******************************************************************
# TimeLine 制御
#*******************************************************************

    #***************************************************************
    # スプライトをfadeInさせる
    #***************************************************************
    fadeIn:(time)->
        @sprite.tl.fadeIn(time)
        return @

    #***************************************************************
    # スプライトをフェイドアウトする
    #***************************************************************
    fadeOut:(time)->
        @sprite.tl.fadeOut(time)
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
    moveTo:(x, y, time, easing = enchant.Easing.QUAD_EASEINOUT)->
        @_reversePosFlag = true
        @sprite.tl.moveTo(x - @_diffx, y - @_diffy, time, easing).then =>
            @_reversePosFlag = false
        return @

    #***************************************************************
    # 相対的に移動させる
    #***************************************************************
    moveBy:(x, y, time, easing = enchant.Easing.QUAD_EASEINOUT)->
        @_reversePosFlag = true
        @sprite.tl.moveBy(x + @_diffx, y + @_diffy, time, easing).then =>
            @_reversePosFlag = false
        return @

    #***************************************************************
    # 指定した時間だけ待つ
    #***************************************************************
    delay:(time)->
        @sprite.tl.delay(time)
        return @

    #***************************************************************
    # 指定した処理を実行する
    #***************************************************************
    then:(func)->
        @sprite.tl.then =>
            func()
        return @
