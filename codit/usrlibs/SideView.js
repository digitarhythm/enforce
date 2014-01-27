var SideView,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

SideView = (function(_super) {

  __extends(SideView, _super);

  function SideView(frame) {
    SideView.__super__.constructor.call(this, frame);
    /*
    		Please describe initialization processing of a class below from here.
    */
    this.selecttab = 0;
    this.tabheight = 24;
    this.sourceview = void 0;
    this.mediaview = void 0;
    this.documentpath = JSSearchPathForDirectoriesInDomains("JSDocumentDirectory");
    this.enforcepath = this.documentpath + "/../..";
    this.picturepath = JSSearchPathForDirectoriesInDomains("JSPictureDirectory");
    this.filemanager = new JSFileManager();
    this.setClipToBounds(false);
  }

  SideView.prototype.viewDidAppear = function() {
    var select,
      _this = this;
    SideView.__super__.viewDidAppear.call(this);
    /*
    		Please describe the processing about a view below from here.
    */
    select = ["code", "media"];
    this.tabview = new JSSegmentedControl(select);
    this.tabview.setTextSize(9);
    this.tabview.setFrame(JSRectMake(0, 0, this._frame.size.width - 2, this.tabheight));
    this.tabview.setValue(this.selecttab);
    this.addSubview(this.tabview);
    this.tabview.addTarget(function() {
      _this.selecttab = _this.tabview._selectedSegmentIndex;
      return _this.dispListView();
    });
    this.sourceview = new JSListView(JSRectMake(0, this.tabview._frame.size.height, this._frame.size.width, this._frame.size.height - this.tabview._frame.size.height - 24));
    this.sourceview.setTextSize(14);
    this.sourceview.setBackgroundColor(JSColor("white"));
    this.sourceview.setHidden(true);
    this.addSubview(this.sourceview);
    this.sourceview.addTarget(function() {
      var fname;
      fname = _this.sourceview.objectAtIndex(_this.sourceview.getSelect());
      return _this.mainview.loadSourceFile(_this.documentpath + "/src/" + fname);
    });
    this.mediaview = new JSListView(JSRectMake(0, this.tabview._frame.size.height, this._frame.size.width, this._frame.size.height - this.tabview._frame.size.height - 24));
    this.mediaview.setTextSize(14);
    this.mediaview.setBackgroundColor(JSColor("white"));
    this.mediaview.setHidden(true);
    this.addSubview(this.mediaview);
    this.mediaview.addTarget(function() {
      var fname;
      fname = _this.mediaview.objectAtIndex(_this.mediaview.getSelect());
      return _this.mainview.dispImage(_this.enforcepath + "/media/" + fname);
    });
    return this.dispListView();
  };

  SideView.prototype.dispListView = function(tab) {
    var ext,
      _this = this;
    if (tab == null) tab = parseInt(this.selecttab);
    if ((this.addButton != null)) this.addButton.removeFromSuperview();
    switch (tab) {
      case 0:
        this.mainview.editorview.setHidden(false);
        this.mainview.imageview.setHidden(true);
        this.sourceview.setHidden(false);
        this.mediaview.setHidden(true);
        this.addButton = new JSButton(JSRectMake(0, this._frame.size.height - 24, 32, 24));
        this.addButton.setButtonTitle("+");
        this.addSubview(this.addButton);
        ext = ["coffee"];
        this.filemanager.fileList(this.documentpath + "/src", ext, function(data) {
          var jdata;
          jdata = JSON.parse(data);
          _this.sourceview.setListData(jdata['file']);
          return _this.sourceview.reload();
        });
        this.addButton.addTarget(function() {
          var alert;
          alert = new JSAlertView("Create New Class File", "Input new class file name.", [""]);
          alert.delegate = _this._self;
          alert.setAlertViewStyle("JSAlertViewStylePlainTextInput");
          alert.mode = "NEW CLASS";
          _this.addSubview(alert);
          return alert.show();
        });
        this.delbutton = new JSButton(JSRectMake(34, this._frame.size.height - 24, 32, 24));
        this.delbutton.setButtonTitle("-");
        this.addSubview(this.delbutton);
        return this.delbutton.addTarget(function() {
          var alert, fname;
          fname = _this.sourceview.objectAtIndex(_this.sourceview.getSelect());
          if ((fname != null)) {
            alert = new JSAlertView("Caution", "Delete '" + fname + "' OK?");
            alert.delegate = _this._self;
            alert.cancel = true;
            alert.mode = "DELETE FILE";
            alert.fname = fname;
            _this.addSubview(alert);
            return alert.show();
          }
        });
      case 1:
        this.mainview.editorview.setHidden(true);
        this.mainview.imageview.setHidden(false);
        this.sourceview.setHidden(true);
        this.mediaview.setHidden(false);
        this.addButton = new JSButton(JSRectMake(0, this._frame.size.height - 24, 64, 24));
        this.addButton.setStyle("JSFormButtonStyleImageUpload");
        this.addButton.delegate = this;
        this.addSubview(this.addButton);
        ext = ["png", "jpg", "gif", "mp3", "ogg"];
        return this.filemanager.fileList(this.documentpath + "/media", ext, function(data) {
          var jdata;
          jdata = JSON.parse(data);
          _this.mediaview.setListData(jdata['file']);
          return _this.mediaview.reload();
        });
    }
  };

  SideView.prototype.didImageUpload = function(res) {
    var imgpath, savefile,
      _this = this;
    imgpath = this.picturepath + "/" + res.path;
    savefile = this.documentpath + "/media/";
    return this.filemanager.moveItemAtPath(imgpath, savefile, function(err) {
      var ext, path, thumb;
      if (err === 1) {
        path = res.path;
        thumb = path.replace(/\./, "_s.");
        _this.filemanager.removeItemAtPath(_this.picturepath + "/.thumb/" + thumb);
        ext = ["png", "jpg", "gif", "mp3", "ogg"];
        return _this.filemanager.fileList(_this.documentpath + "/media", ext, function(data) {
          var jdata;
          jdata = JSON.parse(data);
          _this.mediaview.setListData(jdata['file']);
          return _this.mediaview.reload();
        });
      }
    });
  };

  SideView.prototype.clickedButtonAtIndex = function(ret, alert) {
    var fname, jret,
      _this = this;
    jret = JSON.parse(ret);
    switch (alert.mode) {
      case "NEW CLASS":
        return $.post("syslibs/enforce.php", {
          mode: "derive",
          name: jret[0]
        }, function(data) {
          var ext;
          ext = ["coffee"];
          return _this.filemanager.fileList(_this.documentpath + "/src", ext, function(data) {
            var jdata;
            jdata = JSON.parse(data);
            _this.sourceview.setListData(jdata['file']);
            return _this.sourceview.reload();
          });
        });
      case "DELETE FILE":
        if (ret === 1) {
          fname = alert.fname;
          JSLog("fname=%@", fname);
          return this.filemanager.removeItemAtPath(this.documentpath + "/src/" + alert.fname, function(err) {
            var ext;
            _this.mainview.editorview.setText("");
            _this.mainview.editorview.setEditable(false);
            _this.mainview.sourceinfo.setText("");
            _this.mainview.editfile = void 0;
            ext = ["coffee"];
            return _this.filemanager.fileList(_this.documentpath + "/src", ext, function(data) {
              var jdata;
              jdata = JSON.parse(data);
              _this.sourceview.setListData(jdata['file']);
              return _this.sourceview.reload();
            });
          });
        }
    }
  };

  return SideView;

})(JSView);
