class SideView extends JSView
	constructor:(frame)->
		super(frame)
		###
		Please describe initialization processing of a class below from here. 
		###

		@selecttab = 0
		@tabheight = 24
		@sourceview = undefined
		@mediaview = undefined
		@documentpath = JSSearchPathForDirectoriesInDomains("JSDocumentDirectory")
		@enforcepath = @documentpath+"/../.."
		@picturepath = JSSearchPathForDirectoriesInDomains("JSPictureDirectory")
		@filemanager = new JSFileManager()
		@setClipToBounds(false)

	viewDidAppear:->
		super()
		###
		Please describe the processing about a view below from here. 
		###

		select = ["code", "media"]
		@tabview = new JSSegmentedControl(select)
		@tabview.setTextSize(9)
		@tabview.setFrame(JSRectMake(0, 0, @_frame.size.width - 2, @tabheight))
		@tabview.setValue(@selecttab)
		@addSubview(@tabview)
		@tabview.addTarget =>
			@selecttab = @tabview._selectedSegmentIndex
			@dispListView()

		@sourceview = new JSListView(JSRectMake(0, @tabview._frame.size.height, @_frame.size.width, @_frame.size.height - @tabview._frame.size.height - 24))
		@sourceview.setTextSize(14)
		@sourceview.setBackgroundColor(JSColor("white"))
		@sourceview.setHidden(true)
		@addSubview(@sourceview)
		@sourceview.addTarget =>
			fname = @sourceview.objectAtIndex(@sourceview.getSelect())
			@mainview.loadSourceFile(@documentpath+"/src/"+fname)

		@mediaview = new JSListView(JSRectMake(0, @tabview._frame.size.height, @_frame.size.width, @_frame.size.height - @tabview._frame.size.height - 24))
		@mediaview.setTextSize(14)
		@mediaview.setBackgroundColor(JSColor("white"))
		@mediaview.setHidden(true)
		@addSubview(@mediaview)
		@mediaview.addTarget =>
			fname = @mediaview.objectAtIndex(@mediaview.getSelect())
			@mainview.dispImage(@enforcepath+"/media/"+fname)

		@dispListView()

	dispListView:(tab = parseInt(@selecttab))->
		if (@addButton?)
			@addButton.removeFromSuperview()
		switch tab
			when 0 # ソースモード
				if (@mainview.editorview?)
					@mainview.editorview.setHidden(false)
				@mainview.imageview.setHidden(true)
				@sourceview.setHidden(false)
				@mediaview.setHidden(true)
				@addButton = new JSButton(JSRectMake(0, @_frame.size.height - 24, 32, 24))
				@addButton.setButtonTitle("+")
				@addSubview(@addButton)
				ext = ["coffee"]
				@filemanager.fileList @documentpath+"/src", ext, (data)=>
					jdata = JSON.parse(data)
					dispdata = jdata['file']
					dispdata.sort (a, b)=>
						if (a < b)
							return -1
						else if (a > b)
							return 1
						else
							return 0
					@sourceview.setListData(dispdata)
					@sourceview.reload()
				@addButton.addTarget =>
					alert = new JSAlertView("Create New Class File", "Input new class file name.", [""])
					alert.delegate = @_self
					alert.setAlertViewStyle("JSAlertViewStylePlainTextInput")
					alert.mode = "NEW CLASS"
					@addSubview(alert)
					alert.show()
				@delbutton = new JSButton(JSRectMake(34, @_frame.size.height - 24, 32, 24))
				@delbutton.setButtonTitle("-")
				@addSubview(@delbutton)
				@delbutton.addTarget =>
					fname = @sourceview.objectAtIndex(@sourceview.getSelect())
					if (fname?)
						alert = new JSAlertView("Caution", "Delete '"+fname+"' OK?")
						alert.delegate = @_self
						alert.cancel = true
						alert.mode = "DELETE FILE"
						alert.fname = fname
						@addSubview(alert)
						alert.show()

			when 1 # 画像モード
				if (@mainview.editorview?)
					@mainview.editorview.setHidden(true)
				@mainview.imageview.setHidden(false)
				@sourceview.setHidden(true)
				@mediaview.setHidden(false)
				@addButton = new JSButton(JSRectMake(0, @_frame.size.height - 24, 64, 24))
				@addButton.setStyle("JSFormButtonStyleImageUpload")
				@addButton.delegate = @
				@addSubview(@addButton)
				ext = ["png", "jpg", "gif", "mp3", "ogg"]
				@filemanager.fileList @documentpath+"/media", ext, (data)=>
					jdata = JSON.parse(data)
					dispdata = jdata['file']
					dispdata.sort (a, b)=>
						if (a < b)
							return -1
						else if (a > b)
							return 1
						else
							return 0
					@mediaview.setListData(dispdata)
					@mediaview.reload()

	didImageUpload:(res)->
		imgpath = @picturepath+"/"+res.path
		savefile = @documentpath+"/media/"
		@filemanager.moveItemAtPath imgpath, savefile, (err)=>
			if (err == 1)
				path = res.path
				thumb = path.replace(/\./, "_s.")
				@filemanager.removeItemAtPath(@picturepath+"/.thumb/"+thumb)
				ext = ["png", "jpg", "gif", "mp3", "ogg"]
				@filemanager.fileList @documentpath+"/media", ext, (data)=>
					jdata = JSON.parse(data)
					@mediaview.setListData(jdata['file'])
					@mediaview.reload()

	clickedButtonAtIndex:(ret, alert)->
		jret = JSON.parse(ret)
		switch alert.mode
			when "NEW CLASS"
				$.post "syslibs/enforce.php",
					mode: "derive"
					name: jret[0]
				, (data)=>
					ext = ["coffee"]
					@filemanager.fileList @documentpath+"/src", ext, (data)=>
						jdata = JSON.parse(data)
						@sourceview.setListData(jdata['file'])
						@sourceview.reload()
			when "DELETE FILE"
				if (ret == 1)
					fname = alert.fname
					JSLog("fname=%@", fname)
					@filemanager.removeItemAtPath @documentpath+"/src/"+alert.fname, (err)=>
						@mainview.editorview.setText("")
						@mainview.editorview.setEditable(false)
						@mainview.sourceinfo.setText("")
						@mainview.editfile = undefined
						ext = ["coffee"]
						@filemanager.fileList @documentpath+"/src", ext, (data)=>
							jdata = JSON.parse(data)
							@sourceview.setListData(jdata['file'])
							@sourceview.reload()
					
