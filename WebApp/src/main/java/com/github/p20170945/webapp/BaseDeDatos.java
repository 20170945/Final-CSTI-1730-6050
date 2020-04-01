package com.github.p20170945.webapp;

import org.json.simple.JSONObject;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class BaseDeDatos {
    private static Connection CONN = null;
    private static Statement stat;

    public static Connection getCONN() {
        return CONN;
    }
    public static Statement getStat() {return stat;}

    public static void load() {
        JSONObject dbConfig = (JSONObject) WebAppApplication.getCONFIG().get("Base de Datos");
        String connectionUrl = "jdbc:sqlserver://" +
                (String) dbConfig.get("IP") + ":1433;" +
                "databaseName=" + (String) dbConfig.get("Database") +
                ";user=" + (String) dbConfig.get("User") +
                ";password=" + (String) dbConfig.get("Pass") + ";";
        try {
            CONN = DriverManager.getConnection(connectionUrl);
            System.out.println("Base de datos conectado.");
        } catch (SQLException e) {
            System.out.println("Error en la conexión de la base de datos cargado.");
            e.printStackTrace();
            System.exit(1);
        }

        try {
            stat = CONN.createStatement();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
