class _stationary
	constructor:(@sprite)->
		@processnumber = 0
		@waittime = 0
		@nextproc = -1

		if (@sprite?)
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

	destructor:->

	behavior:->
		if (@waittime > 0 && lapsedtime > @waittime)
			@nextjob()
			@waittime = 0

	touchesBegan:(e)->

	touchesMoved:(e)->

	touchesEnded:(e)->

	touchesCanceled:(e)->

	nextjob:->
		@processnumber = @nextproc
		@nextproc = -1

	waitjob:(wtime)->
		@waittime = lapsedtime + wtime
		@nextproc = @processnumber + 1
		@processnumber = -1
