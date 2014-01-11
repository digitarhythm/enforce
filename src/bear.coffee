# motionObj, kind, x, y, xs, ys, g, image, chara_w, chara_h, opacity, animlist, anime, visible
class bear extends _stationary
	#**************************
	# character constructor
	#**************************
	constructor:(sprite)->
		super(sprite)

	#**************************
	# character destructor
	#**************************
	destructor:->
		super()

	#**************************
	# character behavior
	#**************************
	behavior:->
		super()
		switch @processnumber
			when 0
				if (@sprite.y > SCREEN_HEIGHT - 32)
					@sprite.y = SCREEN_HEIGHT - 32
					@sprite.ys *= -1
				if (@sprite.x > SCREEN_WIDTH - 32)
					@sprite.x = SCREEN_WIDTH - 32
					@sprite.xs *= -1
				if (@sprite.x < 0)
					@sprite.x = 0
					@sprite.xs *= -1
				if (@sprite.xs > 0)
					@sprite.scaleX = 1
				else
					@sprite.scaleX = -1

	#**************************
	# touch event
	#**************************
	#touchesBegan:(e)->
	#	super(e)

	#**************************
	# swipe event
	#**************************
	#touchesMoved:(e)->
	#	super(e)

	#**************************
	# detouch event
	#**************************
	#touchesEnded:(e)->
	#	super(e)

	#**************************
	# touch cancel event
	#**************************
	#touchesCanceled:(e)->
	#	super(e)
