<?php
header('Content-Type: application/json');
require_once '../models/User.php';

class AuthController {
    private $user;

    public function __construct() {
        $this->user = new User();
    }

    public function register($data) {
        $this->user->name = $data['name'];
        $this->user->email = $data['email'];
        $this->user->phone = $data['phone'];
        $this->user->password = $data['password'];

        if($this->user->register()) {
            http_response_code(201);
            echo json_encode(array(
                'message' => 'User registered successfully',
                'data' => array(
                    'name' => $this->user->name,
                    'email' => $this->user->email
                )
            ));
        } else {
            http_response_code(400);
            echo json_encode(array('message' => 'Registration failed'));
        }
    }

    public function login($data) {
        $this->user->email = $data['email'];
        $this->user->password = $data['password'];

        if($this->user->login()) {
            http_response_code(200);
            echo json_encode(array(
                'message' => 'Login successful',
                'data' => array(
                    'id' => $this->user->id,
                    'name' => $this->user->name,
                    'email' => $this->user->email,
                    'phone' => $this->user->phone,
                    'balance' => $this->user->balance
                )
            ));
        } else {
            http_response_code(401);
            echo json_encode(array('message' => 'Login failed'));
        }
    }
}
?>
