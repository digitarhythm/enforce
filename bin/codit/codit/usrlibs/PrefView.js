var PrefView,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

PrefView = (function(_super) {

  __extends(PrefView, _super);

  function PrefView(frame) {
    var dialogtitle,
      _this = this;
    PrefView.__super__.constructor.call(this, frame);
    /*
            Please describe initialization processing of a class below from here.
    */
    this.setCornerRadius(6.0);
    this.setShadow(true);
    this.userdefaults = new JSUserDefaults();
    this.preference = [];
    dialogtitle = new JSLabel(JSRectMake(8, 4, 120, 48));
    dialogtitle.setText("環境設定");
    dialogtitle.setTextSize(12);
    dialogtitle.setTextAlignment("JSTextAlignmentLeft");
    dialogtitle.setTextColor(JSColor("black"));
    this.addSubview(dialogtitle);
    this.applybutton = new JSButton(JSRectMake(this._frame.size.width - 84 * 1, this._frame.size.height - 28, 80, 24));
    this.applybutton.setButtonTitle("OK");
    this.addSubview(this.applybutton);
    this.applybutton.addTarget(function() {
      return _this.animateWithDuration(0.2, {
        alpha: 0.0
      }, function() {
        _this.preference[0] = _this.vimode.getValue();
        _this.userdefaults.setObject(_this.preference, "preference");
        return _this.delegate.closePrefview();
      });
    });
    this.cancelbutton = new JSButton(JSRectMake(this._frame.size.width - 84 * 2, this._frame.size.height - 28, 80, 24));
    this.cancelbutton.setButtonTitle("Cancel");
    this.addSubview(this.cancelbutton);
    this.cancelbutton.addTarget(function() {
      return _this.animateWithDuration(0.2, {
        alpha: 0.0
      }, function() {
        return _this.delegate.closePrefview();
      });
    });
    this.userdefaults.stringForKey("preference", function(data) {
      if (data !== "") {
        _this.preference = data;
      } else {
        _this.preference[0] = false;
        _this.preference[1] = false;
        _this.preference[2] = false;
      }
      _this.vimodetext = new JSLabel(JSRectMake(8, 64, 64, 24));
      _this.vimodetext.setText("vi mode");
      _this.addSubview(_this.vimodetext);
      _this.vimode = new JSSwitch(JSRectMake(_this._frame.size.width - 120, 64, 80, 24));
      _this.vimode.setValue(_this.preference[0]);
      return _this.addSubview(_this.vimode);
    });
  }

  PrefView.prototype.viewDidAppear = function() {
    return PrefView.__super__.viewDidAppear.call(this);
    /*
            Please describe the processing about a view below from here.
    */
  };

  return PrefView;

})(JSView);
