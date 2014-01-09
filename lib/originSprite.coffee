class originSprite
	constructor:(@sprite)->
		@childlist = []

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

	addSprite:(sprite)=>
		@childlist.push(sprite)
		core.rootScene.addChild(sprite);

