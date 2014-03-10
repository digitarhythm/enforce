class MainView extends JSView
    constructor:(frame)->
        super(frame)
        ###
        Please describe initialization processing of a class below from here. 
        ###

        @userdefaults = new JSUserDefaults()
        @currentEditFile = ""
        @setClipToBounds(true)
        @prefview = undefined

        @editfile = undefined
        @filemanager = new JSFileManager()
        @documentpath = JSSearchPathForDirectoriesInDomains("JSDocumentDirectory")
        @keyarray = []

        @preference = []
        @userdefaults.stringForKey "preference", (data)=>
            if (data != "")
                @preference = data
            else
                @preference = [true, false, false]
        
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

        @memobutton = new JSButton(JSRectMake(@_frame.size.width - (32 + 2) * 2, 0, 32, 24))
        @memobutton.setButtonTitle("M")
        @addSubview(@memobutton)
        @memobutton.addTarget =>
            @dispMemoview()

        @infobutton = new JSButton(JSRectMake(@_frame.size.width - (32 + 2) * 3, 0, 32, 24))
        @infobutton.setButtonTitle("I")
        @addSubview(@infobutton)
        @infobutton.addTarget =>
            @dispInfoview()

        @prefbutton = new JSButton(JSRectMake(@_frame.size.width - (32 + 2) * 4, 0, 32, 24))
        @prefbutton.setButtonTitle("E")
        @addSubview(@prefbutton)
        @prefbutton.addTarget =>
            @dispPrefview()

        @editorview = new JSTextView(JSRectMake(4, 24, @_frame.size.width - 4, @_frame.size.height - 28 - 24))
        @editorview.setBackgroundColor(JSColor("#000020"))
        @editorview.setTextColor(JSColor("white"))
        @editorview.setTextSize(10)
        @editorview.setHidden(true)
        #@editorview.setEditable(false)
        @addSubview(@editorview)
        $(@editorview._viewSelector+"_textarea").keyup (e)=>
            @keyarray[e.keyCode] = false
        $(@editorview._viewSelector+"_textarea").keydown (e)=>
            @keyarray[e.keyCode] = true
            if (@keyarray[16] && @keyarray[91] && e.keyCode == 77)
                e.preventDefault()
                @dispMemoview()

        @memoview = new JSTextView(JSRectMake(@_frame.size.width, 24, 0, @_frame.size.height - 28))
        @memoview.setBackgroundColor(JSColor("#f0f0f0"))
        @memoview.setTextSize(10)
        @memoview.setHidden(false)
        @memoview.dispflag = false
        @addSubview(@memoview)
        @userdefaults.stringForKey "memo", (string)=>
            @memoview.setText(string)
        $(@memoview._viewSelector+"_textarea").keyup (e)=>
            @keyarray[e.keyCode] = false
        $(@memoview._viewSelector+"_textarea").keydown (e)=>
            @keyarray[e.keyCode] = true
            if (@keyarray[16] && @keyarray[91] && e.keyCode == 77)
                e.preventDefault()
                @dispMemoview()
        @imageRefresh()

        @infoview = new JSTextView(JSRectMake(4, @_frame.size.height - 24, @_frame.size.width - 4, 24))
        @infoview.setBackgroundColor(JSColor("#f0f0f0"))
        @infoview.setTextColor(JSColor("black"))
        @infoview.setTextSize(10)
        @infoview.setEditable(false)
        @infoview.dispflag = false
        @addSubview(@infoview)
        @infoview.addTapGesture =>
            @dispInfoview()

    imageRefresh:->
        if (@imageview?)
            @imageview.removeFromSuperview()
        size = JSSizeMake(parseInt(@_frame.size.width / 2), parseInt(@_frame.size.height / 2))
        @imageview = new JSImageView(JSRectMake((@_frame.size.width - size.width) / 2, (@_frame.size.height - size.height) / 2, size.width, size.height))
        @imageview.setContentMode("JSViewContentModeScaleAspectFit")
        @imageview.setHidden(true)
        @addSubview(@imageview)
    
    dispInfoview:(flagtmp = undefined)->
        if (!flagtmp?)
            flag = @infoview.dispflag
        else
            flag = (if (flagtmp == true) then false else true)
        if (flag == false)
            @infoview.dispflag = true
            @infoview.animateWithDuration 0.2, {top: @_frame.size.height - parseInt(@_frame.size.height / 3), height: parseInt(@_frame.size.height / 3)}
        else
            @infoview.dispflag = false
            @infoview.animateWithDuration 0.2, {top: @_frame.size.height - 24, height: 24}

    focusEditorview:->
        $(@editorview._viewSelector+"_textarea").focus()

    focusMemoview:->
        $(@memoview._viewSelector+"_textarea").focus()

    saveSource:->
        if (@editfile?)
            str = @editorview.getText()
            if (str != "")
                savepath = @documentpath+"/src/"+@editfile
                @filemanager.writeToFile savepath, str

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

    dispMemoview:->
        if (@memoview.dispflag == false)
            if (@preference[0] == true)
                $(@memoview._viewSelector+"_textarea").vixtarea()
            else
                $(@memoview._viewSelector+"_textarea").keydown (e)=>
                    if(e.keyCode == 9)
                        e.preventDefault()
                        elem = e.target
                        val = elem.value
                        pos = elem.selectionStart
                        elem.value = val.substr(0, pos) + '    ' + val.substr(pos, val.length)
                        elem.setSelectionRange(pos + 4, pos + 4)
            @memoview.dispflag = true
            @bringSubviewToFront(@memoview)
            @memoview.animateWithDuration 0.2, {left: Math.floor(@_frame.size.width / 3) * 2, width: Math.floor(@_frame.size.width / 3)}, =>
                @focusMemoview()
        else
            memostr = @memoview.getText()
            @userdefaults.setObject memostr, "memo"
            @memoview.dispflag = false
            @memoview.animateWithDuration 0.2, {left: @_frame.size.width, width:0}, =>
                @focusEditorview()

    loadSourceFile:(fpath)->
        if (@editorview?)
            @editorview.removeFromSuperview()
        @currentEditFile = fpath
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
            if (@preference[0] == true)
                $(@editorview._viewSelector+"_textarea").vixtarea({backgroundColor:"#000020",color:"white"})
            else
                $(@editorview._viewSelector+"_textarea").keydown (e)=>
                    if(e.keyCode == 9)
                        e.preventDefault()
                        elem = e.target
                        val = elem.value
                        pos = elem.selectionStart
                        elem.value = val.substr(0, pos) + '    ' + val.substr(pos, val.length)
                        elem.setSelectionRange(pos + 4, pos + 4)
                    
            @focusEditorview()
            $(@editorview._viewSelector+"_textarea").keyup (e)=>
                @keyarray[e.keyCode] = false
            $(@editorview._viewSelector+"_textarea").keydown (e)=>
                @keyarray[e.keyCode] = true
                if (@keyarray[16] && @keyarray[91] && e.keyCode == 82)
                    e.preventDefault()
                    @compileSource()
                if (@keyarray[16] && @keyarray[91] && e.keyCode == 89)
                    e.preventDefault()
                    @dispInfoview()
                if (@keyarray[16] && @keyarray[91] && e.keyCode == 77)
                    e.preventDefault()
                    @dispMemoview()
                if (@keyarray[16] && @keyarray[91] && e.keyCode == 69)
                    e.preventDefault()
                    @dispPrefview()

    dispImage:(fpath)->
        if (@editorview?)
            @editorview.setHidden(true)
        if (@imageview?)
            @imageview.setHidden(false)
        img = new JSImage(fpath)
        @imageview.setImage(img)

    dispPrefview:->
        if (@prefview?)
            return
        bounds = getBounds()
        @bgview = new JSView(bounds)
        @bgview.setBackgroundColor(JSColor("black"))
        @bgview.setAlpha(1.0)
        rootView.addSubview(@bgview)
        PREFWIDTH  = 320
        PREFHEIGHT = 240
        bounds = getBounds()
        @prefview = new PrefView(JSRectMake((bounds.size.width - PREFWIDTH) / 2, (bounds.size.height - PREFHEIGHT) / 2, PREFWIDTH, PREFHEIGHT))
        @prefview.delegate = @
        @bgview.addSubview(@prefview)

    closePrefview:->
        @prefRefresh()
        @prefview.removeFromSuperview()
        @prefview = undefined
        @bgview.removeFromSuperview()
        @bgview = undefined

    prefRefresh:->
        @userdefaults.stringForKey "preference", (data)=>
            if (data != "")
                @preference = data
            else
                @preference = [false, false, false]
            if (@currentEditFile != "")
                @saveSource()
                @loadSourceFile(@currentEditFile)
