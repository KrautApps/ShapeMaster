Strict

Import mojo

Import constants
Import eyeballing
Import globals
Import game
Import init

Const LOADTIME:Int = 3000

Function LoadScreen:Void()
  Cls()
  If( gFirstCall )
    gFirstCall = False
    gGameStartTime = Millisecs()
  End If
  'Zunaechst blenden wir den Ladebildschirm ein
  'Der initiale Ladescreen wird mindestens 3 Sekunden dargestellt
  If( ( Millisecs() - gGameStartTime ) < 1000 )
    'gAlpha = Float( Millisecs() - gGameStartTime ) / 1000.0
    'SetAlpha( gAlpha )
    DrawImage(gSplashScreen, IMGX / 2.0, gMaxY / 2.0)
    gFontMain.DrawText(VERSION, IMGX - 20, gMaxY - 40 - BOTTOM_SPACE_FOR_BANNER, eDrawAlign.RIGHT)
    Return
  Else If( ( Millisecs() - gGameStartTime ) < LOADTIME )
    gAlpha = 1.0
    SetAlpha( gAlpha )
    DrawImage(gSplashScreen, IMGX / 2.0, gMaxY / 2.0)
    gFontMain.DrawText(VERSION, IMGX - 20, gMaxY - 40 - BOTTOM_SPACE_FOR_BANNER, eDrawAlign.RIGHT)
    If( Not gIsLoadingInitialized )
      gIsLoadingInitialized = True
      Initialize()
    End If

  'Blenden wir den Ladebildschirm aus
  'Der initiale Ladescreen wird mindestens 3 Sekunden dargestellt
  Else If( ( Millisecs() - gGameStartTime ) < (LOADTIME+250) )
    gAlpha = 1.0 - Float( Millisecs() - gGameStartTime - (LOADTIME+0) ) / 250.0
    SetAlpha( gAlpha )
    DrawImage(gSplashScreen, IMGX / 2.0, gMaxY / 2.0)
    gFontMain.DrawText(VERSION, IMGX - 20, gMaxY - 40 - BOTTOM_SPACE_FOR_BANNER, eDrawAlign.RIGHT)
  Else If( ( Millisecs() - gGameStartTime ) < (LOADTIME+500) )
    gRequestedState = GAME_STATE_MENU_MAIN
    gAlpha = Float( Millisecs() - gGameStartTime - (LOADTIME+250) ) / 250.0
    SetAlpha( gAlpha )
    'gActiveGUI = gGameGUI
    'gGameGUI.alpha = gAlpha
    gMenuMain.draw()
  Else If( ( Millisecs() - gGameStartTime ) < (LOADTIME+750) )
    gAlpha = 1.0
    SetAlpha( gAlpha )
    'gGameGUI.alpha = gAlpha
    gMenuMain.draw()
  Else
    gGameState = GAME_STATE_MENU_MAIN
    gRequestedState = gGameState
    'Wir entfernen den Splash Screen aus dem Speicher
    gSplashScreen.Discard()
    gAlpha = 1.0
    SetAlpha( gAlpha )
    'gGameGUI.alpha = gAlpha
    gMenuMain.draw()
  End If
End Function
