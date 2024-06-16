<?php
require_once 'config.php';
// Set the content type to JSON
header('Content-Type: application/json');
// Handle HTTP methods
$method = $_SERVER['REQUEST_METHOD'];
switch ($method) {
    case 'GET':
        // Read operation (fetch users)
        $stmt = $pdo->query('SELECT * FROM users');
        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($result);
        break;
    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);
        // Check if the request is to add a user
        if (isset($data['id']) && isset($data['password']) && isset($data['firstname']) && isset($data['lastname']) && isset($data['org'])) {
            // Add user operation
            $id = $data['id'];
            $password = $data['password'];
            $firstname = $data['firstname'];
            $lastname = $data['lastname'];
            $org = $data['org'];
            $id_auto = null;

            $stmt = $pdo->prepare('INSERT INTO users (id, password, firstname, lastname, org, id_auto) VALUES (?, ?, ?, ?, ?, ?)');
            $stmt->execute([$id, $password, $firstname, $lastname, $org, $id_auto]);

            echo json_encode(['message' => 'User added successfully']);


        }elseif (isset($data['Add_concert'])){
            $id = null;
            $Name = $data['name'];
            $description = $data['description'];
            $dateTime = $data['date_time'];
            $location = $data['location'];
            $imagePath = $data['image_path'];

            try {

                $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
                $stmt = $pdo->prepare('INSERT INTO concerts (id, name, description, date_time, location, image_path) VALUES (?, ?, ?, ?, ?, ?)');
                $stmt->execute([$id, $Name, $description, $dateTime, $location, $imagePath]);
                echo json_encode(['message' => 'Concert data added successfully']);
            } catch (PDOException $e) {
                
                echo json_encode(['error' => $e->getMessage()]);
            }
        } else {
            echo json_encode(['error' => 'Invalid request']);
        }
        break;

    case 'PUT':
        // Update operation (edit a user)
        $data = json_decode(file_get_contents('php://input'), true);
        $id = $data['id'];
        $password = $data['password'];
        $firstname = $data['firstname'];
        $lastname = $data['lastname'];
        $org = $data['org'];

        $stmt = $pdo->prepare('UPDATE users SET password=?, firstname=?, lastname=?, org=? WHERE id=?');
        $stmt->execute([$password, $firstname, $lastname, $org, $id]);

        echo json_encode(['message' => 'User updated successfully']);
        break;
    case 'DELETE':
        // Delete operation (remove a user)
        $data = json_decode(file_get_contents('php://input'), true);
        $id = $data['id'];

        $stmt = $pdo->prepare('DELETE FROM users WHERE id=?');
        $stmt->execute([$id]);

        echo json_encode(['message' => 'User deleted successfully']);
        break;

}
?>