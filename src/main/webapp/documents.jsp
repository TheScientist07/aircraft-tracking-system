<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, java.time.*, java.time.temporal.ChronoUnit, com.gideon.util.DBConnection" %>
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
    <title>Aircraft Documents</title>
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

<h2 class="mb-4">Documents for Aircraft ID: <%= aircraftId %></h2>

<div class="card p-3 mb-4">

<h4>Add Document</h4>

<form action="uploadDocument" method="post" enctype="multipart/form-data">

<input type="hidden" name="aircraftId" value="<%= aircraftId %>">

<div class="mb-3">
<label class="form-label">Document Type</label>
<input type="text" class="form-control" name="type" required>
</div>

<div class="mb-3">
<label class="form-label">Issue Date</label>
<input type="date" class="form-control" name="issueDate" required>
</div>

<div class="mb-3">
<label class="form-label">Expiry Date</label>
<input type="date" class="form-control" name="expiryDate" required>
</div>

<div class="mb-3">
<label class="form-label">Upload Document</label>
<input type="file" class="form-control" name="file" required>
</div>

<button class="btn btn-success">Upload Document</button>

</form>

</div>

<hr>

<h3>Document List</h3>

<table class="table table-bordered table-striped">

<tr>
<th>Type</th>
<th>Issue Date</th>
<th>Expiry Date</th>
<th>Status</th>
<th>File</th>
<th>Action</th>
</tr>

<%
try {

    Connection conn = DBConnection.getConnection();

    PreparedStatement ps = conn.prepareStatement(
        "SELECT * FROM documents WHERE aircraft_id = ?");

    ps.setInt(1, aircraftId);

    ResultSet rs = ps.executeQuery();

    LocalDate today = LocalDate.now();

    while (rs.next()) {

        LocalDate expiry = rs.getDate("expiry_date").toLocalDate();

        long daysRemaining = ChronoUnit.DAYS.between(today, expiry);

        String status;
        String rowClass;

        if (daysRemaining < 0) {
            status = "❌ EXPIRED";
            rowClass = "table-danger";
        }
        else if (daysRemaining <= 30) {
            status = "⚠ Expiring Soon (" + daysRemaining + " days)";
            rowClass = "table-warning";
        }
        else {
            status = "OK (" + daysRemaining + " days left)";
            rowClass = "table-success";
        }

        String filePath = rs.getString("file_path");
%>

<tr class="<%= rowClass %>">

<td><%= rs.getString("document_type") %></td>

<td><%= rs.getDate("issue_date") %></td>

<td><%= rs.getDate("expiry_date") %></td>

<td><%= status %></td>

<td>

<%
if(filePath != null && !filePath.isEmpty()){
%>

<a href="<%= filePath %>" target="_blank">View</a>

|

<a href="<%= filePath %>" download>Download</a>

<%
}else{
%>

No File

<%
}
%>

</td>

<td>

<a href="editDocument.jsp?id=<%= rs.getInt("id") %>&aircraftId=<%= aircraftId %>">
Edit
</a>

|

<a href="deleteDocument?id=<%= rs.getInt("id") %>&aircraftId=<%= aircraftId %>">
Delete
</a>

</td>

</tr>

<%
    }

    conn.close();

} catch (Exception e) {

    out.println("Error: " + e.getMessage());

}
%>

</table>

<br>

<a href="aircraft.jsp">Back to Aircraft</a>

</body>
</html>