package com.github.p20170945.webapp.controller;

import com.github.p20170945.webapp.Empresa;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class EntryController {

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("companyName", Empresa.NOMBRE);
        model.addAttribute("vehiculos", new String[]{"1", "no", "ye"});
        return "home";
    }
}
