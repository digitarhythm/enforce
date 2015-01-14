var JSColor, JSEscape, JSLog, JSMakeRange, JSPointMake, JSRectMake, JSSearchPathForDirectoriesInDomains, JSSizeMake, UniqueID, getApplicationFrame, getBounds, getCookieValue, isAndroid, isConfirm, isTouch, objectNum,
  __slice = Array.prototype.slice;

JSLog = function() {
  var a, b, data, _i, _len;
  a = arguments[0], b = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
  for (_i = 0, _len = b.length; _i < _len; _i++) {
    data = b[_i];
    a = a.replace('%@', data);
  }
  console.log(a);
  return a;
};

isConfirm = function(str) {
  if (window.confirm(str)) return 1;
};

getCookieValue = function(arg) {
  var cookieData, endPoint, startPoint1, startPoint2;
  if (arg) {
    cookieData = document.cookie + ";";
    startPoint1 = cookieData.indexOf(arg);
    startPoint2 = cookieData.indexOf("=", startPoint1) + 1;
    endPoint = cookieData.indexOf(";", startPoint1);
    if (startPoint2 < endPoint && startPoint1 > -1) {
      cookieData = cookieData.substring(startPoint2, endPoint);
      cookieData = cookieData;
      return cookieData;
    }
  }
  return false;
};

UniqueID = function() {
  var S4;
  S4 = function() {
    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
  };
  return S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4();
};

JSRectMake = function(x, y, w, h) {
  var frame;
  frame = new JSRect();
  frame.origin.x = x;
  frame.origin.y = y;
  frame.size.width = w;
  frame.size.height = h;
  return frame;
};

JSPointMake = function(x, y) {
  var point;
  point = new JSPoint();
  point.x = x;
  point.y = y;
  return point;
};

JSSizeMake = function(w, h) {
  var size;
  size = new JSSize();
  size.width = w;
  size.height = h;
  return size;
};

JSMakeRange = function(loc, len) {
  var range;
  range = new JSRange();
  range.location = loc;
  range.length = len;
  return range;
};

getApplicationFrame = function() {
  var frame;
  frame = new JSRect(0, 0, $("html").innerWidth() - 1, $("html").innerHeight() - 1);
  return frame;
};

getBounds = function() {
  var frame;
  frame = JSRectMake(0, 0, document.documentElement.clientWidth - 1, document.documentElement.clientHeight - 1);
  return frame;
};

JSColor = function(color) {
  var ret;
  ret = color;
  switch (color) {
    case "clearColor":
      ret = "transparent";
  }
  return ret;
};

JSSearchPathForDirectoriesInDomains = function(kind) {
  var ret;
  ret = "";
  switch (kind) {
    case "JSLibraryDirectory":
      ret = "Library";
      break;
    case "JSDocumentDirectory":
      ret = "Documents";
      break;
    case "JSPictureDirectory":
      ret = "Media/Picture";
      break;
    case "JSSystemDirectory":
      ret = "syslibs";
  }
  return ret;
};

JSEscape = function(str) {
  str = str.replace(/&/g, "&amp;");
  str = str.replace(/\'/g, "&quot;");
  str = str.replace(/\"/g, "&quot;");
  str = str.replace(/</g, "&lt;");
  str = str.replace(/>/g, "&gt;");
  return str;
};

objectNum = function(obj) {
  return Object.keys(obj).length;
};

isTouch = function() {
  return 'ontouchstart' in window;
};

isAndroid = function() {
  return navigator.userAgent.indexOf('Android') !== -1;
};
