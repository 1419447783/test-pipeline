package com.example.testpipeline.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @Author: Rookie
 * @Date: Create in 2020/07/22 16:53
 * @Description:
 **/
@RestController
@RequestMapping("test")
public class TestController {

    @GetMapping("hello")
    public String hello(){
        return "hello, world!";
    }

    @GetMapping("ok")
    public String ok(){
        return "ok!";
    }

    @GetMapping("or")
    public String or(){
        return "or!";
    }
}
