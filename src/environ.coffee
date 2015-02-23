#**********************************************************************************************************
# enforce game engine
#
# 2014.04.04 ver2.0
#
# Coded by Kow Sakazaki
#**********************************************************************************************************

# static values setting ***********************************************************************************
DEBUG           = true                      # デバッグモード
SCREEN_WIDTH    = 480                       # 画面の幅
SCREEN_HEIGHT   = 640                       # 画面の高さ
BGCOLOR         = "black"                   # 背景色
OBJECTNUM       = 256                       # キャラの最大数
FPS             = 60                        # FPS
GRAVITY_X       = 0.0                       # box2d用水平方向重力
GRAVITY_Y       = 9.8                       # box2d用垂直方向重力

# preloading image list ***********************************************************************************
MEDIALIST =
    controlplane    : 'media/picture/controlplane.png'
    colliderimage   : 'media/picture/colliderimage.png'
    startbutton     : 'media/picture/startbutton.png'
    bear            : 'media/picture/chara1.png'

    gamestart       : 'media/sound/gamestart.mp3'
