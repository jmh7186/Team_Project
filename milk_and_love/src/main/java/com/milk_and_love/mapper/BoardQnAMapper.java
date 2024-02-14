package com.milk_and_love.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.milk_and_love.vo.BoardQnAVO;

@Mapper
public interface BoardQnAMapper {
	public int insert(Map<String, Object> joinDate);
	public List<BoardQnAVO> selectAll(int start, int end);
	public BoardQnAVO selectOne(String no);
	public int updateAnswer(Map<String, Object> updates);
	public List<BoardQnAVO> search (Map<String, Object> keyWord);
	public int totalPage();
	public int searchTotalPage(Map<String, Object> keyWord);
	public int deleteQnA(String no);
}
