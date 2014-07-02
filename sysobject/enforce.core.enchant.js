var BGSCENE, BGSCENE_SUB1, BGSCENE_SUB2, CAMERA, CONTROL, GAMESCENE, GAMESCENE_SUB1, GAMESCENE_SUB2, JSLog, LAPSEDTIME, SPRITE, TOPSCENE, addObject, box2dworld, core, getBounds, getObject, nop, rand, removeObject, rootScene, rootScene3D, sprintf, uniqueID, _DEBUGLABEL, _getNullObject, _main, _objects, _originObject, _scenes, _stationary,
  __slice = Array.prototype.slice;

_originObject = (function() {

  function _originObject() {
    this.active = false;
  }

  return _originObject;

})();

_stationary = (function() {

  function _stationary(sprite) {
    this.sprite = sprite;
    this._processnumber = 0;
    this._waittime = 0.0;
    this._dispframe = 0;
    this._endflag = false;
    this._returnflag = false;
    this._autoRemove = false;
    /*
            if (@sprite?)
                @sprite.intersectFlag = true
                #@sprite.addEventListener 'touchstart', (e)=>
                @sprite.ontouchstart = (e)=>
                    if (typeof @touchesBegan == 'function')
                        @touchesBegan(e)
                #@sprite.addEventListener 'touchmove', (e)=>
                @sprite.ontouchmove = (e)=>
                    if (typeof @touchesMoved == 'function')
                        @touchesMoved(e)
                #@sprite.addEventListener 'touchend', (e)=>
                @sprite.ontouchend = (e)=>
                    if (typeof @touchesEnded == 'function')
                        @touchesEnded(e)
                #@sprite.addEventListener 'touchcancel', (e)=>
                @sprite.ontouchcancel = (e)=>
                    if (typeof @touchesCanceled == 'function')
                        @touchesCanceled(e)
    */
  }

  _stationary.prototype.destructor = function() {};

  _stationary.prototype.behavior = function() {
    var animpattern;
    if (this._type === SPRITE && (this.sprite != null)) {
      if (this.sprite.x !== this.sprite.xback) this.sprite._x_ = this.sprite.x;
      if (this.sprite.y !== this.sprite.yback) this.sprite._y_ = this.sprite.y;
      if (this.sprite.z !== this.sprite.zback) this.sprite._z_ = this.sprite.z;
      this.sprite.ys += this.sprite.gravity;
      this.sprite._x_ += this.sprite.xs;
      this.sprite._y_ += this.sprite.ys;
      this.sprite._z_ += this.sprite.zs;
      this.sprite.x = Math.round(this.sprite._x_);
      this.sprite.y = Math.round(this.sprite._y_);
      this.sprite.z = Math.round(this.sprite._z_);
      this.sprite.xback = this.sprite.x;
      this.sprite.yback = this.sprite.y;
      this.sprite.zback = this.sprite.z;
    }
    if (this._type < 5) {
      if (this.sprite.x < -this.sprite.width || this.sprite.x > SCREEN_WIDTH || this.sprite.y < -this.sprite.height || this.sprite.y > SCREEN_HEIGHT || this._autoRemove === true) {
        if (typeof this.autoRemove === 'function') {
          this.autoRemove();
          removeObject(this);
        }
      }
      if ((this.sprite.animlist != null)) {
        animpattern = this.sprite.animlist[this.sprite.animnum];
        this.sprite.frameIndex = animpattern[this._dispframe++];
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
    }
    if (this._waittime > 0 && LAPSEDTIME > this._waittime) {
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
    this._waittime = LAPSEDTIME + wtime;
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

  _stationary.prototype.isIntersect = function(motionObj, method) {
    var ret;
    if (method == null) method = void 0;
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

  _stationary.prototype.setModel = function(num) {
    var model;
    model = MEDIALIST[num];
    return this.set(core.assets[model]);
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

BGSCENE = 0;

BGSCENE_SUB1 = 1;

BGSCENE_SUB2 = 2;

GAMESCENE = 3;

GAMESCENE_SUB1 = 4;

GAMESCENE_SUB2 = 5;

TOPSCENE = 6;

LAPSEDTIME = 0;

CAMERA = void 0;

_objects = [];

_scenes = [];

_main = null;

_DEBUGLABEL = null;

core = null;

box2dworld = null;

rootScene3D = null;

rootScene = null;

enchant();

enchant.Sound.enabledInMobileSafari = true;

enchant.ENV.MOUSE_ENABLED = false;

window.onload = function() {
  var i, imagearr, obj, scene, _ref;
  core = new Core(SCREEN_WIDTH, SCREEN_HEIGHT);
  core.rootScene.backgroundColor = "transparent";
  core.fps = FPS;
  if ((typeof MEDIALIST !== "undefined" && MEDIALIST !== null)) {
    imagearr = [];
    i = 0;
    for (obj in MEDIALIST) {
      imagearr[i++] = MEDIALIST[obj];
    }
    core.preload(imagearr);
  }
  rootScene = core.rootScene;
  for (i = 0, _ref = TOPSCENE + 1; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
    scene = new Group();
    scene.backgroundColor = "black";
    _scenes[i] = scene;
    rootScene.addChild(scene);
  }
  core.onload = function() {
    var i;
    for (i = 0; 0 <= OBJECTNUM ? i < OBJECTNUM : i > OBJECTNUM; 0 <= OBJECTNUM ? i++ : i--) {
      _objects[i] = new _originObject();
    }
    _main = new enforceMain();
    return rootScene.addEventListener('enterframe', function(e) {
      return LAPSEDTIME = parseFloat((core.frame / FPS).toFixed(2));
    });
  };
  return core.start();
};

addObject = function(param) {
  var animlist, animnum, animpattern, cellx, celly, density, friction, gravity, image, img, model, motionObj, motionsprite, move, obj, objnum, opacity, restitution, scene, uid, visible, x, xs, y, ys, _type;
  motionObj = (param.motionObj != null) ? param.motionObj : void 0;
  _type = (param.type != null) ? param.type : SPRITE;
  x = (param.x != null) ? param.x : 0.0;
  y = (param.y != null) ? param.y : 0.0;
  xs = (param.xs != null) ? param.xs : 0.0;
  ys = (param.ys != null) ? param.ys : 0.0;
  gravity = (param.gravity != null) ? param.gravity : 0.0;
  image = (param.image != null) ? param.image : void 0;
  cellx = (param.cellx != null) ? param.cellx : 0.0;
  celly = (param.celly != null) ? param.celly : 0.0;
  opacity = (param.opacity != null) ? param.opacity : 1.0;
  animlist = (param.animlist != null) ? param.animlist : void 0;
  animnum = (param.animnum != null) ? param.animnum : 0;
  visible = (param.visible != null) ? param.visible : true;
  scene = (param.scene != null) ? param.scene : -1;
  model = (param.model != null) ? param.model : void 0;
  density = (param.density != null) ? param.density : 1.0;
  friction = (param.friction != null) ? param.friction : 0.5;
  restitution = (param.restitution != null) ? param.restitution : 0.1;
  move = (param.move != null) ? param.move : false;
  if (motionObj === null) motionObj = void 0;
  objnum = _getNullObject();
  if (objnum < 0) return;
  obj = _objects[objnum];
  obj.active = true;
  switch (_type) {
    case CONTROL:
    case SPRITE:
      motionsprite = new Sprite();
      if (scene < 0) scene = GAMESCENE_SUB1;
      break;
    default:
      motionsprite = void 0;
      if (scene < 0) scene = GAMESCENE_SUB1;
  }
  motionsprite.tl.setTimeBased();
  _scenes[scene].addChild(motionsprite);
  switch (_type) {
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
      motionsprite.gravity = gravity;
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
  if ((MEDIALIST[image] != null) && (animlist != null)) {
    img = MEDIALIST[image];
    motionsprite.image = core.assets[img];
  }
  if ((animlist != null)) {
    animpattern = animlist[animnum];
    motionsprite.frame = animpattern[0];
  }
  obj.motionObj._type = _type;
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
  if (motionObj._type === DSPRITE_BOX || motionObj._type === DSPRITE_CIRCLE || motionObj._type === SSPRITE_BOX || motionObj._type === SSPRITE_CIRCLE) {
    parent.motionObj.sprite.destroy();
  } else {
    _scenes[parent.motionObj._scene].removeChild(parent.motionObj.sprite);
  }
  parent.motionObj.sprite = 0;
  parent.motionObj = 0;
  return parent.active = false;
};

getObject = function(id) {
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
