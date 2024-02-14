package com.milk_and_love.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.milk_and_love.vo.CustomerVO;

@Mapper
public interface CustomerMapper {
	public List<CustomerVO> selectList(Map<String, Object> paramMap);
	public int selectTotalCount(Map<String, Object> paramMap);
	public int updateStatusToLeave(String[] ids);
	public List<Map<String, Object>> selectDeliveryManList(Map<String, Object> paramMap);
	public int insert(CustomerVO vo);
	public CustomerVO select(String id);
	public int update(CustomerVO vo);
}
