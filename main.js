//###########################################################################################################
// enchant.js game engine
//
// 2013.12.28 ver0.1
//
// Coded by Kow Sakazaki
//###########################################################################################################

// environ values setting ###################################################################################
var SCREEN_WIDTH = 240;
var SCREEN_HEIGHT = 320;
var FPS = 30;
var BGCOLOR = "black";
var OBJECTNUM = 100;
var IMAGELIST = ['media/chara1.png'];

//###########################################################################################################
var bears = [];
var core = null;
var main = null;
enchant();
window.onload = function() {
	core = new Core(SCREEN_WIDTH, SCREEN_HEIGHT);
	core.rootScene.backgroundColor = BGCOLOR;
	core.fps = FPS;
	core.preload(IMAGELIST);
	core.onload = function() {

		var seedObject = Class.create(Sprite, {
			initialize: function() {
				Sprite.call(this, 0, 0);
				this.active = false;
				this.characterObj = null;
				this.xs = 0;
				this.ys = 0;
				this.gravity = 0;

				core.rootScene.addChild(this);
			}
		});

		for (var i = 0; i < OBJECTNUM; i++) {
			bears[i] = new seedObject();
		}

		main = new enchantMain();
	};
	core.start();
};

function addObject(x, y, xs, ys, g, image, cellx, celly, frame, opacity, seedobj, animpattern, visible) {
	var obj = _getNullObject();
	if (obj == null) {
		return;
	}

	Sprite.call(obj, cellx, celly);
	obj.x = x;
	obj.y = y;
	obj.xs = xs;
	obj.ys = ys;
	obj.gravity = g;
	obj.frame = frame;
	obj.opacity = opacity
	obj.animpattern = animpattern;
	obj.visible = visible;
	if (IMAGELIST[image] != null) {
		obj.image = core.assets[IMAGELIST[image]];
	}

	if (seedobj != null) {
		obj.characterObj = new seedobj(obj)
	}

	obj.addEventListener('enterframe', function() {
		obj.ys += obj.gravity;
		obj.x += obj.xs;
		obj.y += obj.ys;

		obj.frame = obj.animpattern[obj.age % obj.animpattern.length];

		if (obj.characterObj != null) {
			obj.characterObj.behavior();
		}
	});

	return obj;
}

function removeObject(obj) {
	obj.active = false;
	obj.visible = false;
	obj.addEventListner('enterframe', function() {});
}

function _getNullObject() {
	var obj = null;
	for (var i = 0; i < bears.length; i++) {
		if (bears[i].active == false) {
			obj = bears[i];
			obj.active = true;
			break;
		}
	}
	return obj;
}
