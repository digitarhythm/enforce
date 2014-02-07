var JSLocation, JSLocationManager,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

JSLocationManager = (function(_super) {

  __extends(JSLocationManager, _super);

  function JSLocationManager() {
    this.errorCallback = __bind(this.errorCallback, this);
    this.successCallback = __bind(this.successCallback, this);    JSLocationManager.__super__.constructor.call(this);
    this._location = new JSLocation();
    this._oldcoord = new JSLocation();
    this._calcelID = null;
    this.delegate = this._self;
  }

  JSLocationManager.prototype.locationServicesEnabled = function() {
    var ret;
    ret = navigator.geolocation;
    if (ret) {
      return true;
    } else {
      return false;
    }
  };

  JSLocationManager.prototype.startUpdatingLocation = function() {
    var position_options;
    position_options = {
      enableHighAccuracy: true,
      timeout: 60000,
      maximumAge: 0
    };
    return this._cancelID = navigator.geolocation.watchPosition(this.successCallback, this.errorCallback, position_options);
  };

  JSLocationManager.prototype.stopUpdatingLocation = function() {
    if (this._cancelID !== null) {
      navigator.geolocation.clearWatch(this._cancelID);
      return this._cancelID = null;
    }
  };

  JSLocationManager.prototype.successCallback = function(event) {
    var lat, lng;
    if (this._cancelID === null) return;
    if (typeof this.delegate.didUpdateToLocation === 'function') {
      lat = event.coords.latitude;
      lng = event.coords.longitude;
      this._oldcoord._latitude = this._location._latitude;
      this._oldcoord._longitude = this._location._longitude;
      this._location._latitude = lat;
      this._location._longitude = lng;
      return this.delegate.didUpdateToLocation(this._oldcoord, this._location);
    }
  };

  JSLocationManager.prototype.errorCallback = function(err) {
    if (typeof this.delegate.didFailWithError === 'function') {
      return this.delegate.didFailWithError(err);
    }
  };

  return JSLocationManager;

})(JSObject);

JSLocation = (function(_super) {

  __extends(JSLocation, _super);

  function JSLocation(_latitude, _longitude) {
    this._latitude = _latitude != null ? _latitude : 0.0;
    this._longitude = _longitude != null ? _longitude : 0.0;
    JSLocation.__super__.constructor.call(this);
  }

  return JSLocation;

})(JSObject);
