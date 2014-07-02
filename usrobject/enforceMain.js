var enforceMain;

enforceMain = (function() {

  function enforceMain() {
    var obj;
    obj = addObject({
      motionObj: bear,
      type: SPRITE,
      x: 160,
      y: 200,
      gravity: 3.0,
      xs: rand(16) - 8,
      image: 'dokuro',
      cellx: 175,
      celly: 175,
      opacity: 1.0,
      animlist: [[0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11]]
    });
  }

  return enforceMain;

})();
