package com.milk_and_love.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.milk_and_love.mapper.ManagerMapper;
import com.milk_and_love.vo.ManagerVO;

@Service
public class ManagerService implements ManagerMapper{

	@Autowired
	ManagerMapper mapper;
	
	@Override
	public int insert(ManagerVO vo) {
		return mapper.insert(vo);
	}

	@Override
	public List<ManagerVO> selectAll() {
		return mapper.selectAll();
	}

	@Override
	public ManagerVO selectById(String id) {
		return mapper.selectById(id);
	}

	@Override
	public int update(ManagerVO vo) {
		return mapper.update(vo);
	}

	@Override
	public int delete(String id) {
		return mapper.delete(id);
	}

}
