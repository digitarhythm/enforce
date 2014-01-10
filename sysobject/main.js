// Generated by CoffeeScript 1.3.3
var core, createObject, lapsedtime, main, removeObject, rootScene, _getNullObject, _objects;

_objects = [];

core = null;

main = null;

rootScene = null;

lapsedtime = 0;

enchant();

window.onload = function() {
  core = new Core(SCREEN_WIDTH, SCREEN_HEIGHT);
  rootScene = core.rootScene;
  core.rootScene.backgroundColor = BGCOLOR;
  core.fps = FPS;
  core.preload(IMAGELIST);
  core.onload = function() {
    var i, _i;
    for (i = _i = 0; 0 <= OBJECTNUM ? _i < OBJECTNUM : _i > OBJECTNUM; i = 0 <= OBJECTNUM ? ++_i : --_i) {
      _objects[i] = new _originObject();
    }
    main = new enchantMain();
    /*
    		core.rootScene.addEventListener 'touchstart', (e)->
    			if (typeof(main.touchesBegan) == 'function')
    				main.touchesBegan(e)
    		core.rootScene.addEventListener 'touchmove', (e)->
    			if (typeof(main.touchesMoved) == 'function')
    				main.touchesMoved(e)
    		core.rootScene.addEventListener 'touchend', (e)->
    			if (typeof(main.touchesEnded) == 'function')
    				main.touchesEnded(e)
    		core.rootScene.addEventListener 'touchcancel', (e)->
    			if (typeof(main.touchesCanceled) == 'function')
    				main.touchesCanceled(e)
    */

    return core.rootScene.addEventListener('enterframe', function(e) {
      return lapsedtime = Math.floor(core.frame / FPS);
    });
  };
  return core.start();
};

createObject = function(motionObj, kind, x, y, xs, ys, g, image, cellx, celly, opacity, animlist, animnum, visible) {
  var animpattern, obj;
  if (motionObj == null) {
    motionObj = void 0;
  }
  if (kind == null) {
    kind = 0;
  }
  if (x == null) {
    x = 0;
  }
  if (y == null) {
    y = 0;
  }
  if (xs == null) {
    xs = 0;
  }
  if (ys == null) {
    ys = 0;
  }
  if (g == null) {
    g = 0;
  }
  if (image == null) {
    image = 0;
  }
  if (cellx == null) {
    cellx = 0;
  }
  if (celly == null) {
    celly = 0;
  }
  if (opacity == null) {
    opacity = 1.0;
  }
  if (animlist == null) {
    animlist = void 0;
  }
  if (animnum == null) {
    animnum = 0;
  }
  if (visible == null) {
    visible = true;
  }
  if (motionObj === null) {
    motionObj = void 0;
  }
  obj = _getNullObject();
  if (obj === void 0) {
    return void 0;
  }
  switch (kind) {
    case 0:
      obj.sprite = new Sprite();
      obj.sprite.animlist = animlist;
      obj.sprite.animnum = animnum;
      obj.sprite.backgroundColor = "transparent";
      obj.sprite.x = x;
      obj.sprite.y = y;
      obj.sprite.xs = xs;
      obj.sprite.ys = ys;
      obj.sprite.gravity = g;
      obj.sprite.width = cellx;
      obj.sprite.height = celly;
      obj.sprite.originX = cellx / 2;
      obj.sprite.originY = celly / 2;
      obj.sprite.opacity = opacity;
      obj.sprite.rotation = 0.0;
      obj.sprite.scaleX = 1.0;
      obj.sprite.scaleY = 1.0;
      obj.sprite.visible = visible;
      break;
    case 1:
      obj.sprite = new Label();
      obj.sprite.x = x;
      obj.sprite.y = y;
      obj.sprite.xs = xs;
      obj.sprite.ys = ys;
      obj.sprite.gravity = g;
      obj.sprite.opacity = opacity;
      obj.sprite.text = "";
      obj.sprite.font = "12pt 'Arial'";
      obj.sprite.color = "black";
      obj.sprite.rotation = 0.0;
      obj.sprite.scaleX = 1.0;
      obj.sprite.scaleY = 1.0;
      obj.sprite.visible = visible;
      break;
    default:
      obj.sprite = void 0;
  }
  if ((obj.sprite != null)) {
    core.rootScene.addChild(obj.sprite);
  }
  if ((IMAGELIST[image] != null) && (animlist != null)) {
    obj.sprite.image = core.assets[IMAGELIST[image]];
  }
  if ((animlist != null)) {
    animpattern = obj.sprite.animlist[obj.sprite.animnum];
    obj.sprite.frame = animpattern[0];
  }
  obj.sprite.addEventListener('enterframe', function() {
    obj.sprite.ys += obj.sprite.gravity;
    obj.sprite.x += obj.sprite.xs;
    obj.sprite.y += obj.sprite.ys;
    if ((animlist != null) && obj.motionObj !== void 0) {
      animpattern = obj.sprite.animlist[obj.sprite.animnum];
      obj.sprite.frame = animpattern[obj.sprite.age % animpattern.length];
    }
    if (obj.motionObj !== void 0 && typeof obj.motionObj.behavior === 'function') {
      return obj.motionObj.behavior();
    }
  });
  if (motionObj !== void 0) {
    obj.motionObj = new motionObj(obj.sprite);
  } else {
    obj.motionObj = void 0;
  }
  return obj;
};

removeObject = function(obj) {
  if ((obj.motionObj != null) && typeof obj.motionObj.destructor === 'function') {
    obj.motionObj.destructor();
  }
  obj.motionObj = 0;
  obj.sprite.removeEventListener('enterframe');
  core.rootScene.removeChild(obj.sprite);
  return obj.active = false;
};

_getNullObject = function() {
  var i, obj, _i, _ref;
  obj = void 0;
  for (i = _i = 0, _ref = _objects.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
    if (_objects[i].active === false) {
      obj = _objects[i];
      obj.active = true;
      break;
    }
  }
  return obj;
};
