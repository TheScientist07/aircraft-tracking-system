<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Aircraft Maintenance System - Login</title>

    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center vh-100">

<div class="card shadow p-4" style="width: 400px;">

    <div class="text-center mb-4">
        <div class="text-center mb-3">
            <img src="images/university-logo.png" alt="University Logo"
                 style="max-height:80px;">
        </div>
        <h3 class="fw-bold">Aircraft Maintenance</h3>
        <p class="text-muted">Technical Records Management System</p>
        <small class="text-muted">University Research Prototype</small>
    </div>

    <form action="login" method="post">

        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" class="form-control" name="email" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" class="form-control" name="password" required>
        </div>

        <button class="btn btn-primary w-100">Login</button>

    </form>

</div>

</body>
</html>