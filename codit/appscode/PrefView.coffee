class PrefView extends JSView
    constructor:(frame)->
        super(frame)
        ###
        Please describe initialization processing of a class below from here. 
        ###

        @setCornerRadius(6.0)
        @setShadow(true)

        @userdefaults = new JSUserDefaults()
        @preference = []

        dialogtitle = new JSLabel(JSRectMake(8, 4, 120, 48))
        dialogtitle.setText("環境設定")
        dialogtitle.setTextSize(12)
        dialogtitle.setTextAlignment("JSTextAlignmentLeft")
        dialogtitle.setTextColor(JSColor("black"))
        @addSubview(dialogtitle)

        # OKボタン ###################################################
        @applybutton = new JSButton(JSRectMake(@_frame.size.width - 84 * 1, @_frame.size.height - 28, 80, 24))
        @applybutton.setButtonTitle("OK")
        @addSubview(@applybutton)
        @applybutton.addTarget =>
            @animateWithDuration 0.2, {alpha:0.0}, =>
                @preference[0] = @vimode.getValue()
                @userdefaults.setObject @preference, "preference"
                @delegate.closePrefview()
        
        # Cancelボタン ##############################################
        @cancelbutton = new JSButton(JSRectMake(@_frame.size.width - 84 * 2, @_frame.size.height - 28, 80, 24))
        @cancelbutton.setButtonTitle("Cancel")
        @addSubview(@cancelbutton)
        @cancelbutton.addTarget =>
            @animateWithDuration 0.2, {alpha:0.0}, =>
                @delegate.closePrefview()

        # 初期設定 #################################################
        @userdefaults.stringForKey "preference", (data)=>
            if (data != "")
                @preference = data
            else
                @preference[0] = false
                @preference[1] = false
                @preference[2] = false
            @vimodetext = new JSLabel(JSRectMake(8, 64, 64, 24))
            @vimodetext.setText("vi mode")
            @addSubview(@vimodetext)
            @vimode = new JSSwitch(JSRectMake(@_frame.size.width - 120, 64, 80, 24))
            @vimode.setValue(@preference[0])
            @addSubview(@vimode)

    viewDidAppear:->
        super()
        ###
        Please describe the processing about a view below from here. 
        ###

