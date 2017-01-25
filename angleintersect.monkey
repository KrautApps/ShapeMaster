Strict

Import constants
Import construct
Import globals

Class Angleintersect Implements Construct
  Field _x1:Float
  Field _y1:Float
  Field _x2:Float
  Field _y2:Float
  Field _x3:Float
  Field _y3:Float
  Field _pX:Float
  Field _pY:Float
  Field _middleX:Float
  Field _middleY:Float
  Field _sOY:Float
  Field _angle:Float
  Field _overallAngle:Float
  Field _mat:Float[]
  Field _showSolution:Bool
  Field _offsetX:Float  'Offset for the mouse to not hide structures with the finger!
  Field _offsetY:Float
  Field _insaneMode:Bool
  
  Method New()
    _offsetX = 0.0
    _offsetY = 0.0
    _sOY = Rnd( -50.0, 50.0 )
    _showSolution = False
    _overallAngle = Rnd( 0.0, 360.0 ) 'Angle of the complete image
    _x1 = -IMGX/2.0 + 16.0
    _y1 = _sOY
    _angle = Rnd( 40.0, 130.0 )
    _x2 = Cos( _angle ) * ( IMGX/2.0 - 16.0 )
    _y2 = _sOY + Sin( _angle ) * ( -IMGX/2.0 + 16.0 )
    _x3 = Cos( _angle ) * ( IMGX/2.0 - 16.0 )
    _y3 = _sOY + Sin( _angle ) * ( IMGX/2.0 - 16.0 )
    Local playerAngle:Float = _angle / 2.0 - Rnd( 0.0, 20.0 )
    _pX = Cos( playerAngle ) * ( IMGX/2.0 - 16.0 )
    _pY = _sOY + Sin( playerAngle ) * ( -IMGX/2.0 + 16.0 )
    _middleX = ( IMGX/2.0 - 16.0 )
    _middleY = _sOY
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
    Local a:Float = GetDist( _x1, _y1, _x2, _y2 )
    Local b:Float = GetDist( _x1, _y1, _pX, _pY )
    Local c:Float = GetDist( _x2, _y2, _pX, _pY )
    Local gamma:Float = ACos( ( a*a + b*b - c*c ) / ( 2*a*b ) )
    'Print "a: " + a + " b: " + b + " c: " + c + " g: " + gamma + " gg: " + (( a*a + b*b - c*c ) / (2*a*b))
    Return Abs( _angle / 2.0 - gamma )
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
      DrawThickLine( _x1, _y1, _x3, _y3, 4.0 )
      SetColor( 0, 0, 255 )
      DrawThickLine( _x1, _y1, _pX, _pY, 4.0 )
      If( _showSolution )
        SetColor( 0, 0, 0 )
        DrawThickLine( _x1, _y1, _middleX, _middleY, 4.0 )
        SetColor( 0, 255, 0 )
        DrawThickLine( _x1, _y1, _middleX, _middleY, 2.0 )
      End If
    PopMatrix()
    SetColor( 255, 255, 255 )
  End Method
End Class