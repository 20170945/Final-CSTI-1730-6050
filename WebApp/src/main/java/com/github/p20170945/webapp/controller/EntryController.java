package com.github.p20170945.webapp.controller;

import com.github.p20170945.webapp.BaseDeDatos;
import com.github.p20170945.webapp.Empresa;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.sql.SQLException;

@Controller
public class EntryController {

    @GetMapping("/")
    public String home(Model model) {
        datosGenerales(model);
        model.addAttribute("vehiculos", new String[]{"1", "no", "ye"});
        model.addAttribute("marcas", new String[]{"Toyota", "Ferrari", "Mercedes"});
        model.addAttribute("modelos",new String[]{"A", "B", "C"});
        model.addAttribute("provincias",new String[]{"a", "b", "c"});
        try {
            System.out.println(BaseDeDatos.getStat().execute("SELECT nombre FROM Provincias;"));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "home";
    }

    @GetMapping("/catalog")
    public String catalog(Model model) {
        datosGenerales(model);
        model.addAttribute("vehiculos", new String[]{"1", "no", "ye"});
        model.addAttribute("marcas", new String[]{"Toyota", "Ferrari", "Mercedes"});
        model.addAttribute("modelos",new String[]{"A", "B", "C"});
        model.addAttribute("provincias",new String[]{"a", "b", "c"});
        return "catalog";
    }

    private void datosGenerales(Model model) {
        model.addAttribute("islogged",false);
        model.addAttribute("pageTitle", Empresa.NOMBRE);
        model.addAttribute("companyName", Empresa.NOMBRE);
    }
}
