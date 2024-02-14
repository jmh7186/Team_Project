package com.milk_and_love.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.milk_and_love.service.CustomerService;
import com.milk_and_love.vo.CustomerVO;

@Controller
public class CustomerController {
	@Value("${row.count.per.page}")
	private String rowCountPerPage;		// 한 페이지에서 보여줄 행의 수
	
	@Autowired
	CustomerService service;
	
	// 고객 조회 페이지
	@GetMapping("/customer/list")
	public ModelAndView list(ModelAndView mav) {
		String today = new SimpleDateFormat("yyyy-MM-dd").format(new Date());	// 오늘 날짜(YYYY-MM-DD)
		
		// 기본 조건
		Map<String, Object> paramMap = new HashMap<String, Object>();;
		paramMap.put("start_date", today);		// 시작 일자 = 오늘
		paramMap.put("end_date", today);		// 종료 일자 = 오늘
		paramMap.put("c_status", -1);			// 고객 상태 = 전체
		paramMap.put("start_row", 1);									// 시작 행 번호 = 1
		paramMap.put("end_row", Integer.parseInt(rowCountPerPage));		// 종료 행 번호
		
		// 목록
		mav.addObject("list", service.selectList(paramMap));
		
		// 현재 페이지 = 1
		mav.addObject("pageNum", 1);
		
		// 페이지
		int totalCount = service.selectTotalCount(paramMap);	// 조건에 부합하는 전체 데이터 개수
		int totalPageCount = (int) Math.ceil((double)totalCount / Integer.parseInt(rowCountPerPage));	// 전체 페이지 수
		if(totalPageCount == 0) totalPageCount = 1;	// 0페이지 방지
		mav.addObject("totalPageCount", totalPageCount);
		
		mav.setViewName("/customer/list.jsp");
		
		return mav;
	}
	
	// 고객 목록 불러오기
	@PostMapping("/customer/load_list_process")
	@ResponseBody
	public Map<String, Object> loadListProcess(@RequestParam Map<String, Object> paramMap) {
		int pageNum = Integer.parseInt(paramMap.get("page_num").toString());		// 페이지 번호
		int startRow = (pageNum - 1) * Integer.parseInt(rowCountPerPage) + 1;		// 시작 행 번호
		int endRow = pageNum * Integer.parseInt(rowCountPerPage);					// 종료 행 번호
		
		paramMap.put("start_row", startRow);
		paramMap.put("end_row", endRow);
		
		// 결과 데이터
		Map<String, Object> response = new HashMap<>();
		
		response.put("list", service.selectList(paramMap));	// 목록
		response.put("pageNum", pageNum);					// 현재 페이지
		response.put("startRow", startRow);					// 시작 행 번호
		
		// 전체 페이지 수
		int totalCount = service.selectTotalCount(paramMap);	// 조건에 부합하는 전체 데이터 개수
		int totalPageCount = (int) Math.ceil((double)totalCount / Integer.parseInt(rowCountPerPage));	// 전체 페이지 수
		if(totalPageCount == 0) totalPageCount = 1;	// 0페이지 방지
		response.put("totalPageCount", totalPageCount);
		
		return response;
	}
	
	// 해지
	@PostMapping("/customer/leave_process")
	@ResponseBody
	public int leaveProcess(@RequestParam String id) {
		return service.updateStatusToLeave(id.split(","));
	}
	
	// 신규 고객 등록 페이지
	@GetMapping("/customer/join")
	public String regist() {
		return "/customer/join.jsp";
	}
	
	// 배달원 목록 불러오기
	@PostMapping("/customer/load_delivery_man_list_process")
	@ResponseBody
	public List<Map<String, Object>> loadDeliveryManListProcess(@RequestParam Map<String, Object> paramMap) {
		return service.selectDeliveryManList(paramMap);
	}
	
	// 신규 고객 등록
	@PostMapping("/customer/join_process")
	@ResponseBody
	public int registProcess(CustomerVO vo) {
		return service.insert(vo);
	}
	
	// 고객 정보 확인 및 수정 페이지
	@GetMapping("/customer/view")
	public ModelAndView view(ModelAndView mav, @RequestParam String id) {
		// 고객 정보가 담긴 VO 객체
		CustomerVO vo = service.select(id);
		mav.addObject("vo", vo);
		
		// 배달원 목록
		String area = vo.getRoad_address().split(" ")[0] + " " + vo.getRoad_address().split(" ")[1];
		Map<String, Object> paramMap = new HashMap<String, Object>();;
		paramMap.put("area",  area);
		paramMap.put("area3", vo.getArea3());
		
		mav.addObject("delivery_man_list", service.selectDeliveryManList(paramMap));
		
		mav.setViewName("/customer/view.jsp");
		
		return mav;
	}
	
	// 고객 정보 수정
	@PostMapping("/customer/edit_process")
	@ResponseBody
	public int editProcess(CustomerVO vo) {
		return service.update(vo);
	}
	

}
