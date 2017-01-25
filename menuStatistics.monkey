Strict

Import mojo

Import constants
Import globals
Import language
Import network
Import utils

Class Highscore
Public
  Field _score:String
  Field _time:String
  Field _name:String
  Field _system:String
  
  Method New( score:String, time:String, name:String, system:String )
    _score = score
    _time = time
    _name = name
    Select system
      Case "1"
        _system = "Android"
      Case "2"
        _system = "iOS"
      Case "3"
        _system = "Windows"
      Case "4"
        _system = "Web"
      Case "5"
        _system = "Desktop"
      Case "6"
        _system = "Amazon"
      Case "7"
        _system = "Nook"
    End Select
  End Method
End Class

Class MenuStatistics Implements ButtonCallback, NetworkCallback
Private
  Field _statValues:String[]
  Field _normalSelected:Bool
  Field _playedGames:String
  Field _rank:String
  Field _bestRank:String
  Field _highscoreList:List<Highscore>
  Field _highscoreRequestSend:Bool
  Field _isMousePressed:Bool
  Field _currentState:Int
  Field _errorMessage:String
  Field _daysSelected:Int

Public
  Method New()
    '_statValues = New String[100]
    _isMousePressed = False
    _normalSelected = True
    _highscoreList = New List<Highscore>()
    _currentState = GAME_STATE_STATISTICS_CREATE
    _errorMessage = ""
    _daysSelected = 10000
  End Method
  
  Method init:Void()
    _highscoreRequestSend = False
    _highscoreList.Clear()
    _currentState = GAME_STATE_STATISTICS_CREATE
    _errorMessage = ""
  End Method
  
  Method buttonCallBack:Void( buttonName:String )
    gParentState = gGameState
    gRequestedState = GAME_STATE_MENU_MAIN
    gStateChangeTime = 0
  End Method

  Method onHttpRequestComplete:Void( req:HttpRequest )
    'Print "Status="+req.Status()
    'Print "ResponseText="+req.ResponseText()
    Select _currentState
      Case GAME_STATE_STATISTICS_WAIT
        Local status:Int = req.Status()
        If( status >= 200 And status < 300 )
          'Everything all right, continue!
          _errorMessage = ""
          Local resultString:String = req.ResponseText()
          _statValues = resultString.Split( "," )
          'Print "L: " + _statValues.Length()
          If( _statValues.Length() >= 3 )
            _playedGames = _statValues[0]
            _rank = _statValues[1]
            _bestRank = _statValues[2]
            For Local i:Int = 3 Until _statValues.Length()-4 Step 4
              _highscoreList.AddLast( New Highscore( _statValues[i], _statValues[i+1], _statValues[i+2], _statValues[i+3] ) )
            Next
          End If
          _errorMessage = ""
          _currentState = GAME_STATE_STATISTICS_DISPLAY
        Else
          _errorMessage = "Can't connect to server to obtain scores!"
          _currentState = GAME_STATE_STATISTICS_DISPLAY
        End If
    End Select
  End Method

  Method update:Void()
  End Method
  
  Method draw:Void( drawAlwaysBackground:Bool = False )
    If( drawAlwaysBackground ) Then SetAlpha( 1.0 )
    Local animSeq:Int = ( Millisecs() / 100 ) Mod 8
    gNetworkStats.update()

    DrawImage( gRM.get( GFX_BACKGROUND ), IMGX / 2.0, gMaxY / 2.0 )
    DrawImage( gRM.get( GFX_TITLE ), 0, 0 )
    SetAlpha( gAlpha )

    If( gControls.isMousePressed() And Not _isMousePressed )
      _isMousePressed = True
    End If
    If( Not gControls.isMousePressed() And _isMousePressed )
      _isMousePressed = False
      If( gControls.getMousePressedX() > 0 And gControls.getMouseReleasedX() > 0 And
        gControls.getMousePressedX() < 288 And gControls.getMouseReleasedX() < 288 And
        gControls.getMousePressedY() > 120 And gControls.getMouseReleasedY() > 120 And
        gControls.getMousePressedY() < 182 And gControls.getMouseReleasedY() < 182 )
        If( Not _normalSelected )
          _normalSelected = True
          init()
        End If
      Else If( gControls.getMousePressedX() > 288 And gControls.getMouseReleasedX() > 288 And
               gControls.getMousePressedX() < 576 And gControls.getMouseReleasedX() < 576 And
               gControls.getMousePressedY() > 120 And gControls.getMouseReleasedY() > 120 And
               gControls.getMousePressedY() < 182 And gControls.getMouseReleasedY() < 182 )
        If( _normalSelected )
          _normalSelected = False
          init()
        End If
      Else If( gControls.getMousePressedX() > 0 And gControls.getMouseReleasedX() > 0 And
               gControls.getMousePressedX() < 144 And gControls.getMouseReleasedX() < 144 And
               gControls.getMousePressedY() > 182 And gControls.getMouseReleasedY() > 182 And
               gControls.getMousePressedY() < 214 And gControls.getMouseReleasedY() < 214 )
        If( _daysSelected <> 10000 )
          _daysSelected = 10000
          init()
        End If
      Else If( gControls.getMousePressedX() > 144 And gControls.getMouseReleasedX() > 144 And
               gControls.getMousePressedX() < 2*144 And gControls.getMouseReleasedX() < 2*144 And
               gControls.getMousePressedY() > 182 And gControls.getMouseReleasedY() > 182 And
               gControls.getMousePressedY() < 214 And gControls.getMouseReleasedY() < 214 )
        If( _daysSelected <> 30 )
          _daysSelected = 30
          init()
        End If
      Else If( gControls.getMousePressedX() > 2*144 And gControls.getMouseReleasedX() > 2*144 And
               gControls.getMousePressedX() < 3*144 And gControls.getMouseReleasedX() < 3*144 And
               gControls.getMousePressedY() > 182 And gControls.getMouseReleasedY() > 182 And
               gControls.getMousePressedY() < 214 And gControls.getMouseReleasedY() < 214 )
        If( _daysSelected <> 7 )
          _daysSelected = 7
          init()
        End If
      Else If( gControls.getMousePressedX() > 3*144 And gControls.getMouseReleasedX() > 3*144 And
               gControls.getMousePressedX() < 4*144 And gControls.getMouseReleasedX() < 4*144 And
               gControls.getMousePressedY() > 182 And gControls.getMouseReleasedY() > 182 And
               gControls.getMousePressedY() < 214 And gControls.getMouseReleasedY() < 214 )
        If( _daysSelected <> 1 )
          _daysSelected = 1
          init()
        End If
      End If
    End If

    gFontMain.DrawText( "HIGHSCORES", IMGX/2.0, 80, eDrawAlign.CENTER )
    If( _normalSelected )
      DrawImage( gRM.get( GFX_TAB_NORMAL_ON ), 0, 120 )
      DrawImage( gRM.get( GFX_TAB_INSANE ), 288, 120 )
    Else
      DrawImage( gRM.get( GFX_TAB_NORMAL ), 0, 120 )
      DrawImage( gRM.get( GFX_TAB_INSANE_ON ), 288, 120 )
    End If
    If( _daysSelected = 10000 )
      DrawImage( gRM.get( GFX_SUBTAB_SELECTED ), 0, 182 )
    Else
      DrawImage( gRM.get( GFX_SUBTAB_UNSELECTED ), 0, 182 )
    End If
    If( _daysSelected = 30 )
      DrawImage( gRM.get( GFX_SUBTAB_SELECTED ), 144, 182 )
    Else
      DrawImage( gRM.get( GFX_SUBTAB_UNSELECTED ), 144, 182 )
    End If
    If( _daysSelected = 7 )
      DrawImage( gRM.get( GFX_SUBTAB_SELECTED ), 2*144, 182 )
    Else
      DrawImage( gRM.get( GFX_SUBTAB_UNSELECTED ), 2*144, 182 )
    End If
    If( _daysSelected = 1 )
      DrawImage( gRM.get( GFX_SUBTAB_SELECTED ), 3*144, 182 )
    Else
      DrawImage( gRM.get( GFX_SUBTAB_UNSELECTED ), 3*144, 182 )
    End If
    gFontMedium.DrawText( "ALLTIME", 144/2, 184, eDrawAlign.CENTER )
    gFontMedium.DrawText( "LAST 30D", 1*144+144/2, 184, eDrawAlign.CENTER )
    gFontMedium.DrawText( "LAST 7D", 2*144+144/2, 184, eDrawAlign.CENTER )
    gFontMedium.DrawText( "TODAY", 3*144+144/2, 184, eDrawAlign.CENTER )
    
    If( _playedGames.Length() = 0 ) Then _playedGames = "0"
    gFontMedium.DrawText( "Total played games (server): " + FormatInt( Int( _playedGames ) ), 16, 190+32 )
    DrawImage( gRM.get( GFX_HR ), IMGX/2.0, 224+32 )
    gFontMedium.DrawText( "RANK", 50, 230+32, eDrawAlign.CENTER )
    gFontMedium.DrawText( "SCORE", 135, 230+32, eDrawAlign.CENTER )
    gFontMedium.DrawText( "TIME", 220, 230+32, eDrawAlign.CENTER )
    gFontMedium.DrawText( "NAME", 350, 230+32, eDrawAlign.CENTER )
    gFontMedium.DrawText( "SYSTEM", 500, 230+32, eDrawAlign.CENTER )
    DrawImage( gRM.get( GFX_HR ), IMGX/2.0, 264+32 )
    
    'Display connection error if there is one
    gFontMedium.DrawText( _errorMessage, IMGX/2.0, gMaxY/2.0, eDrawAlign.CENTER )

    'Limit the amount of lines depending on the device height    
    Local lines:Int = 20 + ( 256 - ( IMGY - gMaxY ) - ( BOTTOM_SPACE_FOR_BANNER - 10 ) ) / 16
    Local i:Int = 1
    For Local h:Highscore = EachIn _highscoreList
      gFontSmall.DrawText( i, 50, 260 + i*16+32, eDrawAlign.CENTER )
      gFontSmall.DrawText( Round( Float( h._score ) / 100.0, 2 ), 135, 260 + i*16+32, eDrawAlign.CENTER )
      gFontSmall.DrawText( Round( Float( h._time ) / 100.0, 2 ), 220, 260 + i*16+32, eDrawAlign.CENTER )
      gFontSmall.DrawText( h._name, 350, 260 + i*16+32, eDrawAlign.CENTER )
      gFontSmall.DrawText( h._system, 500, 260 + i*16+32, eDrawAlign.CENTER )
      i += 1
      If( i = lines ) Then Exit
    Next
    Local bestScore:Int = gBestScoreInNormal
    Local bestTime:Int = gBestTimeInNormal
    Local currentScore:Int = gCurrentScoreInNormal
    Local currentTime:Int = gCurrentTimeInNormal
    Local gameMode:Int = 1
    If( Not _normalSelected )
      bestScore = gBestScoreInInsane
      bestTime = gBestTimeInInsane
      currentScore = gCurrentScoreInInsane
      currentTime = gCurrentTimeInInsane
      gameMode = 2
    End If
    
    If( bestScore < MAX_NUMBER )
      gFontSmall.DrawText( _bestRank, 50, 260 + (i+1)*16+32, eDrawAlign.CENTER )
      gFontSmall.DrawText( Round( Float( bestScore ) / 100.0, 2 ), 135, 260 + (i+1)*16+32, eDrawAlign.CENTER )
      gFontSmall.DrawText( Round( Float( bestTime ) / 100.0 ), 220, 260 + (i+1)*16+32, eDrawAlign.CENTER )
      gFontSmall.DrawText( gPlayerName, 350, 260 + (i+1)*16+32, eDrawAlign.CENTER )
      gFontSmall.DrawText( "YOUR BEST", 500, 260 + (i+1)*16+32, eDrawAlign.CENTER )
      i += 1
    End If

    If( currentScore > 0 )
      gFontSmall.DrawText( _rank, 50, 260 + (i+1)*16+32, eDrawAlign.CENTER )
      gFontSmall.DrawText( Round( Float( currentScore ) / 100.0, 2 ), 135, 260 + (i+1)*16+32, eDrawAlign.CENTER )
      gFontSmall.DrawText( Round( Float( currentTime ) / 100.0 ), 220, 260 + (i+1)*16+32, eDrawAlign.CENTER )
      gFontSmall.DrawText( gPlayerName, 350, 260 + (i+1)*16+32, eDrawAlign.CENTER )
      gFontSmall.DrawText( "YOUR LAST", 500, 260 + (i+1)*16+32, eDrawAlign.CENTER )
    End If
    gMenuStatisticsGUI.update()
    gMenuStatisticsGUI.paint()
    
    Select _currentState
      Case GAME_STATE_STATISTICS_CREATE
        DrawImage( gRM.get( GFX_WAIT_ANIMATION ), IMGX / 2.0, gMaxY / 2.0, animSeq )
        If( Not gNetworkStats.isReady() ) Then Return
        Local sendString:String = "getStats.php?gt=" + gameMode + "&csc=" + currentScore + "&bsc=" + bestScore + "&ld=" + String(_daysSelected)
        If( Not gNetworkStats.send( sendString ) )
          _errorMessage = "Can't connect to server to obtain scores!"
          _currentState = GAME_STATE_STATISTICS_DISPLAY
          Return
        End If
        _errorMessage = ""
        _currentState = GAME_STATE_STATISTICS_WAIT
        Return
      Case GAME_STATE_STATISTICS_WAIT
        DrawImage( gRM.get( GFX_WAIT_ANIMATION ), IMGX / 2.0, gMaxY / 2.0, animSeq )
        If( gNetworkStats.wasTimedOut() )
          _errorMessage = "Can't connect to server to obtain scores!"
          _currentState = GAME_STATE_STATISTICS_DISPLAY
          Return
        End If
    End Select
  End Method
End Class