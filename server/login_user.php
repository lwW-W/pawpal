<?php
include 'common_cors.php';
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendJsonResponse(array(
        'status' => 'failed',
        'message' => 'Method Not Allowed',
        'success' => false,
        'data' => null
    ));
    exit();
}

if (!isset($_POST['email']) || !isset($_POST['password'])) {
    sendJsonResponse(array(
        'status' => 'failed',
        'message' => 'Bad Request: Missing email or password',
        'success' => false,
        'data' => null
    ));
    exit();
}

$email = $_POST['email'];
$pass = sha1($_POST['password']);

$sql = "SELECT user_id, name, email, password, phone, reg_date 
        FROM tbl_users 
        WHERE email='$email' AND password='$pass'";

$result = $conn->query($sql);

// Check if user exists
if ($result->num_rows > 0) {

    $userdata = array();
    while ($row = $result->fetch_assoc()) {
        $userdata[] = $row;
    }

    // Send success response with user data
    sendJsonResponse(array(
        'status' => 'success',
        'message' => 'Login successful',
        'success' => true,
        'data' => $userdata[0]   
    ));

} else {

    // Send failed login response
    sendJsonResponse(array(
        'status' => 'failed',
        'message' => 'Invalid email or password',
        'success' => false,
        'data' => null
    ));
}

// JSON response function
function sendJsonResponse($sentarray) {
    header('Content-Type: application/json');
    echo json_encode($sentarray);
}
?>
