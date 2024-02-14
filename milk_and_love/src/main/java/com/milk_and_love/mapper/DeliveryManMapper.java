package com.milk_and_love.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.milk_and_love.vo.DeliveryManVO;

@Mapper
public interface DeliveryManMapper {
	public int insert(Map<String, Object> joinDate);
	public List<DeliveryManVO> selectAll(int start, int end);
	public DeliveryManVO selectOne(String id);
	public int update(Map<String, Object> updates);
	public int updateStatus(String id,int status);
	public List<DeliveryManVO> search(Map<String, Object> keyWord);
	public int searchTotalPage(Map<String, Object> keyWord);
	public int totalPage();
	
	
	public List<Map<String, Object>> selectArea1List();
	public List<Map<String, Object>> selectArea2List(String arae1Code);
	public List<Map<String, Object>> selectArea3List(String area2Code);
}
