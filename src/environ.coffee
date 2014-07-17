#**********************************************************************************************************
# enforce game engine
#
# 2014.04.04 ver2.0
#
# Coded by Kow Sakazaki
#**********************************************************************************************************

# static values setting ***********************************************************************************
DEBUG           = true                      # デバッグモード
SCREEN_WIDTH    = 600                       # 画面の幅
SCREEN_HEIGHT   = 864                       # 画面の高さ
BGCOLOR         = "black"                   # 背景色
OBJECTNUM       = 256                       # キャラの最大数
GRAVITY         = 9.8                       # 重力（box2dで使用）

# preloading image list ***********************************************************************************
MEDIALIST       = {
    bear    : 'media/picture/chara1.png'
    droid   : 'media/collada/droid.dae'
}
