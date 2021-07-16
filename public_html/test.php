<?php
$bdd = new PDO('mysql:host=localhost;port=3306;dbname=pbraidersdb;charset=utf8mb4', 'pbraidersdbuser', 'pbrusrpwd', array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION));
$resultat = $bdd->query('SELECT * FROM table');
echo 'Il y a ' . $resultat->rowCount() . ' entrée(s) dans la base de données : </br>';
while ($donnees = $resultat->fetch(PDO::FETCH_ASSOC)) {
    echo $donnees['id'] . ' ' . $donnees['message'] . '</br>';
}
