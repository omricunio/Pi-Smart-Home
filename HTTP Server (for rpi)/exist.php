<?php
// Start the session
session_start();
?>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
    #result
    {
      color: white;
      text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black;
      font-size: 20vmin;
      background-color: red;

      position:fixed;
      padding:0;
      margin:0;
      top:0;
      left:0;

      width: 100%;
      height: 100%;
      top: 0;
      left: 0;
    }

    #cresult
    {
      color: white;
      text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black;
      font-size: 20vmin;
      background-color: green;

      position:fixed;
      padding:0;
      margin:0;
      top:0;
      left:0;

      width: 100%;
      height: 100%;
      top: 0;
      left: 0;

    }

    </style>
</head>
<body>
<?php
   //include("master.php");
   //$dbhost = 'localhost:3036';
   if(isset($_SESSION["login"]))
   {
   $dbhost = 'localhost';
   $dbuser = 'id4018540_user1';
   $dbpass = 'pass123';
   $dbname = 'id4018540_mydb';
   $conn = mysqli_connect($dbhost,$dbuser,$dbpass,$dbname);
    if(! $conn ) {
      die('Could not connect');
   }

   $result = $conn->query("SELECT * FROM tickets WHERE serialkey = '".$_GET["code"]."'");
    if ($result->num_rows > 0) {
    // output data of each row
        //echo '<table border="1" width="100%">';
        //echo '<tr><td><b>index</b></td><td><b>serialkey</b></td><td><b>scanstatus</b></td></tr>';
        $index = 0;
        while($row = $result->fetch_assoc())
        {
            if($row["scanstatus"]==1)
            {
              echo '<div id="result" align="center">';
              echo 'ERROR: TICKET SCANNED';
              echo '</div>';
            }
            elseif ($row["scanstatus"]==0)
            {
              echo '<div id="cresult" align="center">';
              echo 'TICKET SCANNED SUCCESSFULLY';
              $upscan = $conn->query("UPDATE tickets SET scanstatus = 1 WHERE serialkey = '".$_GET["code"]."'");
              echo '</div>';
            }
            //echo '<tr>';
            //    echo '<td>'.$index.'</td>'.'<td>'.$row["serialkey"].'</td>'.'<td>'.$row["scanstatus"].'</td>';
            //echo '</tr>';
            $index++;
        }
        //echo '</table>';
    }
    else
    {
        echo '<div id="result" align="center">';
        echo "ERROR: FILTHY CHEATER";
        echo '</div>';
    }
   $conn->close();
   }
   else
   {
     echo '<script>window.location.href = "/index.php";</script>';
   }
?>
</h1>
</body>
