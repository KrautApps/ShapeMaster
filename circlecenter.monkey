Strict

Import constants
Import construct
Import globals

Class Circlecenter Implements Construct
  Field _x1:Float
  Field _y1:Float
  Field _pX:Float
  Field _pY:Float
  Field _sOY:Float
  Field _overallAngle:Float
  Field _mat:Float[]
  Field _showSolution:Bool
  Field _offsetX:Float  'Offset for the mouse to not hide structures with the finger!
  Field _offsetY:Float
  Field _insaneMode:Bool
  
  Method New()
    _offsetX = 100.0
    _offsetY = 100.0
    _sOY = Rnd( -50.0, 50.0 )
    _showSolution = False
    _overallAngle = Rnd( 0.0, 360.0 ) 'Angle of the complete image
    _x1 = 0.0
    _y1 = _sOY
    _pX = Rnd( -50.0, 50.0 )
    _pY = _sOY + Rnd( -50.0, 50.0 )
  End Method

  Method setInsaneMode:Void( insaneMode:Bool )
    _insaneMode = insaneMode
  End Method
  
  'Returns the transformation matrix to transform the touch coordinates into the local space
  Method getMatrix:Float[]()
    Return _mat
  End Method
  
  Method setPlayerPoint:Void( x:Float, y:Float )
    _pX = x - _offsetX
    _pY = y - _offsetY - _sOY
  End Method
  
  Method showSolution:Void( show:Bool )
    _showSolution = show
  End Method
  
  Method getDeviation:Float()
    Return GetDist( _x1, _y1, _pX, _pY )
  End Method
  
  Method draw:Void()
    If( _insaneMode )
      _overallAngle += 30.0 * gDiffTimeSec
    End If
    '_overallAngle += 0.5
    'getDeviation()
    'Print getDeviation()
    PushMatrix()
      Translate( IMGX/2.0, gMaxY/2.0 )
      Rotate( _overallAngle )
      _mat = GetMatrix()
      SetColor( 255, 0, 0 )
      DrawArcOutline( _x1, _y1+_sOY, IMGX / 2.0 - 64.0, IMGX / 2.0 - 64.0, 0.0, 360.0, 64, 4.0 )
      SetColor( 0, 0, 255 )
      DrawArcOutline( _pX+_offsetX, _pY+_offsetY+_sOY, 60.0, 60.0, 0.0, 360.0, 64, 2.0 )
      DrawThickLine( _pX+_offsetX, _pY+_offsetY+_sOY, _pX, _pY+_sOY, 2.0 )
      DrawArcOutline( _pX, _pY+_sOY, 10.0, 10.0, 0.0, 360.0, 64, 2.0 )
      If( _showSolution )
        SetColor( 0, 0, 0 )
        DrawArcOutline( _x1, _y1+_sOY, 10.0, 10.0, 0.0, 360.0, 64, 4.0 )
        SetColor( 0, 255, 0 )
        DrawArcOutline( _x1, _y1+_sOY, 10.0, 10.0, 0.0, 360.0, 64, 2.0 )
      End If
    PopMatrix()
    SetColor( 255, 255, 255 )
  End Method
End Class