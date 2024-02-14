package com.milk_and_love.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.milk_and_love.mapper.DeliveryManMapper;
import com.milk_and_love.vo.DeliveryManVO;

@Service
public class DeliveryManService implements DeliveryManMapper {
	@Autowired
	DeliveryManMapper mapper;
	
	@Override
	public int insert(Map<String, Object> joinDate) {
		int reuslt = mapper.insert(joinDate);
		return reuslt;
	}

	// 전체 배달원의 정보를 가져온다
	@Override
	public List<DeliveryManVO> selectAll(int start, int end) {
		List<DeliveryManVO> deliveryManVos = mapper.selectAll(start, end);
		return deliveryManVos;
	}

	// 아이디로 배달원 한명의 정보를 가져온다
	@Override
	public DeliveryManVO selectOne(String id) {
		//System.out.println(id);
		
		DeliveryManVO deliveryManVo = mapper.selectOne(id);
		
		//System.out.println(deliveryManVo);
		
		return deliveryManVo;
	}

	@Override
	public int update(Map<String, Object> updates) {
		//System.out.println(updates);
		int result = mapper.update(updates);
		return result;
	}

	@Override
	public int updateStatus(String id, int status) {
		int result = mapper.updateStatus(id, status);
		return result;
	}

	@Override
	public List<DeliveryManVO> search(Map<String, Object> keyWord) {
		List<DeliveryManVO> deliveryManVos = mapper.search(keyWord);
		return deliveryManVos;
	}
	
	@Override
	public int searchTotalPage(Map<String, Object> keyWord) {
		int result = mapper.searchTotalPage(keyWord);
		return result;
	}
	
	@Override
	public int totalPage() {
		int totalPage = mapper.totalPage();

		return totalPage;
	};

	@Override
	public List<Map<String, Object>> selectArea1List() {
		return mapper.selectArea1List();
	}

	@Override
	public List<Map<String, Object>> selectArea2List(String arae1Code) {
		return mapper.selectArea2List(arae1Code);
	}

	@Override
	public List<Map<String, Object>> selectArea3List(String area2Code) {
		return mapper.selectArea3List(area2Code);
	}
	
}
