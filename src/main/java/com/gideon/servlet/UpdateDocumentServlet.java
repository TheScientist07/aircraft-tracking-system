package com.gideon.servlet;

import com.gideon.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Date;

@WebServlet("/updateDocument")
public class UpdateDocumentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        int aircraftId = Integer.parseInt(request.getParameter("aircraftId"));
        String type = request.getParameter("type");
        Date issueDate = Date.valueOf(request.getParameter("issueDate"));
        Date expiryDate = Date.valueOf(request.getParameter("expiryDate"));

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                    "UPDATE documents SET document_type=?, issue_date=?, expiry_date=? WHERE id=?");

            ps.setString(1, type);
            ps.setDate(2, issueDate);
            ps.setDate(3, expiryDate);
            ps.setInt(4, id);

            ps.executeUpdate();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(
                request.getContextPath() + "/documents.jsp?aircraftId=" + aircraftId
        );
    }
}