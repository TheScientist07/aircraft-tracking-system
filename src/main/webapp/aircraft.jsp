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

int totalAircraft = 0;
double avgHours = 0;
double maxHours = 0;
double minHours = 0;

try {

    Connection conn = DBConnection.getConnection();
    Statement st = conn.createStatement();

    ResultSet rsStats = st.executeQuery(
        "SELECT COUNT(*), AVG(total_hours), MAX(total_hours), MIN(total_hours) FROM aircraft"
    );

    if(rsStats.next()){
        totalAircraft = rsStats.getInt(1);
        avgHours = rsStats.getDouble(2);
        maxHours = rsStats.getDouble(3);
        minHours = rsStats.getDouble(4);
    }

    conn.close();

} catch(Exception e){
    out.println("Error: " + e.getMessage());
}

%>

<!DOCTYPE html>

<html>

<head>

<title>Aircraft Management</title>

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

<h2>Aircraft Management</h2>

<!-- Fleet Overview -->

<div class="row mb-4">

<div class="col-md-3">
<div class="card text-center bg-primary text-white p-3">
<h6>Total Aircraft</h6>
<h3><%= totalAircraft %></h3>
</div>
</div>

<div class="col-md-3">
<div class="card text-center bg-success text-white p-3">
<h6>Average Flight Hours</h6>
<h3><%= String.format("%.1f", avgHours) %></h3>
</div>
</div>

<div class="col-md-3">
<div class="card text-center bg-warning text-dark p-3">
<h6>Highest Time Aircraft</h6>
<h3><%= maxHours %></h3>
</div>
</div>

<div class="col-md-3">
<div class="card text-center bg-info text-white p-3">
<h6>Lowest Time Aircraft</h6>
<h3><%= minHours %></h3>
</div>
</div>

</div>

<div class="card p-3 mb-4">

<h4>Add Aircraft</h4>

<form action="addAircraft" method="post">

<div class="mb-3">
<label class="form-label">Registration Number</label>
<input type="text" class="form-control" name="registration" required>
</div>

<div class="mb-3">
<label class="form-label">Aircraft Model</label>
<input type="text" class="form-control" name="model" required>
</div>

<div class="mb-3">
<label class="form-label">Total Flight Hours</label>
<input type="number" step="0.1" class="form-control" name="hours" required>
</div>

<button class="btn btn-success">Add Aircraft</button>

</form>

</div>

<hr>

<h3>Aircraft List</h3>

<input
type="text"
id="searchAircraft"
class="form-control mb-3"
placeholder="Search aircraft by registration or model..."
onkeyup="filterAircraft()"

>

<table class="table table-striped table-hover align-middle text-center">

<thead class="table-dark">

<tr>
<th>Registration</th>
<th>Model</th>
<th>Total Hours</th>
<th>Details</th>
<th>Action</th>
</tr>

</thead>

<tbody id="aircraftTable">

<%

try{

Connection conn = DBConnection.getConnection();

Statement st = conn.createStatement();

ResultSet rs = st.executeQuery("SELECT * FROM aircraft");

while(rs.next()){

%>

<tr>

<td><b><%= rs.getString("registration_number") %></b></td>

<td><%= rs.getString("model") %></td>

<td><%= rs.getDouble("total_hours") %></td>

<td>
<a class="btn btn-primary btn-sm"
href="aircraftDetails.jsp?id=<%= rs.getInt("id") %>">
Details
</a>
</td>

<td>

<a class="btn btn-warning btn-sm"
href="editAircraft.jsp?id=<%= rs.getInt("id") %>">
Edit </a>

<a class="btn btn-danger btn-sm"
href="deleteAircraft?id=<%= rs.getInt("id") %>"
onclick="return confirm('Delete this aircraft?');">
Delete </a>

</td>

</tr>

<%

}

conn.close();

}catch(Exception e){

out.println("Error: " + e.getMessage());

}

%>

</tbody>

</table>

<script>

function filterAircraft(){

let input = document.getElementById("searchAircraft");

let filter = input.value.toUpperCase();

let table = document.getElementById("aircraftTable");

let rows = table.getElementsByTagName("tr");

for(let i = 0; i < rows.length; i++){

let text = rows[i].textContent || rows[i].innerText;

rows[i].style.display = text.toUpperCase().indexOf(filter) > -1 ? "" : "none";

}

}

</script>

</body>

</html>
