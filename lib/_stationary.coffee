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
			@waittime = 0
			@nextjob()

	touchesBegan:(e)->

	touchesMoved:(e)->

	touchesEnded:(e)->

	touchesCanceled:(e)->

	nextjob:->
		@processnumber++

	waitjob:(wtime)->
		@waittime = lapsedtime + wtime
