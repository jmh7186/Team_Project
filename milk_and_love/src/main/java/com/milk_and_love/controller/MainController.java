package com.milk_and_love.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.milk_and_love.service.ManagerService;
import com.milk_and_love.vo.ManagerVO;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;



@Controller
public class MainController {

	@Autowired
	ManagerService managerSvc;
	
	String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	
	@GetMapping("/")
	public ModelAndView index(ModelAndView mv, HttpServletRequest hreq) {
		Cookie[] cookies = hreq.getCookies();
		
		if(cookies!=null) {
			for(Cookie c:cookies) {
				if(c.getName().equals("id")) {
					mv.addObject("rememberid", c.getValue());
					break;
				}
			}
		}
		
		mv.setViewName("/login.jsp");
		return mv;
	}
	
	@PostMapping("/loginproc")
	public ModelAndView login(	ModelAndView mv, ManagerVO vo, HttpServletRequest hreq, HttpServletResponse hres,
								@RequestParam(required = false, defaultValue = "off") String rememberid) {
		ManagerVO mvo = managerSvc.selectById(vo.getId());
		mv.addObject("kind", "로그인");
		
		if(mvo==null || !(mvo.getPw().equals(vo.getPw()))) {
			mv.addObject("result", 0);
		}else {
			hreq.getSession().setAttribute("id", vo.getId());
			mv.addObject("result", 1);
			
			if(rememberid.equals("on")) {
				Cookie cookie = new Cookie("id", vo.getId());
				cookie.setMaxAge(60*60*24*365); //쿠키 유효 기간: 365일
			    cookie.setPath("/"); //모든 경로에서 접근 가능하도록 설정
			    hres.addCookie(cookie);
			}else {
				Cookie cookie = new Cookie("id", null);
				cookie.setMaxAge(0); //쿠키 삭제
			    hres.addCookie(cookie);
			}
		}
		mv.setViewName("/result.jsp");
		return mv;
	}
	
	@GetMapping("/logout")
	public void logout(HttpServletRequest hreq, HttpServletResponse hres) throws IOException {
		hreq.getSession().setAttribute("id", null);
		hres.sendRedirect("/");
	}
	
	@GetMapping("/mypage")
	public ModelAndView mypage(ModelAndView mv, HttpServletRequest hreq) {
		String id = (String) hreq.getSession().getAttribute("id");
		
		mv.addObject("vo", managerSvc.selectById(id));
		mv.setViewName("/mypage.jsp");
		return mv;
	}
	
	@PostMapping("/mypage/update")
	public ModelAndView mypageUpdate(ModelAndView mv, ManagerVO vo) {
		int result = managerSvc.update(vo);
		mv.addObject("kind", "mgrupdate");
		mv.addObject("result", result);
		mv.setViewName("/result.jsp");
		return mv;
	}
	
	@GetMapping("/updatepw")
	public ModelAndView updatepw(ModelAndView mv, HttpServletRequest hreq) {
		String id = (String) hreq.getSession().getAttribute("id");
		
		mv.addObject("oldpw", managerSvc.selectById(id).getPw());
		mv.setViewName("/updatepw.jsp");
		return mv;
	}
	
	@PostMapping("/updatepw")
	public ModelAndView updatepwProc(ModelAndView mv, HttpServletRequest hreq, String oldpw, String newpw) {
		String id = (String) hreq.getSession().getAttribute("id");
		String d_oldpw = managerSvc.selectById(id).getPw();
		mv.addObject("kind", "updatepw");
		
		if(d_oldpw.equals(oldpw)) {
			mv.addObject("result", managerSvc.updatepw(id, newpw));
		}else {
			mv.addObject("result", 2); //현재 비밀번호 틀림
		}
		mv.setViewName("/result.jsp");
		return mv;
	}
	
}
