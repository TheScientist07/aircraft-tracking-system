<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.gideon.util.DBConnection" %>
<%@ page session="true" %>

<%
if (session.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp");
    return;
}

response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

int aircraftId = Integer.parseInt(request.getParameter("id"));

String registration = "";
String model = "";
double hours = 0;

try {

Connection conn = DBConnection.getConnection();

PreparedStatement ps = conn.prepareStatement(
"SELECT * FROM aircraft WHERE id = ?");

ps.setInt(1, aircraftId);

ResultSet rs = ps.executeQuery();

if(rs.next()){

registration = rs.getString("registration_number");
model = rs.getString("model");
hours = rs.getDouble("total_hours");

}

conn.close();

}catch(Exception e){

out.println("Error: " + e.getMessage());

}
%>

<!DOCTYPE html>
<html>

<head>

<title>Aircraft Details</title>

<meta charset="UTF-8">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

</head>

<body class="container mt-4">

<%
String userName = (String) session.getAttribute("name");
if(userName == null){
    userName = "User";
}
%>

<nav class="mb-4 d-flex justify-content-between align-items-center">

<div>
    <a class="btn btn-primary btn-sm" href="dashboard.jsp">Dashboard</a>
    <a class="btn btn-secondary btn-sm" href="aircraft.jsp">Aircraft</a>
</div>

<div>

<span class="me-3">
Logged in: <b><%= userName %></b>
</span>

<a class="btn btn-danger btn-sm" href="logout">Logout</a>

</div>

</nav>

<h2>Aircraft Technical Record</h2>

<div class="card p-3 mb-4">

<h4>Aircraft Information</h4>

<p><b>Registration:</b> <%= registration %></p>

<p><b>Model:</b> <%= model %></p>

<p><b>Total Flight Hours:</b> <%= hours %></p>

</div>

<div class="row">

<div class="col-md-6">

<div class="card p-3">

<h4>Components</h4>

<p>Manage aircraft component life tracking.</p>

<a class="btn btn-primary"
href="components.jsp?aircraftId=<%= aircraftId %>">
Open Components
</a>

</div>

</div>

<div class="col-md-6">

<div class="card p-3">

<h4>Documents</h4>

<p>Manage compliance and certification documents.</p>

<a class="btn btn-primary"
href="documents.jsp?aircraftId=<%= aircraftId %>">
Open Documents
</a>

</div>

</div>

</div>

<br>

<a href="aircraft.jsp" class="btn btn-secondary">Back to Aircraft List</a>

</body>

</html>