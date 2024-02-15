package com.milk_and_love.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.milk_and_love.vo.BoardNoticeVO;

@Mapper
public interface BoardNoticeMapper {
	public List<BoardNoticeVO> selectList(Map<String, Object> paramMap);
	public int selectTotalCount(Map<String, Object> paramMap);
	public int updateStatusToPin(String[] nos);
	public int updateStatusToUnpin(String[] nos);
	public int updateStatusToHide(String[] nos);
	public int updateStatusToDisplay(String[] nos);
	public int insert(BoardNoticeVO vo);
	public int updateViews(String no);
	public BoardNoticeVO select(String no);
	public int update(BoardNoticeVO vo);
}
