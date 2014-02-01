class MainView extends JSView
	constructor:(frame)->
		super(frame)
		###
		Please describe initialization processing of a class below from here. 
		###

		@userDefaults = new JSUserDefaults()

		@editfile = undefined
		@filemanager = new JSFileManager()
		@documentpath = JSSearchPathForDirectoriesInDomains("JSDocumentDirectory")
		@keyarray = []
		
	viewDidAppear:->
		super()
		###
		Please describe the processing about a view below from here. 
		###

		@sourceinfo = new JSTextField(JSRectMake(4, 0, parseInt(@_frame.size.width / 2), 24))
		@sourceinfo.setEditable(false)
		@sourceinfo.setBackgroundColor(JSColor("clearColor"))
		@sourceinfo.setTextSize(14)
		@sourceinfo.setTextAlignment("JSTextAlignmentLeft")
		@addSubview(@sourceinfo)

		@savebutton = new JSButton(JSRectMake(@_frame.size.width - 32, 0, 32, 24))
		@savebutton.setButtonTitle("◯")
		@addSubview(@savebutton)
		@savebutton.addTarget =>
			@compileSource()

		@editorview = new JSTextView(JSRectMake(4, 24, @_frame.size.width - 4, @_frame.size.height - 28 - 24))
		@editorview.setBackgroundColor(JSColor("#000020"))
		@editorview.setTextColor(JSColor("white"))
		@editorview.setTextSize(10)
		@editorview.setHidden(true)
		@editorview.setEditable(false)
		@addSubview(@editorview)

		@memoview = new JSTextView(JSRectMake(parseInt(@_frame.size.width / 3) * 2, 24, parseInt(@_frame.size.width / 3), @_frame.size.height - 28))
		@memoview.setBackgroundColor(JSColor("#f0f0f0"))
		@memoview.setTextSize(10)
		@memoview.setHidden(true)
		@addSubview(@memoview)
		@userDefaults.stringForKey "memo", (string)=>
			@memoview.setText(string)
		$(@memoview._viewSelector+"_textarea").vixtarea()
		$(@memoview._viewSelector+"_textarea").keyup (e)=>
			@keyarray[e.keyCode] = false
		$(@memoview._viewSelector+"_textarea").keydown (e)=>
			@keyarray[e.keyCode] = true
			if (@keyarray[17] && @keyarray[91] && e.keyCode == 77)
				@memoview.animateWithDuration 0.2, {alpha: 0.0}, =>
					string = @memoview.getText()
					@userDefaults.setObject(string, "memo")
					@memoview.setHidden(true)
					@focusEditorview()

		size = JSSizeMake(parseInt(@_frame.size.width / 2), parseInt(@_frame.size.height / 2))
		@imageview = new JSImageView(JSRectMake((@_frame.size.width - size.width) / 2, (@_frame.size.height - size.height) / 2, size.width, size.height))
		@imageview.setContentMode("JSViewContentModeScaleAspectFit")
		@imageview.setHidden(true)
		@addSubview(@imageview)

		@infoview = new JSTextView(JSRectMake(4, @_frame.size.height - 24, @_frame.size.width - 4, 24))
		@infoview.setBackgroundColor(JSColor("#f0f0f0"))
		@infoview.setTextColor(JSColor("black"))
		@infoview.setTextSize(10)
		@infoview.setEditable(false)
		@infoview.dispflag = false
		@addSubview(@infoview)
		@infoview.addTapGesture =>
			@dispInfoview()
	
	dispInfoview:(flagtmp = undefined)->
		if (!flagtmp?)
			flag = @infoview.dispflag
		else
			flag = (if (flagtmp == true) then false else true)
		if (flag == false)
			@infoview.dispflag = true
			@infoview._frame.size.height = parseInt(@_frame.size.height / 3)
			@infoview._frame.origin.y = @_frame.size.height - parseInt(@_frame.size.height / 3)
			@infoview.setFrame(@infoview._frame)
		else
			@infoview.dispflag = false
			@infoview._frame.size.height = 24
			@infoview._frame.origin.y = @_frame.size.height - 24
			@infoview.setFrame(@infoview._frame)

	focusEditorview:->
		$(@editorview._viewSelector+"_textarea").focus()

	focusMemoview:->
		$(@memoview._viewSelector+"_textarea").focus()

	compileSource:->
		if (@editfile?)
			str = @editorview.getText()
			savepath = @documentpath+"/src/"+@editfile
			@filemanager.writeToFile savepath, str, (err)=>
				if (err == 1)
					$.post "syslibs/enforce.php",
						mode: "compile"
					, (err)=>
						if (err != "")
							@infoview.setText(err)
							@dispInfoview(true)
						else
							@infoview.setText("no error.")
							@dispInfoview(false)
		else
			$.post "syslibs/enforce.php",
				mode: "compile"
			, (err)=>
				if (err != "")
					@infoview.setText(err)
					@dispInfoview(true)
				else
					@infoview.setText("no error.")
					@dispInfoview(false)

	loadSourceFile:(fpath)->
		if (@editorview?)
			@editorview.removeFromSuperview()
		@editorview = new JSTextView(JSRectMake(4, 24, @_frame.size.width - 4, @_frame.size.height - 28 - 24))
		@editorview.setBackgroundColor(JSColor("#000020"))
		@editorview.setTextColor(JSColor("white"))
		@editorview.setTextSize(10)
		@addSubview(@editorview)
		@bringSubviewToFront(@infoview)
		tmp = fpath.match(/.*\/(.*)/)
		@editfile = tmp[1]
		@imageview.setHidden(true)
		@sourceinfo.setText(@editfile)
		@filemanager.stringWithContentsOfFile fpath, (string)=>
			@editorview.setEditable(true)
			@editorview.setHidden(false)
			@editorview.setText(string)
			$(@editorview._viewSelector+"_textarea").vixtarea({backgroundColor:"#000020",color:"white"})
			@focusEditorview()
			$(@editorview._viewSelector+"_textarea").keyup (e)=>
				@keyarray[e.keyCode] = false
			$(@editorview._viewSelector+"_textarea").keydown (e)=>
				@keyarray[e.keyCode] = true
				if (@keyarray[17] && @keyarray[91] && e.keyCode == 83)
					@compileSource()
				if (@keyarray[17] && @keyarray[91] && e.keyCode == 89)
					@dispInfoview()
				if (@keyarray[17] && @keyarray[91] && e.keyCode == 77)
					if (@memoview._hidden == true)
						@bringSubviewToFront(@memoview);
						@memoview.setHidden(false)
						@memoview.animateWithDuration 0.2, {alpha: 1.0}, =>
							@focusMemoview()
					else
						@memoview.animateWithDuration 0.2, {alpha: 0.0}, =>
							@memoview.setHidden(true)

	dispImage:(fpath)->
		if (@editorview?)
			@editorview.setHidden(true)
		if (@imageview?)
			@imageview.setHidden(false)
		img = new JSImage(fpath)
		@imageview.setImage(img)

