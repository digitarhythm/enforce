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
      var savepath, str;
      if ((_this.editfile != null)) {
        str = _this.editorview.getText();
        savepath = _this.documentpath + "/src/" + _this.editfile;
        return _this.filemanager.writeToFile(savepath, str, function(err) {
          if (err === 1) {
            return $.post("syslibs/enforce.php", {
              mode: "compile"
            }, function(err) {
              return _this.infoview.setText(err);
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
    });
    this.editorview = new JSTextView(JSRectMake(4, 24, this._frame.size.width - 4, this._frame.size.height - 28 - 24));
    this.editorview.setBackgroundColor(JSColor("#000020"));
    this.editorview.setTextColor(JSColor("white"));
    this.editorview.setTextSize(10);
    this.editorview.setHidden(true);
    this.editorview.setEditable(false);
    this.addSubview(this.editorview);
    $(this.editorview._viewSelector).keydown(function(e) {
      var elem, pos, val;
      if (e.keyCode === 9) {
        e.preventDefault();
        elem = e.target;
        val = elem.value;
        pos = elem.selectionStart;
        elem.value = val.substr(0, pos) + '\t' + val.substr(pos, val.length);
        return elem.setSelectionRange(pos + 1, pos + 1);
      }
    });
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
      if (_this.infoview.dispflag === false) {
        _this.infoview.dispflag = true;
        _this.infoview._frame.size.height = parseInt(_this._frame.size.height / 3);
        _this.infoview._frame.origin.y = _this._frame.size.height - parseInt(_this._frame.size.height / 3);
        return _this.infoview.setFrame(_this.infoview._frame);
      } else {
        _this.infoview.dispflag = false;
        _this.infoview._frame.size.height = 24;
        _this.infoview._frame.origin.y = _this._frame.size.height - 24;
        return _this.infoview.setFrame(_this.infoview._frame);
      }
    });
  };

  MainView.prototype.loadSourceFile = function(fpath) {
    var tmp,
      _this = this;
    tmp = fpath.match(/.*\/(.*)/);
    this.editfile = tmp[1];
    this.editorview.setHidden(false);
    this.imageview.setHidden(true);
    this.sourceinfo.setText(this.editfile);
    this.filemanager.stringWithContentsOfFile(fpath, function(string) {
      _this.editorview.setText(string);
      return _this.editorview.setEditable(true);
    });
    return this.editorview.setHidden(false);
  };

  MainView.prototype.dispImage = function(fpath) {
    var img;
    this.editorview.setHidden(true);
    this.imageview.setHidden(false);
    img = new JSImage(fpath);
    this.imageview.setImage(img);
    return this.editorview.setHidden(true);
  };

  return MainView;

})(JSView);
