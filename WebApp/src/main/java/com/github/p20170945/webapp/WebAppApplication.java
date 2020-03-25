package com.github.p20170945.webapp;

import com.sun.org.apache.bcel.internal.generic.NEW;
import netscape.javascript.JSObject;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

@SpringBootApplication
public class WebAppApplication {
    public static JSONObject CONFIG = null;

    public static void main(String[] args) {
        try {
            Object obj = new JSONParser().parse(new FileReader("config.json"));
            CONFIG = (JSONObject) obj;
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        SpringApplication.run(WebAppApplication.class, args);
    }

}
