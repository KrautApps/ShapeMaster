<?PHP
  ini_set("session.use_cookies", 0);
  ini_set("session.use_only_cookies", 0);
  ini_set("session.use_trans_sid", 1);
  ini_set("session.cache_limiter", "");
  session_start();
  $_SESSION = array();

  function make_seed()
  {
    list( $usec, $sec ) = explode( ' ', microtime() );
    return (float)$sec + ( (float)$usec * 100000 );
  }
  
  mt_srand( make_seed() );
  $rndValue = mt_rand( 1, 2000000000 );
  $_SESSION['rnd'] = $rndValue;
  printf( "%d,%s,%s", $rndValue, session_name(), session_id() );
?>