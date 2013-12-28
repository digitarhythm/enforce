class stationary
	constructor:(@obj)->

	behavior:->
		if (@obj.x < -16 || @obj.x > SCREEN_WIDTH - 16)
			@obj.xs *= -1
		if (@obj.y > SCREEN_HEIGHT - 32)
			@obj.ys *= -1
			@obj.y = SCREEN_HEIGHT - 32
