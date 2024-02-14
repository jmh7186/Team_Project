package com.milk_and_love.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.milk_and_love.mapper.DeliveryMapper;
import com.milk_and_love.vo.DeliveryVO;

@Service
public class DeliveryService implements DeliveryMapper{

	@Autowired
	DeliveryMapper mapper;

	@Override
	public int insert(DeliveryVO vo) {
		return mapper.insert(vo);
	}

	@Override
	public List<DeliveryVO> selectAll() {
		return mapper.selectAll();
	}

	@Override
	public DeliveryVO selectByNo(String no) {
		return mapper.selectByNo(no);
	}

	@Override
	public int update(DeliveryVO vo) {
		return mapper.update(vo);
	}

	@Override
	public int delete(String no) {
		return mapper.delete(no);
	}

	@Override
	public List<DeliveryVO> selectByPage(String page) {
		return mapper.selectByPage(page);
	}

	@Override
	public int selectCount(DeliveryVO vo, String startdate, String enddate) {
		return mapper.selectCount(vo, startdate, enddate);
	}

	@Override
	public List<DeliveryVO> search(DeliveryVO vo, String startdate, String enddate, String page) {
		return mapper.search(vo, startdate, enddate, page);
	}

}
