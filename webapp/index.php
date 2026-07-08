<?php
$dbHost = getenv('DB_HOST') ?: 'mysql-db';
$dbName = getenv('DB_NAME') ?: 'usersdb';
$dbUser = getenv('DB_USER') ?: 'labuser';
$dbPass = getenv('DB_PASS') ?: 'labpass';

$mysqli = @new mysqli($dbHost, $dbUser, $dbPass, $dbName);
$error = null;
$users = [];

if ($mysqli->connect_errno) {
    $error = $mysqli->connect_error;
} else {
    $result = $mysqli->query('SELECT id, name, email, created_at FROM users ORDER BY id DESC');
    while ($row = $result->fetch_assoc()) {
        $users[] = $row;
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lab Users</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>Registered Users</h1>
    <?php if ($error): ?>
        <p class="error">Could not connect to database: <?= htmlspecialchars($error) ?></p>
    <?php else: ?>
        <table>
            <thead>
                <tr><th>ID</th><th>Name</th><th>Email</th><th>Created At</th></tr>
            </thead>
            <tbody>
                <?php foreach ($users as $user): ?>
                <tr>
                    <td><?= htmlspecialchars($user['id']) ?></td>
                    <td><?= htmlspecialchars($user['name']) ?></td>
                    <td><?= htmlspecialchars($user['email']) ?></td>
                    <td><?= htmlspecialchars($user['created_at']) ?></td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php endif; ?>
</body>
</html>
