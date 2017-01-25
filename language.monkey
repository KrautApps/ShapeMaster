Strict

Import constants
Import globals
Import words

Function InitLanguages:Void()
  gLanguage.Clear()
  If( LANGUAGE = "de" )
    gLanguage.Set( LANG_GAME_HEADING, "Galaxy Raids" )
    gLanguage.Set( LANG_GAME_BUTTON_ATTACK, "ANGRIFF" )

  Else
    gLanguage.Set( LANG_GAME_HEADING, "Galaxy Raids" )
    gLanguage.Set( LANG_GAME_BUTTON_ATTACK, "ATTACK" )
  End If
End Function