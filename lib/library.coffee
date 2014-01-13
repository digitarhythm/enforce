# random
rand = (n)->
	return Math.floor(Math.random() * (n + 1))

# debug write
JSLog = (a, b...) -> 
	for data in b
		a = a.replace('%@', data)
	console.log(a)
	return a
