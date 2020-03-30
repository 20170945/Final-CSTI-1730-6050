package com.github.p20170945.webapp;

import org.json.simple.JSONObject;

public class Empresa {
    public static String NOMBRE;

    public static void load() {
        NOMBRE = (String) ((JSONObject) WebAppApplication.getCONFIG().get("Empresa")).get("Nombre");
    }
}
