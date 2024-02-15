package com.milk_and_love.vo;

import java.sql.Date;

import lombok.Data;

@Data
public class BoardQnAVO {
	private int no;
	private String title;
	private String q_content;
	private String q_author;
	private Date q_date;
	private int status;
	private String a_author;
	private Date a_date;
	private String a_content;
	private int is_deleted;
}
