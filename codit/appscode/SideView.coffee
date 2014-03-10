class SideView extends JSView
    constructor:(frame)->
        super(frame)
        ###
        Please describe initialization processing of a class below from here. 
        ###

        @CELLHEIGHT = 20
        @TABHEIGHT = 24

        @selecttab = 0
        @dispdata = []
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

        # ソースビューとメディアビューのタブ
        select = ["code", "media"]
        @tabview = new JSSegmentedControl(select)
        @tabview.setTextSize(9)
        @tabview.setFrame(JSRectMake(0, 0, @_frame.size.width - 2, @TABHEIGHT))
        @tabview.setValue(@selecttab)
        @addSubview(@tabview)
        @tabview.addTarget =>
            @selecttab = @tabview._selectedSegmentIndex
            @dispListView()

        @sourceview = new SourceView(JSRectMake(0, @tabview._frame.size.height, @_frame.size.width, @_frame.size.height - @tabview._frame.size.height - 64))
        @sourceview._titleBar.setText("source list")
        @addSubview(@sourceview)
        #@sourceview.setBorderWidth(1)
        #@sourceview.setBorderColor(JSColor("red"))

        @mediaview = new MediaView(JSRectMake(0, @tabview._frame.size.height, @_frame.size.width, @_frame.size.height - @tabview._frame.size.height - 64))
        @mediaview._titleBar.setText("media list")
        @addSubview(@mediaview)
        ###
        @mediaview = new JSListView(JSRectMake(0, @tabview._frame.size.height, @_frame.size.width, @_frame.size.height - @tabview._frame.size.height - 24))
        @mediaview.setTextSize(14)
        @mediaview.setBackgroundColor(JSColor("white"))
        @mediaview.setHidden(true)
        @addSubview(@mediaview)
        @mediaview.addTarget =>
            fname = @mediaview.objectAtIndex(@mediaview.getSelect())
            @mainview.dispImage(@enforcepath+"/media/"+fname)
        ###

        @dispListView()

    dispListView:(tab = parseInt(@selecttab))->
        if (@addButton?)
            @addButton.removeFromSuperview()
        if (@delButton?)
            @delButton.removeFromSuperview()
        if (@renameButton?)
            @renameButton.removeFromSuperview()
        switch tab
            when 0 # ソースモード
                dir = @documentpath+"/src"
                ext = ["coffee"]

                if (@mainview.editorview?)
                    @mainview.editorview.setHidden(false)
                @mainview.imageview.setHidden(true)
                @sourceview.setHidden(false)
                @mediaview.setHidden(true)
                @addButton = new JSButton(JSRectMake(0, @_frame.size.height - 24, 32, 24))
                @addButton.setButtonTitle("+")
                @addSubview(@addButton)
                @filemanager.fileList dir, ext, (data)=>
                    jdata = JSON.parse(data)['file']
                    @sourceview.dispdata = jdata
                    @sourceview.dispdata.sort (a, b)=>
                        if (a < b)
                            return -1
                        else if (a > b)
                            return 1
                        else
                            return 0
                    @sourceview.reloadData()
                    $(@sourceview._viewSelector+"_select").focus()
                @addButton.addTarget =>
                    alert = new JSAlertView("Create New Class File", "Input new class file name.", [""])
                    alert.delegate = @_self
                    alert.setAlertViewStyle("JSAlertViewStylePlainTextInput")
                    alert.delegate = @
                    alert.mode = "NEW_CLASS"
                    @addSubview(alert)
                    alert.show()
                @delButton = new JSButton(JSRectMake(@_frame.size.width - 32, @_frame.size.height - 24, 32, 24))
                @delButton.setButtonTitle("-")
                @addSubview(@delButton)
                @delButton.addTarget =>
                    fname = @sourceview.dispdata[@sourceview.lastedittab]
                    if (fname?)
                        alert = new JSAlertView("Caution", "Delete '"+fname+"' OK?")
                        alert.delegate = @_self
                        alert.cancel = true
                        alert.mode = "DELETE_FILE"
                        alert.fname = fname
                        @addSubview(alert)
                        alert.show()

            when 1 # メディアモード
                dir = @documentpath+"/media"
                ext = ["png", "jpg", "gif", "mp3", "ogg", "dae"]

                if (@mainview.editorview?)
                    @mainview.editorview.setHidden(true)
                @mainview.imageview.setHidden(false)
                @sourceview.setHidden(true)
                @mediaview.setHidden(false)
                @addButton = new JSButton(JSRectMake(0, @_frame.size.height - 24, 64, 24))
                @addButton.setStyle("JSFormButtonStyleImageUpload")
                @addButton.delegate = @_self
                @addSubview(@addButton)
                @renameButton = new JSButton(JSRectMake(@addButton._frame.size.width + 4, @_frame.size.height - 24, 64, 24))
                @renameButton.setButtonTitle("リネーム")
                @renameButton.addTarget =>
                    num = @mediaview.getSelect()
                    fname = @mediaview.objectAtIndex(num)
                    alert = new JSAlertView("ファイル名変更", "新しいファイル名を入力してください。", ["新ファイル名"])
                    alert.oldfname = fname
                    alert.setData([fname])
                    alert.cancel = true
                    alert.setAlertViewStyle("JSAlertViewStylePlainTextInput")
                    alert.delegate = @_self
                    alert.mode = "IMAGE_RENAME"
                    @addSubview(alert)
                    alert.show()
                @addSubview(@renameButton)
                @delButton = new JSButton(JSRectMake(@_frame.size.width - 32, @_frame.size.height - 24, 32, 24))
                @delButton.setButtonTitle("-")
                @delButton.addTarget =>
                    fname = @mediaview.dispdata[@lastedittab]
                    if (fname?)
                        alert = new JSAlertView("Caution", "Delete '"+fname+"' OK?")
                        alert.delegate = @_self
                        alert.cancel = true
                        alert.mode = "DELETE_IMAGE"
                        alert.fname = fname
                        @addSubview(alert)
                        alert.show()
                @addSubview(@delButton)
                ext = ["png", "jpg", "gif", "mp3", "ogg", "dae"]
                @filemanager.fileList dir, ext, (data)=>
                    @mediaview.dispdata = JSON.parse(data)['file']
                    @mediaview.dispdata.sort (a, b)=>
                        if (a < b)
                            return -1
                        else if (a > b)
                            return 1
                        else
                            return 0
                    @mediaview.reloadData()

    didImageUpload:(res)->
        imgpath = @picturepath+"/"+res.path
        savefile = @documentpath+"/media/"+res.path
        @filemanager.moveItemAtPath imgpath, savefile, (err)=>
            if (err == 1)
                path = res.path
                thumb = path.replace(/\./, "_s.")
                @filemanager.removeItemAtPath(@picturepath+"/.thumb/"+thumb)
                ext = ["png", "jpg", "gif", "mp3", "ogg", "dae"]
                @filemanager.fileList @documentpath+"/media", ext, (data)=>
                    jdata = JSON.parse(data)
                    @mediaview.setListData(jdata['file'])
                    @mediaview.reload()

    clickedButtonAtIndex:(ret, alert)->
        jret = JSON.parse(ret)
        switch alert.mode
            when "NEW_CLASS"
                $.post "syslibs/enforce.php",
                    mode: "derive"
                    name: jret[0]
                , (data)=>
                    ext = ["coffee"]
                    @filemanager.fileList @documentpath+"/src", ext, (data)=>
                        datatmp = JSON.parse(data)
                        @dispdata = []
                        for d in datatmp['file']
                            @dispdata.push(d)
                        @dispdata.sort()
                        #@sourceview.setListData(jdata['file'])
                        @sourceview.reloadData()
            when "DELETE_FILE"
                if (ret == 1)
                    fname = alert.fname
                    @filemanager.removeItemAtPath @documentpath+"/src/"+alert.fname, (err)=>
                        @mainview.editorview.setText("")
                        @mainview.editorview.setEditable(false)
                        @mainview.sourceinfo.setText("")
                        @mainview.editfile = undefined
                        ext = ["coffee"]
                        @filemanager.fileList @documentpath+"/src", ext, (data)=>
                            datatmp = JSON.parse(data)
                            @dispdata = []
                            for d in datatmp['file']
                                @dispdata.push(d)
                            @dispdata.sort()
                            #@sourceview.setListData(jdata['file'])
                            @sourceview.reloadData()
                            @mainview.editorview.setText("")
                            #@mainview.sourceview.setHidden(true)
            when "DELETE_IMAGE"
                if (ret == 1)
                    fname = alert.fname
                    @filemanager.removeItemAtPath @documentpath+"/media/"+alert.fname, (err)=>
                        @mainview.editorview.setText("")
                        @mainview.editorview.setEditable(false)
                        @mainview.sourceinfo.setText("")
                        @mainview.editfile = undefined
                        ext = ["png", "jpg", "gif", "mp3", "ogg", "dae"]
                        @filemanager.fileList @documentpath+"/media", ext, (data)=>
                            jdata = JSON.parse(data)
                            @mediaview.setListData(jdata['file'])
                            @mediaview.reload()
                            @mainview.imageRefresh()
            when "IMAGE_RENAME"
                fname = jret[0];
                ext = fname.match(/.*\.(.*)/)
                if (ext == null)
                    alert = new JSAlertView("Caution", "拡張子を指定してください。")
                    @addSubview(alert)
                    alert.show()
                else
                    oldfpath = @documentpath+"/media/"+alert.oldfname
                    newfpath = @documentpath+"/media/"+fname
                    @filemanager.moveItemAtPath oldfpath, newfpath, (err)=>
                        ext = ["png", "jpg", "gif", "mp3", "ogg", "dae"]
                        @filemanager.fileList @documentpath+"/media", ext, (data)=>
                            jdata = JSON.parse(data)
                            @mediaview.setListData(jdata['file'])
                            @mediaview.reload()
                        
                 
