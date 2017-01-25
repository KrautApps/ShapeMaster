Strict

Import constants
Import globals
Import utils

Class NetworkError
Private

Public
  Method New()
  End Method

  Method draw:Void()
    gFontMain.DrawText( "Can't connect to server!", IMGX/2.0, gMaxY/2.0, eDrawAlign.CENTER )
    gGameNetworkErrorGUI.update()
    gGameNetworkErrorGUI.paint()
  End Method
End Class