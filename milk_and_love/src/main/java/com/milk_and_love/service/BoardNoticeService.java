package com.milk_and_love.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.milk_and_love.mapper.BoardNoticeMapper;
import com.milk_and_love.vo.BoardNoticeVO;

@Service
public class BoardNoticeService implements BoardNoticeMapper {
	@Autowired
	BoardNoticeMapper mapper;

	@Override
	public List<BoardNoticeVO> selectList(Map<String, Object> paramMap) {
		return mapper.selectList(paramMap);
	}

	@Override
	public int selectTotalCount(Map<String, Object> paramMap) {
		return mapper.selectTotalCount(paramMap);
	}

	@Override
	public int updateStatusToPin(String[] nos) {
		return mapper.updateStatusToPin(nos);
	}

	@Override
	public int updateStatusToUnpin(String[] nos) {
		return mapper.updateStatusToUnpin(nos);
	}

	@Override
	public int updateStatusToHide(String[] nos) {
		return mapper.updateStatusToHide(nos);
	}

	@Override
	public int updateStatusToDisplay(String[] nos) {
		return mapper.updateStatusToDisplay(nos);
	}
	
	@Override
	public int insert(BoardNoticeVO vo) {
		return mapper.insert(vo);
	}
	
	@Override
	public BoardNoticeVO select(String no) {
		return mapper.select(no);
	}

	@Override
	public int update(BoardNoticeVO vo) {
		return update(vo);
	}
	
}
