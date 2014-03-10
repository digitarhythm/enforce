var MediaView,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

MediaView = (function(_super) {

  __extends(MediaView, _super);

  function MediaView(frame) {
    MediaView.__super__.constructor.call(this, frame);
    /*
    		Please describe initialization processing of a class below from here.
    */
    this.media_path = JSSearchPathForDirectoriesInDomains("JSDocumentDirectory") + "/media";
  }

  MediaView.prototype.viewDidAppear = function() {
    var ext, filemanager,
      _this = this;
    MediaView.__super__.viewDidAppear.call(this);
    /*
    		Please describe the processing about a view below from here.
    */
    this.mediaview = new JSListView(JSRectMake(0, 0, this._frame.size.width, this._frame.size.height));
    this.mediaview.setBackgroundColor(JSColor("clearColor"));
    this.addSubview(this.mediaview);
    ext = ["png", "jpg", "gif", "mp3", "ogg"];
    filemanager = new JSFileManager();
    return filemanager.fileList(this.media_path, ext, function(data) {
      var jdata;
      jdata = JSON.parse(data);
      _this.mediaview.setListData(jdata['file']);
      return _this.mediaview.reload();
    });
  };

  return MediaView;

})(JSView);
