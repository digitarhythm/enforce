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
    this.CELLHEIGHT = 24;
    this.selecttab = 0;
    this.tabheight = 24;
    this.dispdata = [];
    this.sourceview = void 0;
    this.mediaview = void 0;
    this.documentpath = JSSearchPathForDirectoriesInDomains("JSDocumentDirectory");
    this.enforcepath = this.documentpath + "/../..";
    this.picturepath = JSSearchPathForDirectoriesInDomains("JSPictureDirectory");
    this.filemanager = new JSFileManager();
    this.setClipToBounds(false);
    this.lastedittab = void 0;
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
    this.sourceview = new JSTableView(JSRectMake(0, this.tabview._frame.size.height, this._frame.size.width, this._frame.size.height - this.tabview._frame.size.height - 24));
    this.sourceview.delegate = this.sourceview.dataSource = this._self;
    this.sourceview._titleBar.setText("source list");
    this.addSubview(this.sourceview);
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
    if ((this.delButton != null)) this.delButton.removeFromSuperview();
    if ((this.renameButton != null)) this.renameButton.removeFromSuperview();
    switch (tab) {
      case 0:
        if ((this.mainview.editorview != null)) {
          this.mainview.editorview.setHidden(false);
        }
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
          _this.dispdata = jdata['file'];
          _this.dispdata.sort(function(a, b) {
            if (a < b) {
              return -1;
            } else if (a > b) {
              return 1;
            } else {
              return 0;
            }
          });
          _this.sourceview.reloadData();
          return $(_this.sourceview._viewSelector + "_select").focus();
        });
        this.addButton.addTarget(function() {
          var alert;
          alert = new JSAlertView("Create New Class File", "Input new class file name.", [""]);
          alert.delegate = _this._self;
          alert.setAlertViewStyle("JSAlertViewStylePlainTextInput");
          alert.delegate = _this;
          alert.mode = "NEW_CLASS";
          _this.addSubview(alert);
          return alert.show();
        });
        this.delButton = new JSButton(JSRectMake(this._frame.size.width - 32, this._frame.size.height - 24, 32, 24));
        this.delButton.setButtonTitle("-");
        this.addSubview(this.delButton);
        return this.delButton.addTarget(function() {
          var alert, fname;
          fname = _this.sourceview.objectAtIndex(_this.sourceview.getSelect());
          if ((fname != null)) {
            alert = new JSAlertView("Caution", "Delete '" + fname + "' OK?");
            alert.delegate = _this._self;
            alert.cancel = true;
            alert.mode = "DELETE_FILE";
            alert.fname = fname;
            _this.addSubview(alert);
            return alert.show();
          }
        });
      case 1:
        if ((this.mainview.editorview != null)) {
          this.mainview.editorview.setHidden(true);
        }
        this.mainview.imageview.setHidden(false);
        this.sourceview.setHidden(true);
        this.mediaview.setHidden(false);
        this.addButton = new JSButton(JSRectMake(0, this._frame.size.height - 24, 64, 24));
        this.addButton.setStyle("JSFormButtonStyleImageUpload");
        this.addButton.delegate = this._self;
        this.addSubview(this.addButton);
        this.renameButton = new JSButton(JSRectMake(this.addButton._frame.size.width + 4, this._frame.size.height - 24, 64, 24));
        this.renameButton.setButtonTitle("リネーム");
        this.renameButton.addTarget(function() {
          var alert, fname, num;
          num = _this.mediaview.getSelect();
          fname = _this.mediaview.objectAtIndex(num);
          alert = new JSAlertView("ファイル名変更", "新しいファイル名を入力してください。", ["新ファイル名"]);
          alert.oldfname = fname;
          alert.setData([fname]);
          alert.cancel = true;
          alert.setAlertViewStyle("JSAlertViewStylePlainTextInput");
          alert.delegate = _this._self;
          alert.mode = "IMAGE_RENAME";
          _this.addSubview(alert);
          return alert.show();
        });
        this.addSubview(this.renameButton);
        this.delButton = new JSButton(JSRectMake(this._frame.size.width - 32, this._frame.size.height - 24, 32, 24));
        this.delButton.setButtonTitle("-");
        this.delButton.addTarget(function() {
          var alert, fname;
          fname = _this.mediaview.objectAtIndex(_this.mediaview.getSelect());
          if ((fname != null)) {
            alert = new JSAlertView("Caution", "Delete '" + fname + "' OK?");
            alert.delegate = _this._self;
            alert.cancel = true;
            alert.mode = "DELETE_IMAGE";
            alert.fname = fname;
            _this.addSubview(alert);
            return alert.show();
          }
        });
        this.addSubview(this.delButton);
        ext = ["png", "jpg", "gif", "mp3", "ogg", "dae"];
        return this.filemanager.fileList(this.documentpath + "/media", ext, function(data) {
          var jdata;
          jdata = JSON.parse(data);
          _this.dispdata = jdata['file'];
          _this.dispdata.sort(function(a, b) {
            if (a < b) {
              return -1;
            } else if (a > b) {
              return 1;
            } else {
              return 0;
            }
          });
          _this.mediaview.setListData(_this.dispdata);
          return _this.mediaview.reload();
        });
    }
  };

  SideView.prototype.didImageUpload = function(res) {
    var imgpath, savefile,
      _this = this;
    imgpath = this.picturepath + "/" + res.path;
    savefile = this.documentpath + "/media/" + res.path;
    return this.filemanager.moveItemAtPath(imgpath, savefile, function(err) {
      var ext, path, thumb;
      if (err === 1) {
        path = res.path;
        thumb = path.replace(/\./, "_s.");
        _this.filemanager.removeItemAtPath(_this.picturepath + "/.thumb/" + thumb);
        ext = ["png", "jpg", "gif", "mp3", "ogg", "dae"];
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
    var ext, fname, jret, newfpath, oldfpath,
      _this = this;
    jret = JSON.parse(ret);
    switch (alert.mode) {
      case "NEW_CLASS":
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
      case "DELETE_FILE":
        if (ret === 1) {
          fname = alert.fname;
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
              _this.sourceview.reload();
              _this.mainview.sourceview.setText("");
              return _this.mainview.sourceview.setHidden(true);
            });
          });
        }
        break;
      case "DELETE_IMAGE":
        if (ret === 1) {
          fname = alert.fname;
          return this.filemanager.removeItemAtPath(this.documentpath + "/media/" + alert.fname, function(err) {
            var ext;
            _this.mainview.editorview.setText("");
            _this.mainview.editorview.setEditable(false);
            _this.mainview.sourceinfo.setText("");
            _this.mainview.editfile = void 0;
            ext = ["png", "jpg", "gif", "mp3", "ogg", "dae"];
            return _this.filemanager.fileList(_this.documentpath + "/media", ext, function(data) {
              var jdata;
              jdata = JSON.parse(data);
              _this.mediaview.setListData(jdata['file']);
              _this.mediaview.reload();
              return _this.mainview.imageRefresh();
            });
          });
        }
        break;
      case "IMAGE_RENAME":
        fname = jret[0];
        ext = fname.match(/.*\.(.*)/);
        if (ext === null) {
          alert = new JSAlertView("Caution", "拡張子を指定してください。");
          this.addSubview(alert);
          return alert.show();
        } else {
          oldfpath = this.documentpath + "/media/" + alert.oldfname;
          newfpath = this.documentpath + "/media/" + fname;
          return this.filemanager.moveItemAtPath(oldfpath, newfpath, function(err) {
            ext = ["png", "jpg", "gif", "mp3", "ogg", "dae"];
            return _this.filemanager.fileList(_this.documentpath + "/media", ext, function(data) {
              var jdata;
              jdata = JSON.parse(data);
              _this.mediaview.setListData(jdata['file']);
              return _this.mediaview.reload();
            });
          });
        }
    }
  };

  SideView.prototype.numberOfRowsInSection = function() {
    return this.dispdata.length;
  };

  SideView.prototype.cellForRowAtIndexPath = function(i) {
    var cell, fname;
    cell = new JSTableViewCell();
    cell.setBorderColor(JSColor("clearColor"));
    cell.setBorderWidth(0);
    cell.delegate = this._self;
    fname = this.dispdata[i].match(/(.*).coffee/);
    cell.setText(fname[1]);
    cell.setTextSize(14);
    return cell;
  };

  SideView.prototype.heightForRowAtIndexPath = function(num) {
    return this.CELLHEIGHT;
  };

  SideView.prototype.didSelectRowAtIndexPath = function(num, e) {
    var cell, fname;
    fname = this.dispdata[num];
    this.mainview.loadSourceFile(this.documentpath + "/src/" + fname);
    if ((this.lastedittab != null)) {
      this.sourceview.cellForRowAtIndexPath(this.lastedittab).setBackgroundColor(JSColor("clearColor"));
    }
    cell = this.sourceview.cellForRowAtIndexPath(num);
    cell.setBackgroundColor(JSColor("#abcdef"));
    return this.lastedittab = num;
  };

  return SideView;

})(JSView);