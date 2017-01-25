Strict

Import fontmachine
Import mojo
Import framework.xgui

Import constants
Import controls
Import eyeballing
Import game
Import menuCredits
Import menuMain
Import menuStatistics
Import network
Import resourcemanager
Import timer

Global gResX:Float
Global gResY:Float
Global gMaxY:Float
Global gAspectRatio:Float = 1.67
Global gScaleRatio:Float = 1.0

Global gMain:Eyeballing
Global gShowInterstitial:Bool = False

Global gTimer:Timer
Global gNetwork:Network
Global gNetworkStats:Network

Global gControls:Controls
Global gRM:ResourceManager

Global gGameGUI:XGui
Global gGameReportGUI:XGui
Global gGameNetworkErrorGUI:XGui
Global gMenuMainGUI:XGui
Global gMenuCreditsGUI:XGui
Global gMenuStatisticsGUI:XGui
Global gAlpha:Float = 1.0

Global gFirstCall:Bool = True
Global gLoopTimeAll:Int
Global gLoopTimeStart:Int
Global gLoopTimeEnd:Int
Global gFPSCounter:Int
Global gFPSLastUpdate:Int
Global gRenderTime:Float
Global gRenderTimeAll:Int
Global gFPS:Float
Global gTimeMSOld:Float
Global gDiffTimeMS:Float
Global gDiffTimeSec:Float

Global gGameState:Int = GAME_STATE_INTRO
Global gRequestedState:Int = GAME_STATE_INTRO
Global gParentState:Int = GAME_STATE_INTRO
Global gStateChangeTime:Int = 1

Global gIsLoadingInitialized:Bool = False
Global gGameStartTime:Int = 0
Global gLoadScreenStartTime:Int
Global gLanguages:IntMap< String >
Global gSplashScreen:Image = Null
Global gFontMain:BitmapFont
Global gFontMedium:BitmapFont
Global gFontSmall:BitmapFont
Global gFontSmallR:BitmapFont
Global gGame:Game
Global gMenuMain:MenuMain
Global gMenuCredits:MenuCredits
Global gMenuStatistics:MenuStatistics

Global gSoundEnabled:Bool = True
Global gButtonSoundPlayed:Bool = False

Global gCurrentZoom:Float = 1.0
Global gMapOffsetX:Float = 0.0
Global gMapOffsetY:Float = 0.0

Global gPlayerName:String
Global gCurrentScoreInNormal:Int
Global gCurrentScoreInInsane:Int
Global gCurrentTimeInNormal:Int
Global gCurrentTimeInInsane:Int
Global gBestScoreInNormal:Int = MAX_NUMBER
Global gBestScoreInInsane:Int = MAX_NUMBER
Global gBestTimeInNormal:Int
Global gBestTimeInInsane:Int
