class _stationary
	#***************************************************************
	# コンストラクター
	#***************************************************************
	constructor:(@sprite)->
		@_processnumber = 0
		@_waittime = 0.0
		@_dispframe = 0
		@_endflag = false
		@_returnflag = false

		if (@sprite?)
			@sprite.intersectFlag = true
			@sprite.addEventListener 'touchstart', (e)=>
				if (typeof @touchesBegan == 'function')
					@touchesBegan(e)
			@sprite.addEventListener 'touchmove', (e)=>
				if (typeof @touchesMoved == 'function')
					@touchesMoved(e)
			@sprite.addEventListener 'touchend', (e)=>
				if (typeof @touchesEnded == 'function')
					@touchesEnded(e)
			@sprite.addEventListener 'touchcancel', (e)=>
				if (typeof @touchesCanceled == 'function')
					@touchesCanceled(e)

	#***************************************************************
	# デストラクター
	#***************************************************************
	destructor:->

	#***************************************************************
	# ビヘイビアー
	#***************************************************************
	behavior:->
		if (@_type_ == SPRITE && @sprite?)
			if (@sprite.x != @sprite.xback)
				@sprite.x2 = @sprite.x
			if (@sprite.y != @sprite.yback)
				@sprite.y2 = @sprite.y
			@sprite.ys += @sprite.gravity
			@sprite.x2 += @sprite.xs
			@sprite.y2 += @sprite.ys
			@sprite.x = Math.round(@sprite.x2)
			@sprite.y = Math.round(@sprite.y2)
			@sprite.xback = @sprite.x
			@sprite.yback = @sprite.y

		if (@sprite.animlist?)
			animpattern = @sprite.animlist[@sprite.animnum]
			@sprite.frame = animpattern[@_dispframe++]
			if (@_dispframe >= animpattern.length)
				if (@_endflag == true)
					@_endflag = false
					removeObject(@)
					return
				else if (@_returnflag == true)
					@_returnflag = false
					@sprite.animnum = @_beforeAnimnum
					@_dispframe = 0
				else
					@_dispframe = 0

		if (@_waittime > 0 && lapsedtime > @_waittime)
			@_waittime = 0
			@_processnumber = @_nextprocessnum

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
		@_waittime = lapsedtime + wtime
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
	isWithIn:(sprite, range = -1)->
		if (!@sprite? || !sprite?)
			reuturn false

		if (range < 0)
			range = sprite.width / 2

		if (@sprite.intersectFlag == true && sprite.intersectFlag == true)
			ret = @sprite.within(sprite, range)
		else
			ret = false
		return ret

	#***************************************************************
	# スプライト同士の衝突判定(intersect)
	#***************************************************************
	isIntersect:(sprite)->
		if (!@sprite? || !sprite?)
			reuturn false

		if (@sprite.intersectFlag == true && sprite.intersectFlag == true)
			ret = @sprite.intersect(sprite)
		else
			ret = false
		return ret

	#***************************************************************
	# 指定されたアニメーションを再生した後オブジェクト削除
	#***************************************************************
	setAnimationToRemove:(animnum)->
		@sprite.animnum = animnum
		@_dispframe = 0
		@_endflag = true

	#***************************************************************
	# 指定したアニメーションを一回だけ再生し指定したアニメーションに戻す
	#***************************************************************
	setAnimationToOnce:(animnum, animnum2)->
		@_beforeAnimnum = animnum2
		@sprite.animnum = animnum
		@_dispframe = 0
		@_returnflag = true

