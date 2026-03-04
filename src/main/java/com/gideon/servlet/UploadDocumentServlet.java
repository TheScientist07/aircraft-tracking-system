package com.gideon.servlet;

import com.gideon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/uploadDocument")
@MultipartConfig
public class UploadDocumentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int aircraftId = Integer.parseInt(request.getParameter("aircraftId"));
            String type = request.getParameter("type");
            String issueDate = request.getParameter("issueDate");
            String expiryDate = request.getParameter("expiryDate");

            Part filePart = request.getPart("file");

            // Generate unique filename so files never overwrite
            String fileName = System.currentTimeMillis() + "_" +
                    Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Upload folder
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";

            File uploadDir = new File(uploadPath);

            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            // Save file
            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);

            // Path saved in database
            String dbPath = "uploads/" + fileName;

            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO documents (aircraft_id, document_type, issue_date, expiry_date, file_path) VALUES (?, ?, ?, ?, ?)");

            ps.setInt(1, aircraftId);
            ps.setString(2, type);
            ps.setString(3, issueDate);
            ps.setString(4, expiryDate);
            ps.setString(5, dbPath);

            ps.executeUpdate();

            conn.close();

            response.sendRedirect("documents.jsp?aircraftId=" + aircraftId);

        } catch (Exception e) {

            e.printStackTrace();
            response.getWriter().println("Upload error: " + e.getMessage());

        }
    }
}