# motionObj, kind, x, y, xs, ys, g, image, chara_w, chara_h, opacity, animlist, anime, visible
class stationary extends _stationary
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
				@waitjob(1)

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
