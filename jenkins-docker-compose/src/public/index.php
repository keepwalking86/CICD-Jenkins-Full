<?php
   $username = "keepwalking";
   $password = "P@ssw0rd";
   $database = "laravel";
   
   // Create connection
   $conn = mysqli_connect('db', $username, $password, $database);
   
   // Check connection
   if (!$conn) {
       die("Connection failed: " . mysqli_connect_error());
   }
   echo "Connect to the database successfully!!!";

 ?>