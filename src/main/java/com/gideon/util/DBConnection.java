package com.gideon.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://127.0.0.1:3306/aircraft_tracking?useSSL=false&allowPublicKeyRetrieval=true";

    private static final String USER = "appuser";
    private static final String PASSWORD = "app123";

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}