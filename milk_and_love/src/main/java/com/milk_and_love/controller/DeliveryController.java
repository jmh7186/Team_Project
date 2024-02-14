package com.milk_and_love.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.milk_and_love.service.DeliveryService;
import com.milk_and_love.service.ManagerService;
import com.milk_and_love.vo.DeliveryVO;


@Controller
public class DeliveryController {

	@Autowired
	ManagerService managerSvc;
	@Autowired
	DeliveryService deliverySvc;
	
	String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	
	@GetMapping("/deliverymgr")
	public ModelAndView deliveryMgr(ModelAndView mv, @RequestParam(defaultValue = "1", required = false) String page) {
		int intpage = Integer.parseInt(page);
		int cnt = deliverySvc.selectCount(null, today, today);
		int maxpage = 1;
		if(cnt%50!=0 ) {
			maxpage = cnt/50+1;
		}else {
			maxpage = cnt/50;
		}
		if(intpage>maxpage) intpage=maxpage;
		if(intpage<0) intpage=1;
		mv.addObject("dlvlist", deliverySvc.selectByPage(String.valueOf(intpage)));
		mv.addObject("curpage", intpage);
		mv.addObject("maxpage", maxpage);
		mv.addObject("startdate", today);
		mv.addObject("enddate", today);
		mv.setViewName("/deliverymgr.jsp");
		
		return mv;
	}
	
	@PostMapping("/deliverymgr")
	public ModelAndView deliveryMgrSearch(DeliveryVO vo,
											String startdate,
											String enddate, 
											@RequestParam(defaultValue = "1", required = false) String page,
											ModelAndView mv) {
		
		int intpage = Integer.parseInt(page);
		int cnt = deliverySvc.selectCount(vo, startdate, enddate);
		int maxpage = 1;
		if(cnt%50!=0 ) {
			maxpage = cnt/50+1;
		}else {
			maxpage = cnt/50;
		}
		if(intpage>maxpage) intpage=maxpage;
		if(intpage<0) intpage=1;
		
		List<DeliveryVO> lis = deliverySvc.search(vo, startdate, enddate, String.valueOf(intpage));
		
		mv.addObject("searchdetail", vo);
		mv.addObject("startdate", startdate);
		mv.addObject("enddate", enddate);
		mv.addObject("dlvlist", lis);
		mv.addObject("curpage", intpage);
		mv.addObject("maxpage", maxpage);
		mv.setViewName("/deliverymgr.jsp");
		System.out.println(cnt);
		System.out.println(lis.size());
		return mv;
	}
	
	@GetMapping("/deliverymgr/detail/{no}")
	public ModelAndView deliveryDetail(ModelAndView mv, @PathVariable("no") String no) {
		
		mv.setViewName("/deliverymgr_update.jsp");
		mv.addObject("vo", deliverySvc.selectByNo(no));
		return mv;
	}
	
	@PostMapping("/deliverymgr/update")
	public ModelAndView deliveryUpdate(ModelAndView mv, DeliveryVO vo) {
		int result = deliverySvc.update(vo);
		mv.addObject("kind", "배달수정");
		mv.addObject("result", result);
		mv.setViewName("/result.jsp");
		System.out.println(vo.toString());
		return mv;
	}
}
