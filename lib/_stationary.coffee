class _stationary
	constructor:(@sprite)->
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

	touchesBegan:(e)->

	touchesMoved:(e)->

	touchesEnded:(e)->

	touchesCanceled:(e)->
