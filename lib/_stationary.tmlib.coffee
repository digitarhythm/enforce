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
            @parent = initparam['parent']
            @active = initparam['active']
            @collider = initparam['collider']
            @_offsetx = initparam['offsetx']
            @_offsety = initparam['offsety']
            @worldview = initparam['worldview']

            @animnum_back = @animnum

            if (!@collider?)
                @collider = @

            @collider.worldview = @worldview

            @lastvisible = @visible

            @sprite.setInteractive(true)

            @sprite.onpointingstart = (e)=>
                pos = {x:e.app.pointing.x, y:e.app.pointing.y}
                if (typeof @touchesBegan == 'function' && @visible)
                    @touchesBegan(pos)
            @sprite.onpointingmove = (e)=>
                pos = {x:e.app.pointing.x, y:e.app.pointing.y}
                if (typeof @touchesMoved == 'function' && @visible)
                    @touchesMoved(pos)
            @sprite.onpointingend = (e)=>
                pos = {x:e.app.pointing.x, y:e.app.pointing.y}
                if (typeof @touchesEnded == 'function' && @visible)
                    @touchesEnded(pos)
            @sprite.onpointingcancel = (e)=>
                pos = {x:e.app.pointing.x, y:e.app.pointing.y}
                if (typeof @touchesCanceled == 'function' && @visible)
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
                    @ys += @gravity
                    @x += @xs
                    @y += @ys
                    @z += @zs

                    if (@opacity != @sprite.alpha)
                        if (@sprite.alpha == @opacity_back)
                            @sprite.alpha = @opacity
                        else
                            @opacity = @sprite.alpha
                    @opacity_back = @sprite.alpha

                    # コライダーを追随させる
                    if (@collider? && @collider.sprite?)
                        if (@collider._uniqueID != @_uniqueID)
                            @collider.worldview = true
                            @collider.sprite.visible = DEBUG
                            @collider.visible = DEBUG
                            @collider.opacity = if (DEBUG) then 0.5 else 1.0
                            @collider._xback = @collider.x = @x - @collider._offsetx
                            @collider._yback = @collider.y = @y - @z + @collider._offsety

                    @sprite.visible = @visible
                    @sprite.scaleX  = @scaleX
                    @sprite.scaleY  = @scaleY
                    @sprite.width = @width
                    @sprite.height = @height

                    if (@animlist?)
                        if (@animnum_back != @animnum)
                            @_dispframe = 0
                            @animnum_back = @animnum
                        animtmp = @animlist[@animnum]
                        animtime = animtmp[0]
                        animpattern = animtmp[1]
                        if (LAPSEDTIME * 1000 > @_animTime + animtime)
                            @sprite.frameIndex = animpattern[@_dispframe]
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
                    else
                        @sprite.frameIndex = 0

                when LABEL
                    @x += @xs
                    @y += @ys
                    @z += @zs

                    if (@opacity != @sprite.alpha)
                        if (@sprite.alpha == @opacity_back)
                            @sprite.alpha = @opacity
                        else
                            @opacity = @sprite.alpha
                    @opacity_back = @sprite.alpha

                    @sprite.visible = @visible
                    @sprite.scaleX  = @scaleX
                    @sprite.scaleY  = @scaleY
                    @sprite.width = @width
                    @sprite.height = @height
                    @sprite.fontSize = @fontsize
                    @sprite.fontFamily = 'Arial'
                    @sprite.fillStyle = @color
                    @sprite.text = @labeltext
                    @sprite.align = @textalign

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

                    @ys += @gravity
                    @x += @xs
                    @y += @ys
                    @z += @zs

                when MAP
                    @x += @xs
                    @y += @ys

                    if (@opacity != @sprite.alpha)
                        if (@opacity < 0.0)
                            @opacity = 0.0
                        if (@opacity > 1.0)
                            @opacity = 1.0
                        if (@sprite.alpha == @opacity_back)
                            @sprite.alpha = @opacity
                        else
                            @opacity = @sprite.alpha
                    @opacity_back = @sprite.alpha
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
        return false

    #***************************************************************
    # スプライト同士の衝突判定(intersect)
    #***************************************************************
    isIntersect:(motionObj)->
        if (@_type == SPRITE)
            if (!motionObj? || !motionObj.collider? || !motionObj.collider.sprite? || !@collider? || !@collider.sprite?)
                ret = false
            else if (@intersectFlag == true && motionObj.intersectFlag == true)
                ret = @collider.sprite.isHitElement(motionObj.collider.sprite)
            else
                ret = false
        return ret

    #***************************************************************
    # マップオブジェクトの指定した座標での衝突判定
    #***************************************************************
    isCollision:(x, y)->
        if (@_type == MAP)
            ret = @sprite.isHitPoint(x, y)
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
        @sprite.addEventListener 'pointingend', (e)=>
        #@sprite.addEventListener 'touchstart', (e)=>
            func(e.app.pointing.x, e.app.pointing.y, @)

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
        @sprite.tweener.to
            alpha: 1.0
        , time
        return @

    #***************************************************************
    # スプライトをフェイドアウトする
    #***************************************************************
    fadeOut:(time)->
        @sprite.tweener.to
            alpha: 0.0
        , time
        return @

    #***************************************************************
    # タイムラインをループさせる
    #***************************************************************
    loop:->
        @sprite.setLoop(true)
        return @

    #***************************************************************
    # ライムラインをクリアする
    #***************************************************************
    clear:->
        @sprite.tweener.clear()
        return @

    #***************************************************************
    #指定した座標に指定した時間で移動させる（絶対座標）
    #***************************************************************
    moveTo:(x, y, time, easing_kind = LINEAR, easing_move = EASEINOUT)->
        move = EASINGVALUE[easing_kind]
        easing = move[easing_move]
        @_reversePosFlag = true
        @sprite.tweener
            .to({ x: x, y: y}, time, easing)
            .call =>
                @_reversePosFlag = false
        return @

    #***************************************************************
    #指定した座標に指定した時間で移動させる（相対座標）
    #***************************************************************
    moveBy:(x, y, time, easing_kind = LINEAR, easing_move = EASEINOUT)->
        move = EASINGVALUE[easing_kind]
        easing = move[easing_move]
        @_reversePosFlag = true
        @sprite.tweener
            .by({ x: x, y: y}, time, easing)
            .call =>
                @_reversePosFlag = false
        return @

    #***************************************************************
    #指定した時間待つ
    #***************************************************************
    delay:(time)->
        @sprite.tweener.wait(time)
        return @

    #***************************************************************
    # 指定した処理を実行する
    #***************************************************************
    then:(func)->
        @sprite.tweener.call(func)
        return @


