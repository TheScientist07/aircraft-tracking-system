package com.gideon.servlet;

import com.gideon.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/addAircraft")
public class AddAircraftServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String registration = request.getParameter("registration");
        String model = request.getParameter("model");
        double hours = Double.parseDouble(request.getParameter("hours"));

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO aircraft (registration_number, model, total_hours) VALUES (?, ?, ?)");

            ps.setString(1, registration);
            ps.setString(2, model);
            ps.setDouble(3, hours);

            ps.executeUpdate();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/aircraft.jsp");
    }
}