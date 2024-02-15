package com.milk_and_love.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.milk_and_love.vo.ManagerVO;

@Mapper
public interface ManagerMapper {
	public int insert(ManagerVO vo);
	public List<ManagerVO> selectAll();
	public ManagerVO selectById(String id);
	public int update(ManagerVO vo);
	public int delete(String id);
	public int updatepw(String id, String newpw);
}
