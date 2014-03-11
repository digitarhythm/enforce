var MediaView,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

MediaView = (function(_super) {

  __extends(MediaView, _super);

  function MediaView(frame) {
    MediaView.__super__.constructor.call(this, frame);
    /*
            Please describe user processing below from here.
    */
    this.CELLHEIGHT = 20;
    this.lastedittab = void 0;
    this.dispdata = [];
    this.delegate = this.dataSource = this._self;
    this.documentpath = JSSearchPathForDirectoriesInDomains("JSDocumentDirectory");
    this.enforcepath = this.documentpath + "/../..";
    this.picturepath = JSSearchPathForDirectoriesInDomains("JSPictureDirectory");
  }

  MediaView.prototype.numberOfRowsInSection = function() {
    return this.dispdata.length;
  };

  MediaView.prototype.cellForRowAtIndexPath = function(i) {
    var cell, fname;
    if (!(this.childlist[i] != null)) {
      cell = new JSTableViewCell();
    } else {
      cell = this.childlist[i];
      cell.setBackgroundColor(JSColor("clearColor"));
    }
    cell.setBorderColor(JSColor("clearColor"));
    cell.setBorderWidth(0);
    cell.delegate = this._self;
    fname = this.dispdata[i];
    cell.setText(fname);
    cell.setTextSize(14);
    return cell;
  };

  MediaView.prototype.heightForRowAtIndexPath = function(num) {
    return this.CELLHEIGHT;
  };

  MediaView.prototype.didSelectRowAtIndexPath = function(num, e) {
    var cell, fname;
    if (this.lastedittab === num) return;
    fname = this.dispdata[num];
    this._parent.mainview.loadMediaFile(fname);
    if ((this.lastedittab != null)) {
      this.childlist[this.lastedittab].setBackgroundColor(JSColor("clearColor"));
    }
    cell = this.cellForRowAtIndexPath(num);
    cell.setBackgroundColor(JSColor("#abcdef"));
    return this.lastedittab = num;
  };

  return MediaView;

})(JSTableView);
