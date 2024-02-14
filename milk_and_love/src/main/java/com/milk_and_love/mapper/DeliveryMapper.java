package com.milk_and_love.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.milk_and_love.vo.DeliveryVO;

@Mapper
public interface DeliveryMapper {
	public int insert(DeliveryVO vo);
	public List<DeliveryVO> selectAll();
	public DeliveryVO selectByNo(String no);
	public List<DeliveryVO> selectByPage(@Param("page") String page);
	public int update(DeliveryVO vo);
	public int delete(String no);
	public int selectCount(@Param("vo") DeliveryVO vo, @Param("startdate") String startdate, @Param("enddate") String enddate);
	public List<DeliveryVO> search(@Param("vo") DeliveryVO vo, @Param("startdate") String startdate, @Param("enddate") String enddate, @Param("page") String page);
}
