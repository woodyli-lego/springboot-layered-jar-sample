package com.example.layeredjar;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class WebController {

    @GetMapping("/greetings")
    public String hello() {
        return "Hello, World!";
    }
}
