package com.milk_and_love.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

import com.milk_and_love.service.DeliveryService;
import com.milk_and_love.service.ManagerService;
import com.milk_and_love.vo.ManagerVO;

import jakarta.servlet.http.HttpServletRequest;


@Controller
public class MainController {

	@Autowired
	ManagerService managerSvc;
	@Autowired
	DeliveryService deliverySvc;
	
	String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	
	@GetMapping("/")
	public String index() {
		return "/login.jsp";
	}
	
	@PostMapping("/loginproc")
	public ModelAndView login(ModelAndView mv, ManagerVO vo, HttpServletRequest hreq) {
		ManagerVO mvo = managerSvc.selectById(vo.getId());
		mv.addObject("kind", "로그인");
		if(mvo==null || !(mvo.getPw().equals(vo.getPw()))) {
			mv.addObject("result", 0);
		}else {
			hreq.getSession().setAttribute("id", vo.getId());
			mv.addObject("result", 1);
		}
		mv.setViewName("/result.jsp");
		return mv;
	}
	
	@GetMapping("/logout")
	public String logout(HttpServletRequest hreq) {
		hreq.getSession().setAttribute("id", null);
		return "/login.jsp";
	}
}
