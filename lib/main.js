//#########################################################################
// enchant.js game engine
//
// 2013.12.28 ver0.1
//
// Coded by Kow Sakazaki
//#########################################################################
var bears = [];
var core = null;
var main = null;
var rootScene = null;
var lapsedtime = 0;
enchant();
window.onload = function() {
	core = new Core(SCREEN_WIDTH, SCREEN_HEIGHT);
	rootScene = core.rootScene;
	core.rootScene.backgroundColor = BGCOLOR;
	core.fps = FPS;
	core.preload(IMAGELIST);
	core.onload = function() {

		//#########################################################################
		var seedObject = Class.create(Sprite, {
			initialize: function() {
				Sprite.call(this, 0, 0);
				this.active = false;
				core.rootScene.addChild(this);
			}
		});
		//#########################################################################

		for (var i = 0; i < OBJECTNUM; i++) {
			bears[i] = new seedObject();
		}
		main = new enchantMain();

		core.rootScene.addEventListener('touchstart', function(e) {
			if (typeof(main.touchesBegan) == 'function') {
				main.touchesBegan(e);
			}
		});
		core.rootScene.addEventListener('touchmove', function(e) {
			if (typeof(main.touchesMoved) == 'function') {
				main.touchesMoved(e);
			}
		});
		core.rootScene.addEventListener('touchend', function(e) {
			if (typeof(main.touchesEnded) == 'function') {
				main.touchesEnded(e);
			}
		});
		core.rootScene.addEventListener('touchcancel', function(e) {
			if (typeof(main.touchesCanceled) == 'function') {
				main.touchesCanceled(e);
			}
		});

		core.rootScene.addEventListener('enterframe', function(e) {
			lapsedtime = Math.floor(core.frame / FPS);
		});
	};

	core.start();
};

//#########################################################################
//#########################################################################
function addObject(x, y, xs, ys, g, image, cellx, celly, opacity, seedobj, animlist, animnum, visible) {
	var obj = _getNullObject();
	if (obj == null) {
		return;
	}

	Sprite.call(obj, cellx, celly);
	obj.backgroundColor = "transparent";
	obj.width = cellx;
	obj.height = celly;
	obj.opacity = opacity;
	obj.originX = cellx / 2;
	obj.originY = celly / 2;
	obj.rotation = 0.0;
	obj.scaleX = 1.0;
	obj.scaleY = 1.0;

	obj.x = x;
	obj.y = y;
	obj.xs = xs;
	obj.ys = ys;
	obj.gravity = g;
	obj.animlist = animlist;
	obj.animnum = animnum;

	obj.visible = visible;

	if (IMAGELIST[image] != null) {
		obj.image = core.assets[IMAGELIST[image]];
	}

	if (obj.animlist != null) {
		var animpattern = obj.animlist[obj.animnum];
		obj.frame = animpattern[0];
	}

	if (seedobj != null) {
		obj.characterObj = new seedobj(obj);
	}

	obj.addEventListener('enterframe', function() {
		obj.ys += obj.gravity;
		obj.x += obj.xs;
		obj.y += obj.ys;

		if (obj.animlist != null) {
			var animpattern = obj.animlist[obj.animnum];
			obj.frame = animpattern[obj.age % animpattern.length];
		}

		if (obj.characterObj != null && typeof(obj.characterObj.behavior) == 'function') {
			obj.characterObj.behavior();
		}
	});

	return obj;
}

//#########################################################################
//#########################################################################
function _getNullObject() {
	var obj = null;
	for (var i = 0; i < bears.length; i++) {
		if (bears[i].active == false) {
			obj = bears[i];
			obj.active = true;
			obj.visible = false;
			break;
		}
	}
	return obj;
}

