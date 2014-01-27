var BGSCENE, BGSCENE_SUB1, BGSCENE_SUB2, CONTROL, GAMESCENE, GAMESCENE_SUB1, GAMESCENE_SUB2, JSLog, LABEL, PHYSICS, SPRITE, TOPSCENE, WEBGL, core, createObject, debugwrite, getBounds, lapsedtime, nop, rand, removeObject, rootScene, sprintf, uniqueID, _DEBUGLABEL, _getNullObject, _main, _objects, _originObject, _scenes, _stationary,
  __slice = Array.prototype.slice;

_originObject = (function() {

  function _originObject() {
    this.active = false;
  }

  return _originObject;

})();

_stationary = (function() {

  function _stationary(sprite) {
    var _this = this;
    this.sprite = sprite;
    this._processnumber = 0;
    this._waittime = 0.0;
    this._dispframe = 0;
    this._endflag = false;
    this._returnflag = false;
    this._autoRemove = false;
    if ((this.sprite != null)) {
      this.sprite.intersectFlag = true;
      this.sprite.addEventListener('touchstart', function(e) {
        if (typeof _this.touchesBegan === 'function') return _this.touchesBegan(e);
      });
      this.sprite.addEventListener('touchmove', function(e) {
        if (typeof _this.touchesMoved === 'function') return _this.touchesMoved(e);
      });
      this.sprite.addEventListener('touchend', function(e) {
        if (typeof _this.touchesEnded === 'function') return _this.touchesEnded(e);
      });
      this.sprite.addEventListener('touchcancel', function(e) {
        if (typeof _this.touchesCanceled === 'function') {
          return _this.touchesCanceled(e);
        }
      });
    }
  }

  _stationary.prototype.destructor = function() {};

  _stationary.prototype.behavior = function() {
    var animpattern;
    if (this._type_ === SPRITE && (this.sprite != null)) {
      if (this.sprite.x !== this.sprite.xback) this.sprite._x_ = this.sprite.x;
      if (this.sprite.y !== this.sprite.yback) this.sprite._y_ = this.sprite.y;
      this.sprite.ys += this.sprite.gravity;
      this.sprite._x_ += this.sprite.xs;
      this.sprite._y_ += this.sprite.ys;
      this.sprite.x = Math.round(this.sprite._x_);
      this.sprite.y = Math.round(this.sprite._y_);
      this.sprite.xback = this.sprite.x;
      this.sprite.yback = this.sprite.y;
    }
    if (this.sprite.x < -this.sprite.width || this.sprite.x > SCREEN_WIDTH || this.sprite.y < -this.sprite.height || this.sprite.y > SCREEN_HEIGHT) {
      if (typeof this.autoRemove === 'function') {
        this.autoRemove();
        removeObject(this);
      }
    }
    if ((this.sprite.animlist != null)) {
      animpattern = this.sprite.animlist[this.sprite.animnum];
      this.sprite.frame = animpattern[this._dispframe++];
      if (this._dispframe >= animpattern.length) {
        if (this._endflag === true) {
          this._endflag = false;
          removeObject(this);
          return;
        } else if (this._returnflag === true) {
          this._returnflag = false;
          this.sprite.animnum = this._beforeAnimnum;
          this._dispframe = 0;
        } else {
          this._dispframe = 0;
        }
      }
    }
    if (this._waittime > 0 && lapsedtime > this._waittime) {
      this._waittime = 0;
      return this._processnumber = this._nextprocessnum;
    }
  };

  _stationary.prototype.touchesBegan = function(e) {};

  _stationary.prototype.touchesMoved = function(e) {};

  _stationary.prototype.touchesEnded = function(e) {};

  _stationary.prototype.touchesCanceled = function(e) {};

  _stationary.prototype.nextjob = function() {
    return this._processnumber++;
  };

  _stationary.prototype.waitjob = function(wtime) {
    this._waittime = lapsedtime + wtime;
    this._nextprocessnum = this._processnumber + 1;
    return this._processnumber = -1;
  };

  _stationary.prototype.setProcessNumber = function(num) {
    return this._processnumber = num;
  };

  _stationary.prototype.isWithIn = function(motionObj, range) {
    var ret;
    if (range == null) range = -1;
    if (!(motionObj != null)) return false;
    if (range < 0) range = motionObj.sprite.width / 2;
    if (this.sprite.intersectFlag === true && motionObj.sprite.intersectFlag === true) {
      ret = this.sprite.within(motionObj.sprite, range);
    } else {
      ret = false;
    }
    return ret;
  };

  _stationary.prototype.isIntersect = function(motionObj) {
    var ret;
    if (!(motionObj.sprite != null)) return false;
    if (this.sprite.intersectFlag === true && motionObj.sprite.intersectFlag === true) {
      ret = this.sprite.intersect(motionObj.sprite);
    } else {
      ret = false;
    }
    return ret;
  };

  _stationary.prototype.setAnimationToRemove = function(animnum) {
    this.sprite.animnum = animnum;
    this._dispframe = 0;
    return this._endflag = true;
  };

  _stationary.prototype.setAnimationToOnce = function(animnum, animnum2) {
    this._beforeAnimnum = animnum2;
    this.sprite.animnum = animnum;
    this._dispframe = 0;
    return this._returnflag = true;
  };

  return _stationary;

})();

rand = function(n) {
  return Math.floor(Math.random() * (n + 1));
};

JSLog = function() {
  var a, b, data, _i, _len;
  a = arguments[0], b = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
  if (DEBUG === true) {
    for (_i = 0, _len = b.length; _i < _len; _i++) {
      data = b[_i];
      a = a.replace('%@', data);
    }
    return console.log(a);
  }
};

sprintf = function() {
  var a, b, data, _i, _len;
  a = arguments[0], b = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
  for (_i = 0, _len = b.length; _i < _len; _i++) {
    data = b[_i];
    a = a.replace('%@', data);
  }
  return a;
};

uniqueID = function() {
  var S4;
  S4 = function() {
    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
  };
  return S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4();
};

getBounds = function() {
  var frame;
  frame = [parseInt(document.documentElement.clientWidth - 1), parseInt(document.documentElement.clientHeight - 1)];
  return frame;
};

nop = function() {};

CONTROL = 0;

SPRITE = 1;

LABEL = 2;

PHYSICS = 3;

WEBGL = 4;

BGSCENE = 0;

BGSCENE_SUB1 = 1;

BGSCENE_SUB2 = 2;

GAMESCENE = 3;

GAMESCENE_SUB1 = 4;

GAMESCENE_SUB2 = 5;

TOPSCENE = 6;

_objects = [];

_scenes = [];

_main = null;

_DEBUGLABEL = null;

core = null;

rootScene = null;

lapsedtime = 0;

enchant();

window.onload = function() {
  var i, scene, _ref;
  core = new Core(SCREEN_WIDTH, SCREEN_HEIGHT);
  rootScene = core.rootScene;
  core.rootScene.backgroundColor = BGCOLOR;
  core.fps = FPS;
  core.preload(IMAGELIST);
  core.keybind('Z'.charCodeAt(0), 'a');
  core.keybind('X'.charCodeAt(0), 'b');
  core.keybind(32, "space");
  for (i = 0, _ref = TOPSCENE + 1; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
    scene = new Group();
    _scenes[i] = scene;
    core.rootScene.addChild(scene);
  }
  core.onload = function() {
    var i;
    for (i = 0; 0 <= OBJECTNUM ? i < OBJECTNUM : i > OBJECTNUM; 0 <= OBJECTNUM ? i++ : i--) {
      _objects[i] = new _originObject();
    }
    _main = new enchantMain();
    if (DEBUG === true) {
      _DEBUGLABEL = new Label();
      _DEBUGLABEL.x = 0;
      _DEBUGLABEL.y = 0;
      _DEBUGLABEL.color = "black";
      _DEBUGLABEL.font = "10px 'Arial'";
      _scenes[TOPSCENE].addChild(_DEBUGLABEL);
    }
    return core.rootScene.addEventListener('enterframe', function(e) {
      lapsedtime = core.frame / FPS;
      return lapsedtime = parseFloat(lapsedtime.toFixed(2));
    });
  };
  return core.start();
};

debugwrite = function(str) {
  if (DEBUG === true) return _DEBUGLABEL.text = str;
};

createObject = function(motionObj, _type_, x, y, xs, ys, g, image, cellx, celly, opacity, animlist, animnum, visible, scene) {
  var animpattern, motionsprite, obj, objnum, uid;
  if (motionObj == null) motionObj = void 0;
  if (_type_ == null) _type_ = SPRITE;
  if (x == null) x = 0;
  if (y == null) y = 0;
  if (xs == null) xs = 0.0;
  if (ys == null) ys = 0.0;
  if (g == null) g = 0.0;
  if (image == null) image = 0;
  if (cellx == null) cellx = 0;
  if (celly == null) celly = 0;
  if (opacity == null) opacity = 1.0;
  if (animlist == null) animlist = void 0;
  if (animnum == null) animnum = 0;
  if (visible == null) visible = true;
  if (scene == null) scene = GAMESCENE;
  if (motionObj === null) motionObj = void 0;
  objnum = _getNullObject();
  if (objnum < 0) {
    JSLog("object undefined");
    return;
  }
  obj = _objects[objnum];
  obj.active = true;
  switch (_type_) {
    case CONTROL:
    case SPRITE:
      motionsprite = new Sprite();
      break;
    case LABEL:
      motionsprite = new Label();
      break;
    default:
      motionsprite = void 0;
  }
  _scenes[scene].addChild(motionsprite);
  switch (_type_) {
    case SPRITE:
      motionsprite.frame = 0;
      motionsprite.backgroundColor = "transparent";
      motionsprite.x = x;
      motionsprite.y = y;
      motionsprite._x_ = x;
      motionsprite._y_ = y;
      motionsprite.width = cellx;
      motionsprite.height = celly;
      motionsprite.originX = parseInt(cellx / 2);
      motionsprite.originY = parseInt(celly / 2);
      motionsprite.opacity = opacity;
      motionsprite.rotation = 0.0;
      motionsprite.scaleX = 1.0;
      motionsprite.scaleY = 1.0;
      motionsprite.visible = visible;
      motionsprite.intersectFlag = true;
      motionsprite.animlist = animlist;
      motionsprite.animnum = animnum;
      motionsprite.xs = xs;
      motionsprite.ys = ys;
      motionsprite.gravity = g;
      break;
    case LABEL:
      motionsprite.x = x;
      motionsprite.y = y;
      motionsprite._x_ = x;
      motionsprite._y_ = y;
      motionsprite.textAlign = "left";
      motionsprite.font = "12pt 'Arial'";
      motionsprite.color = "black";
  }
  if (motionObj !== void 0) {
    obj.motionObj = new motionObj(motionsprite);
  } else {
    obj.motionObj = new _stationary(motionsprite);
  }
  uid = uniqueID();
  obj.motionObj._uniqueID = uid;
  obj.motionObj._scene = scene;
  if (motionsprite !== void 0) {
    motionsprite.addEventListener('enterframe', function() {
      if (obj.motionObj !== void 0 && typeof obj.motionObj.behavior === 'function') {
        return obj.motionObj.behavior();
      }
    });
  }
  if ((IMAGELIST[image] != null) && (animlist != null)) {
    motionsprite.image = core.assets[IMAGELIST[image]];
  }
  if ((animlist != null)) {
    animpattern = animlist[animnum];
    motionsprite.frame = animpattern[0];
  }
  obj.motionObj._type_ = _type_;
  return obj.motionObj;
};

removeObject = function(motionObj) {
  var parent, ret, _i, _len;
  if (!(motionObj != null)) return;
  ret = false;
  for (_i = 0, _len = _objects.length; _i < _len; _i++) {
    parent = _objects[_i];
    if (!(parent.motionObj != null)) continue;
    if (parent.motionObj._uniqueID === motionObj._uniqueID) {
      ret = true;
      break;
    }
  }
  if (ret === false) return;
  if (typeof motionObj.destructor === 'function') motionObj.destructor();
  _scenes[parent.motionObj._scene].removeChild(parent.motionObj.sprite);
  parent.motionObj.sprite = 0;
  parent.motionObj = 0;
  return parent.active = false;
};

_getNullObject = function() {
  var i, ret, _ref;
  ret = -1;
  for (i = 0, _ref = _objects.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
    if (_objects[i].active === false) {
      ret = i;
      break;
    }
  }
  return ret;
};

({
  getObject: function(id) {
    var i, ret, _ref;
    ret = void 0;
    for (i = 0, _ref = _objects.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
      if (!(_objects[i].motionObj != null)) continue;
      if (_objects[i].motionObj._uniqueID === id) {
        ret = _objects[i].motionObj;
        break;
      }
    }
    return ret;
  }
});
