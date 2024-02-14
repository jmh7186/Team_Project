package com.milk_and_love.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {
	// 메인
	@GetMapping("/")
	public String main() {
		return login();
	}
	
	// 로그인
	@GetMapping("/login")
	public String login() {
		return "/login.jsp";
	}
	
	// 사이트맵
	@GetMapping("/sitemap")
	public String sitemap() {
		return "/sitemap.jsp";
	}
}
