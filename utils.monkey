Strict

Import globals

Class Vector2
  Field x:Float
  Field y:Float
  
  Method New( xv:Float, yv:Float )
    x = xv
    y = yv
  End Method

  Method New( vec:Vector2 )
    x = vec.x
    y = vec.y
  End Method
End Class

Class Utils
  Function CheckForResolution:Void()
    'Seitenverhaeltnis bestimmen
    gResX = Float( DeviceWidth() )
    gResY = Float( DeviceHeight() )
    gAspectRatio = gResX / gResY
    gScaleRatio = gResX / IMGX
    gMaxY = gResY / gScaleRatio
  End Function
  
  Function UpdateFPS:Void()
    gLoopTimeAll = gLoopTimeEnd - gLoopTimeStart
    gRenderTimeAll = gRenderTimeAll + gLoopTimeAll
    gDiffTimeMS = Millisecs() - gTimeMSOld
    gDiffTimeSec = gDiffTimeMS / 1000.0
    gTimeMSOld = Millisecs()
    
    gFPSCounter = gFPSCounter + 1
    If( ( gLoopTimeStart - gFPSLastUpdate ) > 500 )
      gRenderTime = Float( gRenderTimeAll ) / Float( gFPSCounter )
      If( gRenderTime < 1.0 ) Then gRenderTime = 1.0
      gRenderTimeAll = 0
      gFPSLastUpdate = gLoopTimeStart
      gFPS = 1000.0 / gRenderTime
      gFPSCounter = 0
    End If
  End Function
End Class
  
Class ArrayUtil<T>
  Function CreateArray:T[][]( rows:Int, cols:Int )
    Local a:T[][] = New T[rows][]
    For Local i:Int = 0 Until rows
      a[i] = New T[cols]
    End
    
    Return a
  End Function

  Function FillArray:Void( arr:T[][], xSize:Int, ySize:Int, val:T )
    For Local x:Int = 0 Until xSize
      For Local y:Int = 0 Until ySize
        arr[x][y] = val
      Next
    Next
  End Function
End Class

Function GetDist:Float( x1:Float, y1:Float, x2:Float, y2:Float )
  Return Sqrt( ( x1 - x2 ) * ( x1 - x2 ) + ( y1 - y2 ) * ( y1 - y2 ) )
End Function

Function Round:String( value:Float, decimalPlaces:Int = 1 )
  Local val:Int = Int( value * Pow( 10, decimalPlaces ) + 0.5 * Sgn( value ) )
  Local str:String = String( val )
  Local len:Int = str.Length()
  Local output:String = str[0 .. len - decimalPlaces] + "." + str[len - decimalPlaces ..]
  If( val < Pow( 10, decimalPlaces ) )
    output = "0" + output
  End If
  Return output
End Function

Function IntToString:String( value:Int )
  Local v:String
  Local wasNegative:Bool = False
  If( value < 0 )
    wasNegative = True
    value = Abs( value )
  End If
  If( value < 10 )
    v = "0,0" + String( value )
  Else If( value < 100 )
    v = "0," + String( value )
  Else
    Local l:Int = value / 100
    Local ls:String = String( l )
    Local r:Int = value-l*100
    Local rs:String = String( r )
    v = ls + ","
    If( r < 10 ) Then v += "0"
    v += rs
  End If
  If( wasNegative ) Then v = "-" + v
  Return v
End Function

Function FormatInt:String( value:Int )
  Local v:String = String( value )
  If( value < 1000 ) Then Return v
  If( value < 1000000 )
    Local t:Int = value / 1000
    Local s:String = String( value - t * 1000 )
    If( s.Length() = 1 )
      s = "00" + s
    Else If( s.Length() = 2 )
      s = "0" + s
    End If
    v = String( t ) + "," + s
  Else
    Local m:Int = value / 1000000
    Local t:Int = ( value - m * 1000000 ) / 1000
    Local ts:String = String( t )
    Local s:String = String( value - m * 1000000 - t * 1000 )
    If( ts.Length() = 1 )
      ts = "00" + ts
    Else If( ts.Length() = 2 )
      ts = "0" + ts
    End If
    If( s.Length() = 1 )
      s = "00" + s
    Else If( s.Length() = 2 )
      s = "0" + s
    End If
    v = String( m ) + "," + ts + "," + s
  End If
  Return v
End Function

Function CheckFileConsistency:Void()
  Local stats:String = LoadState()
  'Gibt es noch keine Stats?
  If( stats.Length() = 0 )
    SaveStatistics()
    Return
'  Else
'    Local values:String[] = stats.Split( "," )
'    If( values.Length() < 42 )
'      'Oh oh...
'      'Alles auf Null!
'      gSoundEnabled = True
'      SaveStatistics()
'      Return
'    End If
  End If
End Function

Function LoadStatistics:Void()
  CheckFileConsistency()
  Local stats:String = LoadState()
  Local values:String[] = stats.Split( "," )
  If( values.Length() = 5 )
    gPlayerName = values[0]
    gBestScoreInNormal = Int( values[1] )
    gBestScoreInInsane = Int( values[2] )
    gBestTimeInNormal = Int( values[3] )
    gBestTimeInInsane = Int( values[4] )
  Else
    SaveStatistics()
  End If
End Function

Function SaveStatistics:Void()
  Local stats:String
  stats += gPlayerName + ","
  stats += gBestScoreInNormal + ","
  stats += gBestScoreInInsane + ","
  stats += gBestTimeInNormal + ","
  stats += gBestTimeInInsane
  'Print stats
  SaveState( stats )
End Function

Function DrawRectOutline:Void(x:Float, y:Float, w:Float, h:Float, thickness:Float = 1.0)
  If thickness = 1.0
    DrawLine x, y, x + w, y
    DrawLine x, y, x, y + h
    DrawLine x + w, y, x + w, y + h
    DrawLine x, y + h, x + w, y + h
  Else
    DrawThickLine( x, y, x + w, y, thickness, True )
    DrawThickLine( x, y, x, y + h, thickness, True )
    DrawThickLine( x + w, y, x + w, y + h, thickness, True )
    DrawThickLine( x, y + h, x + w, y + h, thickness, True )
  Endif
End Function

'/ Draws An Arc Outline. Can be used to draw circle outline as well
Function DrawArcOutline:Void(x:Float, y:Float, xRad:Float, yRad:Float, aStart:Float = 0.0, aEnd:Float = 360.0, segments:Int = 8, thickness:Float = 1.0)
  Local x1 : Float = x + ( Sin( aStart ) * xRad )
  Local y1 : Float = y + ( Cos( aStart ) * yRad )
  Local x2 : Float
  Local y2 : Float
  Local div : Float  = ( aEnd - aStart ) / segments
  For Local i : Int = 1 To segments
    x2 = x + ( Sin( aStart + ( i * div )) * xRad )
    y2 = y + ( Cos( aStart + ( i * div )) * yRad )
    If thickness = 1.0
      DrawLine x1, y1, x2, y2
    Else
      DrawThickLine( x1, y1, x2, y2, thickness, True )
    Endif
    x1 = x2
    y1 = y2
  Next
End Function

'/ Draws a Donut, can also be used to draw Donut Segment
Function DrawDonut:Void(x:Float, y:Float, aRad:Float, bRad:Float, aStart:Float = 0.0, aEnd:Float = 360.0, segments:Int = 8)
  Local points : Float[ 8 ]
  points[ 0 ] = x + Float( Sin( aStart ) * aRad )
  points[ 1 ] = y + Float( Cos( aStart ) * aRad )
  points[ 2 ] = x + Float( Sin( aStart ) * bRad )
  points[ 3 ] = y + Float( Cos( aStart ) * bRad )
  Local div : Float  = ( aEnd - aStart ) / segments
  For Local i : Int = 1 To segments
    points[ 4 ] = x + Float( Sin( aStart + ( i * div )) * bRad )
    points[ 5 ] = y + Float( Cos( aStart + ( i * div )) * bRad )
    points[ 6 ] = x + Float( Sin( aStart + ( i * div )) * aRad )
    points[ 7 ] = y + Float( Cos( aStart + ( i * div )) * aRad )
    DrawPoly( points )
    DrawLine points[ 4 ], points[ 5 ], points[ 6 ], points[ 7 ]
    points[ 0 ] = points[ 6 ]
    points[ 1 ] = points[ 7 ]
    points[ 2 ] = points[ 4 ]
    points[ 3 ] = points[ 5 ]
  Next
End Function

'/ Draws a circle with sides or pie segment
Function DrawPie:Void(x:Float, y:Float, xRadius:Float, yRadius:Float, aStart:Float = 0.0, aEnd:Float = 360.0, segments:Int = 8)
  Local points : Float[( segments * 2 ) + 4 ]
  points[ 0 ] = x
  points[ 1 ] = y
  points[ 2 ] = x + Sin( aStart ) * xRadius
  points[ 3 ] = y - Cos( aStart ) * yRadius
  Local div : Float  = ( aEnd - aStart ) / segments
  For Local i : Int = 1 To segments
    points[( i + 1 ) * 2 ] = x + Sin( aStart + ( i * div )) * xRadius
    points[(( i + 1 ) * 2 ) + 1 ] = y - Cos( aStart + ( i * div )) * yRadius
  Next
  DrawPoly( points )
End Function

'/ Draws outline of pie
Function DrawPieOutline:Void(x:Float, y:Float, xRad:Float, yRad:Float, aStart:Float = 0.0, aEnd:Float = 360.0, segments:Int = 8, thickness:Float = 1.0)
  Local x1 : Float = x + ( Sin( aStart ) * xRad )
  Local y1 : Float = y + ( Cos( aStart ) * yRad )
  Local x2 : Float
  Local y2 : Float
  If thickness = 1.0
    DrawLine x, y, x1, y1
  Else
    DrawThickLine( x, y, x1, y1, thickness, True )
  Endif
  Local div : Float  = ( aEnd - aStart ) / segments
  For Local i : Int = 1 To segments
    x2 = x + ( Sin( aStart + ( i * div )) * xRad )
    y2 = y + ( Cos( aStart + ( i * div )) * yRad )
    If thickness = 1.0
      DrawLine x1, y1, x2, y2
    Else
      DrawThickLine( x1, y1, x2, y2, thickness, True )
    Endif
    x1 = x2
    y1 = y2
  Next
  If thickness = 1.0
    DrawLine x, y, x2, y2
  Else
    DrawThickLine( x, y, x2, y2, thickness, True )
  Endif
End Function

'/ Draws Star
Function DrawStarOutline:Void(x:Float, y:Float, aRadius:Float, bRadius:Float, segments:Int = 5, thickness:Float = 1.0)

  Local div : Float  = 360 / segments

  Local x1 : Float = x + Sin( 0.0 ) * aRadius
  Local y1 : Float = y + Cos( 0.0 ) * aRadius
  Local x2 : Float
  Local y2 : Float

  For Local i : Int = 1 To segments
		
    x2 = x + Sin( i * div ) * aRadius
    y2 = y + Cos( i * div ) * aRadius
		
    Local mid_a : Float = (( i * div ) + (( i - 1 ) * div )) / 2.0
    Local mx : Float = x + Sin( mid_a ) * bRadius
    Local my : Float = y + Cos( mid_a ) * bRadius

    If thickness = 1.0
      DrawLine x1, y1, mx, my
      DrawLine x2, y2, mx, my
    Else
      DrawThickLine( x1, y1, mx, my, thickness, True )
      DrawThickLine( x2, y2, mx, my, thickness, True )
    Endif
		
    x1 = x2
    y1 = y2

  Next


End Function

'/ Draws Star
Function DrawStar:Void(x:Float, y:Float, aRadius:Float, bRadius:Float, segments:Int = 5)
  Local div : Float  = 360 / segments
  Local points : Float[ 8 ]
  points[ 0 ] = x
  points[ 1 ] = y
  points[ 2 ] = x + Sin( 0.0 ) * aRadius
  points[ 3 ] = y + Cos( 0.0 ) * aRadius
  Local mid : Float = div / 2.0
  For Local i : Int = 1 To segments
    points[ 4 ] = x + Sin( mid ) * bRadius
    points[ 5 ] = y + Cos( mid ) * bRadius
    points[ 6 ] = x + Sin( i * div ) * aRadius
    points[ 7 ] = y + Cos( i * div ) * aRadius
    DrawPoly( points )
    DrawLine x, y, points[ 2 ], points[ 3 ]
    points[ 2 ] = points[ 6 ]
    points[ 3 ] = points[ 7 ]
    mid = mid + div
  Next
End Function

'/ Draws thick line, rounded ends optional
Function DrawThickLine:Void(x1:Float, y1:Float, x2:Float, y2:Float, thickness:Float = 2.0, rounded:Bool = False)
  Local dx : Float = x2 - x1
  Local dy : Float = y2 - y1
  Local d : Float = Sqrt( dx * dx + dy * dy )
  Local vx : Float = dx / d
  Local vy : Float = dy / d
  Local nx : Float = vy
  Local ny : Float = -vx
  Local points : Float[ 8 ]
  points[ 0 ] = x1 + ( nx * ( thickness / 2.0 ))
  points[ 1 ] = y1 + ( ny * ( thickness / 2.0 ))
  points[ 2 ] = x1 + ( -nx * ( thickness / 2.0 ))
  points[ 3 ] = y1 + ( -ny * ( thickness / 2.0 ))
  points[ 4 ] = x2 + ( -nx * ( thickness / 2.0 ))
  points[ 5 ] = y2 + ( -ny * ( thickness / 2.0 ))
  points[ 6 ] = x2 + ( nx * ( thickness / 2.0 ))
  points[ 7 ] = y2 + ( ny * ( thickness / 2.0 ))
  DrawPoly( points )
  If rounded = True
    DrawEllipse x1, y1, thickness / 2.0, thickness / 2.0
    DrawEllipse x2, y2, thickness / 2.0, thickness / 2.0
  Endif
End Function

'/ Draws thick line, rounded ends optional
Function DrawThickLine2:Void(x1:Float, y1:Float, x2:Float, y2:Float, thickness:Float = 2.0, rounded:Bool = False)
  Local da : Float = 90 - ATan2( y2 - y1, x2 - x1 )
  Local points : Float[ 8 ]
  points[ 0 ] = x1 + ( Sin( da - 90 ) * ( thickness / 2.0 ))
  points[ 1 ] = y1 + ( Cos( da - 90 ) * ( thickness / 2.0 ))
  points[ 2 ] = x1 + ( Sin( da + 90 ) * ( thickness / 2.0 ))
  points[ 3 ] = y1 + ( Cos( da + 90 ) * ( thickness / 2.0 ))
  points[ 4 ] = x2 + ( Sin( da + 90 ) * ( thickness / 2.0 ))
  points[ 5 ] = y2 + ( Cos( da + 90 ) * ( thickness / 2.0 ))
  points[ 6 ] = x2 + ( Sin( da - 90 ) * ( thickness / 2.0 ))
  points[ 7 ] = y2 + ( Cos( da - 90 ) * ( thickness / 2.0 ))
  DrawPoly( points )
  If rounded = True
    DrawEllipse x1, y1, thickness / 2.0, thickness / 2.0
    DrawEllipse x2, y2, thickness / 2.0, thickness / 2.0
  Endif
End Function