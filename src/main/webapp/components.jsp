<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.gideon.util.DBConnection" %>
<%@ page session="true" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    int aircraftId = Integer.parseInt(request.getParameter("aircraftId"));
%>

<!DOCTYPE html>
<html>

<head>

<title>Aircraft Components</title>

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

<h2 class="mb-4">Components for Aircraft ID: <%= aircraftId %></h2>

<div class="card p-3 mb-4">

<h4>Add Component</h4>

<form action="addComponent" method="post">

<input type="hidden" name="aircraftId" value="<%= aircraftId %>">

<div class="mb-3">
<label class="form-label">Component Name</label>
<input type="text" class="form-control" name="componentName" required>
</div>

<div class="mb-3">
<label class="form-label">Life Limit (Hours)</label>
<input type="number" step="0.1" class="form-control" name="lifeLimit" required>
</div>

<div class="mb-3">
<label class="form-label">Current Hours</label>
<input type="number" step="0.1" class="form-control" name="currentHours" required>
</div>

<button class="btn btn-success">Add Component</button>

</form>

</div>

<hr>

<h3>Component List</h3>

<table class="table table-bordered table-striped">

<tr>
<th>Component</th>
<th>Life Limit (hrs)</th>
<th>Current Hours</th>
<th>Life Used</th>
<th>Action</th>
</tr>

<%
try {

    Connection conn = DBConnection.getConnection();

    PreparedStatement ps = conn.prepareStatement(
        "SELECT * FROM components WHERE aircraft_id = ?");

    ps.setInt(1, aircraftId);

    ResultSet rs = ps.executeQuery();

    while (rs.next()) {

        double lifeLimit = rs.getDouble("life_limit_hours");
        double currentHours = rs.getDouble("current_hours");

        double percentUsed = (currentHours / lifeLimit) * 100;

        String barClass = "bg-success";

        if(percentUsed >= 100){
            barClass = "bg-danger";
        }
        else if(percentUsed >= 80){
            barClass = "bg-warning";
        }
%>

<tr>

<td><%= rs.getString("component_name") %></td>

<td><%= lifeLimit %></td>

<td><%= currentHours %></td>

<td>

<div class="progress">

<div class="progress-bar <%= barClass %>"
role="progressbar"
style="width: <%= percentUsed %>%">

<%= String.format("%.1f", percentUsed) %>%

</div>

</div>

</td>

<td>

<a href="editComponent.jsp?id=<%= rs.getInt("id") %>&aircraftId=<%= aircraftId %>">
Edit
</a>

|

<a href="deleteComponent?id=<%= rs.getInt("id") %>&aircraftId=<%= aircraftId %>">
Delete
</a>

</td>

</tr>

<%
    }

    conn.close();

} catch(Exception e) {

    out.println("Error: " + e.getMessage());

}
%>

</table>

<br>

<a href="aircraft.jsp">Back to Aircraft</a>

</body>
</html>