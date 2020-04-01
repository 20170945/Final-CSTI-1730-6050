package com.github.p20170945.webapp.controller;

import com.github.p20170945.webapp.BaseDeDatos;
import com.github.p20170945.webapp.Empresa;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

@Controller
public class EntryController {

    @GetMapping("/")
    public String home(Model model) {
        datosGenerales(model);
        ResultSet rs = null;
        ArrayList<String> stringArray = new ArrayList<>();
        model.addAttribute("marcas", new String[]{"Toyota", "Ferrari", "Mercedes"});
        model.addAttribute("modelos", new String[]{"A", "B", "C"});
        datosGenerales(model);
        try {
            rs = BaseDeDatos.getStat().executeQuery("SELECT nombre FROM Provincias;");
            while (rs.next()) {
                stringArray.add(rs.getString("nombre"));
            }
            model.addAttribute("provincias", stringArray);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "home";
    }

    @GetMapping("/catalog")
    public String catalog(Model model) {
        datosGenerales(model);
        model.addAttribute("marcas", new String[]{"Toyota", "Ferrari", "Mercedes"});
        model.addAttribute("modelos", new String[]{"A", "B", "C"});
        return "catalog";
    }

    private void datosGenerales(Model model) {
        ResultSet rs = null;
        ArrayList<String> stringArray = new ArrayList<>();
        try {
            rs = BaseDeDatos.getStat().executeQuery("SELECT descripcion FROM TipoVehiculo;");
            while (rs.next()) {
                stringArray.add(rs.getString("descripcion"));
            }
            model.addAttribute("vehiculos", stringArray);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        model.addAttribute("islogged", false);
        model.addAttribute("pageTitle", Empresa.NOMBRE);
        model.addAttribute("companyName", Empresa.NOMBRE);
    }
}
