<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.gideon.util.DBConnection" %>
<%@ page session="true" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    int aircraftId = 0;
    String documentType = "";
    String issueDate = "";
    String expiryDate = "";

    try {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM documents WHERE id = ?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            aircraftId = rs.getInt("aircraft_id");
            documentType = rs.getString("document_type");
            issueDate = rs.getDate("issue_date").toString();
            expiryDate = rs.getDate("expiry_date").toString();
        }

        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Document</title>
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

<div class="card shadow p-4">
    <h3 class="mb-4">Edit Document</h3>

    <form action="updateDocument" method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <input type="hidden" name="aircraftId" value="<%= aircraftId %>">

        <div class="mb-3">
            <label class="form-label">Document Type</label>
            <input type="text"
                   class="form-control"
                   name="documentType"
                   value="<%= documentType %>"
                   required>
        </div>

        <div class="mb-3">
            <label class="form-label">Issue Date</label>
            <input type="date"
                   class="form-control"
                   name="issueDate"
                   value="<%= issueDate %>"
                   required>
        </div>

        <div class="mb-3">
            <label class="form-label">Expiry Date</label>
            <input type="date"
                   class="form-control"
                   name="expiryDate"
                   value="<%= expiryDate %>"
                   required>
        </div>

        <div class="d-flex justify-content-between">
            <a class="btn btn-outline-secondary"
               href="documents.jsp?aircraftId=<%= aircraftId %>">
                Back
            </a>

            <button class="btn btn-success">
                Update Document
            </button>
        </div>

    </form>
</div>

</body>
</html>