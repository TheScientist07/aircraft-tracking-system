package com.gideon.servlet;

import com.gideon.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/addComponent")
public class AddComponentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int aircraftId = Integer.parseInt(request.getParameter("aircraftId"));
        String name = request.getParameter("name");
        double lifeLimit = Double.parseDouble(request.getParameter("lifeLimit"));
        double currentHours = Double.parseDouble(request.getParameter("currentHours"));

        double nextDue = lifeLimit; // simple logic for now

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO components (aircraft_id, component_name, life_limit_hours, current_hours, next_due_hours) VALUES (?, ?, ?, ?, ?)");

            ps.setInt(1, aircraftId);
            ps.setString(2, name);
            ps.setDouble(3, lifeLimit);
            ps.setDouble(4, currentHours);
            ps.setDouble(5, nextDue);

            ps.executeUpdate();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/components.jsp?aircraftId=" + aircraftId);
    }
}