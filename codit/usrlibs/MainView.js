var MainView,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

MainView = (function(_super) {

  __extends(MainView, _super);

  function MainView(frame) {
    MainView.__super__.constructor.call(this, frame);
    /*
    		Please describe initialization processing of a class below from here.
    */
    this.editfile = void 0;
    this.filemanager = new JSFileManager();
    this.documentpath = JSSearchPathForDirectoriesInDomains("JSDocumentDirectory");
    this.keyarray = [];
  }

  MainView.prototype.viewDidAppear = function() {
    var size,
      _this = this;
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
    this.savebutton.addTarget(function() {
      return _this.compileSource();
    });
    this.editorview = new JSTextView(JSRectMake(4, 24, this._frame.size.width - 4, this._frame.size.height - 28 - 24));
    this.editorview.setBackgroundColor(JSColor("#000020"));
    this.editorview.setTextColor(JSColor("white"));
    this.editorview.setTextSize(10);
    this.editorview.setHidden(true);
    this.editorview.setEditable(false);
    this.addSubview(this.editorview);
    size = JSSizeMake(parseInt(this._frame.size.width / 2), parseInt(this._frame.size.height / 2));
    this.imageview = new JSImageView(JSRectMake((this._frame.size.width - size.width) / 2, (this._frame.size.height - size.height) / 2, size.width, size.height));
    this.imageview.setContentMode("JSViewContentModeScaleAspectFit");
    this.imageview.setHidden(true);
    this.addSubview(this.imageview);
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
      this.infoview._frame.size.height = parseInt(this._frame.size.height / 3);
      this.infoview._frame.origin.y = this._frame.size.height - parseInt(this._frame.size.height / 3);
      return this.infoview.setFrame(this.infoview._frame);
    } else {
      this.infoview.dispflag = false;
      this.infoview._frame.size.height = 24;
      this.infoview._frame.origin.y = this._frame.size.height - 24;
      return this.infoview.setFrame(this.infoview._frame);
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
              _this.infoview.setText(err);
              return _this.dispInfoview(false);
            }
          });
        }
      });
    } else {
      return $.post("syslibs/enforce.php", {
        mode: "compile"
      }, function(err) {
        return _this.infoview.setText(err);
      });
    }
  };

  MainView.prototype.loadSourceFile = function(fpath) {
    var tmp,
      _this = this;
    if ((this.editorview != null)) this.editorview.removeFromSuperview();
    this.editorview = new JSTextView(JSRectMake(4, 24, this._frame.size.width - 4, this._frame.size.height - 28 - 24));
    this.editorview.setBackgroundColor(JSColor("#000020"));
    this.editorview.setTextColor(JSColor("white"));
    this.editorview.setTextSize(10);
    this.editorview.setEditable(false);
    this.addSubview(this.editorview);
    this.bringSubviewToFront(this.infoview);
    tmp = fpath.match(/.*\/(.*)/);
    this.editfile = tmp[1];
    this.imageview.setHidden(true);
    this.sourceinfo.setText(this.editfile);
    return this.filemanager.stringWithContentsOfFile(fpath, function(string) {
      _this.editorview.setText(string);
      _this.editorview.setEditable(true);
      _this.editorview.setHidden(false);
      $(_this.editorview._viewSelector + "_textarea").vixtarea({
        backgroundColor: "#000020",
        color: "white"
      });
      $(_this.editorview._viewSelector + "_textarea").keyup(function(e) {
        return _this.keyarray[e.keyCode] = false;
      });
      return $(_this.editorview._viewSelector + "_textarea").keydown(function(e) {
        _this.keyarray[e.keyCode] = true;
        if (_this.keyarray[17] && _this.keyarray[91] && e.keyCode === 83) {
          _this.compileSource();
        }
        if (_this.keyarray[17] && _this.keyarray[91] && e.keyCode === 89) {
          return _this.dispInfoview();
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

  return MainView;

})(JSView);
