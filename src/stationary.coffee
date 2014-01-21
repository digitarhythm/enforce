# motionObj, kind, x, y, xs, ys, g, image, chara_w, chara_h, opacity, animlist, anime, visible
class [__classname__] extends _stationary
	#**************************
	# character constructor
	#**************************
	constructor:(@sprite)->
		super(@sprite)

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
		switch @_processnumber
			when 0
				nop()

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
