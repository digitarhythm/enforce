#**********************************************************************************************************
# enforce game engine
#
# 2014.04.04 ver2.0
#
# Coded by Kow Sakazaki
#**********************************************************************************************************

# static values setting ***********************************************************************************
DEBUG           = true                      # デバッグモード
SCREEN_WIDTH    = 800                       # 画面の幅
SCREEN_HEIGHT   = 960                       # 画面の高さ
BGCOLOR         = "black"                   # 背景色
OBJECTNUM       = 256                       # キャラの最大数
FPS             = 60                        # FPS
GRAVITY_X       = 0.0                       # box2d用水平方向重力
GRAVITY_Y       = 9.8                       # box2d用垂直方向重力
GAMEPADMIX      = false                     # ゲームパッドとアナログコントローラーの値を合算

FOGCOLOR        = 0xffffff                  # 霧の色
FOGLEVEL        = 0                         # 霧の濃さ
VIEWANGLE       = 90                        # 視野角
VIEWNEAR        = 1                         # 最短描画距離
VIEWFAR         = 1000                      # 最長描画距離

# preloading image list ***********************************************************************************
MEDIALIST =
    controlplane    : 'media/picture/controlplane.png'
    colliderimage   : 'media/picture/colliderimage.png'
    startbutton     : 'media/picture/startbutton.png'
    bear            : 'media/picture/chara1.png'

    gamestart       : 'media/sound/gamestart.mp3'
