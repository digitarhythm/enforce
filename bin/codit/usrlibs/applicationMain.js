var applicationMain,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

applicationMain = (function(_super) {

  __extends(applicationMain, _super);

  function applicationMain(rootView) {
    this.rootView = rootView;
    applicationMain.__super__.constructor.call(this);
  }

  applicationMain.prototype.didFinishLaunching = function() {
    /*
    		Please describe the user code below from here.
    		Please arrange an indent with the head of this comment.
    */
    var browserframe, img, logo, picturepath, sideview_width, toolview_height;
    browserframe = getBounds();
    toolview_height = 48;
    sideview_width = 240;
    this.mainview = new MainView(JSRectMake(sideview_width, toolview_height, browserframe.size.width - sideview_width, browserframe.size.height - toolview_height));
    this.mainview.setBackgroundColor(JSColor("#ffffff"));
    this.rootView.addSubview(this.mainview);
    this.sideview = new SideView(JSRectMake(0, toolview_height, sideview_width, browserframe.size.height - toolview_height));
    this.sideview.setShadow(true);
    this.sideview.mainview = this.mainview;
    this.rootView.addSubview(this.sideview);
    this.toolview = new ToolView(JSRectMake(0, 0, browserframe.size.width, toolview_height));
    this.toolview.setShadow(true);
    this.rootView.addSubview(this.toolview);
    picturepath = JSSearchPathForDirectoriesInDomains("JSPictureDirectory");
    img = new JSImage(picturepath + "/enforce_logo.png");
    logo = new JSImageView(JSRectMake(2, 2, 120, 44));
    logo.setImage(img);
    return this.toolview.addSubview(logo);
  };

  return applicationMain;

})(JSObject);
