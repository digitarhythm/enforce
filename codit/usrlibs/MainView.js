var MainView,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

MainView = (function(_super) {

  __extends(MainView, _super);

  function MainView(frame) {
    var _this = this;
    MainView.__super__.constructor.call(this, frame);
    /*
            Please describe initialization processing of a class below from here.
    */
    this.userdefaults = new JSUserDefaults();
    this.currentEditFile = "";
    this.setClipToBounds(true);
    this.prefview = void 0;
    this.editfile = void 0;
    this.filemanager = new JSFileManager();
    this.documentpath = JSSearchPathForDirectoriesInDomains("JSDocumentDirectory");
    this.keyarray = [];
    this.preference = [];
    this.userdefaults.stringForKey("preference", function(data) {
      if (data !== "") {
        return _this.preference = data;
      } else {
        return _this.preference = [true, false, false];
      }
    });
  }

  MainView.prototype.viewDidAppear = function() {
    var _this = this;
    MainView.__super__.viewDidAppear.call(this);
    /*
            Please describe the processing about a view below from here.
    */
    this.sourceinfo = new JSTextField(JSRectMake(4, 0, parseInt(this._frame.size.width / 2), 24));
    this.sourceinfo.setEditable(false);
    this.sourceinfo.setBackgroundColor(JSColor("clearColor"));
    this.sourceinfo.setTextSize(14);
    this.sourceinfo.setTextAlignment("JSTextAlignmentLeft");
    this.addSubview(this.sourceinfo);
    this.savebutton = new JSButton(JSRectMake(this._frame.size.width - 32, 0, 32, 24));
    this.savebutton.setButtonTitle("◯");
    this.addSubview(this.savebutton);
    this.savebutton.addTarget(function(e) {
      e.preventDefault();
      return _this.compileSource();
    });
    this.memobutton = new JSButton(JSRectMake(this._frame.size.width - (32 + 2) * 2, 0, 32, 24));
    this.memobutton.setButtonTitle("M");
    this.addSubview(this.memobutton);
    this.memobutton.addTarget(function() {
      return _this.dispMemoview();
    });
    this.infobutton = new JSButton(JSRectMake(this._frame.size.width - (32 + 2) * 3, 0, 32, 24));
    this.infobutton.setButtonTitle("I");
    this.addSubview(this.infobutton);
    this.infobutton.addTarget(function() {
      return _this.dispInfoview();
    });
    this.prefbutton = new JSButton(JSRectMake(this._frame.size.width - (32 + 2) * 4, 0, 32, 24));
    this.prefbutton.setButtonTitle("E");
    this.addSubview(this.prefbutton);
    this.prefbutton.addTarget(function() {
      return _this.dispPrefview();
    });
    this.editorview = new JSTextView(JSRectMake(4, 24, this._frame.size.width - 4, this._frame.size.height - 28 - 24));
    this.editorview.setBackgroundColor(JSColor("#000020"));
    this.editorview.setTextColor(JSColor("white"));
    this.editorview.setTextSize(10);
    this.editorview.setHidden(true);
    this.addSubview(this.editorview);
    $(this.editorview._viewSelector + "_textarea").keyup(function(e) {
      return _this.keyarray[e.keyCode] = false;
    });
    $(this.editorview._viewSelector + "_textarea").keydown(function(e) {
      _this.keyarray[e.keyCode] = true;
      if (_this.keyarray[16] && _this.keyarray[91] && e.keyCode === 77) {
        e.preventDefault();
        return _this.dispMemoview();
      }
    });
    this.memoview = new JSTextView(JSRectMake(this._frame.size.width, 24, 0, this._frame.size.height - 28));
    this.memoview.setBackgroundColor(JSColor("#f0f0f0"));
    this.memoview.setTextSize(10);
    this.memoview.setHidden(false);
    this.memoview.dispflag = false;
    this.addSubview(this.memoview);
    this.userdefaults.stringForKey("memo", function(string) {
      return _this.memoview.setText(string);
    });
    if (this.preference[0] === true) {
      $(this.memoview._viewSelector + "_textarea").vixtarea();
    }
    $(this.memoview._viewSelector + "_textarea").keyup(function(e) {
      return _this.keyarray[e.keyCode] = false;
    });
    $(this.memoview._viewSelector + "_textarea").keydown(function(e) {
      _this.keyarray[e.keyCode] = true;
      if (_this.keyarray[16] && _this.keyarray[91] && e.keyCode === 77) {
        e.preventDefault();
        return _this.dispMemoview();
      }
    });
    this.imageRefresh();
    this.infoview = new JSTextView(JSRectMake(4, this._frame.size.height - 24, this._frame.size.width - 4, 24));
    this.infoview.setBackgroundColor(JSColor("#f0f0f0"));
    this.infoview.setTextColor(JSColor("black"));
    this.infoview.setTextSize(10);
    this.infoview.setEditable(false);
    this.infoview.dispflag = false;
    this.addSubview(this.infoview);
    return this.infoview.addTapGesture(function() {
      return _this.dispInfoview();
    });
  };

  MainView.prototype.imageRefresh = function() {
    var size;
    if ((this.imageview != null)) this.imageview.removeFromSuperview();
    size = JSSizeMake(parseInt(this._frame.size.width / 2), parseInt(this._frame.size.height / 2));
    this.imageview = new JSImageView(JSRectMake((this._frame.size.width - size.width) / 2, (this._frame.size.height - size.height) / 2, size.width, size.height));
    this.imageview.setContentMode("JSViewContentModeScaleAspectFit");
    this.imageview.setHidden(true);
    return this.addSubview(this.imageview);
  };

  MainView.prototype.dispInfoview = function(flagtmp) {
    var flag;
    if (flagtmp == null) flagtmp = void 0;
    if (!(flagtmp != null)) {
      flag = this.infoview.dispflag;
    } else {
      flag = (flagtmp === true ? false : true);
    }
    if (flag === false) {
      this.infoview.dispflag = true;
      return this.infoview.animateWithDuration(0.2, {
        top: this._frame.size.height - parseInt(this._frame.size.height / 3),
        height: parseInt(this._frame.size.height / 3)
      });
    } else {
      this.infoview.dispflag = false;
      return this.infoview.animateWithDuration(0.2, {
        top: this._frame.size.height - 24,
        height: 24
      });
    }
  };

  MainView.prototype.focusEditorview = function() {
    return $(this.editorview._viewSelector + "_textarea").focus();
  };

  MainView.prototype.focusMemoview = function() {
    return $(this.memoview._viewSelector + "_textarea").focus();
  };

  MainView.prototype.saveSource = function() {
    var savepath, str;
    if ((this.editfile != null)) {
      str = this.editorview.getText();
      savepath = this.documentpath + "/src/" + this.editfile;
      return this.filemanager.writeToFile(savepath, str);
    }
  };

  MainView.prototype.compileSource = function() {
    var savepath, str,
      _this = this;
    if ((this.editfile != null)) {
      str = this.editorview.getText();
      savepath = this.documentpath + "/src/" + this.editfile;
      return this.filemanager.writeToFile(savepath, str, function(err) {
        if (err === 1) {
          return $.post("syslibs/enforce.php", {
            mode: "compile"
          }, function(err) {
            if (err !== "") {
              _this.infoview.setText(err);
              return _this.dispInfoview(true);
            } else {
              _this.infoview.setText("no error.");
              return _this.dispInfoview(false);
            }
          });
        }
      });
    } else {
      return $.post("syslibs/enforce.php", {
        mode: "compile"
      }, function(err) {
        if (err !== "") {
          _this.infoview.setText(err);
          return _this.dispInfoview(true);
        } else {
          _this.infoview.setText("no error.");
          return _this.dispInfoview(false);
        }
      });
    }
  };

  MainView.prototype.dispMemoview = function() {
    var memostr,
      _this = this;
    if (this.memoview.dispflag === false) {
      this.memoview.dispflag = true;
      this.bringSubviewToFront(this.memoview);
      return this.memoview.animateWithDuration(0.2, {
        left: Math.floor(this._frame.size.width / 3) * 2,
        width: Math.floor(this._frame.size.width / 3)
      }, function() {
        return _this.focusMemoview();
      });
    } else {
      memostr = this.memoview.getText();
      this.userdefaults.setObject(memostr, "memo");
      this.memoview.dispflag = false;
      return this.memoview.animateWithDuration(0.2, {
        left: this._frame.size.width,
        width: 0
      }, function() {
        return _this.focusEditorview();
      });
    }
  };

  MainView.prototype.loadSourceFile = function(fpath) {
    var tmp,
      _this = this;
    if ((this.editorview != null)) this.editorview.removeFromSuperview();
    this.currentEditFile = fpath;
    this.editorview = new JSTextView(JSRectMake(4, 24, this._frame.size.width - 4, this._frame.size.height - 28 - 24));
    this.editorview.setBackgroundColor(JSColor("#000020"));
    this.editorview.setTextColor(JSColor("white"));
    this.editorview.setTextSize(10);
    this.addSubview(this.editorview);
    this.bringSubviewToFront(this.infoview);
    tmp = fpath.match(/.*\/(.*)/);
    this.editfile = tmp[1];
    this.imageview.setHidden(true);
    this.sourceinfo.setText(this.editfile);
    return this.filemanager.stringWithContentsOfFile(fpath, function(string) {
      _this.editorview.setEditable(true);
      _this.editorview.setHidden(false);
      _this.editorview.setText(string);
      if (_this.preference[0] === true) {
        $(_this.editorview._viewSelector + "_textarea").vixtarea({
          backgroundColor: "#000020",
          color: "white"
        });
      } else {
        $(_this.editorview._viewSelector + "_textarea").keydown(function(e) {
          var elem, pos, val;
          if (e.keyCode === 9) {
            e.preventDefault();
            elem = e.target;
            val = elem.value;
            pos = elem.selectionStart;
            elem.value = val.substr(0, pos) + '    ' + val.substr(pos, val.length);
            return elem.setSelectionRange(pos + 4, pos + 4);
          }
        });
      }
      _this.focusEditorview();
      $(_this.editorview._viewSelector + "_textarea").keyup(function(e) {
        return _this.keyarray[e.keyCode] = false;
      });
      return $(_this.editorview._viewSelector + "_textarea").keydown(function(e) {
        _this.keyarray[e.keyCode] = true;
        if (_this.keyarray[16] && _this.keyarray[91] && e.keyCode === 82) {
          e.preventDefault();
          _this.compileSource();
        }
        if (_this.keyarray[16] && _this.keyarray[91] && e.keyCode === 89) {
          e.preventDefault();
          _this.dispInfoview();
        }
        if (_this.keyarray[16] && _this.keyarray[91] && e.keyCode === 77) {
          e.preventDefault();
          return _this.dispMemoview();
        }
      });
    });
  };

  MainView.prototype.dispImage = function(fpath) {
    var img;
    if ((this.editorview != null)) this.editorview.setHidden(true);
    if ((this.imageview != null)) this.imageview.setHidden(false);
    img = new JSImage(fpath);
    return this.imageview.setImage(img);
  };

  MainView.prototype.dispPrefview = function() {
    var PREFHEIGHT, PREFWIDTH, bounds;
    if ((this.prefview != null)) return;
    bounds = getBounds();
    this.bgview = new JSView(bounds);
    this.bgview.setBackgroundColor(JSColor("black"));
    this.bgview.setAlpha(0.9);
    rootView.addSubview(this.bgview);
    PREFWIDTH = 320;
    PREFHEIGHT = 240;
    bounds = getBounds();
    this.prefview = new PrefView(JSRectMake((bounds.size.width - PREFWIDTH) / 2, (bounds.size.height - PREFHEIGHT) / 2, PREFWIDTH, PREFHEIGHT));
    this.prefview.delegate = this;
    return this.bgview.addSubview(this.prefview);
  };

  MainView.prototype.closePrefview = function() {
    this.prefRefresh();
    this.prefview.removeFromSuperview();
    this.prefview = void 0;
    this.bgview.removeFromSuperview();
    return this.bgview = void 0;
  };

  MainView.prototype.prefRefresh = function() {
    var _this = this;
    return this.userdefaults.stringForKey("preference", function(data) {
      if (data !== "") {
        _this.preference = data;
      } else {
        _this.preference = [false, false, false];
      }
      if (_this.currentEditFile !== "") {
        _this.saveSource();
        return _this.loadSourceFile(_this.currentEditFile);
      }
    });
  };

  return MainView;

})(JSView);
