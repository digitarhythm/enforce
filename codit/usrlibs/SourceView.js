var SourceView,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

SourceView = (function(_super) {

  __extends(SourceView, _super);

  function SourceView(frame) {
    SourceView.__super__.constructor.call(this, frame);
    /*
    		Please describe initialization processing of a class below from here.
    */
    this.source_path = JSSearchPathForDirectoriesInDomains("JSDocumentDirectory") + "/src";
  }

  SourceView.prototype.viewDidAppear = function() {
    var ext, filemanager,
      _this = this;
    SourceView.__super__.viewDidAppear.call(this);
    /*
    		Please describe the processing about a view below from here.
    */
    this.sourceview = new JSListView(JSRectMake(0, 0, this._frame.size.width, this._frame.size.height));
    this.sourceview.setBackgroundColor(JSColor("clearColor"));
    this.addSubview(this.sourceview);
    ext = ["coffee"];
    filemanager = new JSFileManager();
    return filemanager.fileList(this.source_path, ext, function(data) {
      var jdata;
      jdata = JSON.parse(data);
      _this.sourceview.setListData(jdata['file']);
      return _this.sourceview.reload();
    });
  };

  return SourceView;

})(JSView);
