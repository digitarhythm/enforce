var JSMapView,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

JSMapView = (function(_super) {

  __extends(JSMapView, _super);

  function JSMapView(frame) {
    JSMapView.__super__.constructor.call(this, frame);
    this.delegate = this._self;
    this._map = void 0;
    this.mapOptions = {
      center: new google.maps.LatLng(0.0, 0.0),
      zoom: 8,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      panControl: false,
      zoomControl: false,
      mapTypeControl: false,
      scaleControl: false,
      streetViewControl: false
    };
  }

  JSMapView.prototype.createMap = function() {
    var tag;
    tag = "<div id='" + this._objectID + "_mapcanvas' style='width:" + this._frame.size.width + "px;height:" + this._frame.size.height + "px;'></div>";
    if (($(this._viewSelector + "_mapcanvas").length)) {
      $(this._viewSelector + "_mapcanvas").remove();
    }
    $(this._viewSelector).append(tag);
    return this._map = new google.maps.Map(document.getElementById(this._objectID + "_mapcanvas"), this.mapOptions);
  };

  JSMapView.prototype.setRegion = function(zoom) {
    if (($(this._viewSelector + "_mapcanvas").length)) {
      return this._map.setZoom(zoom);
    }
  };

  JSMapView.prototype.getRegion = function() {
    if (($(this._viewSelector + "_mapcanvas").length)) {
      return this._map.getZoom();
    } else {
      return 0;
    }
  };

  JSMapView.prototype.setCenterCoordinate = function(coord) {
    var latitude, longitude;
    if (($(this._viewSelector + "_mapcanvas").length)) {
      latitude = coord._latitude;
      longitude = coord._longitude;
      this._center = new google.maps.LatLng(latitude, longitude);
      return this._map.setCenter(this._center);
    }
  };

  JSMapView.prototype.setMapType = function(maptype) {
    var maptypeid;
    if (($(this._viewSelector + "_mapcanvas").length)) {
      switch (maptype) {
        case "MKMapTypeHybrid":
          maptypeid = google.maps.MapTypeId.HYBRID;
          break;
        case "MKMapTypeStandard":
          maptypeid = google.maps.MapTypeId.ROADMAP;
          break;
        case "MKMapTypeSatellite":
          maptypeid = google.maps.MapTypeId.SATELLITE;
          break;
        case "MKMapTypeTerrain":
          maptypeid = google.maps.MapTypeId.TERRAIN;
      }
      return this._map.setMapTypeId(maptypeid);
    }
  };

  JSMapView.prototype.mapOptionReflection = function() {
    var center, maptypeid, zoom;
    center = this._map.getCenter();
    zoom = this._map.getZoom();
    maptypeid = this._map.getMapTypeId();
    this.mapOptions.center = center;
    this.mapOptions.zoom = zoom;
    this.mapOptions.mapTypeId = maptypeid;
    return this._map.setOptions(this.mapOptions);
  };

  JSMapView.prototype.viewDidAppear = function() {
    JSMapView.__super__.viewDidAppear.call(this);
    if (!$(this._viewSelector + "_mapcanvas").length) return this.createMap();
  };

  return JSMapView;

})(JSView);
