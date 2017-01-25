<?PHP
  ini_set("session.use_cookies", 0);
  ini_set("session.use_only_cookies", 0);
  ini_set("session.use_trans_sid", 1);
  ini_set("session.cache_limiter", "");
  session_start();
  session_id($_GET[session_name()]);
  
  function hashMe( $rndValue )
  {
    $v = $rndValue;
    $v = ( $v << 15 ) - $v - 1;
    $v = $v ^ ( $v >> 12 );
    $v = $v + ( $v << 2 );
    $v = $v ^ ( $v >> 4 );
    $v = $v * 1017;
    $v = $v ^ ( $v >> 14 );
    return $v;
  }

  if( !isset( $_SESSION['rnd'] ) )
    die();

  $db = new mysqli( "localhost", "DB-USER", "DB-PASSWORD", "DB-NAME" )
    or die( "No connection: " . mysqli_error() );

  // Get the hash value from the client and so some fancy calculation
  $hashFromClient = $_GET['v'];
  if( hashMe( $_SESSION['rnd'] ) == $hashFromClient )
  {
    $name = $_GET['n'];
    $score = $_GET['sc'];
    $tm = $_GET['tm'];
    $sys = $_GET['sy'];
    $gt = $_GET['gt'];
    if( is_numeric( $score ) && is_numeric( $tm ) && is_numeric( $sys ) && is_numeric( $gt ) )
    {
      $query = "";
      if( $gt == "1" )
        $query = "INSERT INTO listnormal (name, points, time, system, date) VALUES (?, ?, ?, ?, now())";
      else
        $query = "INSERT INTO listinsane (name, points, time, system, date) VALUES (?, ?, ?, ?, now())";
 
      $stmt = $db->prepare( $query );
      $stmt->bind_param( 'siii', $name, $score, $tm, $sys );
      $stmt->execute();
      $stmt->close();
      $db->close();
      printf( "OK" );
    }
    else
      printf( "NAN" );
  }
  else
    printf( "HASH" );
  
  $_SESSION['rnd'] = mt_rand(); // invalidate that number
  session_destroy();
?>