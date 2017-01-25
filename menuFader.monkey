Strict

Import mojo

Import constants
Import globals
Import language
Import game
Import menuCredits
Import menuMain
Import menuStatistics
Import utils

Function FadeMenu:Bool()
  If( gRequestedState = gGameState ) Then Return True

  If( gStateChangeTime = 0 ) Then gStateChangeTime = Millisecs()
  Local diffTime:Int = Millisecs() - gStateChangeTime

  If( gRequestedState = GAME_STATE_MENU_CREDITS Or gRequestedState = GAME_STATE_MENU_STATISTICS )
    If( gParentState = GAME_STATE_GAME )
      If( ( diffTime ) < FADE_TIME )
        gAlpha = 1.0 - Float( diffTime ) / Float( FADE_TIME )
        SetAlpha( gAlpha )
        'gGameGUI.alpha = gAlpha
        gGame.draw()
        Return False  'Noch nicht fertig!
      Else If( ( diffTime ) < 2 * FADE_TIME )
        gAlpha = Float( diffTime - FADE_TIME ) / Float( FADE_TIME )
        SetAlpha( gAlpha )
        'gActiveGUI.alpha = gAlpha
        gMenuStatistics.draw( False )
        Return False  'Noch nicht fertig!
      Else
        gGameState = gRequestedState
        gAlpha = 1.0
        'gGame = Null
        SetAlpha( gAlpha )
        'gActiveGUI.alpha = gAlpha
        gMenuStatistics.draw( True )
        Return False  'Fertig!
      End If
    Else
      If( ( diffTime ) < FADE_TIME )
        gAlpha = 1.0 - Float( diffTime ) / Float( FADE_TIME )
        SetAlpha( gAlpha )
        'gActiveGUI.alpha = gAlpha
        gMenuMain.draw( True )
        Return False  'Noch nicht fertig!
      Else If( ( diffTime ) < 2 * FADE_TIME )
        gAlpha = Float( diffTime - FADE_TIME ) / Float( FADE_TIME )
        SetAlpha( gAlpha )
        'gActiveGUI.alpha = gAlpha
        Select gRequestedState
          Case GAME_STATE_MENU_CREDITS
            gMenuCredits.draw( True )
          Case GAME_STATE_MENU_STATISTICS
            gMenuStatistics.draw( True )
        End Select
        Return False  'Noch nicht fertig!
      Else
        gGameState = gRequestedState
        gAlpha = 1.0
        SetAlpha( gAlpha )
        'gActiveGUI.alpha = gAlpha
        Select gRequestedState
          Case GAME_STATE_MENU_CREDITS
            gMenuCredits.draw( True )
          Case GAME_STATE_MENU_STATISTICS
            gMenuStatistics.draw( True )
        End Select
        Return False  'Fertig!
      End If
    End If
  Else If( gRequestedState = GAME_STATE_MENU_MAIN )
    If( gParentState = GAME_STATE_GAME )
      If( ( diffTime ) < FADE_TIME )
        gAlpha = 1.0 - Float( diffTime ) / Float( FADE_TIME )
        SetAlpha( gAlpha )
        'gGameGUI.alpha = gAlpha
        gGame.draw()
        Return False  'Noch nicht fertig!
      Else If( ( diffTime ) < 2 * FADE_TIME )
        gAlpha = Float( diffTime - FADE_TIME ) / Float( FADE_TIME )
        SetAlpha( gAlpha )
        'gActiveGUI.alpha = gAlpha
        gMenuMain.draw( False )
        Return False  'Noch nicht fertig!
      Else
        gGameState = gRequestedState
        gAlpha = 1.0
        'gGame = Null
        SetAlpha( gAlpha )
        'gActiveGUI.alpha = gAlpha
        gMenuMain.draw( True )
        Return False  'Fertig!
      End If
    Else
      If( ( diffTime ) < FADE_TIME )
        gAlpha = 1.0 - Float( diffTime ) / Float( FADE_TIME )
        SetAlpha( gAlpha )
        'gActiveGUI.alpha = gAlpha
        Select gParentState
          Case GAME_STATE_MENU_CREDITS
            gMenuCredits.draw( True )
          Case GAME_STATE_MENU_STATISTICS
            gMenuStatistics.draw( True )
        End Select
        Return False  'Noch nicht fertig!
      Else If( ( diffTime ) < 2 * FADE_TIME )
        gAlpha = Float( diffTime - FADE_TIME ) / Float( FADE_TIME )
        SetAlpha( gAlpha )
        'gActiveGUI.alpha = gAlpha
        gMenuMain.draw( True )
        Return False  'Noch nicht fertig!
      Else
        gGameState = gRequestedState
        gAlpha = 1.0
        SetAlpha( gAlpha )
        'gActiveGUI.alpha = gAlpha
        gMenuMain.draw( True )
        Return False  'Fertig!
      End If
    End If
  Else If( gRequestedState = GAME_STATE_GAME )
    If( ( diffTime ) < FADE_TIME )
      gAlpha = 1.0 - Float( diffTime ) / Float( FADE_TIME )
      SetAlpha( gAlpha )
      'gActiveGUI.alpha = gAlpha
      gMenuMain.draw( False )
      Return False  'Noch nicht fertig!
    Else If( ( diffTime ) < 2 * FADE_TIME )
      gAlpha = Float( diffTime - FADE_TIME ) / Float( FADE_TIME )
      SetAlpha( gAlpha )
      'gGameGUI.alpha = gAlpha
      If( Not gGame ) Then gGame = New Game()
      gGame.draw()
      Return False  'Noch nicht fertig!
    Else
      gGameState = gRequestedState
      gAlpha = 1.0
      SetAlpha( gAlpha )
      'gGameGUI.alpha = gAlpha
      gGame.draw()
      Return False  'Fertig!
    End If
  End If
  Return True
End Function
