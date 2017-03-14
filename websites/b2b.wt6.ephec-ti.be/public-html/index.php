<?php
$servername = "db-b2b";
$username = "b2b";
$password = "b2b";
$dbname = "b2b";

try {
   $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
   // set the PDO error mode to exception
   $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

   // sql to create table
   $sql = "CREATE TABLE IF NOT EXISTS users (
       id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
       firstname VARCHAR(30) NOT NULL,
       lastname VARCHAR(30) NOT NULL,
       email VARCHAR(50)
   )";

   // use exec() because no results are returned
   $conn->exec($sql);
   echo "Table users created successfully";

   $sql = "INSERT INTO users (firstname, lastname, email) VALUES ('John', 'Doe', 'john@example.com')";
   // use exec() because no results are returned
   $conn->exec($sql);
   echo "New record created successfully";

   $reponse = $bdd->query('SELECT * FROM users');
   $donnees = $reponse->fetch();

   while ($donnees = $reponse->fetch())
   {
?>
    <p><strong>User</strong> : <?php echo $donnees['firstname']; ?> -  <?php echo $donnees['lastname']; ?> - <?php echo $donnees['email']; ?><br /></p>
<?php
    }
    $reponse->closeCursor(); // Termine le traitement de la requête
} catch(PDOException $e) {
    echo $sql . "<br>" . $e->getMessage();
}

$conn = null;
?>
