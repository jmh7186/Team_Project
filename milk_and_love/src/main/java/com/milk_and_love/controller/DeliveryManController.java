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

import com.milk_and_love.service.DeliveryManService;
import com.milk_and_love.vo.DeliveryManVO;

@Controller
public class DeliveryManController {
	@Value("${row.count.per.page}")
	private String rowCountPerPage;		// 한 페이지에서 보여줄 행의 수
	
	@Autowired
	DeliveryManService service;
	
	
		// 배달원 관리 배달원 리스트 페이지
		@GetMapping("/delivery_man/list")
		public ModelAndView deliveryList(ModelAndView model) {
			int page = 0;
			
			int size = Integer.parseInt(rowCountPerPage);
			
			int totalPages = 0;
			//첫번째 페이지 설정
			model.addObject("page", page+1);
			
			//배달원 정보 불러오기 및 설정
			List<DeliveryManVO> voList = service.selectAll(page, size);
			model.addObject("list", voList);
			
			// 나머지 페이지 설정
			int count = service.totalPage();
			
			if (count%size == 0) {
				totalPages = count/size;
			} else {
				totalPages = count/size+1;
			}
			
			
			model.addObject("totalPages", totalPages);
			
			// 글의 시작 번호 계산
			int startNumber = page * size + 1;
			model.addObject("startNumber", startNumber);
			
			//url 설정
			model.setViewName("/delivery_man/list.jsp");
			
			return model;
			
		}
		
		// 배달원 상세 정보 이동
		@GetMapping("/delivery_man/view")
		public ModelAndView deliveryManInfo(ModelAndView model, @RequestParam("id") String id) {
			
			//System.out.println(id);
			
			DeliveryManVO DeliveryManVO = service.selectOne(id);
			
			//System.out.println(DeliveryManVO);
			
			if (DeliveryManVO != null) {
				model.addObject("vo", DeliveryManVO);
				model.setViewName("/delivery_man/view.jsp");
			} else {
				model.setViewName("/delivery_man/list.jsp");
			}

			return model;
		}
		
		
		// 신규 배달원 등록 이동
		@GetMapping("/delivery_man/join")
		public String deliveryManJoin() {
			return "delivery_man/join.jsp";
		}
		
		
		// 배달원 수정 ajax 매핑
		@PostMapping("/modify_delivery_man")
		@ResponseBody
		public int deliveryManModify(@RequestBody(required=false) Map<String, Object> updates) {
			//System.out.println(updates);
			
			int result = service.update(updates);
			
			return result;
		}
		
		// 배달원 추가 ajax 매핑
		@PostMapping("/new_delivery_man")
		@ResponseBody
		public int deliveryManJoin(@RequestBody(required=false) Map<String, Object> joinDate) {
			//System.out.println(joinDate);
			
			int result = service.insert(joinDate);
			
			return result;
		}
		
		// 지역 찾기 ajax 매핑
		@PostMapping("/load_area1_list_process")
		@ResponseBody
		public List<Map<String, Object>> loadArea1ListProcess() {
			return service.selectArea1List();
		}
		
		@PostMapping("/load_area2_list_process")
		@ResponseBody
		public List<Map<String, Object>> loadArea2ListProcess(@RequestParam("area1_code") String arae1Code) {
			//System.out.println(arae1Code);
			return service.selectArea2List(arae1Code);
		}
		
		@PostMapping("/load_area3_list_process")
		@ResponseBody
		public List<Map<String, Object>> loadArea3ListProcess(@RequestParam("area2_code") String arae2Code) {
			return service.selectArea3List(arae2Code);
		}
		
		
		// 배달원 상태 선택 수정 ajax 매핑
		@PostMapping("/delivery_man_select_status_modfiy")
		@ResponseBody
		public int modifySelectStatus(@RequestBody(required=false) Map<String, Object>  map) {
		    int result = 0;
		    
		    List<String> ids = (List<String>) map.get("ids");
		    int status = Integer.parseInt((String) map.get("status")); 
		    
		    //System.out.println(ids);
		    //System.out.println(status);
		    
		    if (ids != null) {
		        for (String id : ids) {
		            result = service.updateStatus(id, status);
		        }
		    }
		    
		    return result;
		}
		
		// 배달원 상태 수정 ajax 매핑
		@PostMapping("/delivery_man_status_modfiy")
		@ResponseBody
		public int modifyStatus(@RequestBody(required=false) Map<String, Object>  map) {
			
		    String id = (String) map.get("id");
		    int status = Integer.parseInt((String) map.get("status")); 
		    
		    int result = service.updateStatus(id, status);
		    
		    return result;
		}
		
		// 배달원 페이지 ajax 매핑
		@PostMapping("/delivery_man_page")
		@ResponseBody
		public List<DeliveryManVO> pageFind(@RequestBody(required=false) Map<String, Object>  page) {
			
			//System.out.println(page);
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
			
			//System.out.println("page_number: "+start);
			//System.out.println("size: " +end);
			
			//배달원 정보 불러오기 및 설정
			List<DeliveryManVO> voList = service.selectAll(start, end);
		    
			//System.out.println(voList);
			
		    return voList;
		}
		
		// 배달원 검색 ajax 매핑
		@PostMapping("/delivery_man_srech")
		@ResponseBody
		public List<DeliveryManVO> deliveryManSearch(@RequestBody(required=false) Map<String, Object>  keyWords) {
			//System.out.println(keyWords);
			
			int pageNo = 0;
			
			int size = Integer.parseInt(rowCountPerPage);
			
			if (keyWords.get("page") != null && keyWords.get("page") instanceof String) {
				// 페이지가 널이 아니거나 스트링 타입이 아닐경우
				pageNo = Integer.parseInt((String) keyWords.get("page"));
			} else {
				pageNo = (int) keyWords.get("page");
			} 
			System.out.println(pageNo);
			
			int start = (pageNo - 1) * size + 1;
			int end = pageNo * size;
			
			//System.out.println(start);
			//System.out.println(end);
			
			keyWords.remove("page");
			keyWords.put("start", start);
			keyWords.put("end", end);
			
			//배달원 정보 불러오기 및 설정
			List<DeliveryManVO> voList = service.search(keyWords);
		    
			//System.out.println(voList);
			
		    return voList;
		}
		
		// 배달원 검색시 최대 페이지 ajax 매핑
		@PostMapping("/delivery_man_maxpage")
		@ResponseBody
		public int deliveryManMaxpage(@RequestBody(required=false) Map<String, Object>  keyWords) {
			//System.out.println(keyWords);
			int size = Integer.parseInt(rowCountPerPage);
			
			
			int total =  service.searchTotalPage(keyWords)/size;
		    
		    return total;
		}
	
	
}
