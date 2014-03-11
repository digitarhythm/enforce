var ColladaView,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

ColladaView = (function(_super) {

  __extends(ColladaView, _super);

  function ColladaView(frame, bgColor, alpha, antialias) {
    ColladaView.__super__.constructor.call(this, frame, bgColor, alpha, antialias);
    /*
            Please describe initialization processing of a class below from here.
    */
  }

  ColladaView.prototype.viewDidAppear = function() {
    ColladaView.__super__.viewDidAppear.call(this);
    /*
            Please describe the processing about a view below from here.
    */
    if ((this.fname != null)) return this.dispModel(this.fname);
  };

  ColladaView.prototype.dispModel = function() {
    var documentpath, loader, mediapath,
      _this = this;
    documentpath = JSSearchPathForDirectoriesInDomains("JSDocumentDirectory");
    mediapath = documentpath + "/../../media";
    loader = new THREE.ColladaLoader();
    return loader.load(mediapath + "/" + this.fname, function(collada) {
      _this.model = collada.scene;
      _this.model.scale.set(1.0, 1.0, 1.0);
      _this._scene.add(_this.model);
      return _this.render();
    });
  };

  ColladaView.prototype.enterFrame = function() {
    this.model.rotation.y = 0.2 * (+(new Date) - this._baseTime) / 1000;
    this.model.rotation.x = 0.2 * (+(new Date) - this._baseTime) / 1000;
    return this.model.rotation.z = 0.2 * (+(new Date) - this._baseTime) / 1000;
  };

  return ColladaView;

})(JSGLView);
