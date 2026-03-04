<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, java.time.*, java.time.temporal.ChronoUnit, com.gideon.util.DBConnection" %>
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
    int expiredDocs = 0;
    int expiringDocs = 0;
    int overdueComponents = 0;

    try {

        Connection conn = DBConnection.getConnection();
        Statement st = conn.createStatement();

        ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM aircraft");
        if(rs.next()) totalAircraft = rs.getInt(1);

        rs = st.executeQuery("SELECT COUNT(*) FROM documents WHERE expiry_date < CURDATE()");
        if(rs.next()) expiredDocs = rs.getInt(1);

        rs = st.executeQuery(
            "SELECT COUNT(*) FROM documents WHERE expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)"
        );
        if(rs.next()) expiringDocs = rs.getInt(1);

        rs = st.executeQuery(
            "SELECT COUNT(*) FROM components WHERE current_hours >= life_limit_hours"
        );
        if(rs.next()) overdueComponents = rs.getInt(1);

        conn.close();

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }

    String systemStatus = "SAFE";
    String statusClass = "success";

    if (expiredDocs > 0 || overdueComponents > 0) {
        systemStatus = "CRITICAL";
        statusClass = "danger";
    }
    else if (expiringDocs > 0) {
        systemStatus = "WARNING";
        statusClass = "warning";
    }
%>

<!DOCTYPE html>
<html>

<head>

<title>Aircraft Maintenance Dashboard</title>

<meta charset="UTF-8">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

</head>

<body class="container mt-4">

<!-- LOADING SCREEN -->

<div id="loadingScreen" class="text-center mt-5">

<h3>Aircraft Maintenance Compliance System</h3>

<p>Initializing system modules...</p>

<div class="spinner-border text-primary" role="status"></div>

</div>

<!-- DASHBOARD CONTENT -->

<div id="dashboardContent" style="display:none;">

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

<div class="alert alert-<%= statusClass %> text-center">

<h4>
SYSTEM STATUS: <%= systemStatus %>
</h4>

<div>
Last System Check: <span id="clock"></span>
</div>

</div>

<%
if(expiredDocs > 0 || expiringDocs > 0 || overdueComponents > 0){
%>

<div class="alert alert-danger">

<b>⚠ AIRCRAFT COMPLIANCE ALERT</b><br>

<%
if(expiredDocs > 0){
%>
Expired Documents: <b><%= expiredDocs %></b><br>
<%
}

if(expiringDocs > 0){
%>
Documents Expiring Soon: <b><%= expiringDocs %></b><br>
<%
}

if(overdueComponents > 0){
%>
Overdue Components: <b><%= overdueComponents %></b><br>
<%
}
%>

Immediate maintenance attention required.

</div>

<%
}
%>

<h2 class="mt-4">Maintenance Dashboard</h2>

<p>Welcome, <b><%= session.getAttribute("name") %></b></p>

<div class="row mt-4">

<div class="col-md-3">
<div class="card bg-primary text-white text-center p-3">
<h5>Total Aircraft</h5>
<h2><%= totalAircraft %></h2>
</div>
</div>

<div class="col-md-3">
<div class="card bg-danger text-white text-center p-3">
<h5>Expired Documents</h5>
<h2><%= expiredDocs %></h2>
</div>
</div>

<div class="col-md-3">
<div class="card bg-warning text-dark text-center p-3">
<h5>Expiring Soon Documents</h5>
<h2><%= expiringDocs %></h2>
</div>
</div>

<div class="col-md-3">
<div class="card bg-danger text-white text-center p-3">
<h5>Overdue Components</h5>
<h2><%= overdueComponents %></h2>
</div>
</div>

</div>

<hr>

<h3 class="mt-5">Documents Expiring Soon</h3>

<table class="table table-bordered table-striped">

<tr>
<th>Aircraft</th>
<th>Document</th>
<th>Expiry Date</th>
<th>Days Left</th>
</tr>

<%
try {

    Connection conn = DBConnection.getConnection();

    PreparedStatement ps = conn.prepareStatement(
        "SELECT a.registration_number, d.document_type, d.expiry_date " +
        "FROM documents d " +
        "JOIN aircraft a ON d.aircraft_id = a.id " +
        "WHERE d.expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)"
    );

    ResultSet rs = ps.executeQuery();

    LocalDate today = LocalDate.now();

    while (rs.next()) {

        LocalDate expiry = rs.getDate("expiry_date").toLocalDate();
        long daysLeft = ChronoUnit.DAYS.between(today, expiry);
%>

<tr>

<td><%= rs.getString("registration_number") %></td>

<td><%= rs.getString("document_type") %></td>

<td><%= rs.getDate("expiry_date") %></td>

<td style="color:red;font-weight:bold;">
<%= daysLeft %> days
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

<hr>

<a class="btn btn-primary" href="aircraft.jsp">Manage Aircraft</a>

</div>

<script>

window.onload = function(){

    setTimeout(function(){

        document.getElementById("loadingScreen").style.display = "none";
        document.getElementById("dashboardContent").style.display = "block";

    },1500);

}

function updateClock(){

    const now = new Date();

    document.getElementById("clock").innerHTML =
        now.toLocaleDateString() + " " + now.toLocaleTimeString();

}

setInterval(updateClock,1000);

updateClock();

</script>

</body>
</html>