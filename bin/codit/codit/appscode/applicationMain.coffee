class applicationMain extends JSObject
	constructor:(@rootView)-> super()
	didFinishLaunching:->
		###
		Please describe the user code below from here.
		Please arrange an indent with the head of this comment. 
		###

		browserframe = getBounds()
		toolview_height = 48
		sideview_width = 240

		@mainview = new MainView(JSRectMake(sideview_width, toolview_height, browserframe.size.width - sideview_width, browserframe.size.height - toolview_height))
		@mainview.setBackgroundColor(JSColor("#ffffff"))
		@rootView.addSubview(@mainview)

		@sideview = new SideView(JSRectMake(0, toolview_height, sideview_width, browserframe.size.height - toolview_height))
		@sideview.setShadow(true)
		@sideview.mainview = @mainview
		@rootView.addSubview(@sideview)

		@toolview = new ToolView(JSRectMake(0, 0, browserframe.size.width, toolview_height))
		@toolview.setShadow(true)
		@rootView.addSubview(@toolview)

		picturepath = JSSearchPathForDirectoriesInDomains("JSPictureDirectory")
		img = new JSImage(picturepath+"/enforce_logo.png")
		logo = new JSImageView(JSRectMake(2, 2, 120, 44))
		logo.setImage(img)
		@toolview.addSubview(logo)
