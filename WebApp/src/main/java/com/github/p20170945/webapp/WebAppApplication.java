package com.github.p20170945.webapp;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.FileReader;
import java.io.IOException;

@SpringBootApplication
public class WebAppApplication {
    private static JSONObject CONFIG = null;

    public static JSONObject getCONFIG() {
        return CONFIG;
    }

    public static void main(String[] args) {
        try {
            Object obj = new JSONParser().parse(new FileReader("config.json"));
            CONFIG = (JSONObject) obj;
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        Empresa.load();
        BaseDeDatos.load();
        SpringApplication.run(WebAppApplication.class, args);
    }
}
