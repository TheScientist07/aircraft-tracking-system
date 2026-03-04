package com.gideon.servlet;

import com.gideon.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/updateComponent")
public class UpdateComponentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        int aircraftId = Integer.parseInt(request.getParameter("aircraftId"));
        String name = request.getParameter("name");
        double lifeLimit = Double.parseDouble(request.getParameter("lifeLimit"));
        double currentHours = Double.parseDouble(request.getParameter("currentHours"));

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                    "UPDATE components SET component_name=?, life_limit_hours=?, current_hours=? WHERE id=?");

            ps.setString(1, name);
            ps.setDouble(2, lifeLimit);
            ps.setDouble(3, currentHours);
            ps.setInt(4, id);

            ps.executeUpdate();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(
                request.getContextPath() + "/components.jsp?aircraftId=" + aircraftId
        );
    }
}