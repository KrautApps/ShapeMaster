Strict

Import fontmachine
Import mojo
Import framework.xgui

Import constants
Import controls
Import eyeballing
Import globals
Import game
Import network
Import resourcemanager
Import timer
Import utils

Function InitLoadScreen:Void()
  gSplashScreen = LoadImage( "gfx/titlescreen.png", 1, Image.MidHandle )
  gFontMain = New BitmapFont( "gfx/fonts/font28.txt" )
  gFontMedium = New BitmapFont( "gfx/fonts/font20.txt" )
  gFontSmall = New BitmapFont( "gfx/fonts/font14.txt" )
  gFontSmallR = New BitmapFont( "gfx/fonts/font14red_you.txt" )
  gControls = New Controls()
  gTimer = New Timer()
  gGame = New Game()
  gMenuMain = New MenuMain()
  gMenuCredits = New MenuCredits()
  gMenuStatistics = New MenuStatistics()
  gNetwork = New Network( gGame )
  gNetworkStats = New Network( gMenuStatistics )
End Function

Function Initialize:Void()
  gRM = New ResourceManager()
  gLanguages = New IntMap< String >
  gTimeMSOld = Millisecs()

  LoadResources()
  
  Local offset:Int = 0
  Local dist:Int = 16
'  #If Not FULL_VERSION
'    offset = -48
'    dist = 8
'  #End If
  
  gGameGUI = New XGui( gGame, gScaleRatio )
  gGameGUI.addButton( "Next", gRM.get( GFX_BUTTON_NEXT ), gRM.get( GFX_BUTTON_NEXT_P ), Null, IMGX-40-8, gMaxY-BOTTOM_SPACE_FOR_BANNER-97-32-10 )
  gGameGUI.addButton( "Back", gRM.get( GFX_BUTTON_BACK ), gRM.get( GFX_BUTTON_BACK_P ), Null, 40+8, gMaxY - BOTTOM_SPACE_FOR_BANNER-97-32-10 )
  gGameReportGUI = New XGui( gGame, gScaleRatio )
  gGameReportGUI.addButton( "Submit", gRM.get( GFX_BUTTON_SUBMIT ), gRM.get( GFX_BUTTON_SUBMIT_P ), Null, IMGX-64-8, gMaxY-97-32-10 )
  gGameNetworkErrorGUI = New XGui( gGame, gScaleRatio )
  gGameNetworkErrorGUI.addButton( "Back", gRM.get( GFX_BUTTON_BACK ), gRM.get( GFX_BUTTON_BACK_P ), Null, 40+8, gMaxY-97-32-10 )
  gMenuMainGUI = New XGui( gMenuMain, gScaleRatio )
  gMenuMainGUI.addButton( "Normal", gRM.get( GFX_BUTTON_NORMAL ), gRM.get( GFX_BUTTON_NORMAL_P ), Null, IMGX/2.0, gMaxY/2.0 - 64 - 128 - dist/2 - dist + offset )
  gMenuMainGUI.addButton( "Insane", gRM.get( GFX_BUTTON_INSANE ), gRM.get( GFX_BUTTON_INSANE_P ), Null, IMGX/2.0, gMaxY/2.0 - 64 - dist/2 + offset )
  gMenuMainGUI.addButton( "Credits", gRM.get( GFX_BUTTON_CREDITS ), gRM.get( GFX_BUTTON_CREDITS_P ), Null, IMGX/2.0, gMaxY/2.0 + 64 + dist/2 + offset )
  gMenuMainGUI.addButton( "Statistics", gRM.get( GFX_BUTTON_STATISTICS ), gRM.get( GFX_BUTTON_STATISTICS_P ), Null, IMGX/2.0, gMaxY/2.0 + 64 + 128 + dist/2 + dist + offset )
'  #If Not FULL_VERSION
'    gMenuMainGUI.addButton( "Support", gRM.get( GFX_BUTTON_SUPPORT ), gRM.get( GFX_BUTTON_SUPPORT_P ), Null, IMGX/2.0, gMaxY/2.0 + 32 + 256 + dist/2 + 2*dist + offset )
'  #End If
  gMenuCreditsGUI = New XGui( gMenuCredits, gScaleRatio )
  gMenuCreditsGUI.addButton( "Back", gRM.get( GFX_BUTTON_BACK ), gRM.get( GFX_BUTTON_BACK_P ), Null, 40+8, gMaxY - BOTTOM_SPACE_FOR_BANNER - 40 - 8 )
  gMenuStatisticsGUI = New XGui( gMenuStatistics, gScaleRatio )
  gMenuStatisticsGUI.addButton( "Back", gRM.get( GFX_BUTTON_BACK ), gRM.get( GFX_BUTTON_BACK_P ), Null, 40+8, gMaxY - BOTTOM_SPACE_FOR_BANNER - 40 - 8 )
End

Function LoadResources:Void()
  gRM.addImage( GFX_MONKEY )
  gRM.addImage( GFX_BACKGROUND )
  gRM.addImage( GFX_TITLE, 1, Image.DefaultFlags )
  gRM.addImage( GFX_STATUSBAR, 1, Image.DefaultFlags )
  gRM.addImage( GFX_BUTTON_NORMAL )
  gRM.addImage( GFX_BUTTON_NORMAL_P )
  gRM.addImage( GFX_BUTTON_INSANE )
  gRM.addImage( GFX_BUTTON_INSANE_P )
  gRM.addImage( GFX_BUTTON_CREDITS )
  gRM.addImage( GFX_BUTTON_CREDITS_P )
  gRM.addImage( GFX_BUTTON_STATISTICS )
  gRM.addImage( GFX_BUTTON_STATISTICS_P )
  gRM.addImage( GFX_BUTTON_SUPPORT )
  gRM.addImage( GFX_BUTTON_SUPPORT_P )
  gRM.addImage( GFX_BUTTON_BACK )
  gRM.addImage( GFX_BUTTON_BACK_P )
  gRM.addImage( GFX_BUTTON_NEXT )
  gRM.addImage( GFX_BUTTON_NEXT_P )
  gRM.addImage( GFX_BUTTON_SUBMIT )
  gRM.addImage( GFX_BUTTON_SUBMIT_P )
  gRM.addImage( GFX_NAME_FIELD, 1, Image.DefaultFlags )
  gRM.addImage( GFX_SCORES_DISTRIBUTION, 1, Image.DefaultFlags )
  gRM.addImage( GFX_WAIT_ANIMATION, 8, Image.MidHandle, 64, 64 )
  gRM.addImage( GFX_HR )
  gRM.addImage( GFX_TAB_NORMAL, 1, Image.DefaultFlags )
  gRM.addImage( GFX_TAB_NORMAL_ON, 1, Image.DefaultFlags )
  gRM.addImage( GFX_TAB_INSANE, 1, Image.DefaultFlags )
  gRM.addImage( GFX_TAB_INSANE_ON, 1, Image.DefaultFlags )
  gRM.addImage( GFX_SUBTAB_SELECTED, 1, Image.DefaultFlags )
  gRM.addImage( GFX_SUBTAB_UNSELECTED, 1, Image.DefaultFlags )
  
  gRM.loadAll()
End Function
