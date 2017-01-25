Strict

Import constants
Import construct
Import globals

Class Convergence Implements Construct
  Field _ax1:Float
  Field _ay1:Float
  Field _ax2:Float
  Field _ay2:Float
  Field _bx1:Float
  Field _by1:Float
  Field _bx2:Float
  Field _by2:Float
  Field _cx1:Float
  Field _cy1:Float
  Field _cx2:Float
  Field _cy2:Float
  Field _pX:Float
  Field _pY:Float
  Field _correctX:Float
  Field _correctY:Float
  Field _sOY:Float
  Field _angle:Float
  Field _overallAngle:Float
  Field _mat:Float[]
  Field _showSolution:Bool
  Field _offsetX:Float  'Offset for the mouse to not hide structures with the finger!
  Field _offsetY:Float
  Field _insaneMode:Bool
  
  Method New()
    _offsetX = -100.0
    _offsetY = 0.0
    _sOY = 0.0'Rnd( -50.0, 50.0 )
    _showSolution = False
    _overallAngle = Rnd( 0.0, 360.0 ) 'Angle of the complete image
    _correctX = 0.0
    _correctY = _sOY
    _angle = Rnd( 40.0, 170.0 )
    _ax1 = 0.0 + Cos( _angle/2.0 ) * 150.0
    _ay1 = _sOY + Sin( _angle/2.0 ) * -150.0
    _ax2 = _ax1 + Cos( _angle/2.0 ) * 100.0
    _ay2 = _ay1 + Sin( _angle/2.0 ) * -100.0

    _bx1 = 0.0 + Cos( _angle/2.0 ) * 150.0
    _by1 = _sOY + Sin( _angle/2.0 ) * 150.0
    _bx2 = _bx1 + Cos( _angle/2.0 ) * 100.0
    _by2 = _by1 + Sin( _angle/2.0 ) * 100.0

    Local middleAngle:Float = Rnd( 0.0, 20.0 )
    _cx1 = 0.0 + Cos( middleAngle ) * 150.0
    _cy1 = _sOY + Sin( middleAngle ) * 150.0
    _cx2 = _cx1 + Cos( middleAngle ) * 100.0
    _cy2 = _cy1 + Sin( middleAngle ) * 100.0
    
    _pX = _correctX + Rnd( -80.0, 80.0 )
    _pY = _correctY + Rnd( -80.0, 80.0 )
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
    Return GetDist( _pX, _pY, _correctX, _correctY )
  End Method
  
  Method draw:Void()
    If( _insaneMode )
      _overallAngle += 30.0 * gDiffTimeSec
    End If
    '_overallAngle += 0.5
    'getDeviation()
    'Print _overallAngle
    PushMatrix()
      Translate( IMGX/2.0, gMaxY/2.0 )
      Rotate( _overallAngle )
      _mat = GetMatrix()
      SetColor( 255, 0, 0 )
      DrawThickLine( _ax1, _ay1, _ax2, _ay2, 4.0 )
      DrawThickLine( _bx1, _by1, _bx2, _by2, 4.0 )
      DrawThickLine( _cx1, _cy1, _cx2, _cy2, 4.0 )
      SetColor( 0, 0, 255 )
      DrawThickLine( _pX, _pY, _ax1, _ay1, 4.0 )
      DrawThickLine( _pX, _pY, _bx1, _by1, 4.0 )
      DrawThickLine( _pX, _pY, _cx1, _cy1, 4.0 )
      DrawArcOutline( _pX+_offsetX, _pY+_offsetY, 60.0, 60.0, 0.0, 360.0, 64, 2.0 )
      DrawThickLine( _pX+_offsetX, _pY+_offsetY, _pX, _pY, 2.0 )
      If( _showSolution )
        SetColor( 0, 0, 0 )
        DrawThickLine( _correctX, _correctY, _ax1, _ay1, 4.0 )
        DrawThickLine( _correctX, _correctY, _bx1, _by1, 4.0 )
        DrawThickLine( _correctX, _correctY, _cx1, _cy1, 4.0 )
        SetColor( 0, 255, 0 )
        DrawThickLine( _correctX, _correctY, _ax1, _ay1, 2.0 )
        DrawThickLine( _correctX, _correctY, _bx1, _by1, 2.0 )
        DrawThickLine( _correctX, _correctY, _cx1, _cy1, 2.0 )
      End If
    PopMatrix()
    SetColor( 255, 255, 255 )
  End Method
End Class