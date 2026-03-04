package com.gideon.servlet;

import com.gideon.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Date;

@WebServlet("/addDocument")
public class AddDocumentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int aircraftId = Integer.parseInt(request.getParameter("aircraftId"));
        String type = request.getParameter("type");
        Date issueDate = Date.valueOf(request.getParameter("issueDate"));
        Date expiryDate = Date.valueOf(request.getParameter("expiryDate"));

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO documents (aircraft_id, document_type, issue_date, expiry_date) VALUES (?, ?, ?, ?)");

            ps.setInt(1, aircraftId);
            ps.setString(2, type);
            ps.setDate(3, issueDate);
            ps.setDate(4, expiryDate);

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