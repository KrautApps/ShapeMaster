Strict

Import constants
Import construct
Import globals

Class Rightangle Implements Construct
  Field _x1:Float
  Field _y1:Float
  Field _x2:Float
  Field _y2:Float
  Field _x3:Float
  Field _y3:Float
  Field _pX:Float
  Field _pY:Float
  Field _angle:Float
  Field _overallAngle:Float
  Field _mat:Float[]
  Field _showSolution:Bool
  Field _offsetX:Float  'Offset for the mouse to not hide structures with the finger!
  Field _offsetY:Float
  Field _insaneMode:Bool
  Field _direction:Float
  
  Method New()
    _offsetX = 0.0
    _offsetY = 0.0
    _showSolution = False
    _overallAngle = Rnd( 0.0, 360.0 ) 'Angle of the complete image
    _x1 = -IMGX/2.0 + 64.0
    _y1 = 0.0
    _angle = Rnd( 40.0, 130.0 )
    _x2 = IMGX/2.0 - 64.0
    _y2 = 0.0
    _x3 = -IMGX/2.0 + 64.0
    _y3 = -IMGX/2.0 + 64.0
    _pX = Cos( _angle ) * ( IMGX/2.0 - 64.0 )
    _pY = Sin( _angle ) * ( -IMGX/2.0 + 64.0 )
    _direction = 1.0
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
    _pY = y - _offsetY
  End Method
  
  Method showSolution:Void( show:Bool )
    _showSolution = show
  End Method
  
  Method getDeviation:Float()
    Local a:Float = GetDist( _pX, _pY, _x3, _y3 )
    Local b:Float = GetDist( _x1, _y1, _pX, _pY )
    Local c:Float = GetDist( _x1, _y1, _x3, _y3 )
    Local alpha:Float = ACos( ( b*b + c*c - a*a ) / ( 2*b*c ) )
    If( alpha > 90.0 )
      _direction = -1.0
      alpha = 180.0 - alpha
    End If
    Return alpha
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
      DrawThickLine( _x1, _y1, _x2, _y2, 4.0 )
      'DrawArcOutline( _x1, _y1, 80.0, 80.0, 90.0, 270.0, 64, 4.0 )
      'DrawThickLine( _x1, _y1, _x3, _y3, 4.0 )
      SetColor( 0, 0, 255 )
      DrawThickLine( _x1, _y1, _pX, _pY, 4.0 )
      If( _showSolution )
        SetColor( 0, 0, 0 )
        DrawThickLine( _x1, _y1, _x3, _y3*_direction, 4.0 )
        SetColor( 0, 255, 0 )
        DrawThickLine( _x1, _y1, _x3, _y3*_direction, 2.0 )
      End If
    PopMatrix()
    SetColor( 255, 255, 255 )
  End Method
End Class