Strict

Import constants
Import construct
Import globals

Class Parallelogram Implements Construct
  Field _x1:Float
  Field _y1:Float
  Field _x2:Float
  Field _y2:Float
  Field _x3:Float
  Field _y3:Float
  Field _x4:Float
  Field _y4:Float
  Field _x5:Float
  Field _y5:Float
  Field _a:Float
  Field _b:Float
  Field _angle:Float
  Field _overallAngle:Float
  Field _mat:Float[]
  Field _showSolution:Bool
  Field _offsetX:Float  'Offset for the mouse to not hide structures with the finger!
  Field _offsetY:Float
  Field _insaneMode:Bool
  
  Method New()
    _offsetX = 100.0
    _offsetY = 100.0
    _showSolution = False
    Local dir:Int = Int( Rnd( 0, 2 ) )
    _overallAngle = Rnd( 40.0, 130.0 ) 'Angle of the complete image
    _overallAngle += dir * 180
    _angle = Rnd( 30.0, 80.0 ) 'Angle between 30° and 80°
    _a = Rnd( 150, 250 ) 'Length of side a
    _b = Rnd( 100, 200 ) 'Length of side b
    _x1 = -_a / 2.0 - _b * Cos( _angle ) / 2.0
    _y1 = _b * Sin( _angle ) / 2.0
    _x2 = _x1 + _a
    _y2 = _y1
    _x3 = _x2 + _b * Cos( _angle )
    _y3 = _y2 - _b * Sin( _angle )
    _x4 = _x1 + _b * Cos( _angle )
    _y4 = _y1 - _b * Sin( _angle )
    _x5 = _x3 + Rnd( -50.0, 50.0 )
    _y5 = _y3 + Rnd( -50.0, 50.0 )
    Local dist:Float = GetDist( _x1, _y1, _x3, _y3 )
    Local dX:Float = ( _x3 - _x1 ) / dist
    Local dY:Float = ( _y3 - _y1 ) / dist
    _offsetX *= dX
    _offsetY *= dY
  End Method

  Method setInsaneMode:Void( insaneMode:Bool )
    _insaneMode = insaneMode  
  End Method
  
  'Returns the transformation matrix to transform the touch coordinates into the local space
  Method getMatrix:Float[]()
    Return _mat
  End Method
  
  Method setPlayerPoint:Void( x:Float, y:Float )
    _x5 = x - _offsetX
    _y5 = y - _offsetY
  End Method
  
  Method showSolution:Void( show:Bool )
    _showSolution = show
  End Method
  
  Method getDeviation:Float()
    Return GetDist( _x5, _y5, _x3, _y3 )
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
      SetColor( 255, 0, 0 )
      DrawThickLine( _x1, _y1, _x2, _y2, 4.0 )
      DrawThickLine( _x1, _y1, _x4, _y4, 4.0 )
      SetColor( 0, 0, 255 )
      DrawThickLine( _x2, _y2, _x5, _y5, 4.0 )
      DrawThickLine( _x4, _y4, _x5, _y5, 4.0 )
      DrawArcOutline( _x5+_offsetX, _y5+_offsetY, 60.0, 60.0, 0.0, 360.0, 64, 2.0 )
      DrawThickLine( _x5+_offsetX, _y5+_offsetY, _x5, _y5, 2.0 )
      If( _showSolution )
        SetColor( 0, 0, 0 )
        DrawThickLine( _x2, _y2, _x3, _y3, 4.0 )
        DrawThickLine( _x4, _y4, _x3, _y3, 4.0 )
        SetColor( 0, 255, 0 )
        DrawThickLine( _x2, _y2, _x3, _y3, 2.0 )
        DrawThickLine( _x4, _y4, _x3, _y3, 2.0 )
      End If
    PopMatrix()
    SetColor( 255, 255, 255 )
  End Method
End Class