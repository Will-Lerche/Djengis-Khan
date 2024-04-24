    <?php
		include 'db_connection_test.php';
		
		if(isset($_SERVER['HTTP_ORIGIN'])){
			header("Access-Control-Allow-Origin: *");
			header("Access-Control-Max-Age: 60");
		}
		
		if($_SERVER['REQUEST_METHOD'] === "OPTIONS"){
			header("Access-Control-Allow-Methods: POST, OPTIONS");
			header("Access-Control-Allow-Headers: Authorization, Content-Type, Accept, Origin, cache-control");
			http_response_code(200);
			die;
		}
		
		if ($_SERVER['REQUEST_METHOD'] !== "POST"){
			#http_response_code(405);
			#die;
		}
		
		
		#Returns information and data to Godot
		function print_response($status, $dictionary = [], $error = "none"){
			$string = "{\"error\" : \"$error\",
						\"command\" : \"$_REQUEST[command]\",
						\"response\" : ". json_encode($dictionary) ."}";
						
			#Print out json to Godot
			echo $string;
			//						\"data_status\" : \"$status\",
		}
		
		function verify_nonce($pdo, $secret = "1234567890"){
			
			if(!isset($_SERVER['HTTP_CNONCE'])){
				print_response("no_return", [], "invalide_nonce");
				return false;
			}
			
			$template = "SELECT nonce FROM `nonces` WHERE ip_address = :ip";
			$sth = $pdo -> prepare($template);
			$sth -> execute(["ip" => $_SERVER['REMOTE_ADDR']]);
			$data = $sth -> fetchAll(PDO::FETCH_ASSOC);
			
			if(!isset($data) or sizeof($data) <= 0){
				print_response("no_return", [], "server_missing_nonce");
				return false;
			}
			
			$sth = $pdo -> prepare("DELETE FROM `nonces` WHERE ip_address = :ip");
			$sth -> execute(["ip" => $_SERVER['REMOTE_ADDR']]);
			
			$server_nonce = $data[0]['nonce'];
			
			if (hash('sha256', $server_nonce . $_SERVER['HTTP_CNONCE'] . file_get_contents("php://input") . $secret) != $_SERVER["HTTP_HASH"]){
					print_response("no_return", [], "invalid_nonce_or_hash");
					return false;
			}
			
			return true;			
		}
		
		
		#Handle error: 
		#Missing command
		if (!isset($_REQUEST['command']) or $_REQUEST['command'] === null){
			print_response("no_return", [], "missing_command");
			//echo "{\"error\":\"missing_command\",\"response\":{}}";
			die;
		}
		
		#Missing data
		if (!isset($_REQUEST['data']) or $_REQUEST['data'] === null){
			print_response("no_return", [], "missing_data");
			die;
		}
		
		
		
		#Convert Godot json to dictionary
		$dict_from_json = json_decode($_REQUEST['data'], true);
		#var_dump($dict_from_json);
		#echo $dict_from_json["score"];
		#die;
		
		#Is dictionary valid
		if ($dict_from_json === null){
			print_response("no_return", [], "invalid_json");
			die;
		}
		
		switch ($_REQUEST['command']){
			
			#Adding score
			case "get_nonce":
			
			$bytes = random_bytes(32);
			$nonce = hash('sha256', $bytes);
			
			
			$template = "INSERT INTO `nonces` (ip_address, nonce) VALUES (:ip, :nonce) ON DUPLICATE KEY
			UPDATE nonce = :nonce_update";
			
			$pdo = OpenConnPDO();
			
			$sth = $pdo -> prepare($template);
			$sth -> execute(["ip" => $_SERVER['REMOTE_ADDR'], "nonce" => $nonce, "nonce_update" => $nonce]);
			
			print_response("nonce_return", ["nonce" => $nonce]);
			
			
			die;
			
			break;
            
            
            #set Kills
          	case "set_kills":
            	
            	#Handle error for set kills
				if (!isset($dict_from_json['Kills'])){
					print_response("no_return", [], "missing_kills");
					die;
				}
            
								
				if (!isset($dict_from_json['username'])){
					print_response("no_return", [], "missing_username");
					die;
				}
				
				# Username max length 40, -> should be handled in Godot
				$username = $dict_from_json['username'];
				if (strlen($username) > 64)
					$username = substrt($username, 64);
				
				$Kills = $dict_from_json['Kills'];
				
				$template = "INSERT INTO `players_secure` (username, Kills) VALUES (:username, :Kills);";
				
				$pdo = OpenConnPDO();
				if(!verify_nonce($pdo))
					die;
				
				$sth = $pdo -> prepare($template);
				$sth -> bindValue("username", $username);
            	$sth -> bindValue("Kills", $Kills, PDO::PARAM_INT);
				$sth -> execute();
            
            print_response("no_return", array("size" => 0));
            break;	
			
			#Adding score
			case "set_Time":
				

				#Handle error for add score
				if (!isset($dict_from_json['time'])){
					print_response("no_return", [], "missing_score");
					die;
				}
								
				if (!isset($dict_from_json['username'])){
					print_response("no_return", [], "missing_username");
					die;
				}
				
				# Username max length 40, -> should be handled in Godot
				$username = $dict_from_json['username'];
				if (strlen($username) > 40)
					$username = substrt($username, 40);
				
				$score = $dict_from_json['score'];
				
				$template = "INSERT INTO `players_secure` (username, score) VALUES (:username, :score) ON DUPLICATE
				KEY UPDATE score = GREATEST(score, VALUES(score))";
				
				$pdo = OpenConnPDO();
				if(!verify_nonce($pdo))
					die;
				
				$sth = $pdo -> prepare($template);
				$sth -> bindValue("username", $username);
				$sth -> bindValue("score", $score, PDO::PARAM_INT);
				$sth -> execute(); 
				
		
				#$sql = "INSERT INTO `players` (player_name, score) VALUES (\"". $username ."\", ". $score .") ON DUPLICATE
				#KEY UPDATE score = GREATEST(score, VALUES(". $score . "))";

				#Make a connection to the DB
				#$conn = OpenCon();
				
				// Check connection
				#if ($conn->connect_error) {
				#	print_response("0", [], "db_login_error");
				#	die();
				#}
				
				#Create sql to pass to DB
				#$sql = "INSERT INTO players (player_name, score) VALUES (?, ?) ON DUPLICATE
				#KEY UPDATE score = GREATEST(score, VALUES(score));";
				
				// prepare and bind
				#$stmt = $conn->prepare($sql);
				#s:string, i:integer, d:decimal(float), b:blob
				#$stmt->bind_param("si", $username, $score);
				
				
				#DB call 
				#$stmt->execute();
				
				#Close statement and connection
				#$stmt->close();				
				CloseConnPDO($pdo);
				
				#Response to Godot, all is fine
				
				print_response("no_return", array("size" => 0));
				die;
				
				
			break;
			
			case "get_scores":
			
				$score_number_of = 10;
				$score_offset = 0;
				
				#Check for new values
				if (isset($dict_from_json['score_offset']))
					$score_offset = max(0, (int)$dict_from_json['score_offset']);
								
				if (isset($dict_from_json['score_number']))
					$score_number_of = max(1, (int)$dict_from_json['score_number']);
				
				$template = "SELECT username, Kills FROM `players_secure` ORDER BY Kills DESC LIMIT :number OFFSET :offset";
				
				#Make a connection to the DB
				$pdo = OpenConnPDO();
				//verify_nonce($pdo);
				#if(!verify_nonce($pdo))
				#	die;
				
				$sth = $pdo -> prepare($template);
				#$sth -> execute(["number" => $score_number_of, "offset" => $score_offset]); 
				
				$sth -> bindValue("number", $score_number_of, PDO::PARAM_INT);
				$sth -> bindValue("offset", $score_offset, PDO::PARAM_INT);
				$sth -> execute();

				
				$players = $sth -> fetchAll(PDO::FETCH_ASSOC);
				
				$players["size"] = sizeof($players);
				
				print_response("multi_return", $players);
				

				die;
				
				
				
				
				
				#$conn = OpenCon();
				
				// Check connection
				#if ($conn->connect_error) {
				#	print_response([], "db_login_error");
				#	die();
				#}
			
				#$sql = "SELECT * FROM players ORDER BY score DESC LIMIT ? OFFSET ?";
				#$sql = "SELECT id, player_name, score FROM players ORDER BY score DESC LIMIT ? OFFSET ?";
				//$sql = "SELECT * FROM players WHERE id = ?;";
			
				// prepare and bind
				#$stmt = $conn->prepare($sql);
				#s:string, i:integer, d:decimal(float), b:blob
				#$stmt->bind_param("ii", $score_number_of, $score_offset);
				
				#DB call 
				#$stmt->execute();
				
				#$result = $stmt->get_result();
				#$players;
				#$player = $result->fetch_array(MYSQLI_ASSOC);
				#$counter = 0;
				#while ($player != null)
				#{
					//$players = json_decode($players, TRUE);
					#$players[] = $player;
					#$player = $result->fetch_array(MYSQLI_ASSOC);
					#$counter++;
				#} 
				#$players["size"] = $counter;
				#$players["dummy"] = "";
				#$players = json_encode($players);
				
				#Close result, statement and connection
				#$result->close();
				#$stmt->close();				

				
				#$players["size"] = sizeof($players);
				

			
			
			break;
			
			
			case "get_player":
			
				#Handle missing user id
				if (!isset($dict_from_json['user_id'])){
					print_response([], "missing_user_id");
					die;
				}
				
				# Username max length 40, -> should be handled in Godot
				$user_id = $dict_from_json['user_id'];
				#$user_id = 1;
				
				#Make a connection to the DB
				/*
				$conn = OpenCon();
				
				// Check connection
				if ($conn->connect_error) {
					print_response([], "db_login_error");
					die();
				}				
			*/
			
				$template = "SELECT * FROM players WHERE id = :id;";
			
				#Make a connection to the DB
				$pdo = OpenConnPDO();
				//verify_nonce($pdo);
				if(!verify_nonce($pdo))
					die;
				
				$sth = $pdo -> prepare($template);
				#$sth -> execute(["number" => $score_number_of, "offset" => $score_offset]); 
				
				$sth -> bindValue("id", $user_id, PDO::PARAM_INT);
				$sth -> execute();

				
				$players = $sth -> fetchAll(PDO::FETCH_ASSOC);
				
				$players["size"] = sizeof($players);				

				CloseConnPDO($pdo);
				$data_status = "one_return";
				if (sizeof($players) == 0) $data_status = "no_return";
				
				print_response($data_status, $players);
				die;
				/*
				$datasize = sizeof($player);
				$data_status = "one_return"
				if ($datasize == 0) $data_status = "no_return";
				
				$player["size"] = $datasize;
				$player = json_encode($players);
						*/		

			
			
			break;
				
			
			
			#Handle none excisting request
			default:
				print_reaponse([], "invalide_command");
				die;
			break;
		}

    ?>