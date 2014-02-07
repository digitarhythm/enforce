var getRootView,
  _this = this;

this.rootView = void 0;

$(function() {
  var bounds, frame, height, rootID, width;
  bounds = getBounds();
  width = bounds.size.width;
  height = bounds.size.height;
  frame = JSRectMake(0, 0, width, height);
  _this.rootView = new JSWindow(frame);
  _this.rootView.setBackgroundColor(JSColor("white"));
  _this.rootView.setClipToBounds(true);
  _this.rootView.setBackgroundColor(JSColor("clearColor"));
  $("body").append(_this.rootView._div);
  _this.rootView.viewDidAppear();
  rootID = _this.rootView._objectID;
  _this.applicationMain = new applicationMain(_this.rootView);
  _this.applicationMain.didFinishLaunching();
  $(window).resize(function() {
    var angle, o, _i, _len, _ref, _results;
    frame = getBounds();
    width = frame.size.width;
    height = frame.size.height;
    $("#" + rootID).width(width);
    $("#" + rootID).height(height);
    angle = Math.abs(window.orientation);
    if (typeof _this.applicationMain.didBrowserResize === "function") {
      _this.applicationMain.didBrowserResize();
    }
    if (isAndroid() === true) {
      if (typeof _this.applicationMain.didBrowserRotate === "function") {
        _this.applicationMain.didBrowserRotate(angle);
      }
    }
    _ref = _this.rootView._objlist;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      o = _ref[_i];
      if (typeof o.didBrowserResize === "function") o.didBrowserResize();
      if (isAndroid() === true) {
        if (typeof o.didBrowserRotate === "function") {
          _results.push(o.didBrowserRotate(angle));
        } else {
          _results.push(void 0);
        }
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  });
  if (isAndroid() === false) {
    $(window).bind('orientationchange', function() {
      var angle, o, _i, _len, _ref, _results;
      angle = Math.abs(window.orientation);
      if (typeof _this.applicationMain.didBrowserRotate === "function") {
        _this.applicationMain.didBrowserRotate(angle);
      }
      _ref = _this.rootView._objlist;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        o = _ref[_i];
        if (typeof o.didBrowserRotate === "function") {
          _results.push(o.didBrowserRotate(angle));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    });
  }
  return window.cancelAnimationFrame = window.cancelAnimationFrame || window.mozCancelAnimationFrame || window.webkitCancelAnimationFrame || window.msCancelAnimationFrame;
});

getRootView = function() {
  return _this.rootView;
};
