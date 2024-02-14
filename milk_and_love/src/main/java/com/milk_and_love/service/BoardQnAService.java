package com.milk_and_love.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.milk_and_love.mapper.BoardQnAMapper;
import com.milk_and_love.vo.BoardQnAVO;
import com.milk_and_love.vo.DeliveryManVO;

@Service
public class BoardQnAService implements BoardQnAMapper {
	
	@Autowired
	BoardQnAMapper mapper;
	
	
	@Override
	public int insert(Map<String, Object> joinDate) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<BoardQnAVO> selectAll(int start, int end) {
		List<BoardQnAVO> BoardQnAVOs = mapper.selectAll(start, end);
		
		return BoardQnAVOs;
	}

	@Override
	public BoardQnAVO selectOne(String no) {
		//System.out.println(id);
		
		BoardQnAVO deliveryManVo = mapper.selectOne(no);
		
		//System.out.println(deliveryManVo);
		
		return deliveryManVo;
	}

	@Override
	public int updateAnswer(Map<String, Object> updates) {
		int result = mapper.updateAnswer(updates);
		
		return result;
	}

	@Override
	public List<BoardQnAVO> search(Map<String, Object> keyWord) {
		System.out.println(keyWord);
		
		List<BoardQnAVO> boardQnAVOs = mapper.search(keyWord);
		
		return boardQnAVOs;
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
	}

	@Override
	public int deleteQnA(String no) {
		int result = mapper.deleteQnA(no);
		return result;
	}
	
}
