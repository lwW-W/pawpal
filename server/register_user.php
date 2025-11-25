<?php
include 'common_cors.php';
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    $response = array('success' => false, 'message' => 'Method Not Allowed');
    sendJsonResponse($response);
    exit();
}

if (!isset($_POST['name']) || !isset($_POST['email']) || !isset($_POST['password']) || !isset($_POST['phone'])) {
    http_response_code(400);
    $response = array('success' => false, 'message' => 'Bad Request');
    sendJsonResponse($response);
    exit();
}

$name  = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = $_POST['password'];
$hashedpassword = sha1($password);

// Check if email already exists
$sqlcheckmail = "SELECT * FROM tbl_users WHERE email = '$email'";
$result = $conn->query($sqlcheckmail);

if ($result->num_rows > 0) {
    $response = array('success' => false, 'message' => 'Email already registered');
    sendJsonResponse($response);
    exit();
}

// Insert new user into database
$sqlregister = "INSERT INTO tbl_users (name, email, phone, password, reg_date)
                VALUES ('$name', '$email', '$phone', '$hashedpassword', NOW())";

try {
    if ($conn->query($sqlregister) === TRUE) {

        // Get inserted user
        $user_id = $conn->insert_id;
        $result = $conn->query("SELECT user_id, name, email, password, phone, reg_date 
                                FROM tbl_users WHERE user_id=$user_id");
        $user = $result->fetch_assoc();

        $response = array(
            'success' => true,
            'message' => 'Registration successful',
            'data' => $user
        );
        sendJsonResponse($response);

    } else {
        $response = array('success' => false, 'message' => 'User registration failed');
        sendJsonResponse($response);
    }
} catch (Exception $e) {
    $response = array('success' => false, 'message' => $e->getMessage());
    sendJsonResponse($response);
}

// JSON response function
function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
