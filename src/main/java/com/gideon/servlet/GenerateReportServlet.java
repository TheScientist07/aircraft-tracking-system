package com.gideon.servlet;

import com.gideon.util.DBConnection;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.properties.UnitValue;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;

import com.itextpdf.io.image.ImageDataFactory;
import com.itextpdf.layout.element.Image;

import com.itextpdf.layout.properties.TextAlignment;

@WebServlet("/generateReport")
public class GenerateReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int aircraftId = Integer.parseInt(request.getParameter("aircraftId"));

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=aircraft_report_" + aircraftId + ".pdf");
        response.setHeader("Cache-Control", "no-store");

        try {

            PdfWriter writer = new PdfWriter(response.getOutputStream());
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf);

            String logoPath = getServletContext().getRealPath("/images/university-logo.png");

            try {
                Image logo = new Image(ImageDataFactory.create(logoPath));

                logo.scaleToFit(90, 90);   // hard limit size
                logo.setHorizontalAlignment(com.itextpdf.layout.properties.HorizontalAlignment.CENTER);

                document.add(logo);

            } catch (Exception ignored) {
                // continue without breaking PDF
            }

            document.add(new Paragraph(" "));
            document.add(new Paragraph(" "));

            Connection conn = DBConnection.getConnection();

            // =========================
            // AIRCRAFT DETAILS
            // =========================
            PreparedStatement psAircraft = conn.prepareStatement(
                    "SELECT * FROM aircraft WHERE id = ?");
            psAircraft.setInt(1, aircraftId);
            ResultSet rsAircraft = psAircraft.executeQuery();

            if (!rsAircraft.next()) {
                document.add(new Paragraph("Aircraft not found."));
                document.close();
                conn.close();
                return;
            }

            document.add(new Paragraph("AIRCRAFT COMPLIANCE REPORT")
                    .setBold()
                    .setFontSize(18)
                    .setTextAlignment(TextAlignment.CENTER));

            document.add(new Paragraph("Generated on: "
                    + java.time.LocalDate.now())
                    .setTextAlignment(TextAlignment.CENTER));

            document.add(new Paragraph(" "));

            document.add(new Paragraph("Aircraft Details")
                    .setBold()
                    .setFontSize(14));

            document.add(new Paragraph("Registration: "
                    + rsAircraft.getString("registration_number")));
            document.add(new Paragraph("Model: "
                    + rsAircraft.getString("model")));
            document.add(new Paragraph("Total Hours: "
                    + rsAircraft.getDouble("total_hours")));

            document.add(new Paragraph(" "));

            // =========================
            // COMPLIANCE SUMMARY
            // =========================
            int overdueCount = 0;
            int nearLimitCount = 0;
            int expiredDocCount = 0;
            int expiringSoonDocCount = 0;

            // Count component statuses
            PreparedStatement psCompCount = conn.prepareStatement(
                    "SELECT * FROM components WHERE aircraft_id = ?");
            psCompCount.setInt(1, aircraftId);
            ResultSet rsCompCount = psCompCount.executeQuery();

            while (rsCompCount.next()) {
                double lifeLimit = rsCompCount.getDouble("life_limit_hours");
                double current = rsCompCount.getDouble("current_hours");

                if (current >= lifeLimit) {
                    overdueCount++;
                } else if ((lifeLimit - current) <= (lifeLimit * 0.1)) {
                    nearLimitCount++;
                }
            }

            // Count document statuses
            PreparedStatement psDocCount = conn.prepareStatement(
                    "SELECT * FROM documents WHERE aircraft_id = ?");
            psDocCount.setInt(1, aircraftId);
            ResultSet rsDocCount = psDocCount.executeQuery();

            java.time.LocalDate today = java.time.LocalDate.now();

            while (rsDocCount.next()) {
                java.time.LocalDate expiry =
                        rsDocCount.getDate("expiry_date").toLocalDate();

                long daysRemaining =
                        java.time.temporal.ChronoUnit.DAYS.between(today, expiry);

                if (daysRemaining < 0) {
                    expiredDocCount++;
                } else if (daysRemaining <= 30) {
                    expiringSoonDocCount++;
                }
            }

            document.add(new Paragraph("Compliance Summary")
                    .setBold()
                    .setFontSize(14));

            document.add(new Paragraph("Overdue Components: " + overdueCount));
            document.add(new Paragraph("Near Limit Components: " + nearLimitCount));
            document.add(new Paragraph("Expired Documents: " + expiredDocCount));
            document.add(new Paragraph("Expiring Soon Documents: " + expiringSoonDocCount));

            document.add(new Paragraph(" "));

            // =========================
            // COMPONENTS TABLE
            // =========================
            document.add(new Paragraph("Component Status")
                    .setBold()
                    .setFontSize(14));

            float[] compColumnWidths = {3, 2, 2, 2};
            Table compTable = new Table(UnitValue.createPercentArray(compColumnWidths));
            compTable.setWidth(UnitValue.createPercentValue(100));

            compTable.addHeaderCell(new Cell().add(new Paragraph("Name").setBold()));
            compTable.addHeaderCell(new Cell().add(new Paragraph("Life Limit").setBold()));
            compTable.addHeaderCell(new Cell().add(new Paragraph("Current Hours").setBold()));
            compTable.addHeaderCell(new Cell().add(new Paragraph("Status").setBold()));

            PreparedStatement psComp = conn.prepareStatement(
                    "SELECT * FROM components WHERE aircraft_id = ?");
            psComp.setInt(1, aircraftId);
            ResultSet rsComp = psComp.executeQuery();

            while (rsComp.next()) {

                double lifeLimit = rsComp.getDouble("life_limit_hours");
                double current = rsComp.getDouble("current_hours");

                String status;
                if (current >= lifeLimit) {
                    status = "OVERDUE";
                } else if ((lifeLimit - current) <= (lifeLimit * 0.1)) {
                    status = "Near Limit";
                } else {
                    status = "OK";
                }

                compTable.addCell(rsComp.getString("component_name"));
                compTable.addCell(String.valueOf(lifeLimit));
                compTable.addCell(String.valueOf(current));
                compTable.addCell(status);
            }

            document.add(compTable);
            document.add(new Paragraph(" "));

            // =========================
            // DOCUMENTS TABLE
            // =========================
            document.add(new Paragraph("Document Status")
                    .setBold()
                    .setFontSize(14));

            float[] docColumnWidths = {3, 2, 2};
            Table docTable = new Table(UnitValue.createPercentArray(docColumnWidths));
            docTable.setWidth(UnitValue.createPercentValue(100));

            docTable.addHeaderCell(new Cell().add(new Paragraph("Type").setBold()));
            docTable.addHeaderCell(new Cell().add(new Paragraph("Expiry Date").setBold()));
            docTable.addHeaderCell(new Cell().add(new Paragraph("Status").setBold()));

            PreparedStatement psDocs = conn.prepareStatement(
                    "SELECT * FROM documents WHERE aircraft_id = ?");
            psDocs.setInt(1, aircraftId);
            ResultSet rsDocs = psDocs.executeQuery();

            while (rsDocs.next()) {

                java.time.LocalDate expiry =
                        rsDocs.getDate("expiry_date").toLocalDate();

                long daysRemaining =
                        java.time.temporal.ChronoUnit.DAYS.between(today, expiry);

                String status;
                if (daysRemaining < 0) {
                    status = "EXPIRED";
                } else if (daysRemaining <= 30) {
                    status = "Expiring Soon";
                } else {
                    status = "OK";
                }

                docTable.addCell(rsDocs.getString("document_type"));
                docTable.addCell(expiry.toString());
                docTable.addCell(status);
            }

            document.add(docTable);

            // =========================
            // SIGNATURE SECTION
            // =========================
            document.add(new Paragraph(" "));
            document.add(new Paragraph(" "));
            document.add(new Paragraph("______________________________"));
            document.add(new Paragraph("Maintenance Control Officer"));
            document.add(new Paragraph("Date: _________________________"));

            document.add(new Paragraph(" "));
            document.add(new Paragraph("Generated by Aircraft Technical Records Management System")
                    .setFontSize(10));

            document.close();
            conn.close();

            response.getOutputStream().flush();
            response.getOutputStream().close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}