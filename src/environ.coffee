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
GAMEPADMIX      = false                     # ゲームパッドとアナログコントローラーの値を合算

# preloading image list ***********************************************************************************
MEDIALIST =
    controlplane    : 'media/picture/controlplane.png'
    colliderimage   : 'media/picture/colliderimage.png'
    startbutton     : 'media/picture/startbutton.png'
    bear0           : 'media/picture/chara0.png'
    bear1           : 'media/picture/chara1.png'
    bear2           : 'media/picture/chara2.png'
    bear3           : 'media/picture/chara3.png'
    bear4           : 'media/picture/chara4.png'
    bear5           : 'media/picture/chara5.png'
    bear6           : 'media/picture/chara6.png'
    bear7           : 'media/picture/chara7.png'

    gamestart       : 'media/sound/gamestart.mp3'
