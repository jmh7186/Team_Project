package com.milk_and_love.vo;

import lombok.Data;

@Data
public class BoardNoticeVO {
	private int no;					// 글 번호
	private String title;				// 제목
	private String content;				// 내용
	private String author;				// 작성자 ID
	private java.sql.Date post_date;	// 작성일자
	private int views;					// 조회수
	private int is_pinned;				// 고정 여부 (0: 고정 아님, 1: 고정)
	private int is_hidden;				// 숨김 여부 (0: 숨김 아님, 1: 숨김)
}
