var JSActivityIndicatorView, JSAlertView, JSButton, JSControl, JSFileManager, JSImage, JSImagePicker, JSImageView, JSLabel, JSListView, JSMenuView, JSObject, JSPoint, JSRange, JSRect, JSResponder, JSScrollView, JSSegmentedControl, JSSize, JSSwitch, JSTableView, JSTableViewCell, JSTableViewController, JSTextField, JSTextView, JSUserCookies, JSUserDefaults, JSView, JSWindow,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

JSObject = (function() {

  function JSObject() {
    this._self = this;
    this._objectID = UniqueID();
  }

  return JSObject;

})();

JSFileManager = (function(_super) {
  var escapeRules;

  __extends(JSFileManager, _super);

  function JSFileManager() {
    JSFileManager.__super__.constructor.call(this);
  }

  JSFileManager.prototype.escapeHTML = function(s) {
    return s.replace(/[&"<>]/g, function(c) {
      return escapeRules[c];
    });
  };

  escapeRules = {
    "&": "&amp;",
    "\"": "&quot;",
    "<": "&lt;",
    ">": "&gt;"
  };

  JSFileManager.prototype.stringWithContentsOfFile = function(fname, readaction) {
    var _this = this;
    this.readaction = readaction;
    if (!(fname != null)) return;
    return $.post("syslibs/library.php", {
      mode: "stringWithContentsOfFile",
      fname: fname
    }, function(data) {
      if ((_this.readaction != null)) return _this.readaction(data);
    });
  };

  JSFileManager.prototype.writeToFile = function(path, string, saveaction) {
    var _this = this;
    this.saveaction = saveaction;
    return $.post("syslibs/library.php", {
      mode: "writeToFile",
      fname: path,
      data: string
    }, function(ret) {
      if ((_this.saveaction != null)) return _this.saveaction(parseInt(ret));
    });
  };

  JSFileManager.prototype.fileList = function(path, type, listaction) {
    var _this = this;
    this.listaction = listaction;
    return $.post("syslibs/library.php", {
      mode: "filelist",
      path: path,
      filter: type
    }, function(filelist) {
      if ((_this.listaction != null)) return _this.listaction(filelist);
    });
  };

  JSFileManager.prototype.thumbnailList = function(path, imagelistaction) {
    var _this = this;
    this.imagelistaction = imagelistaction;
    return $.post("syslibs/library.php", {
      mode: "thumbnailList",
      path: path
    }, function(filelist) {
      if ((_this.imagelistaction != null)) return _this.imagelistaction(filelist);
    });
  };

  JSFileManager.prototype.createDirectoryAtPath = function(path, creatediraction) {
    var _this = this;
    this.creatediraction = creatediraction;
    return $.post("syslibs/library.php", {
      mode: "createDirectoryAtPath",
      path: path
    }, function(ret) {
      if ((_this.creatediraction != null)) {
        return _this.creatediraction(parseInt(ret));
      }
    });
  };

  JSFileManager.prototype.removeItemAtPath = function(path, removeaction) {
    var _this = this;
    this.removeaction = removeaction;
    return $.post("syslibs/library.php", {
      mode: "removeFile",
      path: path
    }, function(ret) {
      if ((_this.removeaction != null)) return _this.removeaction(parseInt(ret));
    });
  };

  JSFileManager.prototype.moveItemAtPath = function(file, path, moveaction) {
    var _this = this;
    this.moveaction = moveaction;
    return $.post("syslibs/library.php", {
      mode: "moveFile",
      file: file,
      toPath: path
    }, function(ret) {
      if ((_this.moveaction != null)) return _this.moveaction(parseInt(ret));
    });
  };

  return JSFileManager;

})(JSObject);

JSImage = (function(_super) {

  __extends(JSImage, _super);

  function JSImage(imagename) {
    JSImage.__super__.constructor.call(this);
    if ((imagename != null)) this.imageNamed(imagename);
  }

  JSImage.prototype.imageNamed = function(_imagepath) {
    this._imagepath = _imagepath;
  };

  JSImage.prototype.imageWriteToSavedPicture = function(fname, action) {
    var _this = this;
    return $.post("syslibs/library.php", {
      mode: "savePicture",
      imagepath: this._imagepath,
      fpath: fname
    }, function(ret) {
      if ((action != null)) return action(ret);
    });
  };

  return JSImage;

})(JSObject);

JSPoint = (function(_super) {

  __extends(JSPoint, _super);

  function JSPoint() {
    JSPoint.__super__.constructor.call(this);
    this.x = 0;
    this.y = 0;
  }

  return JSPoint;

})(JSObject);

JSRange = (function(_super) {

  __extends(JSRange, _super);

  function JSRange() {
    JSRange.__super__.constructor.call(this);
    this.location = 0;
    this.length = 0;
  }

  return JSRange;

})(JSObject);

JSResponder = (function(_super) {

  __extends(JSResponder, _super);

  function JSResponder() {
    JSResponder.__super__.constructor.call(this);
    this._event = null;
    this._touches = false;
  }

  JSResponder.prototype.didBrowserResize = function() {
    var o, _i, _len, _ref, _results;
    _ref = this._objlist;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      o = _ref[_i];
      _results.push(o.didBrowserResize());
    }
    return _results;
  };

  JSResponder.prototype.locationView = function() {
    var pt;
    pt = new JSPoint();
    pt.x = this._event.offsetX;
    pt.y = this._event.offsetY;
    return pt;
  };

  return JSResponder;

})(JSObject);

JSSize = (function(_super) {

  __extends(JSSize, _super);

  function JSSize() {
    JSSize.__super__.constructor.call(this);
    this.width = 0;
    this.height = 0;
  }

  return JSSize;

})(JSObject);

JSTableViewController = (function(_super) {

  __extends(JSTableViewController, _super);

  function JSTableViewController() {
    JSTableViewController.__super__.constructor.call(this);
    this._tableViewStyle = "UITableViewStylePlain";
    this._bgColor = JSColor("white");
    this._tableView = new JSTableView();
    this._tableView.delegate = this._self;
    this._tableView.dataSource = this._self;
  }

  return JSTableViewController;

})(JSObject);

JSUserCookies = (function(_super) {

  __extends(JSUserCookies, _super);

  function JSUserCookies() {
    JSUserCookies.__super__.constructor.call(this);
  }

  JSUserCookies.prototype.setObject = function(value, forKey) {
    return $.cookie(forKey, encodeURIComponent(value), {
      expires: 365
    });
  };

  JSUserCookies.prototype.stringForKey = function(forKey) {
    var ret;
    ret = decodeURIComponent($.cookie(forKey));
    return ret;
  };

  JSUserCookies.prototype.removeObjectForKey = function(forKey) {
    return $.removeCookie(forKey);
  };

  return JSUserCookies;

})(JSObject);

JSUserDefaults = (function(_super) {

  __extends(JSUserDefaults, _super);

  function JSUserDefaults() {
    JSUserDefaults.__super__.constructor.call(this);
  }

  JSUserDefaults.prototype.setObject = function(value, forKey) {
    return $.post("syslibs/library.php", {
      "mode": "setUserDefaults",
      "forKey": forKey,
      "value": JSON.stringify(value)
    });
  };

  JSUserDefaults.prototype.stringForKey = function(forKey, action) {
    var _this = this;
    return $.post("syslibs/library.php", {
      "mode": "getUserDefaults",
      "forKey": forKey
    }, function(data) {
      var data2;
      if (data !== "") {
        data2 = JSON.parse(data);
      } else {
        data2 = "";
      }
      return action(data2);
    });
  };

  JSUserDefaults.prototype.removeObjectForKey = function(forKey) {
    return $.post("syslibs/library.php", {
      "mode": "removeUserDefaults",
      "forKey": forKey
    });
  };

  return JSUserDefaults;

})(JSObject);

JSView = (function(_super) {

  __extends(JSView, _super);

  function JSView(_frame) {
    this._frame = _frame != null ? _frame : JSRectMake(0, 0, 320, 240);
    this.animateWithDuration = __bind(this.animateWithDuration, this);
    this.addTapGesture = __bind(this.addTapGesture, this);
    this.removeFromSuperview = __bind(this.removeFromSuperview, this);
    JSView.__super__.constructor.call(this);
    this._parent = null;
    this._viewSelector = "#" + this._objectID;
    this._bgColor = JSColor("#f0f0f0");
    this._alpha = 1.0;
    this._cornerRadius = 0;
    this._borderColor = JSColor("clearColor");
    this._borderWidth = 0;
    this._clipToBounds = false;
    this._draggable = false;
    this._resizable = false;
    this._containment = false;
    this._div = "<div id=\"" + this._objectID + "\" style='position:absolute;z-index:1;'><!--null--></div>";
    this._ignoreDraggable = [];
    this._objlist = new Array();
    this._shadow = false;
    this._userInteractionEnabled = true;
    this._axis = false;
    this._touched = false;
    this._hidden = false;
  }

  JSView.prototype.addSubview = function(object) {
    if (!(object != null)) return;
    this._objlist.push(object);
    object._parent = this._self;
    if (($(this._viewSelector).length)) {
      $(this._viewSelector).append(object._div);
      object.setDraggable(object._draggable, object._axis, object._dragopacity);
      object.setResizable(object._resizable, object._resizeAction, object._resizeopacity);
      return object.viewDidAppear();
    }
  };

  JSView.prototype.setFrame = function(_frame) {
    this._frame = _frame;
    if (($(this._viewSelector).length)) {
      $(this._viewSelector).css("width", this._frame.size.width + "px");
      $(this._viewSelector).css("height", this._frame.size.height + "px");
      $(this._viewSelector).css("left", this._frame.origin.x + "px");
      return $(this._viewSelector).css("top", this._frame.origin.y + "px");
    }
  };

  JSView.prototype.setBackgroundColor = function(_bgColor) {
    this._bgColor = _bgColor;
    if (($(this._viewSelector).length)) {
      return $(this._viewSelector).css("background-color", this._bgColor);
    }
  };

  JSView.prototype.setAlpha = function(_alpha) {
    this._alpha = _alpha;
    if (this._alpha < 0 || this._alpha > 1) return;
    if (($(this._viewSelector).length)) {
      return $(this._viewSelector).css("opacity", this._alpha);
    }
  };

  JSView.prototype.setCornerRadius = function(_cornerRadius) {
    this._cornerRadius = _cornerRadius;
    if (($(this._viewSelector).length)) {
      $(this._viewSelector).css("-webkit-border-radius", this._cornerRadius + "px");
      $(this._viewSelector).css("-moz-border-radius", this._cornerRadius + "px");
      return $(this._viewSelector).css("border-radius", this._cornerRadius + "px");
    }
  };

  JSView.prototype.setBorderColor = function(_borderColor) {
    this._borderColor = _borderColor;
    if (($(this._viewSelector).length)) {
      $(this._viewSelector).css("border-color", this._borderColor);
      $(this._viewSelector).css("border-style", "solid");
      return $(this._viewSelector).css("border-width", this._borderWidth);
    }
  };

  JSView.prototype.setBorderWidth = function(_borderWidth) {
    this._borderWidth = _borderWidth;
    $(this._viewSelector).css("border-width", this._borderWidth);
    $(this._viewSelector).css("border-style", "solid");
    return $(this._viewSelector).css("border-width", this._borderWidth);
  };

  JSView.prototype.setClipToBounds = function(_clipToBounds) {
    this._clipToBounds = _clipToBounds;
    if (($(this._viewSelector).length)) {
      if (this._clipToBounds === true) {
        return $(this._viewSelector).css("overflow", "hidden");
      } else {
        return $(this._viewSelector).css("overflow", "normal");
      }
    }
  };

  JSView.prototype.setUserInteractionEnabled = function(_userInteractionEnabled) {
    var _this = this;
    this._userInteractionEnabled = _userInteractionEnabled;
    if (this._userInteractionEnabled === true) {
      $(this._viewSelector).unbind("click").bind("click", function(event) {
        if ((_this._tapAction != null) && _this._alpha > 0.0) {
          _this._tapAction(_this._self, event);
          return event.stopPropagation();
        }
      });
      return $(this._viewSelector).unbind("dblclick").bind("dblclick", function(event) {
        if ((_this._tapAction2 != null) && _this._alpha > 0.0) {
          _this._tapAction2(_this._self, event);
          return event.stopPropagation();
        }
      });
    } else {
      $(this._viewSelector).unbind("click");
      return $(this._viewSelector).unbind("dblclick");
    }
  };

  JSView.prototype.disableDragObject = function(object) {
    if (($(this._viewSelector).length)) {
      return $(this._viewSelector).draggable('option', 'cancel', object._viewSelector);
    }
  };

  JSView.prototype.setDraggable = function(_draggable, _axis, _dragopacity) {
    var containment;
    this._draggable = _draggable;
    this._axis = _axis != null ? _axis : false;
    this._dragopacity = _dragopacity != null ? _dragopacity : 0.5;
    if ((this._parent != null)) {
      containment = this._parent._containment;
    } else {
      containment = false;
    }
    if (!$(this._viewSelector).length) return;
    if (this._draggable === true) {
      $(this._viewSelector).css("cursor", "pointer");
      if (containment === true) {
        return $(this._viewSelector).draggable({
          containment: "parent",
          axis: this._axis,
          opacity: this._dragopacity,
          disabled: false
        });
      } else {
        $(this._viewSelector).draggable({
          disabled: false
        });
        $(this._viewSelector).draggable("destroy");
        return $(this._viewSelector).draggable({
          opacity: this._dragopacity,
          axis: this._axis,
          disabled: false
        });
      }
    } else {
      $(this._viewSelector).css("cursor", "auto");
      return $(this._viewSelector).draggable({
        disabled: true
      });
    }
  };

  JSView.prototype.setResizable = function(_resizable, _resizeAction, _resizeopacity, minWidth, minHeight, maxWidth, maxHeight) {
    var containment,
      _this = this;
    this._resizable = _resizable;
    this._resizeAction = _resizeAction != null ? _resizeAction : null;
    this._resizeopacity = _resizeopacity != null ? _resizeopacity : 0.5;
    if (minWidth == null) minWidth = 0;
    if (minHeight == null) minHeight = 0;
    if (maxWidth == null) maxWidth = 16777216;
    if (maxHeight == null) maxHeight = 16777216;
    if ((this._parent != null)) {
      containment = this._parent._containment;
    } else {
      containment = false;
    }
    if (!$(this._viewSelector).length) return;
    if (this._resizable === true) {
      if (containment === true) {
        return $(this._viewSelector).resizable({
          containment: "parent",
          minWidth: minWidth,
          minHeight: minHeight,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          resize: function(event, ui) {
            var frame;
            frame = _this._frame;
            frame.origin.x = $(_this._viewSelector).css("left");
            frame.origin.y = $(_this._viewSelector).css("top");
            frame.size.width = $(_this._viewSelector).width();
            frame.size.height = $(_this._viewSelector).height();
            _this._self.setFrame(frame);
            if ((_this._resizeAction != null)) return _this._resizeAction();
          }
        });
      } else {
        $(this._viewSelector).resizable({
          opacity: this._resizeopacity,
          disabled: false
        });
        $(this._viewSelector).resizable("destroy");
        return $(this._viewSelector).resizable({
          minWidth: minWidth,
          minHeight: minHeight,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          opacity: this._resizeopacity,
          disabled: false,
          resize: function(event, ui) {
            var frame;
            frame = _this._self._frame;
            frame.size.width = $(_this._viewSelector).width();
            frame.size.height = $(_this._viewSelector).height();
            _this._self.setFrame(frame);
            return _this._resizeAction();
          }
        });
      }
    }
  };

  JSView.prototype.setHidden = function(_hidden) {
    this._hidden = _hidden;
    if (($(this._viewSelector).length)) {
      if (this._hidden === true) {
        return $(this._viewSelector).css("display", "none");
      } else {
        return $(this._viewSelector).css("display", "inline-block");
      }
    }
  };

  JSView.prototype.setContainment = function(_containment) {
    var obj, _i, _len, _ref, _results;
    this._containment = _containment;
    _ref = this._objlist;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      obj = _ref[_i];
      _results.push(obj.setDraggable(obj._draggable, obj._axis, obj._dragopacity));
    }
    return _results;
  };

  JSView.prototype.bringSubviewToFront = function(obj) {
    var id, v;
    id = obj._objectID;
    v = $('#' + id);
    return v.appendTo(v.parent());
  };

  JSView.prototype.removeFromSuperview = function() {
    var i, o, t, _i, _len, _ref;
    if (this._parent === null) return;
    t = -1;
    i = 0;
    _ref = this._parent._objlist;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      o = _ref[_i];
      if (o._objectID === this._objectID) {
        t = i;
        break;
      }
      i++;
    }
    if (t >= 0) {
      this._parent._objlist.splice(t, 1);
      $(this._viewSelector).remove();
      return null;
    }
  };

  JSView.prototype.removeTapGesture = function(tapnum) {
    var _this = this;
    switch (tapnum) {
      case 1:
        if (this._userInteractionEnabled === true) {
          return $(this._viewSelector).unbind("click").bind("click", function(event) {
            return event.stopPropagation();
          });
        } else {
          this._tapAction = null;
          return $(this._viewSelector).unbind("click");
        }
        break;
      case 2:
        if (this._userInteractionEnabled === true) {
          return $(this._viewSelector).unbind("dblclick").bind("dblclick", function(event) {
            return event.stopPropagation();
          });
        } else {
          this._tapAction2 = null;
          return $(this._viewSelector).unbind("dblclick");
        }
    }
  };

  JSView.prototype.addTapGesture = function(tapAction, tapnum) {
    var _this = this;
    if (tapnum == null) tapnum = 1;
    if (tapnum === 1) {
      this._tapAction = tapAction;
    } else if (tapnum === 2) {
      this._tapAction2 = tapAction;
    } else {
      return;
    }
    if (!$(this._viewSelector).length) return;
    $(this._viewSelector).css("cursor", "pointer");
    if (tapnum === 1) {
      $(this._viewSelector).on('tap', function(e) {
        if ((_this._tapAction != null) && _this._userInteractionEnabled === true && _this._alpha > 0.0 && _this._hidden === false) {
          _this._tapAction(_this._self, e);
          return e.stopPropagation();
        }
      });
    }
    if (tapnum === 2) {
      return $(this._viewSelector).on('doubletap', function(e) {
        if ((_this._tapAction2 != null) && _this._userInteractionEnabled === true && _this._alpha > 0.0 && _this._hidden === false) {
          _this._tapAction2(_this._self, e);
          return e.stopPropagation();
        }
      });
    }
  };

  JSView.prototype.animateWithDuration = function(duration, animations, completion) {
    var animobj, key, value,
      _this = this;
    if (completion == null) completion = null;
    duration *= 1000;
    animobj = {};
    for (key in animations) {
      value = animations[key];
      if (key === "alpha") key = "opacity";
      animobj[key] = value;
    }
    if ((completion != null)) {
      return $(this._viewSelector).animate(animobj, duration, function() {
        var key, value;
        for (key in animations) {
          value = animations[key];
          switch (key) {
            case "top":
              _this._frame.origin.y = value;
              break;
            case "left":
              _this._frame.origin.x = value;
              break;
            case "alpha":
              _this._alpha = value;
              break;
            case "background-color":
              _this._bgColor = value;
              break;
            case "border-color":
              _this._borderColor = value;
              break;
            case "border-width":
              _this._borderWidth = value;
              break;
            case "width":
              _this._frame.size.width = value;
              break;
            case "height":
              _this._frame.size.height = value;
          }
        }
        return completion(_this._self);
      });
    } else {
      return $(this._viewSelector).animate(animobj, duration, function() {
        var key, value, _results;
        _results = [];
        for (key in animations) {
          value = animations[key];
          switch (key) {
            case "top":
              _results.push(_this._frame.origin.y = value);
              break;
            case "left":
              _results.push(_this._frame.origin.x = value);
              break;
            case "alpha":
              _results.push(_this._alpha = value);
              break;
            case "background-color":
              _results.push(_this._bgColor = value);
              break;
            case "border-color":
              _results.push(_this._borderColor = value);
              break;
            case "border-width":
              _results.push(_this._borderWidth = value);
              break;
            case "width":
              _results.push(_this._frame.size.width = value);
              break;
            case "height":
              _results.push(_this._frame.size.height = value);
              break;
            default:
              _results.push(void 0);
          }
        }
        return _results;
      });
    }
  };

  JSView.prototype.setShadow = function(_shadow) {
    this._shadow = _shadow;
    if (this._shadow === true) {
      return $(this._viewSelector).css("box-shadow", "2px 2px 10px rgba(0,0,0,0.4)");
    } else {
      return $(this._viewSelector).css("box-shadow", "none");
    }
  };

  JSView.prototype.viewDidAppear = function() {
    var i, o, _ref,
      _this = this;
    this.setHidden(this._hidden);
    this.setFrame(this._frame);
    this.setBackgroundColor(this._bgColor);
    this.setCornerRadius(this._cornerRadius);
    this.setAlpha(this._alpha);
    this.setBorderColor(this._borderColor);
    this.setBorderWidth(this._borderWidth);
    this.setShadow(this._shadow);
    this.setDraggable(this._draggable, this._axis, this._dragopacity);
    this.setResizable(this._resizable, this._resizeAction, this._resizeopacity);
    this.removeTapGesture(1);
    this.removeTapGesture(2);
    if ((this._tapAction != null)) this.addTapGesture(this._tapAction);
    if ((this._tapAction2 != null)) this.addTapGesture(this._tapAction2, 2);
    if (this._objlist.length > 0) {
      for (i = 0, _ref = objectNum(this._objlist); 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        o = this._objlist[i];
        if (!$(o._viewSelector).length) {
          $(this._viewSelector).append(o._div);
          o.viewDidAppear();
        }
      }
    }
    return $(this._viewSelector).bind({
      'touchstart mousedown': function() {
        var e;
        if (_this._editable === false) event.preventDefault();
        _this.touched = true;
        if (typeof _this.touchesBegan === 'function') {
          if (isTouch() === true && event.changedTouches !== void 0) {
            e = event.changedTouches[0];
          } else {
            e = event;
          }
          return _this.touchesBegan(e);
        }
      },
      'touchmove mousemove': function() {
        var e;
        if (_this._editable === false) event.preventDefault();
        if (_this.touched) {
          if (typeof _this.touchesMoved === 'function') {
            if (isTouch() === true && event.changedTouches !== void 0) {
              e = event.changedTouches[0];
            } else {
              e = event;
            }
            return _this.touchesMoved(e);
          }
        }
      },
      'touchend mouseup': function() {
        var e;
        if (_this._editable === false) event.preventDefault();
        _this.touched = false;
        if (typeof _this.touchesEnded === 'function') {
          if (isTouch() === true && event.changedTouches !== void 0) {
            e = event.changedTouches[0];
          } else {
            e = event;
          }
          return _this.touchesEnded(e);
        }
      },
      'touchcancel': function() {
        var e;
        if (_this._editable === false) event.preventDefault();
        _this.touched = false;
        if (typeof _this.touchesCancelled === 'function') {
          if (isTouch() === true && event.changedTouches !== void 0) {
            e = event.changedTouches[0];
          } else {
            e = event;
          }
          return _this.touchesCancelled(e);
        }
      }
    });
  };

  return JSView;

})(JSResponder);

JSActivityIndicatorView = (function(_super) {

  __extends(JSActivityIndicatorView, _super);

  function JSActivityIndicatorView(frame) {
    JSActivityIndicatorView.__super__.constructor.call(this, frame);
    this._bgColor = JSColor("clearColor");
    this._userInteractionEnabled = false;
    this._activityIndicatorViewStyle = "JSActivityIndicatorViewStyleGray";
  }

  JSActivityIndicatorView.prototype.startAnimating = function() {
    return this.setHidden(false);
  };

  JSActivityIndicatorView.prototype.stopAnimating = function() {
    return this.setHidden(true);
  };

  JSActivityIndicatorView.prototype.setActivityIndicatorViewStyle = function(_activityIndicatorViewStyle) {
    var indicator_img, tag;
    this._activityIndicatorViewStyle = _activityIndicatorViewStyle;
    if (this._activityIndicatorViewStyle === "JSActivityIndicatorViewStyleGray") {
      indicator_img = "loading_indicator_gray.gif";
    } else if (this._activityIndicatorViewStyle === "JSActivityIndicatorViewStyleWhite") {
      indicator_img = "loading_indicator_white.gif";
    } else {
      return;
    }
    tag = "<img id='" + this._objectID + "_indicator' src='syslibs/Picture/" + indicator_img + "' style='position:absolute;z-index:1;' />";
    if (($(this._viewSelector + "_indicator").length)) {
      $(this._viewSelector + "_indicator").remove();
    }
    $(this._viewSelector).append(tag);
    $(this._viewSelector + "_indicator").width(this._frame.size.width);
    return $(this._viewSelector + "_indicator").height(this._frame.size.height);
  };

  JSActivityIndicatorView.prototype.viewDidAppear = function() {
    JSActivityIndicatorView.__super__.viewDidAppear.call(this);
    return this.setActivityIndicatorViewStyle(this._activityIndicatorViewStyle);
  };

  return JSActivityIndicatorView;

})(JSView);

JSAlertView = (function(_super) {

  __extends(JSAlertView, _super);

  function JSAlertView(_title, _message, _param) {
    this._title = _title;
    this._message = _message;
    this._param = _param != null ? _param : null;
    JSAlertView.__super__.constructor.call(this);
    this._bgColor = JSColor("clearColor");
    this._style = "JSAlertViewStyleDefault";
    this.delegate = this;
    this.cancel = false;
  }

  JSAlertView.prototype.setAlertViewStyle = function(_style) {
    var addtag, alerthash, buttonhash, cancelmethod, dialogHeight, i, p, value, _ref,
      _this = this;
    this._style = _style;
    $("body").css({
      "font-size": "60%"
    });
    this._tag = "<div id='" + this._objectID + "_form' title='" + this._title + "'>";
    this._tag += "<p class='validateTips'>" + this._message + "</p>";
    if (this._style === "JSAlertViewStylePlainTextInput" && (this._param != null)) {
      dialogHeight = 144 + (44 * this._param.length);
      this._tag += "<form onSubmit='return false;'>";
      this._tag += "<fieldset>";
      for (i = 0, _ref = this._param.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        p = this._param[i];
        if ((this._data != null)) {
          value = this._data[i];
        } else {
          value = "";
        }
        this._tag += "<label style='vertical-align:bottom;'>" + p + "</labeL>";
        addtag = "<input type='text' name='" + this._objectID + "_textfield_" + i + "' id='" + this._objectID + "_textfield_" + i + "' style='width:" + (this._frame.size.width - 32) + "px;' value='" + value + "' /><br>";
        this._tag += addtag;
      }
      this._tag += "</fieldset>";
      this._tag += "</form>";
    } else {
      dialogHeight = 160;
    }
    this._tag += "</div>";
    if (($(this._viewSelector + "_form").length)) {
      $(this._viewSelector + "_form").remove();
    }
    $(this._viewSelector).append(this._tag);
    buttonhash = {
      OK: function() {
        var arr, i, t, text, _ref2;
        if ((_this.delegate != null) && typeof _this.delegate.clickedButtonAtIndex === "function") {
          switch (_this._style) {
            case "JSAlertViewStylePlainTextInput":
              arr = [];
              for (i = 0, _ref2 = _this._param.length; 0 <= _ref2 ? i < _ref2 : i > _ref2; 0 <= _ref2 ? i++ : i--) {
                t = $(_this._viewSelector + "_textfield_" + i).val();
                arr.push(t);
              }
              text = JSON.stringify(arr);
              _this.delegate.clickedButtonAtIndex(text, _this._self);
              break;
            case "JSAlertViewStyleDefault":
              _this.delegate.clickedButtonAtIndex(1, _this._self);
          }
        }
        $(_this._viewSelector + "_form").dialog("close");
        return _this._self.removeFromSuperview();
      }
    };
    if (this.cancel === true) {
      cancelmethod = {
        Cancel: function() {
          if ((_this.delegate != null) && typeof _this.delegate.clickedButtonAtIndex === "function") {
            _this.delegate.clickedButtonAtIndex(0, _this._self);
          }
          $(_this._viewSelector + "_form").dialog("close");
          return _this._self.removeFromSuperview();
        }
      };
      buttonhash['Cancel'] = cancelmethod['Cancel'];
    }
    alerthash = {
      autoOpen: false,
      width: 350,
      height: dialogHeight,
      modal: true,
      closeOnEscape: true,
      close: function() {
        if ((_this.delegate != null) && typeof _this.delegate.closedDialog === "function") {
          _this.delegate.closedDialog(_this._self);
        }
        $(_this._viewSelector + "_form").dialog("close");
        return _this._self.removeFromSuperview();
      }
    };
    alerthash["buttons"] = buttonhash;
    return $(this._viewSelector + "_form").dialog(alerthash);
  };

  JSAlertView.prototype.setData = function(_data) {
    var i, value, _ref, _results;
    this._data = _data;
    if (($(this._viewSelector + "_form").length)) {
      _results = [];
      for (i = 0, _ref = this._data.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        value = this._data[i];
        _results.push($(this._viewSelector + "_textfield_" + i).val(value));
      }
      return _results;
    }
  };

  JSAlertView.prototype.show = function() {
    return $(this._viewSelector + "_form").dialog("open");
  };

  JSAlertView.prototype.viewDidAppear = function() {
    return this.setAlertViewStyle(this._style);
  };

  return JSAlertView;

})(JSView);

JSControl = (function(_super) {

  __extends(JSControl, _super);

  function JSControl(frame) {
    JSControl.__super__.constructor.call(this, frame);
    this._enable = true;
  }

  JSControl.prototype.addTarget = function(action) {
    this.action = action;
  };

  JSControl.prototype.setEnable = function(_enable) {
    this._enable = _enable;
    if (this._enable === false) {
      return this._self.setAlpha(0.2);
    } else {
      return this._self.setAlpha(1.0);
    }
  };

  JSControl.prototype.viewDidAppear = function() {
    var _this = this;
    JSControl.__super__.viewDidAppear.call(this);
    this.setEnable(this._enable);
    return $(this._viewSelector).on('tap', function(event) {
      if ((_this.action != null) && _this._enable === true && _this._userInteractionEnabled === true) {
        _this.action(_this._self);
        return event.stopPropagation();
      }
    });
  };

  return JSControl;

})(JSView);

JSImageView = (function(_super) {

  __extends(JSImageView, _super);

  function JSImageView(frame) {
    JSImageView.__super__.constructor.call(this, frame);
    this._userInteractionEnabled = false;
    this._bgColor = JSColor("clearColor");
    this._clipToBounds = true;
    this._contentMode = "JSViewContentModeNormal";
  }

  JSImageView.prototype.setImage = function(_image) {
    var img, preimg;
    this._image = _image;
    if ((this._image != null)) {
      preimg = new Image();
      preimg.src = this._image._imagepath;
      img = "<img id='" + this._objectID + "_image' src='" + this._image._imagepath + "' style='position:absolute;z-index:1;left:0px;top:0px;width:" + this._frame.size.width + "px;height:" + this._frame.size.height + "px;'>";
      if (($(this._viewSelector).length)) {
        if (($(this._viewSelector + "_image").length)) {
          $(this._viewSelector + "_image").remove();
        }
        $(this._viewSelector).append(img);
        return this.setContentMode(this._contentMode);
      } else {
        return this._div = this._div.replace(/<!--null-->/, img + "<!--null-->");
      }
    } else {
      if (($(this._viewSelector + "_image").length)) {
        return $(this._viewSelector + "_image").remove();
      }
    }
  };

  JSImageView.prototype.setCornerRadius = function(radius) {
    JSImageView.__super__.setCornerRadius.call(this, radius);
    $(this._viewSelector + "_image").css("border-radius", radius);
    $(this._viewSelector + "_image").css("-webkit-border-radius", radius);
    return $(this._viewSelector + "_image").css("-moz-border-radius", radius);
  };

  JSImageView.prototype.setContentMode = function(_contentMode) {
    this._contentMode = _contentMode;
    if ($(this._viewSelector).length && $(this._viewSelector + "_image").length) {
      switch (this._contentMode) {
        case "JSViewContentModeScaleAspectFit":
          return $(this._viewSelector).imgLiquid({
            fill: false
          });
        case "JSViewContentModeScaleAspectFill":
          return $(this._viewSelector).imgLiquid();
      }
    }
  };

  JSImageView.prototype.setFrame = function(frame) {
    JSImageView.__super__.setFrame.call(this, frame);
    $(this._viewSelector + "_image").css("left", frame.origin.x);
    $(this._viewSelector + "_image").css("top", frame.origin.y);
    $(this._viewSelector + "_image").width(frame.size.width);
    return $(this._viewSelector + "_image").height(frame.size.height);
  };

  JSImageView.prototype.viewDidAppear = function() {
    JSImageView.__super__.viewDidAppear.call(this);
    this.setCornerRadius(this._cornerRadius);
    this.setImage(this._image);
    return this.setContentMode(this._contentMode);
  };

  return JSImageView;

})(JSView);

JSLabel = (function(_super) {

  __extends(JSLabel, _super);

  function JSLabel(frame) {
    if (frame == null) frame = JSRectMake(0, 0, 120, 24);
    JSLabel.__super__.constructor.call(this, frame);
    this._textSize = 10;
    this._textColor = JSColor("black");
    this._bgColor = JSColor("#f0f0f0");
    this._textAlignment = "JSTextAlignmentCenter";
    this._text = "Label";
  }

  JSLabel.prototype.setText = function(_text) {
    this._text = _text;
    if (($(this._viewSelector).length)) {
      return $(this._viewSelector).html(this._text);
    }
  };

  JSLabel.prototype.setTextSize = function(_textSize) {
    this._textSize = _textSize;
    if (($(this._viewSelector).length)) {
      return $(this._viewSelector).css("font-size", this._textSize + "pt");
    }
  };

  JSLabel.prototype.setTextColor = function(_textColor) {
    this._textColor = _textColor;
    if (($(this._viewSelector).length)) {
      return $(this._viewSelector).css("color", this._textColor);
    }
  };

  JSLabel.prototype.setTextAlignment = function(_textAlignment) {
    this._textAlignment = _textAlignment;
    switch (this._textAlignment) {
      case "JSTextAlignmentCenter":
        return $(this._viewSelector).css("text-align", "center");
      case "JSTextAlignmentLeft":
        return $(this._viewSelector).css("text-align", "left");
      case "JSTextAlignmentRight":
        return $(this._viewSelector).css("text-align", "right");
      default:
        return $(this._viewSelector).css("text-align", "center");
    }
  };

  JSLabel.prototype.setFrame = function(frame) {
    JSLabel.__super__.setFrame.call(this, frame);
    $(this._viewSelector).width(frame.size.width);
    return $(this._viewSelector).height(frame.size.height);
  };

  JSLabel.prototype.viewDidAppear = function() {
    JSLabel.__super__.viewDidAppear.call(this);
    $(this._viewSelector).width(this._frame.size.width);
    $(this._viewSelector).css("vertical-align", "middle");
    $(this._viewSelector).css("line-height", this._frame.size.height + "px");
    this.setText(this._text);
    this.setTextSize(this._textSize);
    this.setTextColor(this._textColor);
    return this.setTextAlignment(this._textAlignment);
  };

  return JSLabel;

})(JSView);

JSRect = (function(_super) {

  __extends(JSRect, _super);

  function JSRect() {
    JSRect.__super__.constructor.call(this);
    this.origin = new JSPoint();
    this.size = new JSSize();
  }

  return JSRect;

})(JSObject);

JSScrollView = (function(_super) {

  __extends(JSScrollView, _super);

  function JSScrollView(frame) {
    this.animateWithDuration = __bind(this.animateWithDuration, this);    JSScrollView.__super__.constructor.call(this, frame);
    this._scroll = false;
  }

  JSScrollView.prototype.setScroll = function(_scroll) {
    this._scroll = _scroll;
    if (this._scroll === true) {
      $(this._viewSelector).css("overflow", "auto");
      return $(this._viewSelector).css("-webkit-overflow-scrolling", "touch");
    } else {
      return this.setClipToBounds(this._clipToBounds);
    }
  };

  JSScrollView.prototype.viewDidAppear = function() {
    JSScrollView.__super__.viewDidAppear.call(this);
    return this.setScroll(this._scroll);
  };

  JSScrollView.prototype.animateWithDuration = function(duration, animations, completion) {
    if (completion == null) completion = null;
    return JSScrollView.__super__.animateWithDuration.call(this, duration, animations, completion);
  };

  return JSScrollView;

})(JSView);

JSTableViewCell = (function(_super) {

  __extends(JSTableViewCell, _super);

  function JSTableViewCell(frame) {
    var bounds, sidesize;
    if (!(frame != null)) {
      bounds = getBounds();
      frame = JSRectMake(0, 0, bounds.size.width - 2, 0);
    }
    JSTableViewCell.__super__.constructor.call(this, frame);
    this._image = null;
    this._imageview = null;
    this._text = "";
    this._textColor = JSColor("black");
    this._textSize = 12;
    this._textAlignment = "JSTextAlignmentLeft";
    this._bgColor = JSColor("clearColor");
    this._borderColor = JSColor("#d0d8e0");
    this._borderWidth = 1;
    sidesize = this._frame.size.height;
    this.tag = "<div id='" + this._objectID + "_cell' style='position:absolute;left:0px;top:0px;width:" + this._frame.size.width + "px;height:" + this._frame.size.height + "px;z-index:1;'><div id='" + this._objectID + "_text' style='position:relative;left:" + this._frame.size.height + "px;top:0px;width:" + (this._frame.size.width - sidesize - 4) + "px;height:" + this._frame.size.height + "px;display:table-cell;vertical-align:middle;'></div></div>";
  }

  JSTableViewCell.prototype.setText = function(_text) {
    this._text = _text;
    if (($(this._viewSelector + "_text").length)) {
      return $(this._viewSelector + "_text").html(this._text);
    }
  };

  JSTableViewCell.prototype.setTextSize = function(_textSize) {
    this._textSize = _textSize;
    if (($(this._viewSelector + "_text").length)) {
      return $(this._viewSelector + "_text").css("font-size", this._textSize);
    }
  };

  JSTableViewCell.prototype.setTextColor = function(_textColor) {
    this._textColor = _textColor;
    if (($(this._viewSelector + "_text").length)) {
      return $(this._viewSelector + "_text").css("color", this._textColor);
    }
  };

  JSTableViewCell.prototype.setTextAlignment = function(_textAlignment) {
    this._textAlignment = _textAlignment;
    switch (this._textAlignment) {
      case "JSTextAlignmentLeft":
        return $(this._viewSelector + "_text").css("text-align", "left");
      case "JSTextAlignmentCenter":
        return $(this._viewSelector + "_text").css("text-align", "center");
      case "JSTextAlignmentRight":
        return $(this._viewSelector + "_text").css("text-align", "right");
    }
  };

  JSTableViewCell.prototype.setImage = function(_image) {
    var sidesize;
    this._image = _image;
    if (!$(this._viewSelector + "_cell").length) return;
    if (!(this._image != null)) return;
    if (($(this._viewSelector + "_image").length)) {
      $(this._viewSelector + "_image").remove();
    }
    sidesize = this._frame.size.height;
    return $(this._viewSelector + "_cell").append("<img id='" + this._objectID + "_image' border='0' src='" + this._image._imagepath + "' style='position:absolute;left:0px;top:0px;width:" + sidesize + "px;height:" + sidesize + "px;'>");
  };

  JSTableViewCell.prototype.setFrame = function(frame) {
    JSTableViewCell.__super__.setFrame.call(this, frame);
    if (($(this._viewSelector + "_cell").length)) {
      $(this._viewSelector + "_cell").css("width", frame.size.width);
      $(this._viewSelector + "_cell").css("height", frame.size.height);
      $(this._viewSelector + "_image").css("width", frame.size.height);
      $(this._viewSelector + "_image").css("height", frame.size.height);
      $(this._viewSelector + "_text").css("left", frame.size.height);
      $(this._viewSelector + "_text").css("width", frame.size.width - frame.size.height);
      return $(this._viewSelector + "_text").css("height", frame.size.height);
    }
  };

  JSTableViewCell.prototype.viewDidAppear = function() {
    var _this = this;
    JSTableViewCell.__super__.viewDidAppear.call(this);
    $(this._viewSelector).append(this.tag);
    this.setFrame(this._frame);
    this.setText(this._text);
    this.setTextColor(this._textColor);
    this.setTextSize(this._textSize);
    this.setTextAlignment(this._textAlignment);
    this.setImage(this._image);
    return $(this._viewSelector).on('tap', function(event) {
      if (typeof _this.delegate.didSelectRowAtIndexPath === 'function') {
        return _this.delegate.didSelectRowAtIndexPath(_this._cellnum, event);
      }
    });
  };

  return JSTableViewCell;

})(JSView);

JSWindow = (function(_super) {

  __extends(JSWindow, _super);

  function JSWindow(frame) {
    JSWindow.__super__.constructor.call(this, frame);
  }

  JSWindow.prototype.viewDidAppear = function() {
    return JSWindow.__super__.viewDidAppear.call(this);
  };

  return JSWindow;

})(JSView);

JSButton = (function(_super) {

  __extends(JSButton, _super);

  function JSButton(frame) {
    if (frame == null) frame = JSRectMake(4, 4, 64, 24);
    JSButton.__super__.constructor.call(this, frame);
    this._borderColor = JSColor("clearColor");
    this._bgColor = JSColor("clearColor");
    this._buttonTitle = "Button";
    this._style = "JSFormButtonStyleNormal";
    this._textSize = 8;
    this.delegate = null;
  }

  JSButton.prototype.setButtonTitle = function(title) {
    this._buttonTitle = title;
    if (($(this._viewSelector + "_button").length)) {
      return $(this._viewSelector + "_button").val(this._buttonTitle);
    }
  };

  JSButton.prototype.setTextSize = function(_textSize) {
    this._textSize = _textSize;
    return $(this._viewSelector + "_button").css('font-size', this._textSize + 'pt');
  };

  JSButton.prototype.setStyle = function(_style) {
    this._style = _style;
    if (($(this._viewSelector + "_button").length)) return this.viewDidAppear();
  };

  JSButton.prototype.setFrame = function(frame) {
    var buttonheight, buttonwidth;
    JSButton.__super__.setFrame.call(this, frame);
    switch (this._style) {
      case "JSFormButtonStyleNormal":
        buttonwidth = frame.size.width;
        buttonheight = frame.size.height;
        $(this._viewSelector + "_button").css("width", buttonwidth + "px");
        return $(this._viewSelector + "_button").css("height", buttonheight + "px");
      case "JSFormButtonStyleImageUpload":
        buttonwidth = this._frame.size.width;
        return $(this._viewSelector + "_button").css("width", buttonwidth + "px");
    }
  };

  JSButton.prototype.viewDidAppear = function() {
    var buttonheight, buttonwidth, tag,
      _this = this;
    JSButton.__super__.viewDidAppear.call(this);
    if (($(this._viewSelector + "_button").length)) {
      $(this._viewSelector + "_button").remove();
    }
    if (($(this._viewSelector + "_pack").length)) {
      $(this._viewSelector + "_pack").remove();
    }
    tag = "";
    buttonwidth = this._frame.size.width;
    buttonheight = this._frame.size.height;
    if (this._style === "JSFormButtonStyleNormal") {
      tag += "<input type='submit' id='" + this._objectID + "_button' style='position:absolute;z-index:1;' value='" + this._buttonTitle + "' />";
    } else if (this._style === "JSFormButtonStyleImageUpload") {
      tag += "<div id=\"" + this._objectID + "_pack\">";
      tag += "<input id=\"" + this._objectID + "_file\" type=\"file\" name=\"" + this._objectID + "_file\" style=\"display:none;\">";
      tag += "<input type=\"submit\" id=\"" + this._objectID + "_button\" style=\"position:absolute;z-index:1;\" value=\"Upload\" onClick=\"$('#" + this._objectID + "_file').click();\" />";
      tag += "</div>";
    }
    $(this._viewSelector).append(tag);
    if (this._style === "JSFormButtonStyleImageUpload") {
      $(this._viewSelector + "_file").change(function() {
        return $(_this._viewSelector + "_file").upload("syslibs/library.php", {
          mode: "uploadfile",
          key: _this._objectID + "_file"
        }, function(res) {
          $(_this._viewSelector + "_file").val("");
          return $.post("syslibs/library.php", {
            mode: "createThumbnail",
            path: "Media/Picture"
          }, function() {
            if (typeof _this.delegate.didImageUpload === 'function') {
              return _this.delegate.didImageUpload(res);
            }
          });
        }, "json");
      });
    }
    $(this._viewSelector).css("overflow", "visible");
    $(this._viewSelector + "_button").css("overflow", "hidden");
    $(this._viewSelector + "_button").css("position", "absolute");
    $(this._viewSelector + "_button").css("background-color", "transparent");
    $(this._viewSelector + "_button").css("font-size", this._textSize + "pt");
    $(this._viewSelector + "_button").css("width", buttonwidth + "px");
    $(this._viewSelector + "_button").css("height", buttonheight + "px");
    return $(this._viewSelector + "_button").button();
  };

  return JSButton;

})(JSControl);

JSImagePicker = (function(_super) {

  __extends(JSImagePicker, _super);

  function JSImagePicker() {
    this.deleteImage = __bind(this.deleteImage, this);
    this.editImageList = __bind(this.editImageList, this);
    this.closeImagePickerView = __bind(this.closeImagePickerView, this);
    this.tapImage = __bind(this.tapImage, this);    JSImagePicker.__super__.constructor.call(this);
    this._thumbnail_width = 120;
    this._thumbnail_height = 120;
    this._clipToBounds = true;
    this._imageList = new Array();
    this.delegate = null;
    this.hilight = null;
  }

  JSImagePicker.prototype.dispImageList = function(_filelist) {
    var filelist, h, h2, hnum, imagelist, vnum, vnum2, w, x, y,
      _this = this;
    if (!$(this._viewSelector).length) return;
    filelist = JSON.parse(_filelist);
    imagelist = filelist['file'];
    hnum = parseInt(this._frame.size.width / this._thumbnail_width) - 1;
    w = hnum * (this._thumbnail_width + 4) + 4;
    vnum = parseInt(imagelist.length / hnum) + (imagelist.length % hnum !== 0);
    if (vnum * this._thumbnail_height + 64 > this._frame.size.height) {
      vnum = parseInt(this._frame.size.height / this._thumbnail_height) - 1;
    }
    vnum2 = parseInt(this._frame.size.height / (this._thumbnail_height + 4));
    h = vnum * (this._thumbnail_height + 4) + 4;
    h2 = vnum2 * (this._thumbnail_height + 4) + 4;
    x = parseInt(this._frame.size.width / 2 - (w / 2));
    y = -(h2 + 0);
    this.imagebase = new JSScrollView(JSRectMake(x, y, w, h + 36));
    this.imagebase.setShadow(true);
    this.imagebase.setBackgroundColor(JSColor("black"));
    this._self.addSubview(this.imagebase);
    this._self.bringSubviewToFront(this.imagebase);
    this.listbase = new JSScrollView(JSRectMake(0, 0, w, h + 36));
    this.listbase.setClipToBounds(true);
    this.listbase.setScroll(true);
    this.listbase.setAlpha(0.8);
    this.listbase.setBackgroundColor(JSColor("black"));
    this.listbase.addTapGesture(function() {
      if ((_this.hilight != null)) {
        _this.hilight.delcoverview.setAlpha(0.0);
        return _this.hilight = null;
      }
    });
    this.imagebase.addSubview(this.listbase);
    this.imagebase.bringSubviewToFront(this.listbase);
    this.imagectrl = new JSView(JSRectMake(0, h, w, 36));
    this.imagectrl.setAlpha(0.8);
    this.imagectrl.setBackgroundColor(JSColor("white"));
    this.imagebase.addSubview(this.imagectrl);
    this.closebutton = new JSButton(JSRectMake(w - 84, h + 4, 80, 28));
    this.closebutton.setButtonTitle("閉じる");
    this.closebutton.addTarget(this.closeImagePickerView);
    this.closebutton.setShadow(true);
    this.imagebase.addSubview(this.closebutton);
    this.imagebase.bringSubviewToFront(this.closebutton);
    this.editbutton = new JSButton(JSRectMake(4, h + 4, 80, 28));
    this.editbutton.setButtonTitle("編集");
    this.editbutton.addTarget(this.editImageList);
    this.editbutton.setShadow(true);
    this.imagebase.addSubview(this.editbutton);
    this.imagebase.bringSubviewToFront(this.editbutton);
    return this.imagebase.animateWithDuration(0.2, {
      top: 0
    }, function() {
      var delbutton, delcoverview, delviewfrm, img, imgfname, path, pos, thumbfname, view, viewfrm, xnum, ynum, _i, _len, _results;
      xnum = 0;
      ynum = 0;
      pos = new JSPoint();
      _results = [];
      for (_i = 0, _len = imagelist.length; _i < _len; _i++) {
        thumbfname = imagelist[_i];
        pos.x = xnum * (_this._thumbnail_width + 4) + 4;
        pos.y = ynum * (_this._thumbnail_height + 4) + 4;
        path = JSSearchPathForDirectoriesInDomains("JSPictureDirectory");
        imgfname = thumbfname.replace(/^.*\/(.*?)_s\.(.*)/, "/$1.$2");
        img = new JSImage(thumbfname);
        viewfrm = JSRectMake(pos.x, pos.y, _this._thumbnail_width, _this._thumbnail_height);
        view = new JSImageView(viewfrm);
        view.setContentMode("JSViewContentModeScaleAspectFit");
        view.setBackgroundColor(JSColor("black"));
        view.imgfname = imgfname;
        view.imgthumb = thumbfname;
        view.setUserInteractionEnabled(true);
        view.addTapGesture(_this.tapImage, 2);
        view.addTapGesture(function(sender, e) {
          if ((_this.hilight != null)) _this.hilight.delcoverview.setAlpha(0.0);
          _this.hilight = sender;
          sender.delcoverview.setBackgroundColor(JSColor("white"));
          sender.delcoverview.setAlpha(0.5);
          return e.stopPropagation();
        });
        view.setImage(img);
        delviewfrm = JSRectMake(0, 0, _this._thumbnail_width, _this._thumbnail_height);
        delcoverview = new JSView(delviewfrm);
        delcoverview.setAlpha(0.0);
        delcoverview.setUserInteractionEnabled(false);
        delcoverview.setBackgroundColor(JSColor("black"));
        view.delcoverview = delcoverview;
        view.addSubview(delcoverview);
        delbutton = new JSLabel(JSRectMake(4, 0, 16, 16));
        delbutton.setText("×");
        delbutton.setHidden(true);
        delbutton.setTextColor(JSColor("red"));
        delbutton.setTextSize(14);
        delbutton.setBackgroundColor(JSColor("clearColor"));
        delbutton.addTapGesture(_this.deleteImage);
        view.addSubview(delbutton);
        view.coverview = delcoverview;
        view.delbutton = delbutton;
        _this.listbase.addSubview(view);
        _this._imageList.push(view);
        xnum++;
        if (xnum === hnum) {
          xnum = 0;
          _results.push(ynum++);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    });
  };

  JSImagePicker.prototype.tapImage = function(sender) {
    this.closeImagePickerView();
    if ((this.delegate != null)) {
      return this.delegate.didPickedImage(sender.imgfname);
    }
  };

  JSImagePicker.prototype.closeImagePickerView = function() {
    var _this = this;
    return this.imagebase.animateWithDuration(0.2, {
      top: -this._frame.size.height
    }, function() {
      return _this._self.animateWithDuration(0.2, {
        alpha: 0.0
      }, function() {
        _this.imagectrl.removeFromSuperview();
        _this.listbase.removeFromSuperview();
        _this.imagebase.removeFromSuperview();
        return _this._self.removeFromSuperview();
      });
    });
  };

  JSImagePicker.prototype.editImageList = function(sender) {
    var count, img, _i, _j, _len, _len2, _ref, _ref2, _results, _results2,
      _this = this;
    if (sender._buttonTitle === "編集") {
      sender.setButtonTitle("終了");
      count = 0;
      _ref = this._imageList;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        img = _ref[_i];
        img.removeTapGesture(2);
        img.number = count++;
        img.delbutton.setHidden(false);
        img.setUserInteractionEnabled(false);
        img.coverview.setBackgroundColor(JSColor("black"));
        img.coverview.animateWithDuration(0.2, {
          "alpha": 0.5
        });
        this.listbase.removeTapGesture();
        _results.push(this.hilight = null);
      }
      return _results;
    } else {
      sender.setButtonTitle("編集");
      _ref2 = this._imageList;
      _results2 = [];
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        img = _ref2[_j];
        img.addTapGesture(this.tapImage, 2);
        img.delbutton.setHidden(true);
        img.coverview.animateWithDuration(0.2, {
          "alpha": 0.0
        });
        img.setUserInteractionEnabled(true);
        _results2.push(this.listbase.addTapGesture(function() {
          if ((_this.hilight != null)) {
            _this.hilight.delcoverview.setAlpha(0.0);
            return _this.hilight = null;
          }
        }));
      }
      return _results2;
    }
  };

  JSImagePicker.prototype.deleteImage = function(sender) {
    var _this = this;
    return sender._parent.animateWithDuration(0.2, {
      alpha: 0.0
    }, function() {
      var count, fname, frm, hnum, img, path, pos, thumb, vnum, xnum, ynum, _i, _len, _ref, _results;
      fname = _this._imageList[sender._parent.number].imgfname;
      thumb = _this._imageList[sender._parent.number].imgthumb;
      _this._imageList.splice(sender._parent.number, 1);
      sender._parent.removeFromSuperview();
      path = JSSearchPathForDirectoriesInDomains("JSPictureDirectory");
      $.post("syslibs/library.php", {
        mode: "fileUnlink",
        fpath: path + "/" + fname
      });
      $.post("syslibs/library.php", {
        mode: "fileUnlink",
        fpath: thumb
      });
      xnum = 0;
      ynum = 0;
      hnum = parseInt(_this._frame.size.width / _this._thumbnail_width) - 1;
      pos = new JSPoint();
      vnum = parseInt(_this._imageList.length / hnum) + (_this._imageList.length % hnum !== 0);
      count = 0;
      _ref = _this._imageList;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        img = _ref[_i];
        pos.x = xnum * (_this._thumbnail_width + 4) + 4;
        pos.y = ynum * (_this._thumbnail_height + 4) + 4;
        frm = JSRectMake(pos.x, pos.y, _this._thumbnail_width, _this._thumbnail_height);
        img.setFrame(frm);
        img.number = count++;
        xnum++;
        if (xnum === hnum) {
          xnum = 0;
          _results.push(ynum++);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    });
  };

  JSImagePicker.prototype.viewDidAppear = function() {
    var fm, frm, path,
      _this = this;
    JSImagePicker.__super__.viewDidAppear.call(this);
    this._self.setBackgroundColor(JSColor("clearColor"));
    this._self.setAlpha(1.0);
    this._self.setClipToBounds(true);
    frm = this._parent._frame;
    frm.origin.x = 0;
    frm.origin.y = 0;
    this._self.setFrame(frm);
    this.windowbase = new JSView(frm);
    this.windowbase.setBackgroundColor(JSColor("black"));
    this.windowbase.setAlpha(0.0);
    this.windowbase.addTapGesture(this.closeImagePickerView);
    this._self.addSubview(this.windowbase);
    fm = new JSFileManager();
    fm.delegate = fm;
    path = JSSearchPathForDirectoriesInDomains("JSPictureDirectory");
    return fm.thumbnailList(path, function(filelist) {
      return _this.windowbase.animateWithDuration(0.2, {
        alpha: 0.7
      }, function() {
        return _this.dispImageList(filelist);
      });
    });
  };

  return JSImagePicker;

})(JSScrollView);

JSListView = (function(_super) {

  __extends(JSListView, _super);

  function JSListView(frame) {
    JSListView.__super__.constructor.call(this, frame);
    this._listData = null;
    this._clickaction = null;
    this._dblclickaction = null;
    this._style = "JSListStyleStandard";
    this._textSize = 12;
    this._select = -1;
    this._clipToBounds = true;
    this._scroll = true;
  }

  JSListView.prototype.setFrame = function(frame) {
    JSListView.__super__.setFrame.call(this, frame);
    if (($(this._viewSelector + "_select").length)) {
      $(this._viewSelector + "_select").width(frame.size.width);
      return $(this._viewSelector + "_select").height(frame.size.height);
    }
  };

  JSListView.prototype.setListData = function(list) {
    var disp, i, item, size, value, _i, _j, _len, _len2, _ref, _ref2,
      _this = this;
    switch (this._style) {
      case "JSListStyleStandard":
      case "JSListStyleDropdown":
        if (this._style === "JSListStyleStandard") {
          size = 2;
          this._listData = list;
        } else {
          size = 1;
          if (!(list != null)) return;
          this._listData = new Array();
          for (_i = 0, _len = list.length; _i < _len; _i++) {
            item = list[_i];
            this._listData.push(item);
          }
        }
        this._tag = "<select id='" + this._objectID + "_select' size='" + size + "' style='width:" + this._frame.size.width + "px;height:" + this._frame.size.height + "px;z-index:1;'>";
        if (!(this._listData != null)) this._listData = new Array();
        for (i = 0, _ref = this._listData.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
          value = this._listData[i];
          disp = JSEscape(value);
          this._tag += "<option id='" + i + "' value='" + i + "'>" + disp + "</option>";
        }
        this._tag += "</select>";
        if (($(this._viewSelector + "_select").length)) {
          $(this._viewSelector + "_select").remove();
        }
        $(this._viewSelector).append(this._tag);
        $(this._viewSelector + "_select").css("background-color", "transparent");
        $(this._viewSelector + "_select").css("border", "0px transparent");
        $(this._viewSelector + "_select").css("font-size", this._textSize);
        if (this._style === "JSListStyleStandard") {
          $(this._viewSelector + "_select").click(function(e) {
            e.stopPropagation();
            _this._select = $(_this._viewSelector + "_select option:selected").val();
            if ((_this._clickaction != null) && (_this._select != null)) {
              return _this._clickaction(_this._select);
            }
          });
          $(this._viewSelector + "_select").dblclick(function(e) {
            e.stopPropagation();
            _this._select = $(_this._viewSelector + "_select option:selected").val();
            if ((_this._dblclickaction != null) && (_this._select != null)) {
              return _this._dblclickaction(_this._select);
            }
          });
        } else {
          $(this._viewSelector + "_select").change(function(e) {
            e.stopPropagation();
            _this._select = $(_this._viewSelector + "_select option:selected").val();
            if ((_this._clickaction != null) && (_this._select != null)) {
              return _this._clickaction(_this._select);
            }
          });
        }
        break;
      case "JSListStyleSortable":
        this._tag = "<table style='width:100%;'><tbody id='" + this._objectID + "_select'>";
        if (!(list != null)) return;
        this._listData = new Array();
        for (_j = 0, _len2 = list.length; _j < _len2; _j++) {
          item = list[_j];
          this._listData.push(item);
        }
        for (i = 0, _ref2 = this._listData.length; 0 <= _ref2 ? i < _ref2 : i > _ref2; 0 <= _ref2 ? i++ : i--) {
          disp = JSEscape(this._listData[i]);
          this._tag += "<tr id='" + i + "' class='ui-state-default' style='width:100%;z-index:1;'><td>" + disp + "</td></tr>";
        }
        this._tag += "</tbody></table>";
        if (($(this._viewSelector + "_select").length)) {
          $(this._viewSelector + "_select").remove();
        }
        $(this._viewSelector).append(this._tag);
        $(this._viewSelector + "_select").sortable({
          placeholder: "ui-sortable-placeholder",
          distance: 3,
          opacity: 0.8,
          scroll: true
        });
        $(this._viewSelector + "_select").disableSelection();
        $(this._viewSelector + "_select").css("background-color", "transparent");
        $(this._viewSelector + "_select").css("border", "0px transparent");
        $(this._viewSelector + "_select").css("font-size", (this._textSize - 4) + "pt");
    }
    $(this._viewSelector + "_select").width(this._frame.size.width + "px");
    return $(this._viewSelector + "_select").height(this._frame.size.height + "px");
  };

  JSListView.prototype.count = function() {
    return this._listData.length;
  };

  JSListView.prototype.objectAtIndex = function(index) {
    return this._listData[index];
  };

  JSListView.prototype.indexOfObject = function(target) {
    var num;
    num = this._listData.indexOf(target);
    return num;
  };

  JSListView.prototype.getSelect = function() {
    return this._select;
  };

  JSListView.prototype.setSelect = function(_select) {
    this._select = _select;
    return $(this._viewSelector + "_select").val(this._select);
  };

  JSListView.prototype.sortReflection = function() {
    var arr, i, key, ret, _len;
    if (this._style === "JSListStyleSortable") {
      arr = $(this._viewSelector + "_select").sortable("toArray");
      ret = new Array();
      for (i = 0, _len = arr.length; i < _len; i++) {
        key = arr[i];
        ret[i] = this._listData[key];
      }
      return this._listData = ret;
    }
  };

  JSListView.prototype.setTextSize = function(_textSize) {
    this._textSize = _textSize;
    if ((this._listData != null)) return this.setListData(this._listData);
  };

  JSListView.prototype.addTarget = function(action, tap) {
    if (tap == null) tap = 1;
    if (tap === 1) {
      return this._clickaction = action;
    } else {
      return this._dblclickaction = action;
    }
  };

  JSListView.prototype.setStyle = function(_style) {
    this._style = _style;
    return this.setListData(this._listData);
  };

  JSListView.prototype.reload = function() {
    return this.setListData(this._listData);
  };

  JSListView.prototype.viewDidAppear = function() {
    JSListView.__super__.viewDidAppear.call(this);
    this.setListData(this._listData);
    return this.setSelect(this._select);
  };

  return JSListView;

})(JSScrollView);

JSMenuView = (function(_super) {

  __extends(JSMenuView, _super);

  function JSMenuView(frame) {
    if (frame == null) frame = JSRectMake(0, 0, 200, 0);
    JSMenuView.__super__.constructor.call(this, frame);
    this._textSize = 10;
    this._backgroundColor = JSColor("clearColor");
    this._clipToBounds = false;
    this._containment = false;
  }

  JSMenuView.prototype.addTarget = function(_action) {
    this._action = _action;
  };

  JSMenuView.prototype.addMenuItem = function(_menuitem) {
    var disp, menustr, _i, _len, _ref,
      _this = this;
    this._menuitem = _menuitem;
    if (!(this._menuitem != null)) return;
    if (!$(this._viewSelector).length) return;
    this._div = "<ul id='" + this._objectID + "_menu' style='z-index:1;'><!--menuitem--></ul>";
    menustr = "";
    _ref = this._menuitem;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      disp = _ref[_i];
      menustr += "<li><a href='#'>" + disp + "</a></li>";
    }
    this._div = this._div.replace(/<!--menuitem-->/, menustr);
    if (($(this._viewSelector + "_menu").length)) {
      $(this._viewSelector + "_menu").remove();
    }
    $(this._viewSelector).append(this._div);
    $(this._viewSelector + "_menu").css("left", this._parent._frame.origin.x + "px");
    $(this._viewSelector + "_menu").css("top", this._parent._frame.origin.y + "px");
    $(this._viewSelector + "_menu").css("width", this._parent._frame.size.width + "px");
    $(this._viewSelector + "_menu").css("height", this._parent._frame.size.height + "px");
    $(this._viewSelector + "_menu").css("position", "absolute");
    $(this._viewSelector + "_menu").css("overflow", "visible");
    $(this._viewSelector + "_menu").css("font-size", this._textSize + "pt");
    return $(this._viewSelector + "_menu").menu({
      select: function(event, ui) {
        var item;
        if (_this._userInteractionEnabled === false) return;
        item = ui.item.context.textContent;
        _this.selectMenuItem(item);
        return _this.closeMenu();
      }
    });
  };

  JSMenuView.prototype.selectMenuItem = function(item) {
    var i, o, ret, _len, _ref;
    if ((this._action != null)) {
      _ref = this._menuitem;
      for (i = 0, _len = _ref.length; i < _len; i++) {
        o = _ref[i];
        if (o === item) {
          ret = i;
          break;
        }
      }
      return this._action(ret);
    }
  };

  JSMenuView.prototype.closeMenu = function() {
    $(this._viewSelector + "_menu").remove();
    return event.stopPropagation();
  };

  JSMenuView.prototype.viewDidAppear = function() {
    JSMenuView.__super__.viewDidAppear.call(this);
    if (!$(this._viewSelector + "_menu").length) {
      return this.addMenuItem(this._menuitem);
    }
  };

  return JSMenuView;

})(JSScrollView);

JSSegmentedControl = (function(_super) {

  __extends(JSSegmentedControl, _super);

  function JSSegmentedControl(_dataarray) {
    this._dataarray = _dataarray;
    JSSegmentedControl.__super__.constructor.call(this, JSRectMake(0, 0, 120, 32));
    this._bgColor = JSColor("clearColor");
    this._textSize = 12;
    this._selectedSegmentIndex = -1;
  }

  JSSegmentedControl.prototype.setValue = function(_selectedSegmentIndex) {
    this._selectedSegmentIndex = _selectedSegmentIndex;
    if (($(this._viewSelector + "_radio").length)) {
      if (this._selectedSegmentIndex < 0) {
        return this.addSegmentTag();
      } else {
        $("input:radio[name='" + this._objectID + "_radio'][value='" + this._selectedSegmentIndex + "']").attr("checked", "checked");
        return $(this._viewSelector + "_radio").buttonset('refresh');
      }
    }
  };

  JSSegmentedControl.prototype.setTextSize = function(_textSize) {
    this._textSize = _textSize;
  };

  JSSegmentedControl.prototype.addSegmentTag = function() {
    var i, tag, _ref,
      _this = this;
    tag = '<div id="' + this._objectID + '_radio" style="width:' + this._frame.size.width + 'px;height:' + this._frame.size.height + 'px;display:table-cell;vertical-align:middle;">';
    for (i = 0, _ref = this._dataarray.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
      tag += '<input type="radio" id="' + this._objectID + '_radio_' + i + '" name="' + this._objectID + '_radio" value="' + i + '" /><label for="' + this._objectID + '_radio_' + i + '" style="width:' + (this._frame.size.width / this._dataarray.length) + 'px;height:' + this._frame.size.height + 'px;border:1px #f0f0f0 solid;font-size:' + this._textSize + 'pt;"><div style="position:absolute;left:0px;top:0px;width:100%;height:100%;display:table-cell;line-height:' + this._frame.size.height + 'px;">' + this._dataarray[i] + '</div></label>';
    }
    tag += '</div>';
    if (($(this._viewSelector + "_radio").length)) {
      $(this._viewSelector + "_radio").remove();
    }
    $(this._viewSelector).append(tag);
    $(this._viewSelector + "_radio").buttonset();
    $(this._viewSelector).off();
    return $(this._viewSelector).on('click', function() {
      var select;
      _this.__select = parseInt(_this._selectedSegmentIndex);
      $(_this._viewSelector + "_radio").buttonset('refresh');
      select = parseInt($("input:radio[name='" + _this._objectID + "_radio']:checked").val());
      if ((select != null) && _this.__select !== select) {
        _this._selectedSegmentIndex = select;
        if ((_this.action != null)) return _this.action(_this._self);
      }
    });
  };

  JSSegmentedControl.prototype.viewDidAppear = function() {
    JSSegmentedControl.__super__.viewDidAppear.call(this);
    if (!(this._dataarray != null)) return;
    this.addSegmentTag();
    return this.setValue(this._selectedSegmentIndex);
  };

  return JSSegmentedControl;

})(JSControl);

JSSwitch = (function(_super) {

  __extends(JSSwitch, _super);

  function JSSwitch(frame) {
    if (frame == null) frame = JSRectMake(0, 2, 86, 24);
    JSSwitch.__super__.constructor.call(this, frame);
    this._bgColor = JSColor("clearColor");
    this._value = false;
  }

  JSSwitch.prototype.setValue = function(_value) {
    this._value = _value;
    if (this._value === true) {
      $("input[name='" + this._objectID + "_radio']").val(['on']);
    } else {
      $("input[name='" + this._objectID + "_radio']").val(['off']);
    }
    return $(this._viewSelector).buttonset();
  };

  JSSwitch.prototype.getValue = function() {
    var ret, val;
    val = $("input[name='" + this._objectID + "_radio']:checked").val();
    if (val === "on") {
      ret = true;
    } else {
      ret = false;
    }
    return ret;
  };

  JSSwitch.prototype.viewDidAppear = function() {
    var tag;
    JSSwitch.__super__.viewDidAppear.call(this);
    tag = "<div id='" + this._objectID + "_switch' style='position:absolute;z-index:1;font-size:8pt; margin:0;float:left;width:" + this._frame.size.width + "px;'>";
    tag += "<input type='radio' id='" + this._objectID + "_off' name='" + this._objectID + "_radio' value='off' style='height:20px;'><label for='" + this._objectID + "_off'>OFF</label>";
    tag += "<input type='radio' id='" + this._objectID + "_on'  name='" + this._objectID + "_radio' value='on' style='height:20px;'><label for='" + this._objectID + "_on'>ON</label>";
    tag += "</div>";
    if (($(this._viewSelector + "_switch").length)) {
      $(this._viewSelector + "switch").remove();
    }
    $(this._viewSelector).append(tag);
    this.setValue(this._value);
    return $(this._viewSelector).buttonset();
  };

  return JSSwitch;

})(JSControl);

JSTableView = (function(_super) {

  __extends(JSTableView, _super);

  function JSTableView(frame) {
    if (!(frame != null)) frame = getBounds();
    JSTableView.__super__.constructor.call(this, frame);
    this._rowHeight = 32;
    this._clipToBounds = true;
    this._bgColor = JSColor("white");
    this._scroll = true;
    this._titlebarColor = JSColor("#d0d8e0");
    this._titleColor = JSColor("black");
    this._title = "Title Bar";
    this._titleBar = void 0;
    this._tableView = void 0;
    this.delegate = null;
    this.dataSource = null;
    this.childlist = [];
    this.bounds = getBounds();
    if (!(this._titleBar != null)) {
      this._titleBar = new JSLabel(JSRectMake(0, 0, this.bounds.size.width, 32));
      this._titleBar.setText(this._title);
      this._titleBar.setTextAlignment("JSTextAlignmentLeft");
      this._titleBar.setTextSize(11);
      this._titleBar.setBackgroundColor(this._titlebarColor);
      this._titleBar.setTextColor(this._titleColor);
    }
  }

  JSTableView.prototype.setRowHeight = function(_rowHeight) {
    this._rowHeight = _rowHeight;
  };

  JSTableView.prototype.cellForRowAtIndexPath = function(num) {
    return this.childlist[num];
  };

  JSTableView.prototype.addTableView = function() {
    var cell, cellHeight, diff_y, dispNum, frm, i, _ref;
    if (typeof this.dataSource.numberOfRowsInSection === 'function') {
      this._dataNum = this.dataSource.numberOfRowsInSection();
    } else {
      this._dataNum = 0;
    }
    if (typeof this.dataSource.numberOfSectionsInTableView === 'function') {
      this._sectionNum = this.dataSource.numberOfSectionsInTableView();
    } else {
      this._sectionNum = 1;
    }
    this._tableView.setFrame(getBounds());
    this._tableView.setScroll(true);
    dispNum = parseInt(this.bounds.size.height / this._rowHeight);
    diff_y = 32;
    for (i = 0, _ref = this._dataNum; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
      cell = this.dataSource.cellForRowAtIndexPath(i);
      cell._cellnum = i;
      cell.delegate = this.delegate;
      this.childlist.push(cell);
      if (typeof this.delegate.heightForRowAtIndexPath === 'function') {
        cellHeight = this.delegate.heightForRowAtIndexPath(i);
      } else {
        cellHeight = this._rowHeight;
      }
      frm = JSRectMake(0, diff_y, cell._frame.size.width, cellHeight);
      cell.setFrame(frm);
      this._tableView.addSubview(cell);
      diff_y += cellHeight + 1;
    }
    return this._parent.bringSubviewToFront(this._self);
  };

  JSTableView.prototype.reloadData = function() {
    var obj, _i, _len, _ref;
    _ref = this.childlist;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      obj = _ref[_i];
      obj.removeFromSuperview();
    }
    return this.addTableView();
  };

  JSTableView.prototype.viewDidAppear = function() {
    JSTableView.__super__.viewDidAppear.call(this);
    if (!(this._tableView != null)) {
      this._tableView = new JSScrollView();
      this._self.addSubview(this._tableView);
    }
    if (!(this._titleBar != null)) {
      this._titleBar = new JSLabel(JSRectMake(0, 0, this.bounds.size.width, 32));
    }
    this._titleBar.setAlpha(0.9);
    this._self.addSubview(this._titleBar);
    return this.addTableView();
  };

  return JSTableView;

})(JSScrollView);

JSTextField = (function(_super) {

  __extends(JSTextField, _super);

  function JSTextField(frame) {
    if (frame == null) frame = JSRectMake(0, 0, 120, 24);
    JSTextField.__super__.constructor.call(this, frame);
    this._textSize = 10;
    this._textColor = JSColor("black");
    this._bgColor = JSColor("#f0f0f0");
    this._textAlignment = "JSTextAlignmentCenter";
    this._text = "";
    this._editable = true;
    this._action = null;
    this._focus = false;
    this._placeholder = "";
  }

  JSTextField.prototype.getText = function() {
    var text;
    if (this._editable === true) {
      text = $(this._viewSelector + "_text").val();
    } else {
      text = this._text;
    }
    return text;
  };

  JSTextField.prototype.setText = function(_text) {
    var disp;
    this._text = _text;
    if (($(this._viewSelector + "_text").length)) {
      if (this._editable === true) {
        return $(this._viewSelector + "_text").val(this._text);
      } else {
        disp = JSEscape(this._text);
        return $(this._viewSelector + "_text").html(disp);
      }
    }
  };

  JSTextField.prototype.setTextSize = function(_textSize) {
    this._textSize = _textSize;
    if (($(this._viewSelector + "_text").length)) {
      return $(this._viewSelector + "_text").css("font-size", this._textSize + "pt");
    }
  };

  JSTextField.prototype.setTextColor = function(_textColor) {
    this._textColor = _textColor;
    if (($(this._viewSelector + "_text").length)) {
      return $(this._viewSelector).css("color", this._textColor);
    }
  };

  JSTextField.prototype.setTextAlignment = function(_textAlignment) {
    this._textAlignment = _textAlignment;
    switch (this._textAlignment) {
      case "JSTextAlignmentCenter":
        return $(this._viewSelector).css("text-align", "center");
      case "JSTextAlignmentLeft":
        return $(this._viewSelector).css("text-align", "left");
      case "JSTextAlignmentRight":
        return $(this._viewSelector).css("text-align", "right");
      default:
        return $(this._viewSelector).css("text-align", "center");
    }
  };

  JSTextField.prototype.setFrame = function(frame) {
    frame.size.width -= 5;
    frame.origin.x += 2;
    JSTextField.__super__.setFrame.call(this, frame);
    $(this._viewSelector + "_text").width(frame.size.width);
    return $(this._viewSelector + "_text").height(frame.size.height);
  };

  JSTextField.prototype.setPlaceholder = function(_placeholder) {
    this._placeholder = _placeholder;
    if (($(this._viewSelector + "_text").length)) {
      return $(this._viewSelector + "_text").attr("placeholder", this._placeholder);
    }
  };

  JSTextField.prototype.setEditable = function(editable) {
    var disp, tag, text, x, y,
      _this = this;
    if (!$(this._viewSelector).length) {
      this._editable = editable;
      return;
    }
    if (editable === true) {
      if (this._editable === true) {
        if (!$(this._viewSelector + "_text").length) {
          tag = "<input type='text' id='" + this._objectID + "_text' style='position:absolute;z-index:1;height:" + this._frame.size.height + "px;' value='" + this._text + "' />";
        } else {
          this._text = $(this._viewSelector + "_text").val();
          return;
        }
      } else {
        disp = JSEscape(this._text);
        tag = "<input type='text' id='" + this._objectID + "_text' style='position:absolute;z-index:1;height:" + this._frame.size.height + "px;' value='" + disp + "' />";
      }
      x = -2;
      y = -2;
    } else {
      if (this._editable === true) {
        this._text = $(this._viewSelector + "_text").val();
        text = JSEscape(this._text);
        disp = text.replace(/\n/g, "<br>");
        tag = "<div id='" + this._objectID + "_text' style='position:absolute;z-index:1;overflow:hidden;'>" + disp + "</div>";
      } else {
        text = JSEscape(this._text);
        disp = text.replace(/\n/g, "<br>");
        tag = "<div id='" + this._objectID + "_text' style='position:absolute;z-index:1;overflow:hidden;'>" + disp + "</div>";
      }
      x = 0;
      y = 0;
    }
    this._editable = editable;
    if (($(this._viewSelector + "_text").length)) {
      $(this._viewSelector + "_text").remove();
    }
    $(this._viewSelector).append(tag);
    $(this._viewSelector + "_text").keypress(function(event) {
      if ((_this.action != null)) return _this.action(event.which);
    });
    if (this._editable === true) {
      $(this._viewSelector + "_text").unbind("click").bind("click", function(event) {
        return event.stopPropagation();
      });
      $(this._viewSelector + "_text").bind("change", function() {
        return _this._text = $(_this._viewSelector + "_text").val();
      });
    }
    this.setTextSize(this._textSize);
    this.setTextColor(this._textColor);
    this.setTextAlignment(this._textAlignment);
    $(this._viewSelector + "_text").css("left", x);
    $(this._viewSelector + "_text").css("top", y);
    $(this._viewSelector + "_text").width(this._frame.size.width);
    return $(this._viewSelector + "_text").height(this._frame.size.height);
  };

  JSTextField.prototype.setDidKeyPressEvent = function(action) {
    this.action = action;
  };

  JSTextField.prototype.setFocus = function(_focus) {
    this._focus = _focus;
    if (!$(this._viewSelector + "_text").length) return;
    if (this._focus === true) {
      return $(this._viewSelector + "_text").focus();
    } else {
      return $(this._viewSelector + "_text").blur();
    }
  };

  JSTextField.prototype.viewDidAppear = function() {
    JSTextField.__super__.viewDidAppear.call(this);
    this.setEditable(this._editable);
    $(this._viewSelector).css("vertical-align", "middle");
    $(this._viewSelector + "_text").width(this._frame.size.width);
    this.setTextSize(this._textSize);
    this.setTextColor(this._textColor);
    this.setTextAlignment(this._textAlignment);
    this.setPlaceholder(this._placeholder);
    return $(this._viewSelector).css("overflow", "");
  };

  return JSTextField;

})(JSControl);

JSTextView = (function(_super) {

  __extends(JSTextView, _super);

  function JSTextView(frame) {
    this.animateWithDuration = __bind(this.animateWithDuration, this);    JSTextView.__super__.constructor.call(this, frame);
    this._editable = true;
    this._textSize = 8;
    this._textColor = JSColor("black");
    this._bgColor = JSColor("white");
    this._borderColor = JSColor("clearColor");
    this._borderWidth = 0;
    this._textAlignment = "JSTextAlignmentLeft";
    this._text = "";
    this._writingMode = 0;
    this._lineHeight = 1.0;
    this._fontFamily = "gothic";
    this._placeholder = "";
    this._textVerticalAlignment = "JSTextVerticalAlignmentTop";
  }

  JSTextView.prototype.setWritingMode = function(_writingMode) {
    this._writingMode = _writingMode;
    this._editable = false;
    return this.setEditable(this._editable);
  };

  JSTextView.prototype.getText = function() {
    var text;
    if (this._editable === true) {
      text = $(this._viewSelector + "_textarea").val();
    } else {
      text = this._text;
    }
    return text;
  };

  JSTextView.prototype.setText = function(text) {
    var disp, writingmode;
    this._text = text.replace(/<br>/g, "\n");
    if (($(this._viewSelector + "_textarea").length)) {
      if (this._writingMode === 0) {
        writingmode = "horizontal-tb";
      } else {
        writingmode = "vertical-rl";
      }
      $(this._viewSelector + "_textarea").css("-webkit-writing-mode", writingmode);
      if (this._editable === true) {
        return $(this._viewSelector + "_textarea").val(this._text);
      } else {
        disp = this._text.replace(/\n/g, "<br>");
        return $(this._viewSelector + "_textarea").html(disp);
      }
    }
  };

  JSTextView.prototype.setTextSize = function(_textSize) {
    this._textSize = _textSize;
    if (($(this._viewSelector + "_textarea").length)) {
      return $(this._viewSelector + "_textarea").css("font-size", this._textSize + "pt");
    }
  };

  JSTextView.prototype.setTextColor = function(_textColor) {
    this._textColor = _textColor;
    if (($(this._viewSelector + "_textarea").length)) {
      return $(this._viewSelector + "_textarea").css("color", this._textColor);
    }
  };

  JSTextView.prototype.setFrame = function(frame) {
    JSTextView.__super__.setFrame.call(this, frame);
    if (($(this._viewSelector + "_textarea").length)) {
      $(this._viewSelector + "_textarea").width(frame.size.width);
      return $(this._viewSelector + "_textarea").height(frame.size.height);
    }
  };

  JSTextView.prototype.animateWithDuration = function(duration, animations, completion) {
    var animobj, key, value, _results;
    if (completion == null) completion = null;
    JSTextView.__super__.animateWithDuration.call(this, duration, animations, completion);
    animobj = {};
    _results = [];
    for (key in animations) {
      value = animations[key];
      if (key === "width") {
        _results.push($(this._viewSelector + "_textarea").css('width', value));
      } else if (key === "height") {
        _results.push($(this._viewSelector + "_textarea").css('height', value));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  JSTextView.prototype.setPlaceholder = function(_placeholder) {
    this._placeholder = _placeholder;
    if (($(this._viewSelector + "_textarea").length)) {
      return $(this._viewSelector + "_textarea").attr("placeholder", this._placeholder);
    }
  };

  JSTextView.prototype.setEditable = function(editable) {
    var disp, tag, text, writingmode, x, y,
      _this = this;
    if (!$(this._viewSelector).length) {
      this._editable = editable;
      return;
    }
    if (editable === true) {
      this.setUserInteractionEnabled(true);
      if (this._editable === true) {
        if (!$(this._viewSelector + "_textarea").length) {
          tag = "<textarea id='" + this._objectID + "_textarea' style='position:absolute;overflow:auto;word-break:break-all;z-index:1;'>" + this._text + "</textarea>";
        } else {
          this._text = $(this._viewSelector + "_textarea").val();
          return;
        }
      } else {
        tag = "<textarea id='" + this._objectID + "_textarea' style='position:absolute;overflow:auto;word-break:break-all;z-index:1;'>" + this._text + "</textarea>";
      }
      x = -2;
      y = -2;
    } else {
      if (this._editable === true) {
        this._text = $(this._viewSelector + "_textarea").val();
        text = JSEscape(this._text);
        disp = text.replace(/\n/g, "<br>");
      } else {
        text = JSEscape(this._text);
        disp = text.replace(/\n/g, "<br>");
      }
      tag = "<div id='" + this._objectID + "_textarea' style='overflow:auto;word-break:break-all;z-index:1;display:table-cell; vertical-align:middle;'>" + disp + "</div>";
      x = 0;
      y = 0;
    }
    this._editable = editable;
    if (($(this._viewSelector + "_textarea").length)) {
      $(this._viewSelector + "_textarea").remove();
    }
    $(this._viewSelector).append(tag);
    if (this._writingMode === 0) {
      writingmode = "horizontal-tb";
    } else {
      writingmode = "vertical-rl";
      $(this._viewSelector + "_textarea").css("position", "absolute");
    }
    $(this._viewSelector + "_textarea").css("-webkit-writing-mode", writingmode);
    $(this._viewSelector + "_textarea").css("background-color", JSColor("clearColor"));
    $(this._viewSelector + "_textarea").css("border", "none");
    if (this._editable === true) {
      $(this._viewSelector + "_textarea").unbind("click").bind("click", function(event) {
        return event.stopPropagation();
      });
      $(this._viewSelector + "_textarea").bind("change", function() {
        return _this._text = $(_this._viewSelector + "_textarea").val();
      });
    } else {
      $(this._viewSelector + "_textarea").unbind("click");
    }
    this.setTextSize(this._textSize);
    this.setTextColor(this._textColor);
    this.setTextAlignment(this._textAlignment);
    this.setTextVerticalAlignment(this._textVerticalAlignment);
    $(this._viewSelector + "_textarea").css("left", x);
    $(this._viewSelector + "_textarea").css("top", y);
    $(this._viewSelector + "_textarea").width(this._frame.size.width);
    return $(this._viewSelector + "_textarea").height(this._frame.size.height);
  };

  JSTextView.prototype.setTextAlignment = function(_textAlignment) {
    this._textAlignment = _textAlignment;
    if (!$(this._viewSelector + "_textarea").length) return;
    switch (this._textAlignment) {
      case "JSTextAlignmentCenter":
        return $(this._viewSelector + "_textarea").css("text-align", "center");
      case "JSTextAlignmentLeft":
        return $(this._viewSelector + "_textarea").css("text-align", "left");
      case "JSTextAlignmentRight":
        return $(this._viewSelector + "_textarea").css("text-align", "right");
      default:
        return $(this._viewSelector + "_textarea").css("text-align", "center");
    }
  };

  JSTextView.prototype.setTextVerticalAlignment = function(_textVerticalAlignment) {
    this._textVerticalAlignment = _textVerticalAlignment;
    if (!$(this._viewSelector + "_textarea").length) return;
    switch (this._textVerticalAlignment) {
      case "JSTextVerticalAlignmentTop":
        return $(this._viewSelector + "_textarea").css("vertical-align", "top");
      case "JSTextVerticalAlignmentMiddle":
        return $(this._viewSelector + "_textarea").css("vertical-align", "middle");
      case "JSTextVerticalAlignmentBottom":
        return $(this._viewSelector + "_textarea").css("vertical-align", "bottom");
      default:
        return $(this._viewSelector + "_textarea").css("vertical-align", "middle");
    }
  };

  JSTextView.prototype.setTextLineHeight = function(_lineHeight) {
    this._lineHeight = _lineHeight;
    if (($(this._viewSelector + "_textarea").length)) {
      return $(this._viewSelector + "_textarea").css("line-height", this._lineHeight);
    }
  };

  JSTextView.prototype.setTextFontFamily = function(_fontFamily) {
    this._fontFamily = _fontFamily;
    if (($(this._viewSelector + "_textarea").length)) {
      switch (this._fontFamily) {
        case "mincho":
          return $(this._viewSelector + "_textarea").css("font-family", "'Hiragino Mincho ProN', serif;");
        case "gothic":
          return $(this._viewSelector + "_textarea").css("font-family", "'Hiragino Maru Gothic Pro W4', 'sans-serif';");
      }
    }
  };

  JSTextView.prototype.viewDidAppear = function() {
    var _this = this;
    JSTextView.__super__.viewDidAppear.call(this);
    this.setEditable(this._editable);
    this.setTextSize(this._textSize);
    this.setTextColor(this._textColor);
    this.setTextAlignment(this._textAlignment);
    this.setTextVerticalAlignment(this._textVerticalAlignment);
    this.setTextLineHeight(this._lineHeight);
    this.setTextFontFamily(this._fontFamily);
    this.setPlaceholder(this._placeholder);
    if (this._editable === true) {
      return $(this._viewSelector + "_textarea").unbind("click").bind("click", function(event) {
        return event.stopPropagation();
      });
    } else {
      return $(this._viewSelector + "_textarea").unbind("click");
    }
  };

  return JSTextView;

})(JSScrollView);
