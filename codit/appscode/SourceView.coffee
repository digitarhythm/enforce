class SourceView extends JSTableView
    constructor:(frame)->
        super(frame)
        ###
        Please describe user processing below from here. 
        ###
        @CELLHEIGHT = 20

        @lastedittab = undefined
        @dispdata = []
        @delegate = @dataSource = @_self

        @documentpath = JSSearchPathForDirectoriesInDomains("JSDocumentDirectory")
        @enforcepath = @documentpath+"/../.."
        @picturepath = JSSearchPathForDirectoriesInDomains("JSPictureDirectory")

    numberOfRowsInSection:->
        return @dispdata.length

    cellForRowAtIndexPath:(i)->
        if (!@childlist[i]?)
            cell = new JSTableViewCell()
        else
            cell = @childlist[i]
            cell.setBackgroundColor(JSColor("clearColor"))
        cell.setBorderColor(JSColor("clearColor"))
        cell.setBorderWidth(0)
        cell.delegate = @_self
        fname = @dispdata[i].match(/(.*)\..*/)
        cell.setText(fname[1])
        cell.setTextSize(14)
        return cell

    heightForRowAtIndexPath:(num)->
        return @CELLHEIGHT

    didSelectRowAtIndexPath:(num, e)->
        if (@lastedittab == num)
            return
        fname = @dispdata[num]
        @_parent.mainview.loadSourceFile(fname)
        if (@lastedittab?)
            @childlist[@lastedittab].setBackgroundColor(JSColor("clearColor"))
        cell = @cellForRowAtIndexPath(num)
        cell.setBackgroundColor(JSColor("#abcdef"))
        @lastedittab = num
