Strict

Import mojo

Import constants
Import globals
Import language
Import utils

Class MenuCredits Implements ButtonCallback
Private

Public
  Method New()
  End Method
  
  Method buttonCallBack:Void( buttonName:String )
    gParentState = gGameState
    gRequestedState = GAME_STATE_MENU_MAIN
    gStateChangeTime = 0
  End Method

  Method update:Void()
  End Method
  
  Method draw:Void( drawAlwaysBackground:Bool = False )
    If( drawAlwaysBackground ) Then SetAlpha( 1.0 )
    DrawImage( gRM.get( GFX_BACKGROUND ), IMGX / 2.0, gMaxY / 2.0 )
    DrawImage( gRM.get( GFX_TITLE ), 0, 0 )
    SetAlpha( gAlpha )
    gFontMain.DrawText( "CREDITS", IMGX/2.0, 80, eDrawAlign.CENTER )

    gFontMedium.DrawText( "Developed and published by", IMGX/2.0, 130, eDrawAlign.CENTER )
    gFontMain.DrawText( "KRAUT APPS", IMGX/2.0, 160, eDrawAlign.CENTER )
    gFontMedium.DrawText( "Susann Oehring~nMartin Leidel", IMGX/2.0, 220, eDrawAlign.CENTER )
    gFontMedium.DrawText( "Original idea by Matthias Wandel~nhttp://woodgears.ca/eyeball/", IMGX/2.0, 310, eDrawAlign.CENTER )
    gFontMedium.DrawText( "We use, love and recommend the~nfollowing tools:", IMGX/2.0, 400, eDrawAlign.CENTER )
    gFontMedium.DrawText( "Inkscape and Gimp for graphics", IMGX/2.0, 480, eDrawAlign.CENTER )
    gFontMedium.DrawText( "Monkey X and Jungle IDE for programming", IMGX/2.0, 510, eDrawAlign.CENTER )
    gFontSmall.DrawText( "v.1.1.0 #14", IMGX-8, gMaxY-BOTTOM_SPACE_FOR_BANNER-30, eDrawAlign.RIGHT )
    DrawImage( gRM.get( GFX_MONKEY ), IMGX/2.0, 600 )
    gMenuCreditsGUI.update()
    gMenuCreditsGUI.paint()
  End Method
End Class