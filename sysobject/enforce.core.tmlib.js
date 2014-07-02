var BGSCENE, BGSCENE_SUB1, BGSCENE_SUB2, CONTROL, GAMESCENE, GAMESCENE_SUB1, GAMESCENE_SUB2, GLMODEL, JSLog, LABEL, LAPSEDTIME, PHYSICAL, SPRITE, TOPSCENE, addObject, core, getBounds, getObject, nop, rand, removeObject, sprintf, uniqueID, _getNullObject, _objects, _originObject, _scenes, _stationary,
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

core = null;

_objects = [];

_scenes = [];

LAPSEDTIME = 0;

CONTROL = 0;

SPRITE = 1;

LABEL = 2;

PHYSICAL = 3;

GLMODEL = 4;

BGSCENE = 0;

BGSCENE_SUB1 = 1;

BGSCENE_SUB2 = 2;

GAMESCENE = 3;

GAMESCENE_SUB1 = 4;

GAMESCENE_SUB2 = 5;

TOPSCENE = 6;

tm.main(function() {
  core = tm.display.CanvasApp("#stage");
  core.fps = FPS;
  core.resize(SCREEN_WIDTH, SCREEN_HEIGHT);
  core.fitWindow();
  core.replaceScene(customLoadingScene({
    assets: MEDIALIST,
    nextScene: mainScene,
    width: SCREEN_WIDTH,
    height: SCREEN_HEIGHT
  }));
  return core.run();
});

tm.define("customLoadingScene", {
  superClass: "tm.app.Scene",
  init: function(param) {
    var label;
    this.superInit();
    this.bg = tm.display.Shape(param.width, param.height).addChildTo(this);
    this.bg.canvas.clearColor("#000000");
    this.bg.setOrigin(0, 0);
    label = tm.display.Label("loading");
    label.x = param.width / 2;
    label.y = param.height / 2;
    label.width = param.width;
    label.align = "center";
    label.baseline = "middle";
    label.fontSize = 24;
    label.setFillStyle("#ffffff");
    label.counter = 0;
    label.update = function(app) {
      if (app.frame % 30 === 0) {
        this.text += ".";
        this.counter += 1;
        if (this.counter > 3) {
          this.counter = 0;
          this.text = "loading";
        }
      }
    };
    label.addChildTo(this.bg);
    this.bg.tweener.clear().fadeIn(100).call((function() {
      var loader;
      if (param.assets) {
        loader = tm.asset.Loader();
        loader.onload = (function() {
          this.bg.tweener.clear().wait(300).fadeOut(300).call((function() {
            var e;
            if (param.nextScene) this.app.replaceScene(param.nextScene());
            e = tm.event.Event("load");
            this.fire(e);
          }).bind(this));
        }).bind(this);
        loader.onprogress = (function(e) {
          var event;
          event = tm.event.Event("progress");
          event.progress = e.progress;
          this.fire(event);
        }).bind(this);
        loader.load(param.assets);
      }
    }).bind(this));
  }
});

tm.define("mainScene", {
  superClass: "tm.app.Scene",
  init: function() {
    var i, rootScene, scene, _main, _ref;
    this.superInit();
    rootScene = this;
    for (i = 0, _ref = TOPSCENE + 1; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
      scene = tm.display.CanvasElement().addChildTo(rootScene);
      _scenes[i] = scene;
    }
    for (i = 0; 0 <= OBJECTNUM ? i < OBJECTNUM : i > OBJECTNUM; 0 <= OBJECTNUM ? i++ : i--) {
      _objects[i] = new _originObject();
    }
    return _main = new enforceMain();
  },
  onenterframe: function() {
    return LAPSEDTIME = parseFloat((core.frame / FPS).toFixed(2));
  }
});

addObject = function(param) {
  var animlist, animnum, animtmp, cellx, celly, gravity, image, motionObj, motionsprite, obj, objnum, opacity, scene, type, uid, visible, x, xs, y, ys, z, zs;
  motionObj = (param.motionObj != null) ? param.motionObj : void 0;
  type = (param.type != null) ? param.type : SPRITE;
  x = (param.x != null) ? param.x : 0.0;
  y = (param.y != null) ? param.y : 0.0;
  z = (param.z != null) ? param.z : 0.0;
  xs = (param.xs != null) ? param.xs : 0.0;
  ys = (param.ys != null) ? param.ys : 0.0;
  zs = (param.zs != null) ? param.zs : 0.0;
  gravity = (param.gravity != null) ? param.gravity : 0.0;
  image = (param.image != null) ? param.image : 0;
  cellx = (param.cellx != null) ? param.cellx : 0.0;
  celly = (param.celly != null) ? param.celly : 0.0;
  opacity = (param.opacity != null) ? param.opacity : 1.0;
  animlist = (param.animlist != null) ? param.animlist : [[0]];
  animnum = (param.animnum != null) ? param.animnum : 0;
  visible = (param.visible != null) ? param.visible : true;
  scene = (param.scene != null) ? param.scene : -1;
  if (scene < 0) scene = GAMESCENE;
  objnum = _getNullObject();
  if (objnum < 0) return;
  obj = _objects[objnum];
  obj.active = true;
  motionsprite = tm.display.Sprite(image, cellx, celly);
  switch (type) {
    case SPRITE:
      motionsprite._x_ = x;
      motionsprite._y_ = y;
      motionsprite.setOrigin(0, 0);
      motionsprite.setPosition(x, y);
      animtmp = animlist[animnum];
      motionsprite.frameIndex = animtmp[0];
      motionsprite.blendMode = "lighter";
      motionsprite.alpha = opacity;
      motionsprite.width = cellx;
      motionsprite.height = celly;
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
      _scenes[scene].addChild(motionsprite);
  }
  motionsprite.update = function() {
    if ((obj.motionObj != null) && typeof obj.motionObj.behavior === 'function') {
      return obj.motionObj.behavior();
    }
  };
  if ((motionObj != null)) {
    obj.motionObj = new motionObj(motionsprite);
  } else {
    obj.motionObj = new _stationary(motionsprite);
  }
  uid = uniqueID();
  obj.motionObj._uniqueID = uid;
  obj.motionObj._scene = scene;
  obj.motionObj._type = type;
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
