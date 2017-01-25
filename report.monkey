Strict

Import constants
Import globals
Import utils

Class Report
Private
  Field _accuracy:Int
  Field _time:Int
  Field _playerName:String
  Field _keyboardEnabled:Bool
  Field _mousePressed:Bool
Public
  Method New()
    _accuracy = 0
    _time = 0
    _keyboardEnabled = False
    _mousePressed = False
  End Method

  Method create:Void( accuracy:Float, time:Int )
    _keyboardEnabled = False
    _mousePressed = False
    'stores floats as integer * 100 to preserve one digit after the comma
    'this leads to easier and faster compare in the MySQL database
    _accuracy = Int( accuracy * 100.0 / 7.0 )
    _time = time / 10
    _playerName = gPlayerName
    'Print "Accuracy: " + _accuracy + " time: " + _time
  End Method

  Method getAccuracy:Int()
    Return _accuracy  
  End Method
  
  Method getTime:Int()
    Return _time
  End Method
  
  Method getName:String()
    Return _playerName
  End Method
  
  Method update:Void()
    If( _keyboardEnabled )
      Repeat
        Local char:Int = GetChar()
        If( Not char ) Then Exit
'        Print "char: " + char
        If( char >= 48 And char <= 57 Or char >= 65 And char <= 90 Or char >= 97 And char <= 122 )
          'If( char = 32 ) Then char = 95
          If( gFontMain.GetTxtWidth( _playerName ) < 236 )
            _playerName += String.FromChar( char )
            gPlayerName = _playerName
          End If
        Else
          Select char
            Case 8
              _playerName = _playerName[..-1]
              gPlayerName = _playerName
            Case 13
              DisableKeyboard()
              _keyboardEnabled = False
              'Print "name: " + _playerName
            Case 27
              DisableKeyboard()
              _keyboardEnabled = False
              'Print "name: " + _playerName
          End Select
        End If
      Forever
    End If
  End Method
  
  Method draw:Void( distribution:Int[] )
    gFontMain.DrawText( "Game completed!", IMGX/2.0, 80, eDrawAlign.CENTER )
    gFontMain.DrawText( "Your name:", 32, 96+60 )
    DrawImage( gRM.get( GFX_NAME_FIELD ), 256-32, 80+60 )
    gFontMain.DrawText( _playerName, 256-32, 96+60 )
    If( _keyboardEnabled And ( Millisecs() / 500 ) Mod 2 )
      Local offset:Float = gFontMain.GetTxtWidth( _playerName ) - 12.0
      If( _playerName.Length() = 0 )
        offset = 0.0
      End If
      gFontMain.DrawText( "|", 256-32+offset, 96+60 )
    End If
    gFontMain.DrawText( "Total score:", 32, 96+60+32+1*42 )
    gFontMain.DrawText( Round( Float( _accuracy ) / 100.0, 2 ) + " units.", 256-32, 96+60+32+1*42 )
    gFontMain.DrawText( "Total time:", 32, 96+60+32+2*42 )
    gFontMain.DrawText( Round( Float( _time ) / 100.0 ) + " seconds.", 256-32, 96+60+32+2*42 )
    Local gamesCount:Int = 0
    For Local i:Int = 0 To 24
      gamesCount += distribution[i]
    Next
    gFontMain.DrawText( "Scores distribution of the last~n" + FormatInt( gamesCount ) + " games:", 32, 96+60+32+3*42+21 )
    DrawImage( gRM.get( GFX_SCORES_DISTRIBUTION ), 32, 96+60+32+5*42+16 )
    drawChart( distribution )
    gGameReportGUI.update()
    gGameReportGUI.paint()
    'Check if the player clicks into the name field
    If( gControls.isMousePressed() And Not _mousePressed )
      _mousePressed = True
      Local mx:Float = gControls.getMousePressedX()
      Local my:Float = gControls.getMousePressedY()
      If( mx > ( 256-32 ) And mx < ( 576-32-64 ) And my > ( 80+60 ) And my < ( 80+60+64 ) )
        EnableKeyboard()
        _keyboardEnabled = True
      Else If( mx > ( 576-32-64 ) And mx < ( 576-32 ) And my > ( 80+60 ) And my < ( 80+60+64 ) )
        _playerName = ""
      Else
        DisableKeyboard()
        _keyboardEnabled = False
      End If
    Else If( Not gControls.isMousePressed() And _mousePressed )
      _mousePressed = False
    End If
  End Method
  
  Method drawChart:Void( distribution:Int[] )
    'Normalize distribution
    Local maxCount:Int = 0
    For Local i:Int = 0 To 24
      If( distribution[i] > maxCount ) Then maxCount = distribution[i]
    Next
    If( maxCount = 0 ) Then maxCount = 1  'to avoid division by zero
    
    For Local x:Int = 0 To 24
      SetColor( 0, 0, 0 )
      DrawThickLine( 32+6+22+x*19, 96+60+32+3*42+16+190, 32+6+22+x*19, 96+60+32+3*42+16+190-( 100.0*Float(distribution[x])/Float(maxCount) )-2, 17.0 )
      SetColor( 136, 170, 0 )
      DrawThickLine( 32+6+22+x*19, 96+60+32+3*42+16+190-1, 32+6+22+x*19, 96+60+32+3*42+16+190-( 100.0*Float(distribution[x])/Float(maxCount) )-2+1, 15.0 )
      If( x = 0 Or x = 4 Or x = 8 Or x = 12 Or x = 16 Or x = 20 Or x = 24 )
        SetColor( 255, 255, 255 )
        gFontMain.DrawText( x, 32+6+20+x*19, 96+60+32+3*42+16+190, eDrawAlign.CENTER )
      End If
    Next
    'Draw own score
    Local accuracy:Float = Float( _accuracy ) / 100.0
    If( accuracy < 25.0 )
      SetColor( 255, 0, 0 )
      DrawThickLine( 32+20+accuracy*19.0, 96+60+32+3*42+16+190, 32+20+accuracy*19.0, 96+60+32+3*42+16+190-100, 2.0 )
      SetColor( 255, 255, 255 )
      If( accuracy < 12.5 )
        gFontSmallR.DrawText( "YOU", 32+20+accuracy*19.0, 96+60+32+3*42+16+190-102, eDrawAlign.LEFT )
      Else
        gFontSmallR.DrawText( "YOU", 32+20+accuracy*19.0, 96+60+32+3*42+16+190-102, eDrawAlign.RIGHT )
      End If
    End If
    SetColor( 255, 255, 255 )
    gFontMain.DrawText( "best", 32+13, 96+60+32+3*42+16+190+28, eDrawAlign.LEFT )
    gFontMain.DrawText( "worse", 32+26*20-14, 96+60+32+3*42+16+190+28, eDrawAlign.RIGHT )
  End Method
End Class