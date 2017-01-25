Strict

Import constants
Import construct
Import globals

Class Linesegment Implements Construct
  Field _x1:Float
  Field _y1:Float
  Field _x2:Float
  Field _y2:Float
  Field _x3:Float
  Field _y3:Float
  Field _middleX:Float
  Field _middleY:Float
  Field _overallAngle:Float
  Field _mat:Float[]
  Field _showSolution:Bool
  Field _offsetX:Float  'Offset for the mouse to not hide structures with the finger!
  Field _offsetY:Float
  Field _sOX:Float
  Field _sOY:Float
  Field _insaneMode:Bool
  
  Method New()
    _offsetX = 0.0
    _offsetY = -170.0
    _showSolution = False
    _overallAngle = Rnd( 0.0, 360.0 ) 'Angle of the complete image
    _sOX = 0.0
    _sOY = Rnd( -50.0, 50.0 )
    _x1 = _sOX + Rnd( -IMGX/2.0 + 16.0, -IMGX/2.0 + 100.0 )
    _y1 = _sOY
    _x3 = _sOX + Rnd(  IMGX/2.0 - 100.0, IMGX/2.0 - 16.0 )
    _y3 = _sOY
    _middleX = ( _x3 + _x1 ) / 2.0
    _middleY = ( _y3 + _y1 ) / 2.0
    _x2 = Rnd( -75.0, 75.0 )
    _y2 = Rnd( -75.0, 75.0 )
  End Method

  Method setInsaneMode:Void( insaneMode:Bool )
    _insaneMode = insaneMode
  End Method
  
  'Returns the transformation matrix to transform the touch coordinates into the local space
  Method getMatrix:Float[]()
    Return _mat
  End Method
  
  Method setPlayerPoint:Void( x:Float, y:Float )
    _x2 = x - _offsetX - _sOX
    _y2 = y - _offsetY - _sOY
  End Method
  
  Method showSolution:Void( show:Bool )
    _showSolution = show
  End Method
  
  Method getDeviation:Float()
    Return GetDist( _x2, _y2, _middleX, _middleY )
  End Method
  
  Method draw:Void()
    If( _insaneMode )
      _overallAngle += 30.0 * gDiffTimeSec
    End If
    '_overallAngle += 0.5
    'Print _overallAngle
    PushMatrix()
      Translate( IMGX/2.0, gMaxY/2.0 )
      Rotate( _overallAngle )
      _mat = GetMatrix()
      SetColor( 0, 0, 255 )
      DrawThickLine( _x1+_sOX, _y1+_sOY, _x2+_sOX, _y2+_sOY, 4.0 )
      DrawThickLine( _x2+_sOX, _y2+_sOY, _x3+_sOX, _y3+_sOY, 4.0 )
      DrawArcOutline( _x2+_offsetX+_sOX, _y2+_offsetY+_sOY, 60.0, 60.0, 0.0, 360.0, 64, 2.0 )
      DrawThickLine( _x2+_offsetX+_sOX, _y2+_offsetY+_sOY, _x2+_sOX, _y2+_sOY, 2.0 )
      DrawArcOutline( _x2+_sOX, _y2+_sOY, 10.0, 10.0, 0.0, 360.0, 64, 2.0 )
      If( _showSolution )
        SetColor( 0, 0, 0 )
        DrawThickLine( _x1+_sOX, _y1+_sOY, _middleX+_sOX, _middleY+_sOY, 4.0 )
        DrawThickLine( _middleX+_sOX, _middleY+_sOY, _x3+_sOX, _y3+_sOY, 4.0 )
        DrawArcOutline( _middleX+_sOX, _middleY+_sOY, 10.0, 10.0, 0.0, 360.0, 64, 4.0 )
        SetColor( 0, 255, 0 )
        DrawThickLine( _x1+_sOX, _y1+_sOY, _middleX+_sOX, _middleY+_sOY, 2.0 )
        DrawThickLine( _middleX+_sOX, _middleY+_sOY, _x3+_sOX, _y3+_sOY, 2.0 )
        DrawArcOutline( _middleX+_sOX, _middleY+_sOY, 10.0, 10.0, 0.0, 360.0, 64, 2.0 )
      End If
    PopMatrix()
    SetColor( 255, 255, 255 )
  End Method
End Class