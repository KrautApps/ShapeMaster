Strict

Import constants
Import construct
Import globals

Class Equidistanttriangle Implements Construct
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
    _overallAngle = Rnd( 0.0, 360.0 ) 'Angle of the complete image
    _x1 = Rnd( -IMGX/2.0 + 64.0, -IMGX/2.0 + 164.0 )
    _y1 = 0.0
    _x2 = Rnd( IMGX/2.0 - 164.0, IMGX/2.0 - 64.0 )
    _y2 = Rnd( -IMGX/2.0 + 64.0, -IMGX/2.0 + 164.0 )
    _x3 = Rnd( IMGX/2.0 - 164.0, IMGX/2.0 - 64.0 )
    _y3 = Rnd( IMGX/2.0 - 164.0, IMGX/2.0 - 64.0 )
    Local a:Float = GetDist( _x2, _y2, _x3, _y3 )
    Local b:Float = GetDist( _x1, _y1, _x3, _y3 )
    Local c:Float = GetDist( _x1, _y1, _x2, _y2 )
    _middleX = ( a*_x1 + b*_x2 + c*_x3 ) / ( a+b+c )
    _middleY = ( a*_y1 + b*_y2 + c*_y3 ) / ( a+b+c )
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
    Return GetDist( _pX, _pY, _middleX, _middleY )
  End Method
  
  Method draw:Void()
    If( _insaneMode )
      _overallAngle += 30.0 * gDiffTimeSec
    End If
    '_overallAngle += 2.0
    'getDeviation()
    'Print getDeviation()
    PushMatrix()
      Translate( IMGX/2.0, gMaxY/2.0 )
      Rotate( _overallAngle )
      _mat = GetMatrix()
      SetColor( 255, 0, 0 )
      DrawThickLine( _x1, _y1, _x2, _y2, 4.0 )
      DrawThickLine( _x1, _y1, _x3, _y3, 4.0 )
      DrawThickLine( _x2, _y2, _x3, _y3, 4.0 )
      SetColor( 0, 0, 255 )
      DrawArcOutline( _pX+_offsetX, _pY+_offsetY, 60.0, 60.0, 0.0, 360.0, 64, 2.0 )
      DrawThickLine( _pX+_offsetX, _pY+_offsetY, _pX, _pY, 2.0 )
      DrawArcOutline( _pX, _pY, 10.0, 10.0, 0.0, 360.0, 64, 2.0 )
      If( _showSolution )
        SetColor( 0, 0, 0 )
        DrawArcOutline( _middleX, _middleY, 10.0, 10.0, 0.0, 360.0, 64, 4.0 )
        SetColor( 0, 255, 0 )
        DrawArcOutline( _middleX, _middleY, 10.0, 10.0, 0.0, 360.0, 64, 2.0 )
      End If
    PopMatrix()
    SetColor( 255, 255, 255 )
  End Method
End Class