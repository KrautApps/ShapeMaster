Strict

Import mojo
Import framework.xgui

Import angleintersect
Import circlecenter
Import controls
Import constants
Import construct
Import convergence
Import equidistanttriangle
Import globals
Import linesegment
Import network
Import networkerror
Import parallelogram
Import report
Import resourcemanager
Import rightangle
Import utils

Class Game Implements ButtonCallback, NetworkCallback
Private
  Field _currentState:Int
  Field _isMousePressed:Bool
  Field _isMouseReleased:Bool
  Field _hasStarted:Bool
  Field _moveFinished:Bool
  Field _waitForInitialMouseRelease:Bool
  Field _stage:Int
  
  Field _parallelogram:Parallelogram
  Field _lineSegment:Linesegment
  Field _angleIntersect:Angleintersect
  Field _equidistantTriangle:Equidistanttriangle
  Field _rightAngle:Rightangle
  Field _circleCenter:Circlecenter
  Field _convergence:Convergence
  
  Field _firstCall:Bool
  Field _accuracy:Float
  Field _report:Report
  Field _networkError:NetworkError
  
  Field _distribution:Int[]
  Field _gameMode:Int
  Field _randomNumber:Int
  Field _sessionName:String
  Field _sessionId:String
  Field _networkRetries:Int

Public
  Method New()
    init()
  End Method
  
  Method init:Void( gameMode:Int = 1 )
    _currentState = GAME_STATE_GAME_RUNNING
    _isMousePressed = False
    _isMouseReleased = False
    _hasStarted = False
    _moveFinished = False
    _waitForInitialMouseRelease = True
    _stage = 1
    _parallelogram = New Parallelogram()
    _lineSegment = New Linesegment()
    _angleIntersect = New Angleintersect()
    _equidistantTriangle = New Equidistanttriangle()
    _rightAngle = New Rightangle()
    _circleCenter = New Circlecenter()
    _convergence = New Convergence()
    _firstCall = True
    _report = New Report()
    _networkError = New NetworkError()
    _accuracy = 0.0
    _randomNumber = 0
    _networkRetries = 0
    _gameMode = gameMode
    _distribution = New Int[25]
    If( gameMode = 1 )
      gCurrentScoreInNormal = -1
    Else
      gCurrentScoreInInsane = -1
    End If
  End Method
  
  Method onHttpRequestComplete:Void( req:HttpRequest )
    Select _currentState
      Case GAME_STATE_GAME_CREATE_REPORT_WAIT
        'Print "Status="+req.Status()
        'Print "ResponseText="+req.ResponseText()
        Local status:Int = req.Status()
        If( status >= 200 And status < 300 )
          'Everything all right, continue!
          Local resultString:String = req.ResponseText()
          Local i:Int = 0
          For Local value:String = Eachin resultString.Split( "," )
            If( i > 24 ) Then Exit
            _distribution[i] = Int( value )
            i += 1
          Next
          _networkRetries = 0
'        Else If( status >= 300 )
'          'Network failure, server timeout, etc...
'          _currentState = GAME_STATE_GAME_REPORT_GET_RANDOM_RETRY
'          _networkRetryTime = Millisecs()
'          _networkRetries += 1
        End If
        _currentState = GAME_STATE_GAME_DISPLAY_REPORT
      Case GAME_STATE_GAME_REPORT_GET_RANDOM_WAIT
        'Print "Status="+req.Status()
        'Print "ResponseText="+req.ResponseText()
        Local status:Int = req.Status()
        If( status >= 200 And status < 300 )
          'Everything all right, continue!
          Local resultString:String = req.ResponseText()
          Local values:String[] = resultString.Split( "," )
          _randomNumber = Int( values[0] )
          _sessionName = values[1]
          _sessionId = values[2]
          _currentState = GAME_STATE_GAME_REPORT_SUBMIT_SCORE
          _networkRetries = 0
          Return
        Else
          'Network failure, server timeout, etc...
          _currentState = GAME_STATE_GAME_REPORT_GET_RANDOM
          _networkRetries += 1
        End If
      Case GAME_STATE_GAME_REPORT_SUBMIT_SCORE_WAIT
'        Print "Status="+req.Status()
'        Print "ResponseText="+req.ResponseText()
        Local status:Int = req.Status()
        If( status >= 200 And status < 300 )
          'Everything all right, continue!
          _currentState = GAME_STATE_GAME_REPORT_SUBMIT_SCORE_FINISHED
          _networkRetries = 0
          Return
        Else
          'Network failure, server timeout, etc...
          _currentState = GAME_STATE_GAME_REPORT_SUBMIT_SCORE
          _networkRetries += 1
        End If
    End Select
    'For Local value:String = Eachin resultString.Split( "," )
    '  Print value
    'Next
  End Method
  
  Method buttonCallBack:Void( buttonName:String )
    If( buttonName = "Next" )
      _stage += 1
      If( _stage = 8 )
        _currentState = GAME_STATE_GAME_CREATE_REPORT
        Return
      End If
      _moveFinished = False
      gTimer.cont()
    Else If( buttonName = "Submit" And ( _currentState = GAME_STATE_GAME_CREATE_REPORT Or _currentState = GAME_STATE_GAME_DISPLAY_REPORT ) )
      _currentState = GAME_STATE_GAME_REPORT_GET_RANDOM
    Else If( buttonName = "Back" )
      gParentState = gGameState
      gRequestedState = GAME_STATE_MENU_MAIN
      gStateChangeTime = 0
    End If
  End Method

  Method setInsaneMode:Void( insaneMode:Bool )
    If( insaneMode )
      _gameMode = 2
    Else
      _gameMode = 1
    End If
    _parallelogram.setInsaneMode( insaneMode )
    _lineSegment.setInsaneMode( insaneMode )
    _angleIntersect.setInsaneMode( insaneMode )
    _equidistantTriangle.setInsaneMode( insaneMode )
    _rightAngle.setInsaneMode( insaneMode )
    _circleCenter.setInsaneMode( insaneMode )
    _convergence.setInsaneMode( insaneMode )
  End Method
  
  Method update:Void()
    If( _stage = 8 )
      _report.update()  'For keyboard access it's necessary to do this in OnUpdate
    End If
  End Method
  
  Method draw:Void()
    If( _waitForInitialMouseRelease )
      If( gControls.isMousePressed() ) Then Return
    End If
    _waitForInitialMouseRelease = False
    If( gControls.isMousePressed() And Not _moveFinished And Not _isMousePressed )
      _hasStarted = True
      If( _stage = 1 )
        gTimer.start()
      Else
        gTimer.cont()
      End If
      _isMousePressed = True
      _isMouseReleased = False
    End If
    If( Not gControls.isMousePressed() And _isMousePressed )
      _isMouseReleased = True
      _isMousePressed = False
      _moveFinished = True
      _firstCall = True
      gTimer.pause()
    End If
    DrawImage( gRM.get( GFX_BACKGROUND ), IMGX / 2.0, gMaxY / 2.0 )
    DrawImage( gRM.get( GFX_TITLE ), 0, 0 )
    Select _stage
      Case 1
'        drawGame( "Find the point of convergence!", _convergence )
        DrawImage( gRM.get( GFX_STATUSBAR ), 0, gMaxY-97-BOTTOM_SPACE_FOR_BANNER )
        drawGame( "Adjust to make a parallelogram!", _parallelogram )
      Case 2
        DrawImage( gRM.get( GFX_STATUSBAR ), 0, gMaxY-97-BOTTOM_SPACE_FOR_BANNER )
        drawGame( "Find the mid-point of the line segment!", _lineSegment )
      Case 3
        DrawImage( gRM.get( GFX_STATUSBAR ), 0, gMaxY-97-BOTTOM_SPACE_FOR_BANNER )
        drawGame( "Bisect the angle!", _angleIntersect )
      Case 4
        DrawImage( gRM.get( GFX_STATUSBAR ), 0, gMaxY-97-BOTTOM_SPACE_FOR_BANNER )
        drawGame( "Mark the point equidistant~nto the edges!", _equidistantTriangle )
      Case 5
        DrawImage( gRM.get( GFX_STATUSBAR ), 0, gMaxY-97-BOTTOM_SPACE_FOR_BANNER )
        drawGame( "Make a right angle!", _rightAngle )
      Case 6
        DrawImage( gRM.get( GFX_STATUSBAR ), 0, gMaxY-97-BOTTOM_SPACE_FOR_BANNER )
        drawGame( "Mark the center of the circle!", _circleCenter )
      Case 7
        DrawImage( gRM.get( GFX_STATUSBAR ), 0, gMaxY-97-BOTTOM_SPACE_FOR_BANNER )
        drawGame( "Find the point of convergence!", _convergence )
      Case 8
        report()
    End Select
  End Method
  
Private
  Method drawGame:Void( txt:String, construct:Construct )
    gFontMain.DrawText( txt, IMGX/2.0, 74, eDrawAlign.CENTER )
    construct.draw()
    Local tmx:Float
    Local tmy:Float
    PushMatrix()
      Local mx:Float = gControls.getCurrentMouseRawX()
      Local my:Float = gControls.getCurrentMouseRawY()
      Local m:Float[] = construct.getMatrix()
      'Skalierung umkehren, um zu den normalen Koordinaten zurueckzukehren
      Scale( 1.0/gScaleRatio, 1.0/gScaleRatio )
      'vorherige Transformation anwenden
      Transform( m[0], m[1], m[2], m[3], m[4], m[5] )
  
      'Mauskoordinaten in lokale Kartenkoordinaten umrechnen
      Local coords:Float[] = InvTransform( [ mx, my ] )
      tmx = coords[0]
      tmy = coords[1]
    PopMatrix()

    If( _isMousePressed And Not _moveFinished )
      construct.setPlayerPoint( tmx, tmy )
    End If
    Local currentTime:String = "0.0"
    If( _hasStarted )
      currentTime = Round( Float( gTimer.getTime() ) / 1000.0 )
    End If
    gFontMain.DrawText( "Accurate to:", 16, gMaxY-BOTTOM_SPACE_FOR_BANNER-84 )
    gFontMain.DrawText( "Time:", 16, gMaxY-BOTTOM_SPACE_FOR_BANNER-42 )
    gFontMain.DrawText( currentTime + " seconds.", IMGX/2.0-60, gMaxY-BOTTOM_SPACE_FOR_BANNER-42 )
    If( _moveFinished )
      construct.showSolution( True )
      gFontMain.DrawText( Round( construct.getDeviation(), 2 ) + " units.", IMGX/2.0-60, gMaxY-BOTTOM_SPACE_FOR_BANNER-84 )
'      gFontMain.DrawText( Round( Float( _resultingTime ) / 1000.0 ) + " seconds.", IMGX/2.0-60, gMaxY-BOTTOM_SPACE_FOR_BANNER-42 )
      gGameGUI.update()
      gGameGUI.paint()
      If( _firstCall )
        _firstCall = False
        _accuracy += construct.getDeviation()
        'Print _accuracy
      End If
    Else
    End If
  End Method
  
  Method report:Void()
    Local animSeq:Int = ( Millisecs() / 100 ) Mod 8
    gNetwork.update()
    Select _currentState
      '*****************************************************************************************************
      Case GAME_STATE_GAME_CREATE_REPORT
        _report.create( _accuracy, gTimer.getTime() )
        If( _gameMode = 1 )
          gCurrentScoreInNormal = Int( _accuracy * 100.0 / 7.0 )
          'Print "current score: " + gCurrentScoreInNormal
          gCurrentTimeInNormal = gTimer.getTime() / 10
          If( gCurrentScoreInNormal < gBestScoreInNormal )
            gBestScoreInNormal = gCurrentScoreInNormal
            gBestTimeInNormal = gCurrentTimeInNormal
          End If
        Else
          gCurrentScoreInInsane = Int( _accuracy * 100.0 / 7.0 )
          gCurrentTimeInInsane = gTimer.getTime() / 10
          If( gCurrentScoreInInsane < gBestScoreInInsane )
            gBestScoreInInsane = gCurrentScoreInInsane
            gBestTimeInInsane = gCurrentTimeInInsane
          End If
        End If
        'Print "getDistribution.php?gt=" + String( _gameMode )
        gNetwork.send( "getDistribution.php?gt=" + String( _gameMode ) )
        _currentState = GAME_STATE_GAME_CREATE_REPORT_WAIT
      '*****************************************************************************************************
      Case GAME_STATE_GAME_CREATE_REPORT_WAIT
        _report.draw( _distribution )
        DrawImage( gRM.get( GFX_WAIT_ANIMATION ), IMGX / 2.0, gMaxY / 2.0, animSeq )
        If( _networkRetries > 2 ) 'non critical, just display it anyway
          _currentState = GAME_STATE_GAME_DISPLAY_REPORT
          _networkRetries = 0
          Return
        End If
        If( gNetwork.wasTimedOut() )
          '_networkRetries += 1
          _currentState = GAME_STATE_GAME_DISPLAY_REPORT
          Return
        End If
      '*****************************************************************************************************
      Case GAME_STATE_GAME_DISPLAY_REPORT
        _report.draw( _distribution )
      '*****************************************************************************************************
      Case GAME_STATE_GAME_REPORT_GET_RANDOM
        _report.draw( _distribution )
        DrawImage( gRM.get( GFX_WAIT_ANIMATION ), IMGX / 2.0, gMaxY / 2.0, animSeq )
        If( Not gNetwork.isReady() ) Then Return
        If( _networkRetries > 2 )
          _currentState = GAME_STATE_GAME_REPORT_NETWORK_ERROR
          _networkRetries = 0
          Return
        End If
        If( Not gNetwork.send( "getRandom.php" ) )
          _currentState = GAME_STATE_GAME_REPORT_NETWORK_ERROR
          _networkRetries = 0
          Return
        End If
        _currentState = GAME_STATE_GAME_REPORT_GET_RANDOM_WAIT
      '*****************************************************************************************************
      Case GAME_STATE_GAME_REPORT_GET_RANDOM_WAIT
        _report.draw( _distribution )
        DrawImage( gRM.get( GFX_WAIT_ANIMATION ), IMGX / 2.0, gMaxY / 2.0, animSeq )
        If( _networkRetries > 2 )
          _currentState = GAME_STATE_GAME_REPORT_NETWORK_ERROR
          _networkRetries = 0
          Return
        End If
        If( gNetwork.wasTimedOut() )
          _networkRetries += 1
          _currentState = GAME_STATE_GAME_REPORT_GET_RANDOM
          Return
        End If
      '*****************************************************************************************************
      Case GAME_STATE_GAME_REPORT_SUBMIT_SCORE
        _report.draw( _distribution )
        DrawImage( gRM.get( GFX_WAIT_ANIMATION ), IMGX / 2.0, gMaxY / 2.0, animSeq )
        If( Not gNetwork.isReady() ) Then Return
        If( _networkRetries > 2 )
          _currentState = GAME_STATE_GAME_REPORT_NETWORK_ERROR
          _networkRetries = 0
          Return
        End If
        Local hash:Int = gNetwork.hashMe( _randomNumber )
        Local str:String = "sendScore.php?" + _sessionName + "=" + _sessionId + "&v=" + String( hash ) +
          "&sc=" + String( _report.getAccuracy() ) + "&tm=" + String( _report.getTime() ) +
          "&sy=" + String( SYSTEM ) + "&gt=" + String( _gameMode ) + "&n=" + _report.getName()
        'Print "Hash: " + hash + " str: " + str
        If( Not gNetwork.send( str ) )
          _currentState = GAME_STATE_GAME_REPORT_NETWORK_ERROR
          _networkRetries = 0
          Return
        End If
        If( gNetwork.wasTimedOut() )
          _networkRetries += 1
          _currentState = GAME_STATE_GAME_REPORT_SUBMIT_SCORE
          Return
        End If
        _currentState = GAME_STATE_GAME_REPORT_SUBMIT_SCORE_WAIT
      '*****************************************************************************************************
      Case GAME_STATE_GAME_REPORT_SUBMIT_SCORE_WAIT
        _report.draw( _distribution )
        DrawImage( gRM.get( GFX_WAIT_ANIMATION ), IMGX / 2.0, gMaxY / 2.0, animSeq )
        If( _networkRetries > 2 )
          _currentState = GAME_STATE_GAME_REPORT_NETWORK_ERROR
          _networkRetries = 0
          Return
        End If
        If( gNetwork.wasTimedOut() )
          _networkRetries += 1
          _currentState = GAME_STATE_GAME_REPORT_SUBMIT_SCORE
          Return
        End If
      '*****************************************************************************************************
      Case GAME_STATE_GAME_REPORT_NETWORK_ERROR
        _networkError.draw()
      '*****************************************************************************************************
      Case GAME_STATE_GAME_REPORT_SUBMIT_SCORE_FINISHED
        gShowInterstitial = True
        _report.draw( _distribution )
        gParentState = gGameState
        gRequestedState = GAME_STATE_MENU_STATISTICS
        gStateChangeTime = 0
        gMenuStatistics.init()
        _currentState = GAME_STATE_GAME_REPORT_SUBMIT_SCORE_FINISHED_IDLE
      '*****************************************************************************************************
      Case GAME_STATE_GAME_REPORT_SUBMIT_SCORE_FINISHED_IDLE
        _report.draw( _distribution )
    End Select
    'gFontMain.DrawText( "retries: " + _networkRetries + " state: " + _currentState, 32, 96+60+32+5*42+16 )
'    Local animSeq:Int = ( Millisecs() / 100 ) Mod 8
'    DrawImage( gRM.get( GFX_WAIT_ANIMATION ), IMGX / 2.0, gMaxY / 2.0, animSeq )
  End Method
End Class