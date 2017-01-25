Strict

Import mojo

Class ResourceManager
Private
  Field _imageIds:List<ResourceManagerImage>  'For initial load
  Field _soundIds:List<String>                'For initial load
  Field _images:StringMap<Image>
  Field _sounds:StringMap<Sound>
  
Public
  Method New()
    _imageIds = New List<ResourceManagerImage>()
    _soundIds = New List<String>()
    _images = New StringMap<Image>()
    _sounds = New StringMap<Sound>()
  End Method
  
  Method addImage:Void( path:String, frameCount:Int = 1, flags:Int = Image.MidHandle, frameWidth:Int = -1, frameHeight:Int = -1 )
    Local resId:ResourceManagerImage = New ResourceManagerImage( path, frameCount, flags, frameWidth, frameHeight )
    _imageIds.AddLast( resId )
  End Method
  
  Method addSound:Void( path:String )
    _soundIds.AddLast( path )
  End Method
  
  Method loadAll:Void()
    'Images
    For Local imgId:ResourceManagerImage = EachIn _imageIds
      If( imgId._frameWidth < 0 )
        _images.Add( imgId._path, LoadImage( imgId._path, imgId._frameCount, imgId._flags ) )
      Else
        _images.Add( imgId._path, LoadImage( imgId._path, imgId._frameWidth, imgId._frameHeight, imgId._frameCount, imgId._flags ) )
      End If
    Next
    'Sounds
    For Local sfxId:String = EachIn _soundIds
      _sounds.Add( sfxId, LoadSound( sfxId ) )
    Next
  End Method
  
  Method get:Image( resId:String )
    Local img:Image = _images.Get( resId )
    If( img ) Then Return img
    
    'image not found or it was removed by the OS due to memory issues, reload it!
    Local id:ResourceManagerImage = Null
    For Local imgId:ResourceManagerImage = EachIn _imageIds
      If( imgId._path = resId )
        id = imgId
        Exit
      End If
    Next
    
    If( id )
      If( id._frameWidth < 0 )
        _images.Add( id._path, LoadImage( id._path, id._frameCount, id._flags ) )
      Else
        _images.Add( id._path, LoadImage( id._path, id._frameWidth, id._frameHeight, id._frameCount, id._flags ) )
      End If
      Return _images.Get( resId )
    Else
      Error "Can't find image " + resId
    End If
    Return Null
  End Method
End Class

Class ResourceManagerImage
  Field _path:String
  Field _frameWidth:Int
  Field _frameHeight:Int
  Field _frameCount:Int
  Field _flags:Int
  
  Method New( path:String, frameCount:Int, flags:Int, frameWidth:Int = -1, frameHeight:Int = -1 )
    _path = path
    _frameWidth = frameWidth
    _frameHeight = frameHeight
    _frameCount = frameCount
    _flags = flags
  End Method
End Class
