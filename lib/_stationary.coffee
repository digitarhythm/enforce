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
        @sprite = initparam['motionsprite']

        if (@sprite?)
            @x = initparam['x']
            @y = initparam['y']
            @z = initparam['z']
            @xs = initparam['xs']
            @ys = initparam['ys']
            @zs = initparam['zs']
            @visible = initparam['visible']
            @scaleX = initparam['scaleX']
            @scaleY = initparam['scaleY']
            @scaleZ = initparam['scaleZ']
            @gravity = initparam['gravity']
            @intersectFlag = initparam['intersectFlag']
            @width = initparam['width']
            @height = initparam['height']
            @diffx = initparam['diffx']
            @diffy = initparam['diffy']
            @animlist = initparam['animlist']
            @animnum = initparam['animnum']
            @opacity = initparam['opacity']
            @_type = initparam['_type']
            @rotation = initparam['rotation']
            @sprite.scale(@scaleX, @scaleY, @scaleZ)

            if (@_type == WEBGL)
                @setQuaternion(0, -90)

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
            @sprite.visible = false
            @sprite.x = Math.floor(@x - @diffx)
            @sprite.y = Math.floor(@y - @diffy - @z)

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
                    @sprite.x = Math.floor(@x - @diffx)
                    @sprite.y = Math.floor(@y - @diffy - @z)

                    @ys += @gravity

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

                    if (@_type == SPRITE && @animlist?)
                        animtmp = @animlist[@animnum]
                        animtime = animtmp[0]
                        animpattern = animtmp[1]
                        if (LAPSEDTIME * 1000 > @_animTime + animtime)
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

                when WEBGL
                    @sprite.x = @x
                    @sprite.y = @y
                    @sprite.z = @z

                    @ys += @gravity
                    @x += @xs
                    @y += @ys
                    @z += @zs

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
        @_waittime = LAPSEDTIME + wtime
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
        if (!motionObj.sprite?)
            return false
        if (@intersectFlag == true && motionObj.intersectFlag == true)
            ret = @sprite.intersect(motionObj.sprite)
        else
            ret = false
        return ret

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

