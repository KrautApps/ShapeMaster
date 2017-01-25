Strict

Import mojo

Class Timer
Private
  Field _sumTime:Int
  Field _lastTime:Int
  Field _isPaused:Bool

Public
  Method New()
    _sumTime = 0
    _lastTime = Millisecs()
    _isPaused = False
  End Method
  
  Method update:Void()
    Local deltaTime:Int = Millisecs() - _lastTime
    _lastTime = Millisecs()
    If( Not _isPaused )
      _sumTime += deltaTime
    End If
  End Method
  
  Method start:Void()
    _sumTime = 0
    _isPaused = False
    _lastTime = Millisecs()
  End Method
  
  Method stop:Void()
    _isPaused = True
  End Method
  
  Method pause:Void()
    _isPaused = True
  End Method
  
  Method cont:Void()
    _isPaused = False
  End Method
  
  Method getTime:Int()
    Return _sumTime
  End Method
End Class
