Strict

Import mojo

Import constants
Import globals
Import language
Import utils

Class MenuMain Implements ButtonCallback
Private

Public
  Method New()
  End Method
  
  Method buttonCallBack:Void( buttonName:String )
    Seed = Millisecs()
    If( buttonName = "Normal" )
      gParentState = gGameState
      gRequestedState = GAME_STATE_GAME
      gStateChangeTime = 0
      gGame.init( 1 )
      gGame.setInsaneMode( False )
    Else If( buttonName = "Insane" )
      gParentState = gGameState
      gRequestedState = GAME_STATE_GAME
      gStateChangeTime = 0
      gGame.init( 2 )
      gGame.setInsaneMode( True )
    Else If( buttonName = "Credits" )
      gParentState = gGameState
      gRequestedState = GAME_STATE_MENU_CREDITS
      gStateChangeTime = 0
    Else If( buttonName = "Statistics" )
      gParentState = gGameState
      gRequestedState = GAME_STATE_MENU_STATISTICS
      gStateChangeTime = 0
      gMenuStatistics.init()
    End If
  End Method

  Method update:Void()
  End Method
  
  Method draw:Void( drawAlwaysBackground:Bool = False )
    If( drawAlwaysBackground ) Then SetAlpha( 1.0 )
    DrawImage( gRM.get( GFX_BACKGROUND ), IMGX / 2.0, gMaxY / 2.0 )
    DrawImage( gRM.get( GFX_TITLE ), 0, 0 )
    SetAlpha( gAlpha )
    gMenuMainGUI.update()
    gMenuMainGUI.paint()
  End Method
End Class