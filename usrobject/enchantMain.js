var enchantMain;

enchantMain = (function() {

  function enchantMain() {
    var animlist, bearObj;
    animlist = [[0, 0, 0, 1, 1, 1, 0, 0, 0, 2, 2, 2]];
    bearObj = createObject(bear, SPRITE, rand(320 - 32), rand(240 - 32), rand(10) - 5, 0, 1, 0, 32, 32, 1.0, animlist, 0, true);
  }

  return enchantMain;

})();
