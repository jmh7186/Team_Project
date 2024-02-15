package com.milk_and_love.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.milk_and_love.service.BoardNoticeService;
import com.milk_and_love.vo.BoardNoticeVO;

@Controller
public class BoardNoticeController {
	@Value("${row.count.per.page}")
	private String rowCountPerPage;		// 한 페이지에서 보여줄 행의 수
	
	@Autowired
	BoardNoticeService service;
	
	// 공지사항 목록 페이지
	@GetMapping("/notice/list")
	public ModelAndView list(ModelAndView mav) {
		// 기본 조건
		Map<String, Object> paramMap = new HashMap<String, Object>();
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
		
		mav.setViewName("/board_notice/list.jsp");
		
		return mav;
	}
	
	// 공지사항 목록 불러오기
	@PostMapping("/notice/load_list_process")
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
	
	// 상태 변경 프로세스
	@PostMapping("/notice/update_status_process")
	@ResponseBody
	public int updateStatusProcess(@RequestParam String type, @RequestParam String no) {
		// 고정
		if(type.equals("pin")) {
			return service.updateStatusToPin(no.split(","));
			
		} else if(type.equals("unpin")) { // 고정 해제
			return service.updateStatusToUnpin(no.split(","));
			
		} else if(type.equals("hide")) { // 숨김
			return service.updateStatusToHide(no.split(","));
			
		} else if(type.equals("display")) { // 숨김 해제
			return service.updateStatusToDisplay(no.split(","));
		}
		
		return 0;
	}
	
	// 공지사항 등록 페이지
	@GetMapping("/notice/post")
	public String post() {
		return "/board_notice/post.jsp";
	}
	
	// 공지사항 등록
	@PostMapping("/notice/post_process")
	@ResponseBody
	public int postProcess(HttpServletRequest request, BoardNoticeVO vo) {
		HttpSession session = request.getSession();
		
		vo.setAuthor(session.getAttribute("id").toString());
		return service.insert(vo);
	}
	
	// 공지사항 확인 및 수정 페이지
	@GetMapping("/notice/view")
	public ModelAndView view(ModelAndView mav, @RequestParam String no) {
		// 조회수 증가
		service.updateViews(no);
		
		// 공지사항 정보가 담긴 VO 객체
		BoardNoticeVO vo = service.select(no);
		mav.addObject("vo", vo);
		
		mav.setViewName("/board_notice/view.jsp");
		
		return mav;
	}
	
	// 공지사항 수정 
	@PostMapping("/notice/edit_process")
	@ResponseBody
	public int editProcess(BoardNoticeVO vo) {
		return service.update(vo);
	}
	
}
