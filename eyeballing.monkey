'**********************************************************
' Eyeballing
' 2015 Martin Leidel
'**********************************************************

Strict

#FULL_VERSION = False

Import mojo
#If Not FULL_VERSION And ( TARGET = "ios" Or TARGET = "android" )
  Import brl.admob
  Import admobinterstitial
#End If
Import framework.xgui
Import controls
Import globals
Import init
Import loadScreen
Import menuCredits
Import menuFader
Import menuMain
Import menuStatistics
Import utils

Const VERSION:String = ""'"v.1.0.0 #12 - 27-July-2015"

Function Main:Int()
  gMain = New Eyeballing()
  Return 0
End Function

Class Eyeballing Extends App
  #If Not FULL_VERSION And ( TARGET = "ios" Or TARGET = "android" )
    Field _admob:Admob
    Field _admobInterstitial:AdmobInterstitial
    Field _layout:Int = 5 'Bottom
    Field _enabled:Bool = True
  #End If

  Method OnCreate:Int()
    gIsLoadingInitialized = False
    Utils.CheckForResolution()
    InitLoadScreen()
    LoadStatistics()
    SetUpdateRate(30)
    #If Not FULL_VERSION And ( TARGET = "ios" Or TARGET = "android" )
      _admob = Admob.GetAdmob()
      _admob.ShowAdView( 2, _layout )
      #If TARGET = "android"
        'Android
        _admobInterstitial = AdmobInterstitial.GetAdmobInterstitial("ca-app-pub-6903717755255530/3085936805")
        'Amazon
        '_admobInterstitial = AdmobInterstitial.GetAdmobInterstitial("ca-app-pub-6903717755255530/2146293609")
      #Else
        _admobInterstitial = AdmobInterstitial.GetAdmobInterstitial("ca-app-pub-6903717755255530/8593440009")
      #End If
    #End If
    gShowInterstitial = True
    Return 0
  End Method

  Method OnUpdate:Int()
    #If Not FULL_VERSION And ( TARGET = "ios" Or TARGET = "android" )
      If( gShowInterstitial )
        _admobInterstitial.ShowAd()
        gShowInterstitial = False
      End If
    #End If
    UpdateAsyncEvents()
    gControls.update()
    gTimer.update()
    If( gGameState = GAME_STATE_GAME )
      gGame.update()
    End If
    Return 0
  End Method
  
  Method OnSuspend:Int()
    SaveStatistics()
    Return 0
  End Method
  
  Method OnResume:Int()
    LoadStatistics()
    Return 0
  End Method

  Method OnRender:Int()
    gLoopTimeStart = Millisecs()
    Cls()
    'SetScissor( 0.0, 0.0, gResX, gResY )
    'SetScissor( gTranslateX, gTranslateY, Float(gResX)*gScaleRatioX, Float(gResY)*gScaleRatioY )
    PushMatrix()
      Scale( gScaleRatio, gScaleRatio )
      Select gGameState
        Case GAME_STATE_INTRO
          LoadScreen()
        Case GAME_STATE_MENU_MAIN
          If( FadeMenu() ) Then gMenuMain.draw()
        Case GAME_STATE_MENU_STATISTICS
          If( FadeMenu() ) Then gMenuStatistics.draw()
        Case GAME_STATE_MENU_CREDITS
          If( FadeMenu() ) Then gMenuCredits.draw()
        Case GAME_STATE_GAME
          If( FadeMenu() ) Then gGame.draw()
    End Select
    PopMatrix()
    gLoopTimeEnd = Millisecs()
    Utils.UpdateFPS()
    Return 0
  End Method
  
  Method OnBack:Int()
    Select gGameState
      Case GAME_STATE_MENU_MAIN
        SaveStatistics()
        EndApp()
        Return 0
      Case GAME_STATE_MENU_STATISTICS
        gParentState = gGameState
        gRequestedState = GAME_STATE_MENU_MAIN
        gStateChangeTime = 0
        Return 0
      Case GAME_STATE_MENU_CREDITS
        gParentState = gGameState
        gRequestedState = GAME_STATE_MENU_MAIN
        gStateChangeTime = 0
        Return 0
      Case GAME_STATE_GAME
        gParentState = gGameState
        gRequestedState = GAME_STATE_MENU_MAIN
        gStateChangeTime = 0
        Return 0
    End Select
    Return 0
  End Method
End Class
