package com.milk_and_love.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.milk_and_love.service.BoardQnAService;
import com.milk_and_love.vo.BoardQnAVO;

@Controller
public class BoardQnAController {
	// 한 페이지에서 보여줄 행의 수
	
	@Value("${row.count.per.page}")
	private String rowCountPerPage;
	
	@Autowired
	BoardQnAService service;
	
	// 1대1 문의 게시판 이동
	@GetMapping("/QnA")
	public ModelAndView boradQnA(ModelAndView model) {
			
			int page = 1;
			
			int size = Integer.parseInt(rowCountPerPage);
			
			//첫번째 페이지 설정
			model.addObject("page", page);
			
			// 나머지 페이지 설정
			int count = service.totalPage();
			
			int totalPages = count/size;
			
			model.addObject("totalPages", totalPages);
			
			model.setViewName("/board_QnA/list.jsp");
			return model;
		}
		
		
		// 1대1 문의 상세 게시판 이동
		@GetMapping("/QnA/view")
		public ModelAndView boradQnAView(ModelAndView model, @RequestParam("no") String no) {
			BoardQnAVO boardQnAVO = service.selectOne(no);
			model.addObject("vo", boardQnAVO);
			
			model.setViewName("/board_QnA/view.jsp");
			return model;
		}
		
		// 1대1문의 게시판 ajax 매핑
		@PostMapping("/QnA_list")
		@ResponseBody
		public List<BoardQnAVO> qnaList(@RequestBody(required=false) Map<String, Object>  page){
			int size = Integer.parseInt(rowCountPerPage);
			
			int pageNo = 0;
			
			if (page.get("page") != null && page.get("page") instanceof String) {
				// 페이지가 널이 아니거나 스트링 타입이 아닐경우
				pageNo = Integer.parseInt((String) page.get("page"));
			} else {
				pageNo = (int) page.get("page");
			}

			
			int start = (pageNo - 1) * size + 1;
			int end = pageNo * size;
			
			System.out.println("page_number: "+start);
			System.out.println("size: " +end);
			
			//배달원 정보 불러오기 및 설정
			List<BoardQnAVO> voList = service.selectAll(start, end);
		    
			System.out.println(voList);
			
		    return voList;
		}
		
		// 1대1 문의 게시판 검색 ajax 매핑
		@PostMapping("/QNA_srech")
		@ResponseBody
		public List<BoardQnAVO> qnaSearch(@RequestBody(required=false) Map<String, Object>  keyWords) {
			
			
			int pageNo = 0;
			
			int size = Integer.parseInt(rowCountPerPage);
			
			if (keyWords.get("page") != null && keyWords.get("page") instanceof String) {
				// 페이지가 널이 아니거나 스트링 타입이 아닐경우
				pageNo = Integer.parseInt((String) keyWords.get("page"));
			} else {
				pageNo = (int) keyWords.get("page");
			} 
			
			int start = (pageNo - 1) * size + 1;
			int end = pageNo * size;
			
			System.out.println(start);
			System.out.println(end);
			
			keyWords.remove("page");
			keyWords.put("start", start);
			keyWords.put("end", end);
			
			System.out.println(keyWords);
			
			//배달원 정보 불러오기 및 설정
			List<BoardQnAVO> voList = service.search(keyWords);
		    
		    return voList;
		}
		
		// 1대1문의 검색시 최대 페이지 ajax 매핑
		@PostMapping("/QNA_srech_maxpage")
		@ResponseBody
		public int qnaMaxpage(@RequestBody(required=false) Map<String, Object>  keyWords) {
			System.out.println(keyWords);
			
			int size = Integer.parseInt(rowCountPerPage);
			
			int total =  service.searchTotalPage(keyWords)/size;
		    
		    return total;
		}
		
		// 1대1 문의 삭제 ajax 매핑
		@PostMapping("/QNA_delete")
		@ResponseBody
		public int qnaDelete(@RequestBody(required=false) Map<String, Object>  keyWords) {
			
			String no = String.valueOf(keyWords.get("no"));
			System.out.println(no);
			
			int result = service.deleteQnA(no);
			
			return result;
		}
		
		// 1대1 문의 답변등록
		@PostMapping("/QNA_answer")
		@ResponseBody
		public int updateAnswer(@RequestBody(required=false) Map<String, Object>  keyWords) {
			
			int result = service.updateAnswer(keyWords);
			
			return result;
		}
}
