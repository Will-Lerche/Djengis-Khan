    <?php
		function OpenConnPDO()
		{
			$db_host = "mysql11.unoeuro.com";
			$db_name = "blackrockgames_dk_db";
			$db_username = "blackrockgames_dk";
			$db_password = "g9zyf4t3dpGwREFhbre2";

			#Set up logindata for PDO
			$dsn = "mysql:dbname=$db_name;host=$db_host;charset=utf8mb4;port=3306";			
			
			#Attempt connection and catch error
			try{
				$pdo = new PDO($dsn, $db_username, $db_password); 	
			}
			catch (\PDOException $e){
				print_response("no_return", [], "db_login_error");
				die;
			}
			
			return $pdo;
		}
		
		function CloseConnPDO($pdo)
		{
			//$pdo -> close();
		}
    ?>
	