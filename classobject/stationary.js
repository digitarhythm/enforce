// Generated by CoffeeScript 1.3.3
var stationary,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

stationary = (function(_super) {

  __extends(stationary, _super);

  function stationary(sprite) {
    this.sprite = sprite;
    stationary.__super__.constructor.call(this, this.sprite);
  }

  return stationary;

})(originSprite);
