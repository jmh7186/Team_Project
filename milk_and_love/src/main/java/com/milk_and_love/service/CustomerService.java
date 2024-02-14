package com.milk_and_love.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.milk_and_love.mapper.CustomerMapper;
import com.milk_and_love.vo.CustomerVO;

@Service
public class CustomerService implements CustomerMapper {
	@Autowired
	CustomerMapper mapper;

	@Override
	public List<CustomerVO> selectList(Map<String, Object> paramMap) {
		Map<String, Object> searchMap = new HashMap<>();	// sql문의 조건절에 사용할 변수 목록
		
		for (String key : paramMap.keySet()) {
			String value = String.valueOf(paramMap.get(key));	// null 값이 들어오면 "null"이라는 문자열 반환
			
			if(value != null && !value.isBlank() && !value.equals("null")) {
				if(key.equals("c_status")) {
					searchMap.put("status", paramMap.get(key));
					
				} else {
					searchMap.put(key, paramMap.get(key));
				}
				
				//System.out.println(key + ": " + paramMap.get(key));	// 실제 조건에 들어갈 변수
			}
		}
		
		return mapper.selectList(searchMap);
	}
	
	@Override
	public int selectTotalCount(Map<String, Object> paramMap) {
		Map<String, Object> searchMap = new HashMap<>();	// sql문의 조건절에 사용할 변수 목록
		
		for (String key : paramMap.keySet()) {
			String value = String.valueOf(paramMap.get(key));	// null 값이 들어오면 "null"이라는 문자열 반환
			
			if(value != null && !value.isBlank() && !value.equals("null")) {
				if(key.equals("c_status")) {
					searchMap.put("status", paramMap.get(key));
					
				} else {
					searchMap.put(key, paramMap.get(key));
				}
				
				//System.out.println(key + ": " + paramMap.get(key));	// 실제 조건에 들어갈 변수
			}
		}
		
		return mapper.selectTotalCount(searchMap);
	}

	@Override
	public int updateStatusToLeave(String[] ids) {
		return mapper.updateStatusToLeave(ids);
	}

	@Override
	public List<Map<String, Object>> selectDeliveryManList(Map<String, Object> paramMap) {
		return mapper.selectDeliveryManList(paramMap);
	}

	@Override
	public int insert(CustomerVO vo) {
		return mapper.insert(vo);
	}

	@Override
	public CustomerVO select(String id) {
		return mapper.select(id);
	}

	@Override
	public int update(CustomerVO vo) {
		return mapper.update(vo);
	}
	
}
