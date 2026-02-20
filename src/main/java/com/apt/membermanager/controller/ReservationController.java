package com.apt.membermanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/reservation")
public class ReservationController {

    @GetMapping("/fac_book")
    public String facBook() { return "reservation/fac_book"; }

    @GetMapping("/my_list")
    public String myList() { return "reservation/my_list"; }
}