Strict

Const SYSTEM_ANDROID:Int = 1
Const SYSTEM_IOS:Int = 2
Const SYSTEM_WP8:Int = 3
Const SYSTEM_WEB:Int = 4
Const SYSTEM_DESKTOP:Int = 5
Const SYSTEM_AMAZON:Int = 6
Const SYSTEM_NOOK:Int = 7

Const MAX_NUMBER:Int = 1000000000

#If TARGET="android"
  Const SYSTEM:Int = SYSTEM_ANDROID
  'Const SYSTEM:Int = SYSTEM_AMAZON
  'Const SYSTEM:Int = SYSTEM_NOOK
#Else If TARGET="ios"
  Const SYSTEM:Int = SYSTEM_IOS
#Else If TARGET="winrt"
  Const SYSTEM:Int = SYSTEM_WP8
#Else If TARGET="html5"
  Const SYSTEM:Int = SYSTEM_WEB
#Else If TARGET="glfw"
  Const SYSTEM:Int = SYSTEM_DESKTOP
#Else
  Const SYSTEM:Int = SYSTEM_WEB
#End If

Const NETWORK_TIMEOUT:Int = 10100

#If TARGET="html5" Or TARGET="glfw"
  Const BOTTOM_SPACE_FOR_BANNER:Int = 0
#Else
  Const BOTTOM_SPACE_FOR_BANNER:Int = 90
#End If

Const DEBUG:Bool = True
Const FULL_VERSION:Bool = False

Const IMGX:Float = 576.0
Const IMGY:Float = 1024.0

Const GAME_STATE_INTRO:Int = 1
Const GAME_STATE_MENU_MAIN:Int = 2
Const GAME_STATE_MENU_CREDITS:Int = 3
Const GAME_STATE_MENU_STATISTICS:Int = 4
Const GAME_STATE_GAME:Int = 5

Const GAME_STATE_GAME_RUNNING:Int = 1
Const GAME_STATE_GAME_CREATE_REPORT:Int = 2
Const GAME_STATE_GAME_CREATE_REPORT_WAIT:Int = 3
Const GAME_STATE_GAME_DISPLAY_REPORT:Int = 4
Const GAME_STATE_GAME_REPORT_GET_RANDOM:Int = 5
Const GAME_STATE_GAME_REPORT_GET_RANDOM_WAIT:Int = 6
Const GAME_STATE_GAME_REPORT_GET_RANDOM_RETRY:Int = 7
Const GAME_STATE_GAME_REPORT_SUBMIT_SCORE:Int = 8
Const GAME_STATE_GAME_REPORT_SUBMIT_SCORE_WAIT:Int = 9
Const GAME_STATE_GAME_REPORT_SUBMIT_SCORE_RETRY:Int = 10
Const GAME_STATE_GAME_REPORT_SUBMIT_SCORE_FINISHED:Int = 11
Const GAME_STATE_GAME_REPORT_SUBMIT_SCORE_FINISHED_IDLE:Int = 12
Const GAME_STATE_GAME_REPORT_NETWORK_ERROR:Int = 13
Const GAME_STATE_STATISTICS_CREATE:Int = 14
Const GAME_STATE_STATISTICS_WAIT:Int = 15
Const GAME_STATE_STATISTICS_DISPLAY:Int = 16

Const FADE_TIME:Int = 250

Const DOMAIN:String = "http://shapemaster.krautapps.com/"'"10.255.255.1"'

Const GFX_MONKEY:String               = "gfx/monkey.png"
Const GFX_BACKGROUND:String           = "gfx/background.png"
Const GFX_TITLE:String                = "gfx/title.png"
Const GFX_STATUSBAR:String            = "gfx/statusbar.png"
Const GFX_BUTTON_NORMAL:String        = "gfx/button_menu_normal.png"
Const GFX_BUTTON_NORMAL_P:String      = "gfx/button_menu_normal_p.png"
Const GFX_BUTTON_INSANE:String        = "gfx/button_menu_insane.png"
Const GFX_BUTTON_INSANE_P:String      = "gfx/button_menu_insane_p.png"
Const GFX_BUTTON_STATISTICS:String    = "gfx/button_menu_statistics.png"
Const GFX_BUTTON_STATISTICS_P:String  = "gfx/button_menu_statistics_p.png"
Const GFX_BUTTON_CREDITS:String       = "gfx/button_menu_credits.png"
Const GFX_BUTTON_CREDITS_P:String     = "gfx/button_menu_credits_p.png"
Const GFX_BUTTON_SUPPORT:String       = "gfx/button_support_us.png"
Const GFX_BUTTON_SUPPORT_P:String     = "gfx/button_support_us_p.png"
Const GFX_BUTTON_BACK:String          = "gfx/button_menu_back.png"
Const GFX_BUTTON_BACK_P:String        = "gfx/button_menu_back_p.png"
Const GFX_BUTTON_NEXT:String          = "gfx/button_next.png"
Const GFX_BUTTON_NEXT_P:String        = "gfx/button_next_p.png"
Const GFX_BUTTON_SUBMIT:String        = "gfx/button_submit.png"
Const GFX_BUTTON_SUBMIT_P:String      = "gfx/button_submit_p.png"
Const GFX_NAME_FIELD:String           = "gfx/name_field.png"
Const GFX_SCORES_DISTRIBUTION:String  = "gfx/scores_distribution.png"
Const GFX_WAIT_ANIMATION:String       = "gfx/wait_animation.png"
Const GFX_HR:String                   = "gfx/hr.png"
Const GFX_TAB_NORMAL:String           = "gfx/tab_normal.png"
Const GFX_TAB_NORMAL_ON:String        = "gfx/tab_normal_on.png"
Const GFX_TAB_INSANE:String           = "gfx/tab_insane.png"
Const GFX_TAB_INSANE_ON:String        = "gfx/tab_insane_on.png"
Const GFX_SUBTAB_SELECTED:String      = "gfx/subtab_selected.png"
Const GFX_SUBTAB_UNSELECTED:String    = "gfx/subtab_unselected.png"

'Sprach Enums
Const LANG_GAME_HEADING:Int = 1
Const LANG_GAME_BUTTON_ATTACK:Int = 2
