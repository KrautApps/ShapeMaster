<?PHP
  $db = new mysqli( "localhost", "DB-USER", "DB-PASSWORD", "DB-NAME" )
    or die( "No connection: " . mysqli_error() );

  $gameType = $_GET['gt'];
  $currentScore = $_GET['csc'];
  $bestScore = $_GET['bsc'];
  $lastDays = $_GET['ld'];
  $playedGames = "-1";
  $rank = "-1";
  $bestRank = "-1";
  $str = "";

  if( is_numeric( $gameType ) && is_numeric( $currentScore ) && is_numeric( $bestScore ) && is_numeric( $lastDays ) )
  {
    $listName = "listnormal";
    if( $gameType <> "1" )
      $listName = "listinsane";

    $rs = $db->query( "SELECT COUNT(*) FROM $listName WHERE date >= now() - INTERVAL '$lastDays' DAY" );
    $count = mysqli_fetch_array($rs);
    $playedGames = $count[0];
    $str = $playedGames.",";
    @mysqli_free_result($rs);

    $query = "SELECT COUNT(*)+1 FROM $listName WHERE points < '$currentScore' AND date >= now() - INTERVAL '$lastDays' DAY";
    $rs = $db->query( $query );
    $count = mysqli_fetch_array($rs);
    $rank = $count[0];
    $str .= $rank.",";
    @mysqli_free_result($rs);

    $query = "SELECT COUNT(*)+1 FROM $listName WHERE points < '$bestScore' AND date >= now() - INTERVAL '$lastDays' DAY";
    $rs = $db->query( $query );
    $count = mysqli_fetch_array($rs);
    $bestRank = $count[0];
    $str .= $bestRank.",";
    @mysqli_free_result($rs);

    $rs = $db->query( "SELECT name, points, time, system FROM $listName WHERE date >= now() - INTERVAL '$lastDays' DAY ORDER BY `points` ASC LIMIT 30" );
    if( $rs->num_rows > 0 )
    {
      while( $row = $rs->fetch_assoc() )
      {
        $str .= $row["points"].",".$row["time"].",".$row["name"].",".$row["system"].",";
      }
    }
    @mysqli_free_result($rs);
    $str .= "0";
  }

  printf( $str );
?>