var JSGLView,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

JSGLView = (function(_super) {

  __extends(JSGLView, _super);

  function JSGLView(frame, _bgColor, _alpha, _antialias) {
    if (frame == null) frame = JSRectMake(0, 0, 320, 240);
    this._bgColor = _bgColor != null ? _bgColor : "#f0f0f0";
    this._alpha = _alpha != null ? _alpha : 1.0;
    this._antialias = _antialias != null ? _antialias : true;
    this.render_sub = __bind(this.render_sub, this);
    this.render = __bind(this.render, this);
    JSGLView.__super__.constructor.call(this, frame);
    this._perspective = 15;
    this._camera_x = 0;
    this._camera_y = 0;
    this._camera_z = 10;
    this._lookat_x = 0;
    this._lookat_y = 0;
    this._lookat_z = 0;
    this._lightcolor = 0xffffff;
    this._lightdir_x = 0.577;
    this._lightdir_y = 0.577;
    this._lightdir_z = 0.577;
    this._ambientLightColor = 0x404040;
    this.delegate = this._self;
    if (window.WebGLRenderingContext) {
      this._renderer = new THREE.WebGLRenderer({
        antialias: this._antialias
      });
    } else {
      this._renderer = new THREE.CanvasRenderer({
        antialias: this._antialias
      });
    }
    this._renderer.setSize(frame.size.width, frame.size.height);
    this._renderer.setClearColorHex(this._bgcolor, this._alpha);
  }

  JSGLView.prototype.setCamera = function(_perspective, _camera_x, _camera_y, _camera_z, _lookat_x, _lookat_y, _lookat_z) {
    this._perspective = _perspective;
    this._camera_x = _camera_x;
    this._camera_y = _camera_y;
    this._camera_z = _camera_z;
    this._lookat_x = _lookat_x;
    this._lookat_y = _lookat_y;
    this._lookat_z = _lookat_z;
    this._camera = new THREE.PerspectiveCamera(this._perspective, this._frame.size.width / this._frame.size.height);
    this._camera.position = new THREE.Vector3(this._camera_x, this._camera_y, this._camera_z);
    this._camera.lookAt(new THREE.Vector3(this._lootat_x, this._lootat_y, this._lootat_z));
    return this._scene.add(this._camera);
  };

  JSGLView.prototype.setLight = function(_lightcolor, _lightdir_x, _lightdir_y, _lightdir_z) {
    this._lightcolor = _lightcolor;
    this._lightdir_x = _lightdir_x;
    this._lightdir_y = _lightdir_y;
    this._lightdir_z = _lightdir_z;
    this._light = new THREE.DirectionalLight(this._lightcolor);
    this._light.position = new THREE.Vector3(this._lightdir_x, this._lightdir_y, this._lightdir_z);
    return this._scene.add(this._light);
  };

  JSGLView.prototype.setAmbient = function(_ambientLightColor) {
    this._ambientLightColor = _ambientLightColor;
    this._ambient = new THREE.AmbientLight(this._ambientLightColor);
    return this._scene.add(this._ambient);
  };

  JSGLView.prototype.render = function() {
    this._baseTime = +(new Date);
    return this.render_sub();
  };

  JSGLView.prototype.render_sub = function() {
    requestAnimationFrame(this.render_sub);
    this.delegate.enterFrame();
    return this._renderer.render(this._scene, this._camera);
  };

  JSGLView.prototype.viewDidAppear = function() {
    JSGLView.__super__.viewDidAppear.call(this);
    $(this._viewSelector).append(this._renderer.domElement);
    this._scene = new THREE.Scene();
    this.setCamera(this._perspective, this._camera_x, this._camera_y, this._camera_z, this._lookat_x, this._lootat_y, this._lookat_z);
    this.setLight(this._lightcolor, this._lightdir_x, this._lightdir_y, this._lightdir_z);
    return this.setAmbient(this._ambientLightColor);
  };

  return JSGLView;

})(JSView);
