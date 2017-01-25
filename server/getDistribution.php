<?PHP
  $db = new mysqli( "localhost", "DB-USER", "DB-PASSWORD", "DB-NAME" )
    or die( "No connection: " . mysqli_error() );

  $gt = $_GET['gt'];
  $str = "";
  if( is_numeric( $gt ) )
  {
    for( $i = 0; $i < 25; $i++ )
    {
      $query = "";
      $v1 = $i * 100;
      $v2 = $v1 + 100;
      if( $gt == "1" )
        $query = "SELECT COUNT(*) FROM listnormal WHERE points>='$v1' AND points<'$v2' ORDER BY `id` DESC LIMIT 10000";
      else
        $query = "SELECT COUNT(*) FROM listinsane WHERE points>='$v1' AND points<'$v2' ORDER BY `id` DESC LIMIT 10000";
      
      $rs = $db->query( $query );
      $count = mysqli_fetch_array($rs);
      
      $str .= $count[0];
      $str .= ",";
      @mysqli_free_result($rs);
    }
    $str .= "0";
  }
  printf( $str );
?>