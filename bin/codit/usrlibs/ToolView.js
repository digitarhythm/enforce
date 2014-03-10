var ToolView,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

ToolView = (function(_super) {

  __extends(ToolView, _super);

  function ToolView(frame) {
    ToolView.__super__.constructor.call(this, frame);
    /*
    		Please describe initialization processing of a class below from here.
    */
  }

  ToolView.prototype.viewDidAppear = function() {
    return ToolView.__super__.viewDidAppear.call(this);
    /*
    		Please describe the processing about a view below from here.
    */
  };

  return ToolView;

})(JSView);
