<?php
require_once 'controllers/AuthController.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");

$requestMethod = $_SERVER['REQUEST_METHOD'];
$requestUri = $_SERVER['REQUEST_URI'];

$authController = new AuthController();

// Parse request data
$data = json_decode(file_get_contents('php://input'), true);

// Route the request
switch ($requestMethod) {
    case 'POST':
        if (strpos($requestUri, '/api/auth/register') !== false) {
            $authController->register($data);
        } elseif (strpos($requestUri, '/api/auth/login') !== false) {
            $authController->login($data);
        }
        break;
    default:
        http_response_code(404);
        echo json_encode(array('message' => 'Route not found'));
        break;
}
?>
