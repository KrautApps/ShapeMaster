Strict

Import mojo
Import brl.httprequest
Import constants
Import globals

Interface NetworkCallback
  Method onHttpRequestComplete:Void( req:HttpRequest )
End Interface

Class Network Implements IOnHttpRequestComplete
Private
  Field _callback:NetworkCallback
  Field _request:HttpRequest
  Field _requestStarted:Bool
  Field _requestWatchDogStartTime:Int
  Field _wasTimedOut:Bool

Public
  Method New( callback:NetworkCallback )
    _callback = callback
    _request = New HttpRequest()
    _requestStarted = False
    _requestWatchDogStartTime = 0
    _wasTimedOut = False
  End Method

  Method OnHttpRequestComplete:Void( req:HttpRequest )
    _requestStarted = False
    _wasTimedOut = False
    _callback.onHttpRequestComplete( req )
  End Method
  
  Method hashMe:Int( rndValue:Int )
    Local v:Int = rndValue
    v = ( v Shl 15 ) - v - 1
    v = v ~ ( v Shr 12 )
    v = v + ( v Shl 2 )
    v = v ~ ( v Shr 4 )
    v = v * 1017
    v = v ~ ( v Shr 14 )
    Return v
  End Method
  
  Method update:Void()
    If( Not _requestStarted ) Then Return
    Local dt:Int = Millisecs() - _requestWatchDogStartTime
    If( dt < NETWORK_TIMEOUT ) Then Return
    _wasTimedOut = True
    _requestStarted = False
  End Method
  
  Method isReady:Bool()
    Return Not _requestStarted
  End Method
  
  Method wasTimedOut:Bool()
    Return _wasTimedOut
  End Method
  
  Method send:Bool( str:String )
    If( _requestStarted ) Then Return False
    _requestStarted = True
    _wasTimedOut = False
    _requestWatchDogStartTime = Millisecs()
    '_request = New HttpRequest( "GET", "http://posttestserver.com", Self )'DOMAIN + str, Self )
    _request = New HttpRequest( "GET", DOMAIN + str, Self )
    '    _request.Open( "GET", DOMAIN + str, Self )
'    Print DOMAIN + str
    #If TARGET = "android"
      Local success:Bool = False
      If( _request.Status() = 1 )
        _request.Send()
        success = True
      End If
      Return success
    #Else
      _request.Send()
      Return True
    #End If
  End Method
End Class
